codeunit 71103 SandboxCleanupEventsL365CP
{
    //After introducing this event a sandbx could not be created. So now trying outcomment the eventsubscriber decoration 
    //Todo: Investigare if this is the cause and cant it be fixed. 
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sandbox Cleanup", 'OnClearCompanyConfiguration', '', true, true)]
    local procedure OnClearCompanyConfiguration(CompanyName: Text)
    var
        SetupTestEnvironment: Codeunit "SetupTestEnvironmentL365CP";
    begin
        if SetupTestEnvironment.PrepareTestEnvironment(CompanyName) then;
    end;

}
