codeunit 71112 "Import Matters2 L365"
{
    trigger OnRun()
    begin
        ImportSetup.Get();
        AllowUpdate := ImportSetup."Overwrite Existing Records";
        AutoCreateClient := ImportSetup."Auto Create Clients";
        AutoCreateJobType := ImportSetup."Auto Create Matter Types";
        UseJobNoSeries := ImportSetup."Use Matter No. Series";
        FileManagement.BLOBImport(TempBlob, ExcelFileName);
        TempBlob.CreateInStream(InStr);
        TempExcelBuf.OpenBookStream(InStr, ExcelSheetName);
        TempExcelBuf.ReadSheet;
        ProcessMatters();
    end;

    var
        TempExcelBuf: Record "Excel Buffer" temporary;
        ContStaging: Record "Contact Staging L365";
        ContStaging2: Record "Contact Staging L365";

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
        ImportSetup: Record "Import Setup L365";
        NavokatBasic: Codeunit "Basic L365";
        NavokatSearch: Codeunit "Search Management L365";
        FileManagement: Codeunit "File Management";
        TempBlob: Codeunit "Temp Blob";
        InStr: InStream;
        StartTime: DateTime;
        RecordHasError, AllowUpdate, Update, ValidateJobType, Archived, AutoCreateJobType, AutoCreateClient, UseJobNoSeries : Boolean;
        Text0100: Label '%1 already exist and you have not allowed updates.'; // DAN = '%1 findes allerede og du har ikke tilladt opdatering.'
        RecordNo, NextArchiveLogEntry, TmpInt : Integer;


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
        ProcessStartTime: Time;

    begin
        ProcessStartTime := Time;
        AbakionLegalSetup.FindFirst();
        If ImportSetup."Files has Headers" then
            RowNo := 2
        else
            RowNo := 1;

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
        Message('Imported %1 matters in %2 seconds', MaxCount, round((Time - ProcessStartTime) / 1000, 1));
    end;

    local procedure ProcessMatter(RowNo: Integer)
    var
        Cont: Record Contact;

    begin
        clearVars();
        ReadExcelLine(RowNo);

        RecordNo += 1;

        if not UseJobNoSeries and (ContactNo = '') then
            exit;

        RecordHasError := false;
        ContStaging.INIT;
        ContStaging."Import Type" := ContStaging."Import Type"::Matter;
        ContStaging."No." := ValidateFieldLength(ContactNo, 20, ContStaging.FIELDCAPTION("No."));
        ContStaging."Company No." := ValidateFieldLength(ContactCompanyNo, 20, ContStaging.FIELDCAPTION("Company No."));
        ContStaging.Name := copystr(ContactName, 1, MaxStrLen(ContStaging.Name));
        ContStaging."Extended Name" := ValidateFieldLength(ContactName, 2048, ContStaging.FIELDCAPTION("Extended Name"));
        ContStaging."Search Name" := ValidateFieldLength(ContactSearchName, MAXSTRLEN(ContStaging."Search Name"), ContStaging.FIELDCAPTION("Search Name"));
        ContStaging."Client Reference L365" := ValidateFieldLength(ContactClientRef, MAXSTRLEN(Cont."Client Reference L365"), ContStaging.FIELDCAPTION("Client Reference L365"));

        ContStaging."Job Type Code L365" := ValidateFieldLength(ContactJobType, 20, ContStaging.FIELDCAPTION("Job Type Code L365"));
        ContStaging."Job Sub Type Code L365" := ValidateFieldLength(ContactJobSubType, 20, ContStaging.FIELDCAPTION("Job Sub Type Code L365"));
        ContStaging."Former No. L365" := ValidateFieldLength(FormerNo, 20, ContStaging.FIELDCAPTION("Former No. L365"));
        ContStaging."Creation Date L365" := ValidateIsDate(CreationDateTxt, ContStaging.FieldCaption("Creation Date L365"));

        ContStaging.Archived := false;

        if UpperCase(ArchivedTxt) in ['YES', 'JA', '1'] then
            ContStaging.Archived := true;

        ContStaging."Party 1" := ValidateFieldLength(RelParty1, 20, ContStaging.FIELDCAPTION("No."));
        ContStaging."Part 1 Relation Code" := ValidateFieldLength(ContactRelationType1, 10, ContStaging.FieldCaption("Part 1 Relation Code"));
        ContStaging."Party 2" := ValidateFieldLength(RelParty2, 20, ContStaging.FIELDCAPTION("No."));
        ContStaging."Part 2 Relation Code" := ValidateFieldLength(ContactRelationType2, 10, ContStaging.FieldCaption("Part 2 Relation Code"));
        ContStaging."Legal Connection" := ValidateFieldLength(RelAttorney1, 20, ContRel2.FIELDCAPTION("Relation Code"));
        ContStaging."Inv. Recepient" := ValidateFieldLength(RelInvoiceReceiver, 20, ContRel2.FIELDCAPTION("Relation Code"));

        ContStaging."Language Code" := ValidateFieldLength(ContactLanguageCode, 10, ContStaging.FIELDCAPTION("Language Code"));
        ContStaging.AttentionL365 := ValidateFieldLength(ContactAttention, 50, ContStaging.FIELDCAPTION(AttentionL365));
        ContStaging."Import Type" := ContStaging."Import Type"::Matter;
        if not ContStaging.Insert() then
            ContStaging.Modify();

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
            LogError(ContStaging.TABLECAPTION, Caption, ContStaging."No.", InStr, '', STRSUBSTNO(Text001, STRLEN(InStr), MaxLength));
            exit('');
        end else
            exit(InStr);
    end;

    local procedure ValidateIsInteger(InInteger: Text; Caption: Text) ReturnInt: Integer;
    var
        Text001: Label 'Værdien "%1" er ikke et tal.';
    begin
        if not EVALUATE(ReturnInt, InInteger) then
            LogError(ContStaging.TABLECAPTION, Caption, ContStaging."No.", InInteger, '', STRSUBSTNO(Text001, InInteger));
    end;

    local procedure ValidateisDecimal(InDecimal: Text; Caption: Text) ReturnDecimal: Decimal;
    var
        Text001: Label 'Værdien "%1" er ikke et tal.';
    begin
        if not EVALUATE(ReturnDecimal, InDecimal) then
            LogError(ContStaging.TABLECAPTION, Caption, ContStaging."No.", InDecimal, '', STRSUBSTNO(Text001, InDecimal));
    end;

    local procedure ValidateIsDate(InDate: Text; Caption: Text) ReturnDate: Date;
    var
        Text001: Label 'Værdien "%1" er ikke en dato.';
    begin
        if not EVALUATE(ReturnDate, InDate) then
            LogError(ContStaging.TABLECAPTION, Caption, ContStaging."No.", InDate, '', STRSUBSTNO(Text001, InDate));
    end;

    local procedure ValidateIsBoolean(InBool: Text; Caption: Text) ReturnBool: Boolean;
    var
        Text001: Label 'Værdien "%1" er ikke  ja eller nej.';
    begin
        if not EVALUATE(ReturnBool, InBool) then begin
            if InBool = '' then
                ReturnBool := false
            else
                LogError(ContStaging.TABLECAPTION, Caption, ContStaging."No.", InBool, '', STRSUBSTNO(Text001, InBool));
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

    local procedure GetCell(RowNo: Integer; ColumnNo: Integer): Text
    begin
        If TempExcelBuf.Get(RowNo, ColumnNo) then
            exit(TempExcelBuf."Cell Value as Text")
        else
            exit('');
    end;
}