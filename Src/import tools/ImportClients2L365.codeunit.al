codeunit 71111 "Import Clients2 L365"
{
    trigger OnRun()
    begin
        ImportSetup.Get();
        StartTime := CurrentDateTime;
        FileManagement.BLOBImport(TempBlob, ExcelFileName);
        AllowUpdate := ImportSetup."Overwrite Existing Records";
        ValidatePostCode := ImportSetup."Validate Post Codes";
        AutoCreatePostCode := ImportSetup."Auto Create Post Codes";
        TempBlob.CreateInStream(InStr);
        TempExcelBuf.OpenBookStream(InStr, ExcelSheetName);
        TempExcelBuf.ReadSheet;
        ProcessClients();
    end;

    var
        ContStaging: Record "Contact Staging L365";
        Cont2: Record Contact;
        Cont3: Record Contact;
        AbakionLegalSetup: Record "AbakionLegal Setup L365";
        ContactRel: Record "Contact Relation L365";
        CustTemplate: Record "Customer Template";
        TempExcelBuf: Record "Excel Buffer" temporary;

        ImportSetup: Record "Import Setup L365";
        NavokatSearch: Codeunit "Search Management L365";
        RelMgt: Codeunit "Global Relation Mgt. L365";
        FileManagement: Codeunit "File Management";
        TempBlob: Codeunit "Temp Blob";
        InStr: InStream;
        StartTime: DateTime;
        RecordHasError, AllowUpdate, Update, ValidatePostCode, HasHeading, AutoCreatePostCode : Boolean;
        RecordNo: Integer;
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
        ContactComment: Text;

        Text0102: Label 'No. of Lines imported:%1\No. of Lines with errors:%2'; // DAN = 'Antal linjer, der er importeret:%1\Antal linjer, der med fejl:%2'
        Text0103: Label '%1 must not be blank.'; // DAN = '%1 må ikke være blank'

        ExcelFileName: Label 'KlientImport_v1.1.xlsx';
        ExcelSheetName: Label 'Ark1';


    local procedure ProcessClients()
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
            ProcessClient(RowNo);
            Window.Update(1, RowNo);
            RowNo += 1;
        end;

        Window.Close();
        Message('Imported %1 clients in %2 seconds', MaxCount, round((Time - StartRunTime) / 1000, 1));
    end;

    local procedure ProcessClient(RowNo: Integer)
    var
        Cont: Record Contact;
        Language: Record Language;
    begin
        ClearVars();
        ReadExcelLine(RowNo);

        RecordNo += 1;
        If ContactNo = '' then
            exit;

        RecordHasError := false;
        ContStaging.INIT;
        ContStaging."Import Type" := ContStaging."Import Type"::Client;
        ContStaging."No." := ValidateFieldLength(ContactNo, 20, ContStaging.FIELDCAPTION("No."));
        ContStaging."Company No." := ContStaging."No.";
        ContStaging.Name := ValidateFieldLength(ContactName, MAXSTRLEN(ContStaging.Name), ContStaging.FIELDCAPTION(Name));
        ContStaging."Name 2" := ValidateFieldLength(ContactName2, 50, ContStaging.FIELDCAPTION("Name 2"));
        ContStaging."Search Name" := ValidateFieldLength(ContactSearchName, MAXSTRLEN(ContStaging."Search Name"), ContStaging.FIELDCAPTION("Search Name"));
        ContStaging.Address := ValidateFieldLength(ContactAddress, MAXSTRLEN(ContStaging.Address), ContStaging.FIELDCAPTION(Address));
        ContStaging."Address 2" := ValidateFieldLength(ContactAddress2, MAXSTRLEN(ContStaging."Address 2"), ContStaging.FIELDCAPTION("Address 2"));
        ContStaging."Post Code" := ValidateFieldLength(ContacPostCode, 20, ContStaging.FIELDCAPTION("Post Code"));
        ContStaging.City := ValidateFieldLength(ContactCity, 30, ContStaging.FIELDCAPTION(City));
        ContStaging."Country/Region Code" := ValidateFieldLength(ContactCountryRegionCode, 10, ContStaging.FIELDCAPTION("Country/Region Code"));
        ContStaging."VIP Client L365" := ValidateIsBoolean(ContactVIP, ContStaging.FIELDCAPTION("VIP Client L365"));
        ContStaging."E-Mail" := ValidateFieldLength(ContactEMail, 80, ContStaging.FIELDCAPTION("E-Mail"));
        ContStaging."Phone No." := ValidateFieldLength(ContactPhoneNo, 30, ContStaging.FIELDCAPTION("Phone No."));
        ContStaging."Private Phone No." := ValidateFieldLength(ContactPrivatePhoneNo, 30, Cont.FIELDCAPTION("Private Phone No. L365"));
        ContStaging."Fax No." := ValidateFieldLength(ContactFaxNo, 30, Cont.FIELDCAPTION("Fax No."));
        ContStaging."Home Page" := ValidateFieldLength(ContactHomePage, 80, ContStaging.FIELDCAPTION("Home Page"));
        ContStaging."Mobile Phone No." := ValidateFieldLength(ContactMobilePhoneNo, 20, ContStaging.FIELDCAPTION("Mobile Phone No."));
        ContStaging."VAT Registration No." := ValidateFieldLength(ContactVATRegistrationNo, 20, ContStaging.FIELDCAPTION("VAT Registration No."));
        ContStaging."SE-nummer L365" := ValidateFieldLength(ContactSENummer, 20, ContStaging.FIELDCAPTION("SE-nummer L365"));
        ContStaging."Civil Registration No. L365" := ValidateFieldLength(ContactCivilRegistrationNo, 20, ContStaging.FIELDCAPTION("Civil Registration No. L365"));
        ContStaging."Language Code" := ValidateFieldLength(ContactLanguageCode, 10, ContStaging.FIELDCAPTION("Language Code"));
        ContStaging.AttentionL365 := ValidateFieldLength(ContactAttention, 50, ContStaging.FIELDCAPTION(AttentionL365));
        ContStaging."Bank Branch No. L365" := ValidateFieldLength(ContactBankBranchNo, 20, ContStaging.FIELDCAPTION("Bank Branch No. L365"));
        ContStaging."Bank Account No. L365" := ValidateFieldLength(ContactBankAccountNo, 30, ContStaging.FIELDCAPTION("Bank Account No. L365"));
        ContStaging."Customer Template Code L365" := ValidateFieldLength(ContactTemplateCode, 10, ContStaging.FIELDCAPTION("Customer Template Code L365"));
        ContactClientResponsible := ValidateFieldLength(ContactClientResponsible, 10, ContStaging.FIELDCAPTION("Customer Template Code L365"));
        ContStaging."First Name" := ValidateFieldLength(ContactFirstName, 80, ContStaging.FIELDCAPTION("First Name"));
        ContStaging."Middle Name" := ValidateFieldLength(ContactMiddleName, 50, ContStaging.FIELDCAPTION("Middle Name"));
        ContStaging."Sur name" := ValidateFieldLength(ContactLastName, 50, Cont.FIELDCAPTION(Surname));
        ContStaging."Salutation Code" := ValidateFieldLength(ContactSalutationCode, 10, ContStaging.FIELDCAPTION("Salutation Code"));
        ContStaging.Comment := ValidateFieldLength(ContactComment, 250, ContStaging.FieldCaption(Comment));



        if not ContStaging.Insert() then
            ContStaging.Modify();

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
        Clear(ContactComment);
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
        ContactComment := GetCell(RowNo, 32);
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
            LogError(ContStaging.TABLECAPTION, Caption, ContStaging."No.", InStr, '', STRSUBSTNO(Text001, STRLEN(InStr), MaxLength));
            exit(copystr(InStr, 1, MaxLength));
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
}