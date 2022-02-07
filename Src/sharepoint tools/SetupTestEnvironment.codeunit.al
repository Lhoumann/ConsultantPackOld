codeunit 71102 SetupTestEnvironmentL365CP
{
    var
        SharePointSetup: Record "SharePoint Setup L365";
        SharepointSite: Record "SharePoint Site L365";
        CompanyInformation: Record "Company Information";
        ConfirmMsg: Label 'Preparing test environment. This will delete references to production SharePoint. New links to a test SharePoint can created later. Continue?'; //DAN='Forbereder testmiljø. Dette vil fjerne referencer til produktions SharePoint- Nye referencer til et test SharePoint kan oprettes senere. Fortsæt?'
        CompletedMsg: Label 'The environment is now disconnected from production SharePoint and labelled as "TEST"'; // DAN='Miljøet er nu afkoblet fra produktions SharePoint og mærket som "TEST";

    trigger OnRun()
    begin
        if not Confirm(ConfirmMsg, false) then
            exit;
        PrepareTestEnvironment(CompanyName);
        Message(CompletedMsg);
    end;

    [TryFunction]
    procedure PrepareTestEnvironment(pCompanyName: Text)
    begin
        if (pCompanyName <> '') and (pCompanyName <> CompanyName) then begin
            CompanyInformation.ChangeCompany(pCompanyName);
            SharePointSetup.ChangeCompany(pCompanyName);
            SharepointSite.ChangeCompany(pCompanyName);
        end;

        if CompanyInformation.Get() then begin
            CompanyInformation."System Indicator" := CompanyInformation."System Indicator"::Custom;
            CompanyInformation."System Indicator Style" := CompanyInformation."System Indicator Style"::Accent9;
            CompanyInformation."Custom System Indicator Text" := 'TEST';
            CompanyInformation.Modify();
        end;

        If SharePointSetup.Get() then begin
            If not SharePointSetup."SharePoint Location".TrimEnd('/').ToLower().EndsWith('test') then begin
                SharePointSetup."SharePoint Location" := SharePointSetup."SharePoint Location".TrimEnd('/') + 'Test/';
                SharePointSetup.Modify();
            end;
        end;
        SharepointSite.DeleteAll(false);
    end;

}
