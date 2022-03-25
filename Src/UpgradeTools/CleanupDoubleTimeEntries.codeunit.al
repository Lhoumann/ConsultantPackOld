codeunit 71108 "CleanupDoubleTimeEntries"
{
    Permissions = tabledata "Job Ledger Entry" = rimd;
    trigger OnRun()
    begin
        if Company.FindSet() then begin
            repeat
                TimeEntryL365.ChangeCompany(Company.Name);
                TimeEntryL365.SetFilter("Job Ledger Entry No.", '<>0');
                TimeEntryL365.DeleteAll();

                JobLedgerEntry.ChangeCompany(Company.Name);
                JobLedgerEntry.ModifyAll("Time Entry No. L365", 0);
                until Company.Next() = 0;
        end;
            Message('Done');

        end;

    var
        Company: Record Company;
        TimeEntryL365: Record "Time Entry L365";
        JobLedgerEntry: Record "Job Ledger Entry";
}