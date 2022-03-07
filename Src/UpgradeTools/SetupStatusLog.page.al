page 71102 "SetupStatusLog"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Navokat2BCsetupStatus;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Company Name"; "Company Name")
                {
                    ApplicationArea = All;
                }
                field("Job Id"; "Job Id")
                {
                    ApplicationArea = all;
                }
                field("Job Name"; "Job Name")
                {
                    ApplicationArea = All;
                }
                field(Started; Started)
                {
                    ApplicationArea = All;
                }
                field(Ended; Ended)
                {
                    ApplicationArea = All;
                }
                field(Lenght; Lenght)
                {
                    ApplicationArea = all;
                }

            }
        }

    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}