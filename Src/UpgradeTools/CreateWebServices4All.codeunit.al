codeunit 71104 "CreateWebServices4All"
{
    trigger OnRun()
    begin
        LastID := Log.LogStart(CompanyName, 4, 'CreateWebservices');
        CreateSetup.InitWebServices();
        log.LogEnd(LastID);
    end;

    var
        CreateSetup: Codeunit "Create Setup Data EN L365";
        Log: Record Navokat2BCsetupStatus;
        LastID: Integer;
}