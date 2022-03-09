page 71100 "Navokat2LegalSetupTool"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Navokat to Abakion Legal Setup';

    layout
    {
        area(Content)
        {
            group(GroupName)
            {

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(DoEverything)
            {
                ApplicationArea = All;
                Caption = 'Do everything for all companies';
                RunObject = codeunit Navokat2AbakionLegal;
                Image = AddAction;
                trigger OnAction()
                begin

                end;
            }
        }
        area(Navigation)
        {
            action(ShowLog)
            {
                ApplicationArea = All;
                Caption = 'Show Status Log';
                RunObject = page SetupStatusLog;
                Image = Log;
                RunPageMode = View;
            }
        }
    }

}