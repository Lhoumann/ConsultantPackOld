codeunit 71109 "TimeEntriesWithTimeStamp"
{
    Permissions = tabledata "Time Entry L365" = rimd;
    trigger OnRun()
    begin
        LastID := Log.LogStart(CompanyName, 17, 'Time Entries - Time stamp');
        JobLedgerEntry.SetFilter("Start time L365", '<>%1', 0T);
        if JobLedgerEntry.FindSet() then begin
            repeat
                if TimeEntry.Get(JobLedgerEntry."Time Entry No. L365") then begin
                    if TimeEntry."Start Time" = 0T then begin
                        TimeEntry."Start Time" := JobLedgerEntry."Start time L365";
                        TimeEntry."End Time" := JobLedgerEntry."End time L365";
                        TimeEntry.Modify();
                    end;

                end;
            until JobLedgerEntry.Next() = 0;
        end;
        log.LogEnd(LastID);
    end;

    var
        MyComp: Record Company;
        JobLedgerEntry: Record "Job Ledger Entry";
        TimeEntry: Record "Time Entry L365";
        i: Integer;
        LastID: Integer;
        Log: Record Navokat2BCsetupStatus;

}