codeunit 71110 "Import Parties2 L365"
{

    trigger OnRun()
    begin
        AbakionLegalSetup.GET;
        AbakionLegalSetup.TESTFIELD("Party Contact Type");
        StartTime := CURRENTDATETIME;
        RecordNo := 0;

        ImportSetup.Get();
        StartTime := CurrentDateTime;
        FileManagement.BLOBImport(TempBlob, ExcelFileName);
        AllowUpdate := ImportSetup."Overwrite Existing Records";
        ValidatePostCode := ImportSetup."Validate Post Codes";
        AutoCreatePostCode := ImportSetup."Auto Create Post Codes";
        TempBlob.CreateInStream(InStr);
        TempExcelBuf.OpenBookStream(InStr, ExcelSheetName);
        TempExcelBuf.ReadSheet;
        ProcessParties();

    end;

    var
        Staging: Record "Contact Staging L365";
        Cont2: Record Contact;
        AbakionLegalSetup: Record "AbakionLegal Setup L365";
        ImportSetup: Record "Import Setup L365";
        TempExcelBuf: Record "Excel Buffer" temporary;
        SearchManagement: Codeunit "Search Management L365";
        FileManagement: Codeunit "File Management";
        TempBlob: Codeunit "Temp Blob";
        Instr: InStream;
        StartTime: DateTime;
        RecordHasError: Boolean;
        AllowUpdate: Boolean;

        Update: Boolean;
        RecordNo: Integer;
        ValidatePostCode: Boolean;
        PostCode: Record "Post Code";


        Text0102: Label 'No. of Lines imported:%1\No. of Lines with errors:%2'; // DAN = 'Antal linjer, der er importeret:%1\Antal linjer, der med fejl:%2'
        ExcelFileName: Label 'PartsImport_v1.1.xlsx';
        ExcelSheetName: Label 'Ark1';
        HasHeading: Boolean;
        AutoCreatePostCode: Boolean;
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
        ContactBirthday: Text;
        ContactJobTitle: Text;
        ContactFirstName: Text;
        ContactMiddleName: Text;
        ContactLastName: Text;
        ContactSalutationCode: Text;

    procedure ClearVars();
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
        CLEAR(ContactBirthday);
        CLEAR(ContactJobTitle);
        CLEAR(ContactFirstName);
        CLEAR(ContactMiddleName);
        CLEAR(ContactLastName);
        CLEAR(ContactSalutationCode);
    end;

    local procedure ProcessParties()
    var
        RowNo, MaxCount : Integer;
        Window: Dialog;
        StartRunTime: Time;

    begin
        StartRunTime := Time;
        AbakionLegalSetup.FindFirst();
        TempExcelBuf.SetRange("Column No.", 1);
        TempExcelBuf.FindLast();
        MaxCount := TempExcelBuf."Row No." - 1;
        TempExcelBuf.SetRange("Column No.");

        Window.Open('Importing #1###### of #2#######');
        Window.Update(1, 1);
        Window.Update(2, MaxCount - 1);
        If ImportSetup."Files has Headers" then
            RowNo := 2
        else
            RowNo := 1;

        while TempExcelBuf.Get(RowNo, 1) do begin
            ProcessParty(RowNo);
            Window.Update(1, RowNo);
            RowNo += 1;
        end;

        Window.Close();
        Message('Imported %1 clients in %2 seconds', MaxCount, round((Time - StartRunTime) / 1000, 1));
    end;

    local procedure ProcessParty(RowNo: Integer);
    begin
        ClearVars();
        ReadExcelLine(RowNo);

        RecordNo += 1;
        If ContactNo = '' then
            exit;

        RecordHasError := false;
        Staging.INIT;
        Staging."Import Type" := Staging."Import Type"::Party;
        Staging."No." := ValidateFieldLength(ContactNo, 20, Staging.FIELDCAPTION("No."));
        Staging."Company No." := Staging."No.";
        Staging.Name := ValidateFieldLength(ContactName, 50, Staging.FIELDCAPTION(Name));
        Staging."Name 2" := ValidateFieldLength(ContactName2, 50, Staging.FIELDCAPTION("Name 2"));
        Staging."Search Name" := ValidateFieldLength(ContactSearchName, 50, Staging.FIELDCAPTION("Search Name"));
        Staging.Address := ValidateFieldLength(ContactAddress, 50, Staging.FIELDCAPTION(Address));
        Staging."Address 2" := ValidateFieldLength(ContactAddress2, 50, Staging.FIELDCAPTION("Address 2"));
        Staging."Post Code" := ValidateFieldLength(ContacPostCode, 20, Staging.FIELDCAPTION("Post Code"));
        Staging.City := ValidateFieldLength(ContactCity, 50, Staging.FIELDCAPTION(City));
        Staging."Country/Region Code" := ValidateFieldLength(ContactCountryRegionCode, 10, Staging.FIELDCAPTION("Country/Region Code"));
        Staging."E-Mail" := ValidateFieldLength(ContactEMail, 80, Staging.FIELDCAPTION("E-Mail"));
        Staging."Phone No." := ValidateFieldLength(ContactPhoneNo, 30, Staging.FIELDCAPTION("Phone No."));
        Staging."Private Phone No." := ValidateFieldLength(ContactPrivatePhoneNo, 30, Cont2.FIELDCAPTION("Private Phone No. L365"));
        Staging."Fax No." := ValidateFieldLength(ContactFaxNo, 30, Staging.FIELDCAPTION("Fax No."));
        Staging."Home Page" := ValidateFieldLength(ContactHomePage, 80, Staging.FIELDCAPTION("Home Page"));
        Staging."Mobile Phone No." := ValidateFieldLength(ContactMobilePhoneNo, 20, Staging.FIELDCAPTION("Mobile Phone No."));
        Staging."VAT Registration No." := ValidateFieldLength(ContactVATRegistrationNo, 20, Staging.FIELDCAPTION("VAT Registration No."));
        Staging."Civil Registration No. L365" := ValidateFieldLength(ContactCivilRegistrationNo, 20, Staging.FIELDCAPTION("Civil Registration No. L365"));
        Staging."Language Code" := ValidateFieldLength(ContactLanguageCode, 10, Staging.FIELDCAPTION("Language Code"));
        Staging.AttentionL365 := ValidateFieldLength(ContactAttention, 50, Staging.FIELDCAPTION(AttentionL365));
        Staging."Bank Branch No. L365" := ValidateFieldLength(ContactBankBranchNo, 20, Staging.FIELDCAPTION("Bank Branch No. L365"));
        Staging."Bank Account No. L365" := ValidateFieldLength(ContactBankAccountNo, 30, Staging.FIELDCAPTION("Bank Account No. L365"));
        Staging."Birth Date L365" := ValidateIsDate(ContactBirthday, Staging.FIELDCAPTION("Birth Date L365"));
        Staging."Job Title" := ValidateFieldLength(ContactJobTitle, 30, Staging.FIELDCAPTION("Job Title"));
        Staging."First Name" := ValidateFieldLength(ContactFirstName, 80, Staging.FIELDCAPTION("First Name"));
        Staging."Middle Name" := ValidateFieldLength(ContactMiddleName, 50, Staging.FIELDCAPTION("Middle Name"));
        Staging."Sur name" := ValidateFieldLength(ContactLastName, 50, cont2.FIELDCAPTION(Surname));
        Staging."Salutation Code" := ValidateFieldLength(ContactSalutationCode, 10, Staging.FIELDCAPTION("Salutation Code"));
        Staging."Import Type" := Staging."Import Type"::Party;
        if not Staging.Insert() then
            Staging.Modify();
    end;

    local procedure ReadExcelLine(RowNo: Integer)
    begin
        ContactNo := GetCell(Rowno, 1);
        ContactName := GetCell(Rowno, 2);
        ContactName2 := GetCell(Rowno, 3);
        ContactSearchName := GetCell(Rowno, 4);
        ContactJobTitle := GetCell(RowNo, 5);
        ContactAddress := GetCell(Rowno, 6);
        ContactAddress2 := GetCell(Rowno, 7);
        ContactAddress3 := GetCell(Rowno, 8);
        ContacPostCode := GetCell(Rowno, 9);
        ContactCity := GetCell(Rowno, 10);
        ContactCountryRegionCode := GetCell(Rowno, 11);
        ContactEMail := GetCell(Rowno, 12);
        ContactPhoneNo := GetCell(Rowno, 13);
        ContactPrivatePhoneNo := GetCell(Rowno, 14);
        ContactFaxNo := GetCell(Rowno, 15);
        ContactHomePage := GetCell(Rowno, 16);
        ContactMobilePhoneNo := GetCell(Rowno, 17);
        ContactVATRegistrationNo := GetCell(Rowno, 18);
        ContactCivilRegistrationNo := GetCell(Rowno, 19);
        ContactLanguageCode := GetCell(Rowno, 20);
        ContactAttention := GetCell(Rowno, 21);
        ContactBankBranchNo := GetCell(Rowno, 22);
        ContactBankAccountNo := GetCell(Rowno, 23);
        ContactBirthday := GetCell(RowNo, 25);
        ContactFirstName := GetCell(Rowno, 26);
        ContactMiddleName := GetCell(Rowno, 27);
        ContactLastName := GetCell(Rowno, 28);
        ContactSalutationCode := GetCell(Rowno, 29);
    end;

    local procedure GetCell(RowNo: Integer; ColumnNo: Integer): Text
    begin
        If TempExcelBuf.Get(RowNo, ColumnNo) then
            exit(TempExcelBuf."Cell Value as Text")
        else
            exit('');
    end;

    procedure LogError(TableCaption: Text; FieldCaption: Text; PrimaryKey: Text; FieldValue: Text; FieldValue2: Text; ErrorDescription: Text);
    var
        ImportLog: Record "ImportLog L365";
    begin
        if not ImportLog.FINDLAST then;
        ImportLog.INIT;
        ImportLog."Import Type" := ImportLog."Import Type"::Party;
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
            LogError(Staging.TABLECAPTION, Caption, Staging."No.", InStr, '', STRSUBSTNO(Text001, STRLEN(InStr), MaxLength));
            exit('');
        end else
            exit(InStr);
    end;

    local procedure ValidateIsInteger(InInteger: Text; Caption: Text) ReturnInt: Integer;
    var
        Text001: Label 'Værdien "%1" er ikke et tal.';
    begin
        if not EVALUATE(ReturnInt, InInteger) then
            LogError(Staging.TABLECAPTION, Caption, Staging."No.", InInteger, '', STRSUBSTNO(Text001, InInteger));
    end;

    local procedure ValidateisDecimal(InDecimal: Text; Caption: Text) ReturnDecimal: Decimal;
    var
        Text001: Label 'Værdien "%1" er ikke et tal.';
    begin
        if not EVALUATE(ReturnDecimal, InDecimal) then
            LogError(Staging.TABLECAPTION, Caption, Staging."No.", InDecimal, '', STRSUBSTNO(Text001, InDecimal));
    end;

    local procedure ValidateIsDate(InDate: Text; Caption: Text) ReturnDate: Date;
    var
        Text001: Label 'Værdien "%1" er ikke en dato.';
    begin
        if not EVALUATE(ReturnDate, InDate) then
            LogError(Staging.TABLECAPTION, Caption, Staging."No.", InDate, '', STRSUBSTNO(Text001, InDate));
    end;
}

