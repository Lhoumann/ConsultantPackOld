/// <summary>
/// Imports SharePoint WebSite ID's from a CSV file generated by an external (PowerShell) SiteCreation tool.
/// Also creates SharePoint Site records in Abakion Legal BC if not already present. 
/// </summary>
report 71100 "ImportSharePointWebsitesL365CP"
{
    Caption = 'Import SharePoint Websites from CSV file';
    UsageCategory = Tasks;
    ApplicationArea = All;
    ProcessingOnly = true;
    UseRequestPage = false;

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                }
            }
        }

        trigger OnOpenPage()
        begin
        end;

        trigger OnQueryClosePage(CloseAction: Action): Boolean
        begin
        end;
    }

    var
        SPSetup: Record "SharePoint Setup L365";
        SPSite: Record "SharePoint Site L365";
        FileName: Text;
        InStr: InStream;
        FileSelectionMsg: Label 'Please choose the Client Id CSV file.';

    trigger OnPreReport()
    var
    begin
    end;

    trigger OnPostReport()
    var
        Contact: Record "Contact";
        WebRequestHelper: Codeunit "Web Request Helper";
        Dlg: Dialog;
        TextLine: Text;
        RowNo, MaxRowNo : Integer;
        CreationTime: DateTime;
        SiteCollectionId, SiteId : Guid;
        SiteFound: Boolean;
        SharePointHostName, CreationTimeText, SiteCollectionIdText, SiteIdText, SiteName, CompanyNo : Text;
        TextFields: List of [Text];
        ErrorText: Text;
        ErrorCount: Integer;
        ErrorTexts: List of [Text];

    begin
        SPSetup.Get();
        SPSetup.TestField("SharePoint Location");
        SPSetup."SharePoint Location" := SPSetup."SharePoint Location".TrimEnd('/') + '/';
        //SPSetup.TestField("Hub Site ID"); // Only required when using hubsite instead of subsites
        SharepointHostName := WebRequestHelper.GetHostNameFromUrl(SPSetup."SharePoint Location");
        // Note, the SPSite.GetSiteByUrlGraph(Url: Text) gets both Site ID and Site Graph Full Id from API

        UploadIntoStream(FileSelectionMsg, '', '', FileName, InStr);

        RowNo := 0;
        Dlg.Open('Importing Site Is''s. Row no. #1\Errors encuntered: #2', RowNo, ErrorCount);
        while not InStr.EOS() do begin
            RowNo += 1;
            Dlg.Update();
            InStr.ReadText(TextLine);
            if (RowNo > 1) and (TextLine <> '') then begin
                if TextLine.StartsWith('"') then begin
                    TextLine := DelChr(TextLine, '<>', '"');
                    TextFields := TextLine.Split('","');
                end else
                    TextFields := TextLine.Split(',');

                ErrorText := '';

                if TextFields.Count() < 5 then
                    Errortext := '5 comma separated fields are expected'
                else begin
                    CreationTimeText := TextFields.Get(1);
                    SiteCollectionIdText := TextFields.Get(2);
                    SiteName := TextFields.Get(3); // danske bogstaver er fucked up her
                    SiteIdText := TextFields.Get(4);
                    CompanyNo := TextFields.Get(5);
                    If not Evaluate(CreationTime, CreationTimeText) then
                        ErrorText += StrSubstNo('Could not evaluate field 1 Creation Time as DateTime: %1. \', CreationTimeText);
                    if not Evaluate(SiteId, SiteIdText) then
                        ErrorText += StrSubstNo('Could not evaluate field 2 SiteId as Guid: %1. \', SiteIdText);
                    if not Evaluate(SiteCollectionId, SiteCollectionIdText) then
                        ErrorText += StrSubstNo('Could not evaluate field 3 SiteCollectionId as Guid: %1. \', SiteIdText);
                    if not Contact.get(CompanyNo) then
                        ErrorText += StrSubstNo('Could not find Company No. %1 in Contact table. \', CompanyNo);
                end;

                if ErrorText <> '' then begin
                    ErrorCount += 1;
                    if ErrorCount <= 10 then
                        ErrorTexts.Add(StrSubstNo('Error in line no. %1 : %2 \ Line text: %3', RowNo, ErrorText, TextLine));
                end else begin
                    SiteName := Contact.Name; // because the imported name is unknown encoding
                    SPSite.SetRange("Company No.", CompanyNo);
                    SiteFound := SPSite.FindFirst();
                    if not SiteFound then begin
                        SPSite.Init();
                        SPSite."Site No." := 0;
                    end;
                    SPSite.Validate("Company No.", CompanyNo);
                    SPSite.Validate("Site Collection", SPSetup."SharePoint Location");
                    SPSite.Validate("Site Name", SiteName);
                    SPSite.Validate("Site Description", CompanyNo + ' - ' + SiteName);
                    SPSite.Validate("Site URL", CompanyNo);
                    SPSite.Validate("Creation Time", CreationTime);
                    SPSite.Validate("Site ID", SiteId);
                    SPSite.Validate("SharePoint Site URL", SPSetup."SharePoint Location" + SPSite."Site URL"); // Nescessary??
                    SPSite.Validate("Site Graph Full Id", SharePointHostName + ',' + SiteCollectionIdText + ',' + SiteIdText);
                    SPSite.Validate("Hub Site ID", SPSetup."Hub Site ID"); // Nescessary !!
                    SPSite.Validate("Client Document Library", SPSetup."Client Document Repository");
                    SPSite.Validate("Matter Document Library", SPSetup."Matter Document Repository");
                    if SiteFound then
                        SPSite.Modify()
                    else
                        SPSite.Insert(true);
                end;
            end;
        end;
        Dlg.Close();
        if ErrorCount > 0 then
            Message('%1 Site Id''s imported. %2 lines had errors. The first error was: \%3', RowNo - 1 - ErrorCount, ErrorCount, ErrorTexts.Get(1))
        else
            Message('%1 Site Id''s imported', RowNo - 1);
    end;

    [TryFunction]
    procedure EvaluateCSVLine(CSVTextLine: Text)
    begin

    end;

    /*
        local procedure GetCellValueAsText(RowNo: Integer; ColumnNo: Integer) Return: Text
        begin
            ExcelBuf.Reset();
            if ExcelBuf.Get(RowNo, ColumnNo) then
                exit(ExcelBuf."Cell Value as Text")
            else
                exit('');
        end;

        local procedure GetCellValueAsDatetime(RowNo: Integer; ColumnNo: Integer) Return: DateTime
        var
            TmpText: Text;
        begin
            TmpText := GetCellValueAsText(RowNo, ColumnNo);
            if TmpText = '' then
                exit(0DT);

            Evaluate(Return, TmpText);
        end;


        local procedure GetCellValueAsGuid(RowNo: Integer; ColumnNo: Integer) Return: Guid
        var
            TmpText: Text;
        begin
            Clear(Return);

            TmpText := GetCellValueAsText(RowNo, ColumnNo);
            if TmpText = '' then
                exit;

            Evaluate(Return, TmpText);
        end;
    */
}