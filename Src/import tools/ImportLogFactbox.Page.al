page 71105 "Import Log Factbox"
{
    Caption = 'Import Log Factbox';
    PageType = CardPart;

    layout
    {
        area(content)
        {
            field(NoOfWarnings; NoOfWarnings)
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(NoOfErrors; NoOfErrors)
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
    trigger OnOpenPage()
    begin
        UpdateStats();
    end;

    trigger OnAfterGetRecord()
    begin
        UpdateStats();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        UpdateStats();
    end;

    local procedure UpdateStats()
    var
        ImportLog: Record "ImportLog L365";
    begin
        ImportLog.SetRange("Entry Type", ImportLog."Entry Type"::Warning);
        NoOfWarnings := ImportLog.Count;
        ImportLog.SetRange("Entry Type", ImportLog."Entry Type"::Error);
        NoOfErrors := ImportLog.Count;
    end;

    var
        NoOfErrors, NoOfWarnings : integer;
}
