codeunit 71105 "UpdateAllSearchField4AllComp"
{
    trigger OnRun()
    begin
        LastID := Log.LogStart(CompanyName, 14, 'UpdateAllSearchFields');
        if Contact.FindSet() then
            repeat
                NavokatSearch.BuildSearchWords(Contact."No.");
            until Contact.Next() = 0;
        log.LogEnd(LastID);
    end;

    var
        NavokatSearch: Codeunit "Search Management L365";
        Contact: Record Contact;
        LastID: Integer;
        Log: Record Navokat2BCsetupStatus;
}