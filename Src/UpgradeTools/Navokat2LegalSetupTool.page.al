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
            action(CleanUpDoubleTimeEntries)
            {
                ApplicationArea = All;
                Caption = 'Delete all TimeEntries';
                ToolTip = 'Delete all time entries and resets Job Ledger Entries to allow re-generatoin of Time entries';
                RunObject = codeunit CleanupDoubleTimeEntries;
                Image = AddAction;
                trigger OnAction()
                begin

                end;
            }
            /*        action(FixBlankStartTime)
                   {
                       ApplicationArea = All;
                       Caption = 'Update Time Entries with Start Time';
                       ToolTip = 'Updates Time Entries with start time from job ledger entries. No deletion. And only update if start time is blank on time entry';
                       RunObject = codeunit TimeEntriesWithTimeStamp;
                       Image = AddAction;
                       trigger OnAction()
                       begin

                       end;
                   } */
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