codeunit 71107 "ImportDocumentTemplatesL365"
{
    trigger OnRun()
    var
        IStream: InStream;
        FromFile: Text;
        FileName: Text;
        FileMgt: Codeunit "File Management";

        SheetName: Text;
        MaxRowNo: Integer;
        RowNo: Integer;
        DocTemplate: Record TemplateL365;
        DocTypeTxt: Text;
        RepNoTxt: Text;

    begin
        //Ready Excel sheet for import
        UploadIntoStream('Select file to import', '', '', FromFile, IStream);
        if FromFile <> '' then begin
            FileName := FileMgt.GetFileName(FromFile);
            SheetName := tempExcelBuffer.SelectSheetsNameStream(IStream);
        end else
            error('No file');
        tempExcelBuffer.Reset();
        tempExcelBuffer.DeleteAll();
        tempExcelBuffer.OpenBookStream(IStream, SheetName);
        tempExcelBuffer.ReadSheet();
        //Process Sheet
        tempExcelBuffer.Reset();
        if tempExcelBuffer.FindLast() then
            MaxRowNo := tempExcelBuffer."Row No.";

        for RowNo := 2 to MaxRowNo do begin
            DocTemplate.Init();
            DocTemplate.code := GetValueAtCell(RowNo, 1);
            DocTemplate.Description := GetValueAtCell(RowNo, 2);
            DocTemplate."Data Source Code" := GetValueAtCell(RowNo, 3);
            DocTemplate."Default Folder" := GetValueAtCell(RowNo, 4);
            DocTemplate."Default Relation Type" := GetValueAtCell(RowNo, 5);
            RepNoTxt := GetValueAtCell(RowNo, 6);
            if (not evaluate(DocTemplate."Data Report No.", RepNoTxt)) and (RepNoTxt <> '') then
                LogError('Col6', GetValueAtCell(RowNo, 6), 'Report No. is not a number');
            DocTypeTxt := GetValueAtCell(RowNo, 7);
            case UpperCase(DocTypeTxt) of
                'DOC', 'DOCX':
                    DocTemplate."File Type" := DocTemplate."File Type"::Word;
                'XLS', 'XLSX':
                    DocTemplate."File Type" := DocTemplate."File Type"::Excel;
                'PDF':
                    DocTemplate."File Type" := DocTemplate."File Type"::PDF;
                'MSG':
                    DocTemplate."File Type" := DocTemplate."File Type"::Email;
                else
                    LogError('Col7', DocTypeTxt, 'Unknown file type');
            end;

            DocTemplate."Language Code" := GetValueAtCell(RowNo, 8);
            DocTemplate."Layout Code" := GetValueAtCell(RowNo, 9);
            DocTemplate."Merge Group Code" := GetValueAtCell(RowNo, 10);
            DocTemplate."Import File" := GetValueAtCell(RowNo, 11);

            if not DocTemplate.Insert() then
                DocTemplate.Modify();
        end;
    end;

    /*    procedure ImportWordTemplates()
       var
           Template: Record TemplateL365;
       begin
           Template.CalcFields("Template Layout")
           template.ImportLayout();

       end; */

    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin
        tempExcelBuffer.Reset();
        if tempExcelBuffer.get(RowNo, ColNo) then
            exit(tempExcelBuffer."Cell Value as Text")
        else
            exit('');

    end;

    local procedure LogError(FieldName: Text; Fieldvalue: Text; Msg: Text)
    begin
        if ImportLogL365."Entry No." = 0 then begin
            if ImportLogL365.FindLast() then
                ImportLogL365.Init();
            ImportLogL365."Entry No." += 1;
        end else begin
            ImportLogL365.Init();
            ImportLogL365."Entry No." += 1;
        end;
        ImportLogL365."Import Type" := ImportLogL365."Import Type"::Document;
        ImportLogL365."Error Description" := Msg;
        ImportLogL365."Field Name" := FieldName;
        ImportLogL365."Field Value" := Fieldvalue;
        ImportLogL365."Import By" := UserId;
        ImportLogL365."Import Time" := CurrentDateTime;
        ImportLogL365.Insert();
    end;

    var
        tempExcelBuffer: Record "Excel Buffer" temporary;
        ImportLogL365: Record "ImportLog L365";
}