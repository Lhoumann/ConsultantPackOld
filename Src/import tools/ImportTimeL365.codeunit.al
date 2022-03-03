codeunit 71101 "Import Time L365"
{
    Permissions = tabledata "Job Ledger Entry" = rimd;

    trigger OnRun()
    begin
        StartTime := CURRENTDATETIME;
        RecordNo := 0;
        NoOfErrors := 0;
        ImportSetup.Get();
        StartTime := CurrentDateTime;
        FileManagement.BLOBImport(TempBlob, ExcelFileName);

        TempBlob.CreateInStream(InStr);
        TempExcelBuf.OpenBookStream(InStr, ExcelSheetName);
        TempExcelBuf.ReadSheet;
        ProcessTimeEntries();

        MESSAGE(Text0102, RecordNo - NoOfErrors, NoOfErrors);
    end;

    var
        TimeEntry: Record "Time Entry L365";
        ImportSetup: Record "Import Setup L365";
        TempExcelBuf: Record "Excel Buffer" temporary;
        FileManagement: Codeunit "File Management";
        TempBlob: Codeunit "Temp Blob";
        Instr: InStream;
        StartTime: DateTime;
        RecordHasError: Boolean;
        RecordNo: Integer;
        UnknownValErr: Label 'The Value does not exist in the underlying table.'; // DAN = 'Værdien findes ikke i den bagvedliggende tabel.'
        NoOfErrors: Integer;
        Text0102: Label 'No. of Lines imported:%1\No. of Lines with errors:%2'; // DAN = 'Antal linjer, der er importeret:%1\Antal linjer, der med fejl:%2'
        ExcelFileName: Label 'Tidspostimport_v2.0.xlsx';
        ExcelSheetName: Label 'Data';
        EmployeeNo, PostingDateTxt, MatterNo, WorkTypeCode, DescriptionTxt, QuantityTxt, ClosedText : Text;
        PostingDate: Date;
        Qty: Decimal;


    procedure ClearVars();
    begin
        CLEAR(EmployeeNo);
        CLEAR(PostingDateTxt);
        CLEAR(MatterNo);
        CLEAR(DescriptionTxt);
        CLEAR(WorkTypeCode);
        CLEAR(QuantityTxt);
    end;

    local procedure ProcessTimeEntries()
    var
        RowNo, MaxCount : Integer;
        Window: Dialog;
        StartRunTime: Time;
        TimeQueueBackground: Codeunit "Time Queue Background L365";

    begin
        StartRunTime := Time;
        TimeQueueBackground.RemoveJobQueues();
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
            ProcessTimeEntry(RowNo);
            Window.Update(1, RowNo);
            RowNo += 1;
        end;

        Window.Close();
        Message('Imported %1 time entries in %2 seconds', MaxCount, round((Time - StartRunTime) / 1000, 1));
    end;

    local procedure ProcessTimeEntry(RowNo: Integer);
    var
        JLE: Record "Job Ledger Entry";
        TimeEntryMgt: Codeunit "Time Entry Mgt. L365";
        EntryNo: Integer;

    begin
        ClearVars();
        ReadExcelLine(RowNo);

        RecordNo += 1;
        If EmployeeNo = '' then
            exit;

        RecordHasError := false;
        if ValidateEntry() then begin
            clear(TimeEntry);
            TimeEntry.Init();
            TimeEntry.SetDelayValidation(true);
            TimeEntry.Validate("Posting Date", PostingDate);
            TimeEntry.validate("Resource No.", EmployeeNo);
            TimeEntry.validate("Job No.", MatterNo);
            TimeEntry.Validate("Work Type Code", WorkTypeCode);
            TimeEntry.Validate(Quantity, Qty);
            TimeEntry.Validate(Description, DescriptionTxt);
            TimeEntry.ValidateEntry();
            TimeEntry.Insert();
            if UpperCase(ClosedText) in ['JA', 'YES', 'J', 'Y'] then begin
                if TimeEntryMgt.UpdateTimeEntry(TimeEntry) then begin
                    if JLE.Get(TimeEntry."Job Ledger Entry No.") then begin
                        JLE.OpenL365 := false;
                        JLE.Modify();
                    end;
                end else begin

                end;
            end;
        end else
            NoOfErrors += 1;
    end;

    local procedure ReadExcelLine(RowNo: Integer)
    begin
        EmployeeNo := GetCell(Rowno, 1);
        PostingDateTxt := GetCell(Rowno, 2);
        MatterNo := GetCell(Rowno, 3);
        WorkTypeCode := GetCell(Rowno, 4);
        DescriptionTxt := GetCell(RowNo, 5);
        QuantityTxt := GetCell(Rowno, 6);
        ClosedText := GetCell(RowNo, 7);
    end;

    local procedure ValidateEntry(): Boolean
    var
        Job: Record Job;
        Resource: Record Resource;
        WorkType: Record "Work Type";

    begin
        If not Job.Get(MatterNo) then begin
            LogError(Job.TABLECAPTION, Job.FIELDCAPTION("No."), EmployeeNo + '-' + PostingDateTxt, MatterNo, '', UnknownValErr);
            exit(false);
        end;

        PostingDate := ValidateIsDate(PostingDateTxt, TimeEntry.FieldCaption("Posting Date"));
        if PostingDate = 0D then
            exit(false);

        if not WorkType.Get(WorkTypeCode) then begin
            LogError(WorkType.TABLECAPTION, WorkType.FIELDCAPTION("Code"), EmployeeNo + '-' + PostingDateTxt, WorkTypeCode, '', UnknownValErr);
            exit(false);
        end;

        Qty := ValidateisDecimal(QuantityTxt, TimeEntry.FieldCaption(Quantity));
        if Qty = 0 then
            exit(false);

        exit(true);
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

    local procedure ValidateisDecimal(InDecimal: Text; Caption: Text) ReturnDecimal: Decimal;
    var
        Text001: Label 'Værdien "%1" er ikke et tal.';
    begin
        if not EVALUATE(ReturnDecimal, InDecimal) then
            LogError(TimeEntry.TABLECAPTION, Caption, EmployeeNo + '-' + PostingDateTxt, InDecimal, '', STRSUBSTNO(Text001, InDecimal));
    end;

    local procedure ValidateIsDate(InDate: Text; Caption: Text) ReturnDate: Date;
    var
        Text001: Label 'Værdien "%1" er ikke en dato.';
    begin
        ReturnDate := 0D;
        if not EVALUATE(ReturnDate, InDate) then
            LogError(TimeEntry.TABLECAPTION, Caption, EmployeeNo + '-' + PostingDateTxt, InDate, '', STRSUBSTNO(Text001, InDate));
    end;
}

