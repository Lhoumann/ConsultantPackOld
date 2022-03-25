codeunit 71114 "Import Contact Relations2 L365"
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
        ProcessContactRelations();

    end;

    var
        Staging: Record "Contact Relation Staging L365";
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
        ContactNo1, ContactNo2 : Text;
        RelationCode, YourReference, Attention, AttentionPhoneNo, AttentionEmail, AttentionInvoiceEmail, BlockInteractions, GLN : text;


    procedure ClearVars();
    begin
        CLEAR(ContactNo1);
        CLEAR(ContactNo2);
        CLEAR(RelationCode);
        CLEAR(YourReference);
        CLEAR(Attention);
        CLEAR(AttentionEmail);
        CLEAR(AttentionInvoiceEmail);
        CLEAR(AttentionPhoneNo);
        CLEAR(BlockInteractions);
        CLEAR(GLN);

    end;

    local procedure ProcessContactRelations()
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
            ProcessContactRelation(RowNo);
            Window.Update(1, RowNo);
            RowNo += 1;
        end;

        Window.Close();
        Message('Imported %1 contact relations in %2 seconds', MaxCount, round((Time - StartRunTime) / 1000, 1));
    end;

    local procedure ProcessContactRelation(RowNo: Integer);
    begin
        ClearVars();
        ReadExcelLine(RowNo);

        RecordNo += 1;
        If (ContactNo1 = '') then
            exit;

        RecordHasError := false;
        Staging.INIT;

        Staging."Contact 1 No." := ValidateFieldLength(ContactNo1, 20, Staging.FIELDCAPTION("Contact 1 No."));
        Staging."Contact 2 No." := ValidateFieldLength(ContactNo2, 20, Staging.FIELDCAPTION("Contact 2 No."));
        Staging."Relation Code" := ValidateFieldLength(RelationCode, 20, Staging.FIELDCAPTION("Contact 2 No."));
        Staging."Your Reference" := ValidateFieldLength(YourReference, 250, Staging.FIELDCAPTION("Your Reference"));
        Staging.Attention := ValidateFieldLength(Attention, 20, Staging.FIELDCAPTION(Attention));
        Staging."Attention E-mail" := ValidateFieldLength(AttentionEmail, 80, Staging.FIELDCAPTION(Attention));
        Staging."Attention Invoice E-Mail" := ValidateFieldLength(AttentionInvoiceEmail, 80, Staging.FIELDCAPTION("Attention Invoice E-Mail"));
        Staging."Attention Phone No." := ValidateFieldLength(AttentionPhoneNo, 30, Staging.FIELDCAPTION("Attention Phone No."));
        Staging."Block Interaction" := NOT (uppercase(BlockInteractions) in ['', 'NEJ', 'NO']);

        if not Staging.Insert() then
            Staging.Modify();
    end;

    local procedure ReadExcelLine(RowNo: Integer)
    begin
        ContactNo1 := GetCell(Rowno, 1);
        ContactNo2 := GetCell(Rowno, 2);
        RelationCode := GetCell(Rowno, 3);
        YourReference := GetCell(Rowno, 4);
        Attention := GetCell(RowNo, 5);
        AttentionEmail := GetCell(Rowno, 6);
        AttentionInvoiceEmail := GetCell(Rowno, 7);
        AttentionPhoneNo := GetCell(Rowno, 8);
        BlockInteractions := GetCell(Rowno, 9);

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
            LogError(Staging.TABLECAPTION, Caption, Staging."Contact 1 No.", InStr, Staging."Contact 2 No.", STRSUBSTNO(Text001, STRLEN(InStr), MaxLength));
            exit('');
        end else
            exit(InStr);
    end;

    local procedure ValidateIsInteger(InInteger: Text; Caption: Text) ReturnInt: Integer;
    var
        Text001: Label 'Værdien "%1" er ikke et tal.';
    begin
        if not EVALUATE(ReturnInt, InInteger) then
            LogError(Staging.TABLECAPTION, Caption, Staging."Contact 1 No.", InInteger, Staging."Contact 2 No.", STRSUBSTNO(Text001, InInteger));
    end;

    local procedure ValidateisDecimal(InDecimal: Text; Caption: Text) ReturnDecimal: Decimal;
    var
        Text001: Label 'Værdien "%1" er ikke et tal.';
    begin
        if not EVALUATE(ReturnDecimal, InDecimal) then
            LogError(Staging.TABLECAPTION, Caption, Staging."Contact 1 No.", InDecimal, Staging."Contact 2 No.", STRSUBSTNO(Text001, InDecimal));
    end;

    local procedure ValidateIsDate(InDate: Text; Caption: Text) ReturnDate: Date;
    var
        Text001: Label 'Værdien "%1" er ikke en dato.';
    begin
        if not EVALUATE(ReturnDate, InDate) then
            LogError(Staging.TABLECAPTION, Caption, Staging."Contact 1 No.", InDate, Staging."Contact 2 No.", STRSUBSTNO(Text001, InDate));
    end;
}

