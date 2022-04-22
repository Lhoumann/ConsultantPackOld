page 71109 "Correct Time Entries CP L365"
{
    ApplicationArea = All;
    Caption = 'Correct Time Entries CP L365';
    PageType = List;
    SourceTable = "Time Entry L365";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Resource No."; Rec."Resource No.")
                {
                    ApplicationArea = All;
                }
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = All;
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                    ApplicationArea = All;
                }
                field("Job Ledger Entry No."; Rec."Job Ledger Entry No.")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = All;
                }
                field("Synch Status"; Rec."Synch Status")
                {
                    ApplicationArea = All;
                }
                field("Validation Failed"; Rec."Validation Failed")
                {
                    ApplicationArea = All;
                }
                field("Start Time"; Rec."Start Time")
                {
                    ApplicationArea = All;
                }
                field("End Time"; Rec."End Time")
                {
                    ApplicationArea = All;
                }
                field("Usage Category Code"; Rec."Usage Category Code")
                {
                    ApplicationArea = All;
                }
                field("Work Type Code"; Rec."Work Type Code")
                {
                    ApplicationArea = All;
                }
                field("Value Process Code"; Rec."Value Process Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Chargeable; Rec.Chargeable)
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field("External Id"; Rec."External Id")
                {
                    ApplicationArea = All;
                }
                field("First Validation Error"; Rec."First Validation Error")
                {
                    ApplicationArea = All;
                }
                field(Incomplete; Rec.Incomplete)
                {
                    ApplicationArea = All;
                }
                field("Last Modification"; Rec."Last Modification")
                {
                    ApplicationArea = All;
                }
                field("Last Posted"; Rec."Last Posted")
                {
                    ApplicationArea = All;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = All;
                }
                field("Line Amount (LCY)"; Rec."Line Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ApplicationArea = All;
                }
                field(Minutes; Rec.Minutes)
                {
                    ApplicationArea = All;
                }
                field(Modified; Rec.Modified)
                {
                    ApplicationArea = All;
                }
                field(Source; Rec.Source)
                {
                    ApplicationArea = All;
                }
                field("Template Code"; Rec."Template Code")
                {
                    ApplicationArea = All;
                }
                field("Total Price"; Rec."Total Price")
                {
                    ApplicationArea = All;
                }
                field("Total Price (LCY)"; Rec."Total Price (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                }
                field("Unit price (LCY)"; Rec."Unit price (LCY)")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        Rec.SetDelayValidation(true);
    end;
}
