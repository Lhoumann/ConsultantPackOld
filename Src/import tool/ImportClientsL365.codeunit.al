codeunit 71101 "Import Clients L365"
{
    trigger OnRun()
    begin
        FileManagement.BLOBImport(TempBlob, ExcelFileName);
        AllowUpdate := confirm('Allow updates?');
        TempBlob.CreateInStream(InStr);
        TempExcelBuf.OpenBookStream(InStr, ExcelSheetName);
        TempExcelBuf.ReadSheet;
        ProcessClients();
    end;

    var
        Cont: Record Contact;
        Cont2: Record Contact;
        Cont3: Record Contact;
        AbakionLegalSetup: Record "AbakionLegal Setup L365";
        ContactRel: Record "Contact Relation L365";
        GlobalRelationSetup: Record "Global Relation Setup L365";
        CustTemplate: Record "Customer Template";
        TempExcelBuf: Record "Excel Buffer" temporary;
        PostCode: Record "Post Code";
        NavokatSearch: Codeunit "Search Management L365";
        RelMgt: Codeunit "Global Relation Mgt. L365";
        FileManagement: Codeunit "File Management";
        TempBlob: Codeunit "Temp Blob";
        InStr: InStream;
        StartTime: DateTime;
        RecordHasError, AllowUpdate, Update, ValidatePostCode, HasHeading, AutoCreatePostCode : Boolean;
        RecordNo, NoOfErrors : Integer;
        ContactNo: Text;
        ContactName: Text;
        ContactName2: Text;
        ContactSearchName: Text;
        ContactAddress: Text;
        ContactAddress3: Text;
        ContactAddress2: Text;
        ContacPostCode: Text;
        ContactCity: Text;
        ContactCountryRegionCode: Text;
        ContactEMail: Text;
        ContactPhoneNo: Text;
        ContactPrivatePhoneNo: Text;
        ContactFaxNo: Text;
        ContactHomePage: Text;
        ContactMobilePhoneNo: Text;
        ContactVATRegistrationNo: Text;
        ContactCivilRegistrationNo: Text;
        ContactLanguageCode: Text;
        ContactAttention: Text;
        ContactBankBranchNo: Text;
        ContactBankAccountNo: Text;
        ContactVIP: Text;
        ContactTemplateCode: Text;
        ContactSENummer: Text;
        ContactClientResponsible: Text;
        ContactFirstName: Text;
        ContactMiddleName: Text;
        ContactLastName: Text;
        ContactSalutationCode: Text;
        Text0100: Label '%1 already exists and you have not allowed updates.'; // DAN = '%1 findes allerede og du har ikke tilladt opdatering.'
        Text0101: Label 'The Value does not exist in the underlying table.'; // DAN = 'Værdien findes ikke i den bagvedliggende tabel.'
        Text0102: Label 'No. of Lines imported:%1\No. of Lines with errors:%2'; // DAN = 'Antal linjer, der er importeret:%1\Antal linjer, der med fejl:%2'
        Text0103: Label '%1 must not be blank.'; // DAN = '%1 må ikke være blank'
        Text0104: Label 'Client Responsible does not exist.'; // DAN = 'Klientansvarlig findes ikke.'
        ExcelFileName: Label 'KlientImport_v1.1.xlsx';
        ExcelSheetName: Label 'Ark1';


    local procedure ProcessClients()
    var
        RowNo, MaxCount : Integer;
        Window: Dialog;
        StartTime: Time;

    begin
        StartTime := Time;
        AbakionLegalSetup.FindFirst();
        TempExcelBuf.SetRange("Column No.", 1);
        TempExcelBuf.FindLast();
        MaxCount := TempExcelBuf."Row No." - 1;
        TempExcelBuf.SetRange("Column No.");

        Window.Open('Importing #1###### of #2#######');
        Window.Update(1, 1);
        Window.Update(2, MaxCount - 1);
        RowNo := 2;

        while TempExcelBuf.Get(RowNo, 1) do begin
            ProcessClient(RowNo);
            Window.Update(1, RowNo);
            RowNo += 1;
        end;

        Window.Close();
        Message('Imported %1 clients in %2 seconds', MaxCount, round((Time - StartTime) / 1000, 1));
    end;

    local procedure ProcessClient(RowNo: Integer)
    begin
        ClearVars();
        ReadExcelLine(RowNo);

        RecordNo += 1;
        If ContactNo = '' then
            exit;

        RecordHasError := false;
        Cont.INIT;
        Cont."No." := ValidateFieldLength(ContactNo, 20, Cont.FIELDCAPTION("No."));
        Cont."Company No." := Cont."No.";
        Cont.Name := ValidateFieldLength(ContactName, MAXSTRLEN(Cont.Name), Cont.FIELDCAPTION(Name));
        Cont."Name 2" := ValidateFieldLength(ContactName2, 50, Cont.FIELDCAPTION("Name 2"));
        Cont."Search Name" := ValidateFieldLength(ContactSearchName, MAXSTRLEN(Cont."Search Name"), Cont.FIELDCAPTION("Search Name"));
        Cont.Address := ValidateFieldLength(ContactAddress, MAXSTRLEN(Cont.Address), Cont.FIELDCAPTION(Address));
        Cont."Address 2" := ValidateFieldLength(ContactAddress2, MAXSTRLEN(Cont."Address 2"), Cont.FIELDCAPTION("Address 2"));
        Cont."Post Code" := ValidateFieldLength(ContacPostCode, 20, Cont.FIELDCAPTION("Post Code"));
        Cont.City := ValidateFieldLength(ContactCity, 30, Cont.FIELDCAPTION(City));
        Cont."Country/Region Code" := ValidateFieldLength(ContactCountryRegionCode, 10, Cont.FIELDCAPTION("Country/Region Code"));
        Cont."VIP Client L365" := ValidateIsBoolean(ContactVIP, Cont.FIELDCAPTION("VIP Client L365"));
        Cont."E-Mail" := ValidateFieldLength(ContactEMail, 80, Cont.FIELDCAPTION("E-Mail"));
        Cont."Phone No." := ValidateFieldLength(ContactPhoneNo, 30, Cont.FIELDCAPTION("Phone No."));
        Cont."Private Phone No. L365" := ValidateFieldLength(ContactPrivatePhoneNo, 30, Cont.FIELDCAPTION("Private Phone No. L365"));
        Cont."Fax No." := ValidateFieldLength(ContactFaxNo, 30, Cont.FIELDCAPTION("Fax No."));
        Cont."Home Page" := ValidateFieldLength(ContactHomePage, 80, Cont.FIELDCAPTION("Home Page"));
        Cont."Mobile Phone No." := ValidateFieldLength(ContactMobilePhoneNo, 20, Cont.FIELDCAPTION("Mobile Phone No."));
        Cont."VAT Registration No." := ValidateFieldLength(ContactVATRegistrationNo, 20, Cont.FIELDCAPTION("VAT Registration No."));
        Cont."SE-nummer L365" := ValidateFieldLength(ContactSENummer, 20, Cont.FIELDCAPTION("SE-nummer L365"));
        Cont."Civil Registration No. L365" := ValidateFieldLength(ContactCivilRegistrationNo, 20, Cont.FIELDCAPTION("Civil Registration No. L365"));
        Cont."Language Code" := ValidateFieldLength(ContactLanguageCode, 10, Cont.FIELDCAPTION("Language Code"));
        Cont.AttentionL365 := ValidateFieldLength(ContactAttention, 50, Cont.FIELDCAPTION(AttentionL365));
        Cont."Bank Branch No. L365" := ValidateFieldLength(ContactBankBranchNo, 20, Cont.FIELDCAPTION("Bank Branch No. L365"));
        Cont."Bank Account No. L365" := ValidateFieldLength(ContactBankAccountNo, 30, Cont.FIELDCAPTION("Bank Account No. L365"));
        Cont."Customer Template Code L365" := ValidateFieldLength(ContactTemplateCode, 10, Cont.FIELDCAPTION("Customer Template Code L365"));
        ContactClientResponsible := ValidateFieldLength(ContactClientResponsible, 10, Cont.FIELDCAPTION("Customer Template Code L365"));
        Cont."First Name" := ValidateFieldLength(ContactFirstName, 80, Cont.FIELDCAPTION("First Name"));
        Cont."Middle Name" := ValidateFieldLength(ContactMiddleName, 50, Cont.FIELDCAPTION("Middle Name"));
        Cont.Surname := ValidateFieldLength(ContactLastName, 50, Cont.FIELDCAPTION(Surname));
        Cont."Salutation Code" := ValidateFieldLength(ContactSalutationCode, 10, Cont.FIELDCAPTION("Salutation Code"));
        Cont.UpdatePostCodeCityL365();

        Cont."Import Source Code L365" := 'LEGAL365';
        if ValidatePostCode and (ContacPostCode <> '') then begin
            PostCode.SETRANGE(Code, ContacPostCode);
            if PostCode.ISEMPTY then begin
                if not AutoCreatePostCode then
                    LogError(Cont.TABLECAPTION, Cont.FIELDCAPTION("Post Code"), Cont."No.", Cont."Post Code", '', STRSUBSTNO(Text0101))
                else begin
                    PostCode.Code := Cont."Post Code";
                    PostCode.City := Cont.City;
                    PostCode."Country/Region Code" := Cont."Country/Region Code";
                    PostCode.INSERT;
                end;
            end;

        end;
        if Cont."Customer Template Code L365" = '' then begin
            if not CustTemplate.FINDFIRST then
                LogError(Cont.TABLECAPTION, '', Cont."No.", '', '', STRSUBSTNO(Text0103, Cont.FIELDCAPTION("Customer Template Code L365")))
            else
                Cont."Customer Template Code L365" := CustTemplate.Code;
        end;
        Update := false;
        if not RecordHasError then begin
            if Cont2.GET(Cont."No.") then begin
                if not AllowUpdate then begin
                    LogError(Cont.TABLECAPTION, '', Cont."No.", '', '', STRSUBSTNO(Text0100, Cont.TABLECAPTION));
                    NoOfErrors += 1;
                    exit;
                end else
                    Update := true;
            end else
                CLEAR(Cont2);
            Cont2 := Cont;
            Cont2.Type := Cont2.Type::Company;
            Cont2."Company Name" := Cont2.Name;
            Cont2."Contact Type L365" := AbakionLegalSetup."Client Contact Type";
            Cont2.SETRANGE("Contact Type L365", AbakionLegalSetup."Client Contact Type");
            if not Update then begin
                if (not Cont3.GET(ContactClientResponsible)) and (ContactClientResponsible <> '') then begin
                    LogError(Cont.TABLECAPTION, '', Cont."No.", ContactClientResponsible, '', Text0104);
                    NoOfErrors += 1;
                    exit;
                end else begin
                    Cont2.INSERT(true);
                    if ContactClientResponsible <> '' then begin
                        CLEAR(ContactRel);
                        ContactRel."Contact 1" := Cont2."No.";
                        ContactRel.VALIDATE("Contact 2", ContactClientResponsible);
                        ContactRel.VALIDATE("Relation Code", AbakionLegalSetup."Relation Type - Client Resp.");
                        ContactRel.INSERT(true);
                    end;
                end;
            end else begin
                if (not Cont3.GET(ContactClientResponsible)) and (ContactClientResponsible <> '') then begin
                    LogError(Cont.TABLECAPTION, '', Cont."No.", ContactClientResponsible, '', Text0104);
                    NoOfErrors += 1;
                    exit;
                end else begin
                    Cont2.MODIFY(true);
                    if ContactClientResponsible <> '' then begin
                        ContactRel.SETRANGE("Contact 1", Cont2."No.");
                        ContactRel.SETRANGE("Relation Code", AbakionLegalSetup."Relation Type - Client Resp.");
                        if ContactRel.FINDFIRST then begin
                            ContactRel.VALIDATE("Contact 2", ContactClientResponsible);
                            ContactRel.MODIFY(true);
                        end;
                    end;
                end;
            end;

            Cont2."Customer Template Code L365" := Cont."Customer Template Code L365";
            Cont2.MODIFY;
            NavokatSearch.BuildSearchWords(Cont2."No.");
            RelMgt.Update(Cont2."No.");
        end else
            NoOfErrors += 1;
    end;

    local procedure ClearVars();
    begin
        CLEAR(ContactNo);
        CLEAR(ContactName);
        CLEAR(ContactName2);
        CLEAR(ContactSearchName);
        CLEAR(ContactAddress);
        CLEAR(ContactAddress3);
        CLEAR(ContactAddress2);
        CLEAR(ContacPostCode);
        CLEAR(ContactCity);
        CLEAR(ContactCountryRegionCode);
        CLEAR(ContactEMail);
        CLEAR(ContactPhoneNo);
        CLEAR(ContactPrivatePhoneNo);
        CLEAR(ContactFaxNo);
        CLEAR(ContactHomePage);
        CLEAR(ContactMobilePhoneNo);
        CLEAR(ContactVATRegistrationNo);
        CLEAR(ContactCivilRegistrationNo);
        CLEAR(ContactLanguageCode);
        CLEAR(ContactAttention);
        CLEAR(ContactBankBranchNo);
        CLEAR(ContactBankAccountNo);
        CLEAR(ContactVIP);
        CLEAR(ContactTemplateCode);
        CLEAR(ContactSENummer);
        CLEAR(ContactClientResponsible);
        CLEAR(ContactFirstName);
        CLEAR(ContactMiddleName);
        CLEAR(ContactLastName);
        CLEAR(ContactSalutationCode);
    end;

    local procedure ReadExcelLine(RowNo: Integer)
    begin
        ContactNo := GetCell(Rowno, 1);
        ContactName := GetCell(Rowno, 2);
        ContactName2 := GetCell(Rowno, 3);
        ContactSearchName := GetCell(Rowno, 4);
        ContactAddress := GetCell(Rowno, 5);
        ContactAddress2 := GetCell(Rowno, 6);
        ContactAddress3 := GetCell(Rowno, 7);
        ContacPostCode := GetCell(Rowno, 8);
        ContactCity := GetCell(Rowno, 9);
        ContactCountryRegionCode := GetCell(Rowno, 10);
        ContactVIP := GetCell(Rowno, 11);
        ContactEMail := GetCell(Rowno, 12);
        ContactPhoneNo := GetCell(Rowno, 13);
        ContactPrivatePhoneNo := GetCell(Rowno, 14);
        ContactFaxNo := GetCell(Rowno, 15);
        ContactHomePage := GetCell(Rowno, 16);
        ContactMobilePhoneNo := GetCell(Rowno, 17);
        ContactVATRegistrationNo := GetCell(Rowno, 18);
        ContactSENummer := GetCell(Rowno, 19);
        ContactCivilRegistrationNo := GetCell(Rowno, 20);
        ContactLanguageCode := GetCell(Rowno, 21);
        ContactAttention := GetCell(Rowno, 22);
        ContactBankBranchNo := GetCell(Rowno, 23);
        ContactBankAccountNo := GetCell(Rowno, 24);
        ContactTemplateCode := GetCell(Rowno, 26);
        ContactClientResponsible := GetCell(Rowno, 27);
        ContactFirstName := GetCell(Rowno, 28);
        ContactMiddleName := GetCell(Rowno, 29);
        ContactLastName := GetCell(Rowno, 30);
        ContactSalutationCode := GetCell(Rowno, 31);
    end;

    local procedure GetCell(RowNo: Integer; ColumnNo: Integer): Text
    begin
        If TempExcelBuf.Get(RowNo, ColumnNo) then
            exit(TempExcelBuf."Cell Value as Text")
        else
            exit('');
    end;

    local procedure LogError(TableCaption: Text; FieldCaption: Text; PrimaryKey: Text; FieldValue: Text; FieldValue2: Text; ErrorDescription: Text);
    var
        ImportLog: Record "ImportLog L365";
    begin
        if not ImportLog.FINDLAST then;
        ImportLog.INIT;
        ImportLog."Import Type" := ImportLog."Import Type"::Client;
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
}