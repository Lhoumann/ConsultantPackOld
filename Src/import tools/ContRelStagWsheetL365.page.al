page 71104 "Cont. Rel. Stag. Wsheet L365"
{
    Caption = 'Import Contact Relation Staging';
    PageType = Worksheet;
    SourceTable = "Contact Relation Staging L365";
    ApplicationArea = All;
    UsageCategory = Administration;
    DelayedInsert = true;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = All;
                }

                field("Contact 1 No."; Rec."Contact 1 No.")
                {
                    ToolTip = 'Specifies the value of the Contact 1No. field.';
                    ApplicationArea = All;
                }
                field("Contact 2 No."; Rec."Contact 2 No.")
                {
                    ToolTip = 'Specifies the value of the Contact 2 No. field.';
                    ApplicationArea = All;
                }
                field("Relation Code"; Rec."Relation Code")
                {
                    ToolTip = 'Specifies the value of the Relation Code field.';
                    ApplicationArea = All;
                }
                field("Your Reference"; Rec."Your Reference")
                {
                    ToolTip = 'Specifies the value of the Your Reference field.';
                    ApplicationArea = All;
                }
                field(Attention; Rec.Attention)
                {
                    ToolTip = 'Specifies the value of the Attention field.';
                    ApplicationArea = All;
                }
                field("Attention E-Mail"; Rec."Attention E-Mail")
                {
                    ToolTip = 'Specifies the value of the Email field.';
                    ApplicationArea = All;
                }
                field("Attention Invoice E-Mail"; Rec."Attention Invoice E-Mail")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                    ApplicationArea = All;
                }
                field("Attention Phone No."; Rec."Attention Phone No.")
                {
                    ToolTip = 'Specifies the value of the Attention Phone No. field.';
                    ApplicationArea = All;
                }
                field("Block Interaction"; Rec."Block Interaction")
                {
                    ToolTip = 'Specifies the value of the City field.';
                    ApplicationArea = All;
                }
                field("GLN No."; Rec."GLN No.")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                    ApplicationArea = All;
                }
                field("New Contact 1 No."; Rec."New Contact 1 No.")
                {
                    ToolTip = 'Specifies the value of the New Contact 1No. field.';
                    ApplicationArea = All;
                }
                field("New Contact 2 No."; Rec."New Contact 2 No.")
                {
                    ToolTip = 'Specifies the value of the New Contact 2 No. field.';
                    ApplicationArea = All;
                }

            }
        }

    }

    actions
    {
        area(Processing)
        {
            action(ImportRelations)
            {
                Caption = 'Import Contact Relations';
                RunObject = codeunit "Import Contact Relations2 L365";
                Image = Relationship;
                Promoted = true;
                ApplicationArea = All;
            }
            action(ValidateRelations)
            {
                Caption = 'Validate Contact Relations';
                Image = ValidateEmailLoggingSetup;
                Promoted = true;
                ApplicationArea = All;
                trigger OnAction()
                var
                    ExcelImportToolMgt: Codeunit ExcelImportToolMgtL365;
                begin
                    ExcelImportToolMgt.ValidateContactRelationFields();
                end;
            }
        }
        area(Navigation)
        {
            action(ShowLog)
            {
                Caption = 'Show Log';
                ApplicationArea = All;
                RunObject = page "Importlog L365";
                Image = Log;
            }

        }


    }
}
