codeunit 71100 "Import Matters L365"
{
    trigger OnRun()
    begin
        FileManagement.BLOBImport(TempBlob, ExcelFileName);
        AllowUpdate := confirm('Allow updates?');
        TempBlob.CreateInStream(InStr);
        TempExcelBuf.OpenBookStream(InStr, ExcelSheetName);
        TempExcelBuf.ReadSheet;
        ProcessMatters();
    end;

    var
        TempExcelBuf: Record "Excel Buffer" temporary;
        Cont: Record Contact;
        Cont2: Record Contact;
        JobRelCont: Record Contact;
        AbakionLegalSetup: Record "AbakionLegal Setup L365";
        JobType: Record "Contact Job Type L365";
        JobSubtype: Record "Contact Job Subtype L365";
        ContRel2: Record "Contact Relation L365";
        RelationTypeSetup: Record "Relation Type Setup L365";
        ContFolder: Record "Contact Folder L365";
        JobTask: Record "Job Task";
        Job: Record Job;
        ArchiveLog: Record "Archive Log L365";
        Archive: Record ArchiveL365;
        Customer: Record Customer;
        CustomerTemplate: Record "Customer Template";
        NavokatBasic: Codeunit "Basic L365";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        NavokatSearch: Codeunit "Search Management L365";
        FileManagement: Codeunit "File Management";
        TempBlob: Codeunit "Temp Blob";
        InStr: InStream;
        StartTime: DateTime;
        RecordHasError, AllowUpdate, Update, ValidateJobType, Archived, AutoCreateJobType, AutoCreateClient, UseJobNoSeries : Boolean;
        Text0100: Label '%1 already exist and you have not allowed updates.'; // DAN = '%1 findes allerede og du har ikke tilladt opdatering.'
        RecordNo, NoOfErrors, NextArchiveLogEntry, TmpInt : Integer;
        Text0101: Label 'The values does not exist in the underlying table'; // DAN = 'Værdien findes ikke i den bagvedliggende tabel.'
        Text0102: Label 'The Party does not exist in the underlying table.'; // DAN = 'Parten findes ikke i den bagvedliggende tabel.'
        Text0103: Label 'The Legal Connection does not exist in the underlying table.'; // DAN = 'Advokatforbindelsen findes ikke i den bagvedliggende tabel.'
        Text0104: Label 'The Client does not exist in the underlying table.'; // DAN = 'Klienten findes ikke i den bagvedliggende tabel.'
        Text0105: Label 'No. of Lines imported:%1\No. of Lines with errors:%2'; // DAN = 'Antal linjer, der er importeret:%1\Antal linjer, der med fejl:%2'
        Text0106: Label 'Imported'; // DAN = 'Importeret'
        VersionTxt: Label 'Import fits Excel-sheet version 1.4'; // DAN = 'Importen passer til excel-ark version 1.4'
        ExcelFileName: Label 'SagsImport_v1.6.xlsx';
        ExcelSheetName: Label 'Ark1';
        ContactNo: Text;
        ContactCompanyNo: Text;
        ContactSearchName: Text;
        ContactName, ContactName2 : Text;
        ContactClientRef: Text;
        ContactJobType: Text;
        ContactJobSubType: Text;
        RelParty1: Text;
        RelParty2: Text;
        RelAttorney1: Text;
        CONTROLLER: Text;
        SAGSBEH: Text;
        SEKRETAER: Text;
        ANSVARLIG: Text;
        AFREGNING: Text;
        KLIENTANS1: Text;
        SAGSBEH2: Text;
        ContactLanguageCode: Text;
        ContactAttention: Text;
        ArchivedTxt: Text;
        ArchivedDate: Text;
        ArchiveIndex: Text;
        SpecificDocumentationDemands: Text;
        InvoiceInterval: Text;
        FeeDocumentation: Text;
        RelInvoiceReceiver: Text;
        NextInvoiceDate, CreationDateTxt : Text;
        CollectSettlement: Text;
        ContactRelationType1, ContactRelationType2, FormerNo : Text;


    local procedure ProcessMatters()
    var
        RowNo, MaxCount : Integer;
        Window: Dialog;
        StartTime: Time;

    begin
        StartTime := Time;
        AbakionLegalSetup.FindFirst();
        RowNo := 2;
        TempExcelBuf.SetRange("Column No.", 1);
        TempExcelBuf.FindLast();
        MaxCount := TempExcelBuf."Row No." - 1;
        TempExcelBuf.SetRange("Column No.");

        Window.Open('Importing #1###### of #2#######');
        Window.Update(1, 1);
        Window.Update(2, MaxCount - 1);

        while TempExcelBuf.Get(RowNo, 1) do begin
            ProcessMatter(RowNo);
            Window.Update(1, RowNo);
            RowNo += 1;
        end;

        Window.Close();
        Message('Imported %1 matters in %2 seconds', MaxCount, round((Time - StartTime) / 1000, 1));
    end;

    local procedure ProcessMatter(RowNo: Integer)
    var
        Client: Record Contact;
        JobInvInterval: Record "Job Inv. Interval L365";
        InitJobNo: Code[20];
        MainJobNo: Code[20];
    begin
        clearVars();
        ReadExcelLine(RowNo);

        RecordNo += 1;

        if not UseJobNoSeries and (ContactNo = '') then
            exit;

        RecordHasError := false;
        Cont.INIT;
        Cont.SetHideValidationDialog(true);

        InitJobNo := '';
        MainJobNo := '';
        if (UseJobNoSeries = true) then begin
            Cont."No." := NavokatBasic.CalcJobNo(ValidateFieldLength(ContactCompanyNo, 20, Cont.FIELDCAPTION("Company No.")),
                          ValidateFieldLength(ContactJobType, 20, Cont.FIELDCAPTION("Job Type Code L365")),
                          ValidateFieldLength(ContactJobSubType, 20, Cont.FIELDCAPTION("Job Sub Type Code L365")),
                          InitJobNo,
                          MainJobNo)
        end else
            Cont."No." := ValidateFieldLength(ContactNo, 20, Cont.FIELDCAPTION("No."));

        Cont."Company No." := ValidateFieldLength(ContactCompanyNo, 20, Cont.FIELDCAPTION("Company No."));
        Cont.Validate("Extended Name L365", CopyStr(ContactName, 1, 50));
        Cont."Search Name" := ValidateFieldLength(ContactSearchName, MAXSTRLEN(Cont."Search Name"), Cont.FIELDCAPTION("Search Name"));
        Cont."Client Reference L365" := ValidateFieldLength(ContactClientRef, MAXSTRLEN(Cont."Client Reference L365"), Cont.FIELDCAPTION("Client Reference L365"));
        Cont."Job Type Code L365" := ValidateFieldLength(ContactJobType, 20, Cont.FIELDCAPTION("Job Type Code L365"));
        Cont."Job Sub Type Code L365" := ValidateFieldLength(ContactJobSubType, 20, Cont.FIELDCAPTION("Job Sub Type Code L365"));
        Cont."Former No. L365" := ValidateFieldLength(FormerNo, 20, Cont.FIELDCAPTION("Former No. L365"));
        Cont."Creation Date L365" := ValidateIsDate(CreationDateTxt, Cont.FieldCaption("Creation Date L365"));

        //TODO: Handle fields from separate module
        /*
        if (JobInvInterval.GET(ValidateFieldLength(InvoiceInterval, MAXSTRLEN(Cont."Invoice Interval L365"), Cont.FIELDCAPTION("Invoice Interval L365")))) then
            Cont."Invoice Interval L365" := JobInvInterval.Code;
        if (EVALUATE(Cont."Fee Documentation L365", FeeDocumentation)) then;
        if (EVALUATE(Cont."Next Invoice Date L365", NextInvoiceDate)) then;
        if (EVALUATE(Cont."Collect Settlement L365", CollectSettlement)) then;
        */
        Archived := false;

        if UpperCase(ArchivedTxt) in ['YES', 'JA', '1'] then
            Archived := true;

        RelParty1 := ValidateFieldLength(RelParty1, 20, Cont.FIELDCAPTION("No."));
        RelParty2 := ValidateFieldLength(RelParty2, 20, Cont.FIELDCAPTION("No."));
        RelAttorney1 := ValidateFieldLength(RelAttorney1, 20, ContRel2.FIELDCAPTION("Relation Code"));
        RelInvoiceReceiver := ValidateFieldLength(RelInvoiceReceiver, 20, ContRel2.FIELDCAPTION("Relation Code"));

        if RelParty1 <> '' then begin
            if not JobRelCont.GET(RelParty1) then begin
                LogError(JobRelCont.TABLECAPTION, JobRelCont.FIELDCAPTION("No."), Cont."No.", RelParty1, '', STRSUBSTNO(Text0102));
            end;
        end;
        if RelParty2 <> '' then begin
            if not JobRelCont.GET(RelParty2) then begin
                LogError(JobRelCont.TABLECAPTION, JobRelCont.FIELDCAPTION("No."), Cont."No.", RelParty2, '', STRSUBSTNO(Text0102));
            end;
        end;
        if RelAttorney1 <> '' then begin
            if not JobRelCont.GET(RelAttorney1) then begin
                LogError(JobRelCont.TABLECAPTION, JobRelCont.FIELDCAPTION("No."), Cont."No.", RelAttorney1, '', STRSUBSTNO(Text0103));
            end;
        end;
        if RelInvoiceReceiver <> '' then begin
            if not JobRelCont.GET(RelInvoiceReceiver) then begin
                LogError(JobRelCont.TABLECAPTION, JobRelCont.FIELDCAPTION("No."), Cont."No.", RelInvoiceReceiver, '', STRSUBSTNO(Text0102));
            end;
        end;

        Cont."Language Code" := ValidateFieldLength(ContactLanguageCode, 10, Cont.FIELDCAPTION("Language Code"));
        Cont.AttentionL365 := ValidateFieldLength(ContactAttention, 50, Cont.FIELDCAPTION(AttentionL365));
        Cont."Import Source Code L365" := 'LEGAL365';
        if ValidateJobType and ((ContactJobType <> '') or (ContactJobSubType <> '')) then begin
            if not JobType.GET(ContactJobType) then begin
                if not AutoCreateJobType then
                    LogError(JobType.TABLECAPTION, JobType.FIELDCAPTION(Code), Cont."No.", ContactJobType, '', STRSUBSTNO(Text0101))
                else begin
                    JobType.Code := ContactJobType;
                    JobType.Description := Text0106;
                    JobType.INSERT;
                end;
            end;

            if not JobSubtype.GET(ContactJobType, ContactJobSubType) then begin
                if not AutoCreateJobType then
                    LogError(JobSubtype.TABLECAPTION, JobSubtype.FIELDCAPTION(JobSubtype."Subtype Code"), Cont."No.", ContactJobSubType, '', STRSUBSTNO(Text0101))
                else begin
                    JobSubtype."Type Code" := ContactJobType;
                    JobSubtype."Subtype Code" := ContactJobSubType;
                    JobSubtype.Description := Text0106;
                    JobSubtype.INSERT;
                end;
            end;
        end;

        if not Client.GET(ContactCompanyNo) then begin
            if not AutoCreateClient then
                LogError(Client.TABLECAPTION, Client.FIELDCAPTION("No."), Cont."No.", ContactCompanyNo, '', STRSUBSTNO(Text0104))
            else begin
                Client.INIT;
                Client."No." := ContactCompanyNo;
                Client.Name := Text0106;
                Client."Contact Type L365" := AbakionLegalSetup."Client Contact Type";
                Client."Customer Template Code L365" := CustomerTemplate.Code;
                Client.INSERT(true);
            end;
        end;

        //validate Globalrealtions not supported yet

        Update := false;
        if not RecordHasError then begin
            if Cont2.GET(Cont."No.") then begin
                if not AllowUpdate then begin
                    LogError(Cont.TABLECAPTION, '', Cont."No.", '', '', STRSUBSTNO(Text0100, Cont.TABLECAPTION));
                    NoOfErrors += 1;
                    exit;
                end else begin
                    Update := true;
                end;
            end else begin
                CLEAR(Cont2);
                if Cont."No." <> '' then begin
                    ContFolder.SETRANGE("Contact No.", Cont."No.");
                    ContFolder.DELETEALL;
                    JobTask.SETRANGE("Job No.", Cont."No.");
                    JobTask.DELETEALL;

                end;
            end;

            Cont2 := Cont;
            Cont2.SetHideValidationDialog(true);
            Cont2.Type := Cont2.Type::Person;
            Cont2."Contact Type L365" := AbakionLegalSetup."Job Contact Type";
            Cont2.SETRANGE("Contact Type L365", AbakionLegalSetup."Job Contact Type");
            Cont2.validate("Company No.");

            if not Update then begin
                Cont2.INSERT(true);
                Client.GET(Cont."Company No.");
                if NavokatBasic.GetCustomerNo(Client."No.") = '' then begin
                    Client.TESTFIELD("Customer Template Code L365");
                    Client.SetHideValidationDialog(true);
                    Client.SetCustNoL365(true, Client."No.", false);
                    Client.CreateCustomer(Client."Customer Template Code L365");
                end;
                NavokatBasic.CreateJob2(Cont2."No.", Client."No.", true);
                //TODO: Handle fields from separate extension
                /*
                if (EVALUATE(Cont2.SpecifDocumentationDemandsL365, SpecificDocumentationDemands)) then
                    Cont2.MODIFY;
                if (EVALUATE(Cont2."Fee Documentation L365", FeeDocumentation)) then
                    Cont2.MODIFY;
                */
            end else
                Cont2.MODIFY(true);

            Job.GET(Cont2."No.");
            Job."Creation Date" := Cont."Creation Date L365";

            if Archived then begin
                Cont2."Contact Type L365" := AbakionLegalSetup."Archive Job Contact Type";
                EVALUATE(Cont2."Archive Date L365", ArchivedDate);
                Cont2.MODIFY;

                Job.ArchivedL365 := true;
                Job."Ending Date" := Cont2."Archive Date L365";

                ArchiveLog.RESET;
                ArchiveLog.SETRANGE("Job ID", Cont2."No.");
                ArchiveLog.DELETEALL;

                ArchiveLog.RESET;
                if ArchiveLog.FINDLAST then
                    NextArchiveLogEntry := ArchiveLog."Entry No." + 1
                else
                    NextArchiveLogEntry := 1;
                CLEAR(ArchiveLog);
                ArchiveLog."Entry No." := NextArchiveLogEntry;
                ArchiveLog."Archive No." := JobSubtype."Default Archive";
                ArchiveLog."Contact ID" := Cont2."Company No.";
                ArchiveLog."Job ID" := Cont2."No.";
                ArchiveLog.Type := ArchiveLog.Type::"Full Archive";
                ArchiveLog."Archive Date" := Cont2."Archive Date L365";
                if Archive.GET(JobSubtype."Default Archive") then
                    ArchiveLog."Maculation Date" := CALCDATE(Archive."Maculation Date", Cont2."Archive Date L365");
                ArchiveLog."Archive Index" := ArchiveIndex;
                ArchiveLog."Global Relation 1 Code" := Cont2."Global Relation 1 Code L365";
                ArchiveLog."Global Relation 2 Code" := Cont2."Global Relation 2 Code L365";
                ArchiveLog."Global Relation 3 Code" := Cont2."Global Relation 3 Code L365";
                ArchiveLog."Global Relation 4 Code" := Cont2."Global Relation 4 Code L365";
                ArchiveLog."Global Relation 5 Code" := Cont2."Global Relation 5 Code L365";
                ArchiveLog."Global Relation 6 Code" := Cont2."Global Relation 6 Code L365";
                ArchiveLog."Security Set ID" := Cont2."Security Set ID L365";
                ArchiveLog.Comment := Text0106;
                ArchiveLog.INSERT;
            end;
            Job.Modify();

            //Handle long names
            if StrLen(ContactName) > 50 then begin
                Cont2.Validate("Extended Name L365", ContactName);
                Cont2.Modify();
            end;

            //Create PartyRelations

            if RelParty1 <> '' then begin
                if ContactRelationType1 <> '' then begin
                    CreateRelation(Cont2."No.", RelParty1, ContactRelationType1);
                end else begin
                    CreateRelation(Cont2."No.", RelParty1, AbakionLegalSetup."Party Contact Type");
                end;
            end;
            if RelParty2 <> '' then begin
                if ContactRelationType2 <> '' then begin
                    CreateRelation(Cont2."No.", RelParty2, ContactRelationType2);
                end else begin
                    CreateRelation(Cont2."No.", RelParty2, AbakionLegalSetup."Party Contact Type");
                end;
            end;
            if RelAttorney1 <> '' then begin
                CreateRelation(Cont2."No.", RelAttorney1, AbakionLegalSetup."Relation Type - Legal Conn.");
            end;

            if RelInvoiceReceiver <> '' then begin
                CreateRelation(Cont2."No.", RelInvoiceReceiver, AbakionLegalSetup."Relation Type - Invoice Rec.");
            end;

            if CONTROLLER <> '' then begin
                CreateRelation(Cont2."No.", CONTROLLER, AbakionLegalSetup."Relation Type - Administrator");
            end;
            if SAGSBEH <> '' then begin
                CreateRelation(Cont2."No.", SAGSBEH, AbakionLegalSetup."Relation Type - Case Attorney");
            end;
            if SEKRETAER <> '' then begin
                CreateRelation(Cont2."No.", SEKRETAER, AbakionLegalSetup."Relation Type - Secretary");
            end;
            if ANSVARLIG <> '' then begin
                CreateRelation(Cont2."No.", ANSVARLIG, AbakionLegalSetup."Relation Type - Responsible");
            end;
            if AFREGNING <> '' then begin
                CreateRelation(Cont2."No.", AFREGNING, AbakionLegalSetup."Relation Type - Billing");
            end;
            if KLIENTANS1 <> '' then begin
                CreateRelation(Cont2."No.", KLIENTANS1, AbakionLegalSetup."Relation Type - Client Resp.");
            end;
            if SAGSBEH2 <> '' then begin
                CreateRelation(Cont2."No.", SAGSBEH2, RelationTypeSetup."Relation Type - Case Off. 2");
            end;
            NavokatSearch.BuildSearchWords(Cont2."No.");
            Cont2.Find();
            Cont2."Creation Date L365" := Cont."Creation Date L365";
            Cont2.Modify(true);
        end else
            NoOfErrors += 1;
    end;

    local procedure clearVars();
    begin
        clear(ContactNo);
        clear(ContactCompanyNo);
        clear(ContactSearchName);
        clear(ContactName);
        clear(ContactName2);
        clear(ContactClientRef);
        clear(ContactJobType);
        clear(ContactJobSubType);
        clear(RelParty1);
        clear(RelParty2);
        clear(RelAttorney1);
        clear(CONTROLLER);
        clear(SAGSBEH);
        clear(SEKRETAER);
        clear(ANSVARLIG);
        clear(AFREGNING);
        clear(KLIENTANS1);
        clear(SAGSBEH2);
        clear(ContactLanguageCode);
        clear(ContactAttention);
        clear(Archived);
        clear(ArchivedDate);
        clear(ArchiveIndex);
        clear(SpecificDocumentationDemands);
        clear(InvoiceInterval);
        clear(FeeDocumentation);
        clear(RelInvoiceReceiver);
        clear(NextInvoiceDate);
        clear(CollectSettlement);
        clear(ContactRelationType1);
        clear(ContactRelationType2);
        clear(FormerNo);
        clear(CreationDateTxt);
    end;

    local procedure ReadExcelLine(RowNo: Integer)
    begin
        ContactNo := GetCell(RowNo, 1);
        ContactCompanyNo := GetCell(RowNo, 2);
        ContactSearchName := GetCell(RowNo, 3);
        ContactName := GetCell(RowNo, 4);
        ContactName2 := GetCell(RowNo, 5);
        ContactClientRef := GetCell(RowNo, 6);
        ContactJobType := GetCell(RowNo, 7);
        ContactJobSubType := GetCell(RowNo, 8);
        RelParty1 := GetCell(RowNo, 9);
        ContactRelationType1 := GetCell(RowNo, 10);
        RelParty2 := GetCell(RowNo, 11);
        ContactRelationType2 := GetCell(RowNo, 12);
        RelAttorney1 := GetCell(RowNo, 13);
        ANSVARLIG := GetCell(RowNo, 14);
        SAGSBEH := GetCell(RowNo, 15);
        SEKRETAER := GetCell(RowNo, 16);
        KLIENTANS1 := GetCell(RowNo, 17);
        CONTROLLER := GetCell(RowNo, 18);
        AFREGNING := GetCell(RowNo, 19);
        SAGSBEH2 := GetCell(RowNo, 20);
        ContactLanguageCode := GetCell(RowNo, 21);
        ContactAttention := GetCell(RowNo, 22);
        ArchivedTxt := GetCell(RowNo, 23);
        ArchivedDate := GetCell(RowNo, 24);
        ArchiveIndex := GetCell(RowNo, 25);
        SpecificDocumentationDemands := GetCell(RowNo, 26);
        InvoiceInterval := GetCell(RowNo, 27);
        FeeDocumentation := GetCell(RowNo, 28);
        RelInvoiceReceiver := GetCell(RowNo, 29);
        NextInvoiceDate := GetCell(RowNo, 30);
        CollectSettlement := GetCell(RowNo, 31);
        FormerNo := GetCell(RowNo, 32);
        CreationDateTxt := GetCell(RowNo, 33);
    end;

    local procedure LogError(TableCaption: Text; FieldCaption: Text; PrimaryKey: Text; FieldValue: Text; FieldValue2: Text; ErrorDescription: Text);
    var
        ImportLog: Record "ImportLog L365";
    begin
        if not ImportLog.FINDLAST then;
        ImportLog.INIT;
        ImportLog."Import Type" := ImportLog."Import Type"::Matter;
        ImportLog."Entry No." += 1;
        ImportLog."Import Time" := StartTime;
        ImportLog."Import By" := USERID;
        ImportLog."Table Name" := TableCaption;
        ImportLog."Primary Key" := PrimaryKey;
        ImportLog."Field Name" := FieldCaption;
        ImportLog."Field Value" := FieldValue;
        ImportLog."Field Value 2" := FieldValue2;
        ImportLog."Error Description" := ErrorDescription;
        ImportLog.INSERT;
        RecordHasError := true;
    end;

    local procedure ValidateFieldLength(InStr: Text; MaxLength: Integer; Caption: Text): Text;
    var
        Text001: Label 'Værdien er for lang (%1). Kun %2 tegn er tilladt';
    begin
        if STRLEN(InStr) > MaxLength then begin
            LogError(Cont.TABLECAPTION, Caption, Cont."No.", InStr, '', STRSUBSTNO(Text001, STRLEN(InStr), MaxLength));
            exit('');
        end else
            exit(InStr);
    end;

    local procedure ValidateIsInteger(InInteger: Text; Caption: Text) ReturnInt: Integer;
    var
        Text001: Label 'Værdien "%1" er ikke et tal.';
    begin
        if not EVALUATE(ReturnInt, InInteger) then
            LogError(Cont.TABLECAPTION, Caption, Cont."No.", InInteger, '', STRSUBSTNO(Text001, InInteger));
    end;

    local procedure ValidateisDecimal(InDecimal: Text; Caption: Text) ReturnDecimal: Decimal;
    var
        Text001: Label 'Værdien "%1" er ikke et tal.';
    begin
        if not EVALUATE(ReturnDecimal, InDecimal) then
            LogError(Cont.TABLECAPTION, Caption, Cont."No.", InDecimal, '', STRSUBSTNO(Text001, InDecimal));
    end;

    local procedure ValidateIsDate(InDate: Text; Caption: Text) ReturnDate: Date;
    var
        Text001: Label 'Værdien "%1" er ikke en dato.';
    begin
        if not EVALUATE(ReturnDate, InDate) then
            LogError(Cont.TABLECAPTION, Caption, Cont."No.", InDate, '', STRSUBSTNO(Text001, InDate));
    end;

    local procedure ValidateIsBoolean(InBool: Text; Caption: Text) ReturnBool: Boolean;
    var
        Text001: Label 'Værdien "%1" er ikke  ja eller nej.';
    begin
        if not EVALUATE(ReturnBool, InBool) then begin
            if InBool = '' then
                ReturnBool := false
            else
                LogError(Cont.TABLECAPTION, Caption, Cont."No.", InBool, '', STRSUBSTNO(Text001, InBool));
        end;
    end;

    local procedure CreateRelation(Cont1: Code[20]; Cont2: Code[20]; Rel: Code[20]);
    var
        ContRel: Record "Contact Relation L365";
    begin
        if Cont2 <> '' then begin
            ContRel.SETRANGE("Contact 1", Cont1);
            ContRel.SETRANGE("Relation Code", Rel);
            ContRel.DELETEALL;
            ContRel.HideValidationDialog(true);
            CLEAR(ContRel);
            ContRel."Contact 1" := Cont1;
            ContRel.VALIDATE("Contact 2", Cont2);
            ContRel.VALIDATE("Relation Code", Rel);
            ContRel.INSERT(true);
        end;
    end;

    local procedure GetNextMatterNo(): Code[20];
    begin
        if (AbakionLegalSetup."Job Enumeration" = AbakionLegalSetup."Job Enumeration"::Client) then begin
            Customer.GET(ValidateFieldLength(ContactCompanyNo, 20, Cont.FIELDCAPTION("Company No.")));
            EVALUATE(TmpInt, Customer."Job No. Sequence L365");
            TmpInt += 1;
            Cont."No." := ValidateFieldLength(ContactCompanyNo, 20, Cont.FIELDCAPTION("Company No.")) + '-' + FORMAT(TmpInt);
            Customer."Job No. Sequence L365" := FORMAT(TmpInt);
            Customer.MODIFY;
            exit(Cont."No.");
        end;
    end;

    local procedure GetCell(RowNo: Integer; ColumnNo: Integer): Text
    begin
        If TempExcelBuf.Get(RowNo, ColumnNo) then
            exit(TempExcelBuf."Cell Value as Text")
        else
            exit('');
    end;
}