codeunit 71100 EnvironmentCleanupEventsL365CP
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Environment Cleanup", 'OnClearCompanyConfig', '', true, true)]
    local procedure OnClearCompanyConfig(CompanyName: Text; SourceEnv: Enum "Environment Type"; DestinationEnv: Enum "Environment Type")
    var
        SetupTestEnvironment: Codeunit "SetupTestEnvironmentL365CP";
    begin
        if (SourceEnv = SourceEnv::Production) and (DestinationEnv = DestinationEnv::Sandbox) then
            if SetupTestEnvironment.PrepareTestEnvironment(CompanyName) then;
    end;
}
