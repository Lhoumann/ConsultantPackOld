page 71107 "Consultant Pack CP L365"
{
    Caption = 'Consultant Pack CP L365';
    PageType = Card;
    SourceTable = "AbakionLegal Setup L365";
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Teamviewer Download URL"; Rec."Teamviewer Download URL")
                {
                    ToolTip = 'Specifies the value of the Teamviewer Download URL field.';
                    ApplicationArea = All;
                }
                field("Abakion Legal Guides URL"; Rec."Abakion Legal Guides URL")
                {
                    ToolTip = 'Specifies the value of the Abakion Legal Guides URL field';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group(Upgrade)
            {
                Caption = 'Upgrade'; // DAN = 'Opgradering'
                Image = WorkflowSetup;

                action(A3111010)
                {
                    Caption = '1010 - Move Allocation Lines to new tables';
                    ApplicationArea = All;
                    Image = BulletList;

                    trigger OnAction()
                    var
                        Upgrade: Codeunit UpgradeCodeunits;

                    begin
                        Upgrade.PerformUpgradeA3111010();
                        Message('Done!');
                    end;
                }
                action(A3111056)
                {
                    Caption = '1056 - Line Type added';
                    ApplicationArea = All;
                    Image = BulletList;

                    trigger OnAction()
                    var
                        Upgrade: Codeunit UpgradeCodeunits;

                    begin
                        Upgrade.PerformUpgradeA3111056();
                        Message('Done!');
                    end;
                }

                action(A3111233)
                {
                    Caption = '1233 - To-do replacement';
                    ApplicationArea = All;
                    Image = BulletList;

                    trigger OnAction()
                    var
                        Upgrade: Codeunit UpgradeCodeunits;

                    begin
                        Upgrade.PerformUpgradeA3111233();
                        Message('Done!');
                    end;
                }
                action(A3111260)
                {
                    Caption = '1260 - Update Employee Dim On Allocations';
                    ApplicationArea = All;
                    Image = BulletList;

                    trigger OnAction()
                    var
                        Upgrade: Codeunit UpgradeCodeunits;

                    begin
                        Upgrade.PerformUpgradeA3111260();
                        Message('Done!');
                    end;
                }
                action(VP0059584)
                {
                    Caption = '584 - Update Split percentages';
                    ApplicationArea = All;
                    Image = BulletList;

                    trigger OnAction()
                    var
                        Upgrade: Codeunit UpgradeCodeunits;

                    begin
                        Upgrade.PerformUpgradeVP0059584();
                        Message('Done!');
                    end;
                }
                action(SummaryUpdate)
                {
                    Caption = 'Update Summary Code';
                    ApplicationArea = All;
                    Image = BulletList;

                    trigger OnAction()
                    var
                        Upgrade: Codeunit UpgradeCodeunits;

                    begin
                        Upgrade.PerformUpgradeSummaryCode();
                        Message('Done!');
                    end;
                }

            }
            group(CorrectionPages)
            {
                Caption = 'Correction Pages';

                action(CorrectTimeEntries)
                {
                    ApplicationArea = All;
                    Caption = 'Correct Time Entries';
                    Image = List;

                    trigger OnAction()
                    begin
                        page.Run(page::"Correct Time Entries CP L365");
                    end;
                }
            }
        }
    }
}
