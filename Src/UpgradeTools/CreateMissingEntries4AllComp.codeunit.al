codeunit 71106 "CreateMissingEntries4AllComp"
{
    trigger OnRun()
    var
        CreateTimeEntriesL365: Report "Create Time Entries L365";
    begin
        LastID := Log.LogStart(CompanyName, 14, 'Create Missing Time Entries');
        CreateTimeEntriesL365.UseRequestPage(false);
        CreateTimeEntriesL365.RunModal();
        log.LogEnd(LastID);
    end;

    var
        LastID: Integer;
        Log: Record Navokat2BCsetupStatus;
}