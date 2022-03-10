codeunit 71103 "Navokat2AbakionLegal"
{
    trigger OnRun()
    begin
        //Find company with logo
        LogoCompany.FindSet();
        repeat
            LogoCompanyInf.ChangeCompany(LogoCompany.Name);
            LogoCompanyInf.get();
            if LogoCompanyInf.MasterCompany then
                MasterCompanyName := LogoCompany.Name;

        until (LogoCompany.next = 0) or (MasterCompanyName <> '');
        LogoCompany.get(MasterCompanyName);
        LogoCompanyInf.ChangeCompany(LogoCompany.Name);
        LogoCompanyInf.get();
        LogoCompanyInf.CalcFields(Picture);

        //Update all companies
        Company.FindSet();
        repeat
            RemoveDomain(Company.Name);
            CorrectUserID(Company.Name);
            CorrectVATSetup(Company.Name);
            GeneralURL(Company.Name);
            CreateWebservices(Company.Name);
            ChangeDMS(Company.Name);
            UpdateISOCodes(Company.Name);
            UpdageLanguageCodes(Company.Name);
            UpdateGLPostingSetup(Company.Name);
            SetupReportSelection(Company.Name);
            SetupLogo(Company.Name, LogoCompanyInf);
            UpdateDictionary(Company.Name);
            CreateMissingTimeEntry(Company.Name);
            UpdateAllSearchFields(Company.Name);
            TransferMastertoSlaveCompanies((Company.Name));
        until Company.Next() = 0;
    end;

    local procedure RemoveDomain(ThisCompanyname: Text)
    var
        UserSetup: Record "User Setup";
        UserSetup2: Record "User Setup";

        BasicL365: Codeunit "Basic L365";
    begin
        LastID := Log.LogStart(ThisCompanyname, 1, 'RemoveDomain');
        UserSetup.ChangeCompany(ThisCompanyname);
        UserSetup2.ChangeCompany(ThisCompanyname);
        if UserSetup.FindSet() then begin
            repeat
                UserSetup.Delete();
                UserSetup2 := UserSetup;
                UserSetup2."User ID" := BasicL365.GetSpecificUserID(UserSetup."User ID");
                UserSetup2.Insert();
            until UserSetup.next = 0;
        end;
        log.LogEnd(LastID);
    end;

    local procedure CorrectUserID(ThisCompanyname: Text)
    var
        SharePointSetupL365: Record "SharePoint Setup L365";
        OutlookUserSetupL365: Record "Outlook User Setup L365";
        OutlookUserSetup2L365: Record "Outlook User Setup L365";
        BasicL365: Codeunit "Basic L365";
    begin
        LastID := Log.LogStart(ThisCompanyname, 2, 'CorrectUserID');
        SharePointSetupL365.ChangeCompany(ThisCompanyname);
        OutlookUserSetupL365.ChangeCompany(ThisCompanyname);
        OutlookUserSetup2L365.ChangeCompany(ThisCompanyname);
        if not SharePointSetupL365.get() then
            exit;
        if OutlookUserSetupL365.FindSet() then begin
            repeat
                OutlookUserSetupL365.Delete();
                OutlookUserSetup2L365 := OutlookUserSetupL365;
                OutlookUserSetup2L365."User ID" := BasicL365.GetSpecificUserID(OutlookUserSetupL365."User ID");
                OutlookUserSetup2L365."SharePoint User Name" := SharePointSetupL365."SharePoint Default User";
                OutlookUserSetup2L365."SharePoint Password" := SharePointSetupL365."SharePoint Default Password";
                OutlookUserSetup2L365.Insert();
            until OutlookUserSetupL365.Next() = 0;
        end;
        log.LogEnd(LastID);
    end;

    local procedure GeneralURL(ThisCompanyname: Text)
    var
        OLSetup: Record "Outlook Setup L365";
    begin
        LastID := Log.LogStart(ThisCompanyname, 3, 'GeneralURL');
        OLSetup.ChangeCompany(ThisCompanyname);
        if OLSetup.FindFirst() then begin
            OLSetup."Time Web Client URL" := copystr(GetUrl(ClientType::Web, ThisCompanyname, ObjectType::Page, page::"Time Entries L365"), 1, MaxStrLen(OLSetup."Time Web Client URL"));
            OLSetup.Modify();
        end;
        log.LogEnd(LastID);
    end;

    local procedure CreateWebservices(ThisCompanyname: Text)
    var
        id: Integer;
    begin
        if StartSession(id, codeunit::CreateWebServices4All, ThisCompanyname) then;
    end;

    local procedure ChangeDMS(ThisCompanyname: Text)
    var
        DocumentSetupL365: Record "Document Setup L365";
    begin
        LastID := Log.LogStart(ThisCompanyname, 5, 'ChangeDMS');
        DocumentSetupL365.ChangeCompany(ThisCompanyname);
        if DocumentSetupL365.Get() then begin
            DocumentSetupL365.DMS := 'SHAREPOINT';
            DocumentSetupL365."Document No. in File Names" := false;
            DocumentSetupL365.Modify();
        end;

        log.LogEnd(LastID);
    end;

    local procedure UpdateISOCodes(ThisCompanyname: Text)
    var
        Language: Record Language;
    begin
        LastID := Log.LogStart(ThisCompanyname, 6, 'UpdateISOCodes');
        Language.ChangeCompany(ThisCompanyname);
        if Language.get('DK') then begin
            Language."ISO Language Code L365" := 'DA-DK';
            Language.Modify();
        end;
        if Language.get('ENU') then begin
            Language."ISO Language Code L365" := 'EN-US';
            Language.Modify();
        end;
        log.LogEnd(LastID);
    end;

    local procedure UpdageLanguageCodes(ThisCompanyname: Text)
    var
        CompanyInformation: Record "Company Information";
    begin
        LastID := Log.LogStart(ThisCompanyname, 7, 'UpdageLanguageCodes');
        CompanyInformation.ChangeCompany(ThisCompanyname);
        CompanyInformation.get();
        CompanyInformation."Primary Language Code L365" := 'DK';
        CompanyInformation.Modify();
        log.LogEnd(LastID);
    end;

    local procedure CorrectVATSetup(ThisCompanyname: Text)
    var
        VATPostingSetup: Record "VAT Posting Setup";
        VATPostingSetup2: Record "VAT Posting Setup";
    begin
        LastID := Log.LogStart(ThisCompanyname, 8, 'CorrectVATSetup');
        VATPostingSetup.ChangeCompany(ThisCompanyname);
        VATPostingSetup2.ChangeCompany(ThisCompanyname);
        VATPostingSetup2.SetRange("Disburs. (Y/N) L365", true);
        VATPostingSetup2.SetFilter("Disburs. Account L365", '<>%1', '');
        if VATPostingSetup2.FindFirst() then begin
            VATPostingSetup.SetRange("Disburs. (Y/N) L365", true);
            if VATPostingSetup.FindSet() then begin
                repeat
                    VATPostingSetup."Disburs. Account L365" := VATPostingSetup2."Disburs. Account L365";
                    VATPostingSetup.Modify();
                until VATPostingSetup.Next() = 0;
            end;
        end;
        log.LogEnd(LastID);
    end;

    local procedure UpdateGLPostingSetup(ThisCompanyname: Text)
    var
        GeneralPostingSetup: Record "General Posting Setup";
        ContactJobSubtypeL365: Record "Contact Job Subtype L365";
    begin
        LastID := Log.LogStart(ThisCompanyname, 9, 'GL Posting Setup');
        GeneralPostingSetup.ChangeCompany(ThisCompanyname);
        ContactJobSubtypeL365.ChangeCompany(ThisCompanyname);

        ContactJobSubtypeL365.SetFilter("Sales Account No.", '<>%1', '');
        if ContactJobSubtypeL365.FindFirst() then begin
            GeneralPostingSetup.SetFilter("Gen. Bus. Posting Group", '<>%1', '');
            if GeneralPostingSetup.FindSet() then begin
                repeat
                    GeneralPostingSetup."Sales Account" := ContactJobSubtypeL365."Sales Account No.";
                    GeneralPostingSetup."Sales Credit Memo Account" := ContactJobSubtypeL365."Sales Account No.";
                    GeneralPostingSetup.Modify();
                until GeneralPostingSetup.Next() = 0;
            end;
        end;

        log.LogEnd(LastID);
    end;

    local procedure SetupReportSelection(ThisCompanyname: Text)
    begin
        LastID := Log.LogStart(ThisCompanyname, 10, 'SetupReportSelection');
        SetupUpOneReport(ThisCompanyname, enum::"Report Selection Usage"::"Fee Statement", 6065375);
        SetupUpOneReport(ThisCompanyname, Enum::"Report Selection Usage"::Liability, 6065405);
        SetupUpOneReport(ThisCompanyname, Enum::"Report Selection Usage"::LiabilityReconsiliation, 6065808);
        SetupUpOneReport(ThisCompanyname, Enum::"Report Selection Usage"::"S.Cr.Memo", 6195017);
        SetupUpOneReport(ThisCompanyname, Enum::"Report Selection Usage"::"S.Invoice", 6195016);
        SetupUpOneReport(ThisCompanyname, Enum::"Report Selection Usage"::"S.Test", 6195015);
        SetupUpOneReport(ThisCompanyname, Enum::"Report Selection Usage"::"Label", 6065463);
        SetupUpOneReport(ThisCompanyname, Enum::"Report Selection Usage"::"Label with part", 6065464);
        SetupUpOneReport(ThisCompanyname, Enum::"Report Selection Usage"::"Inv. Amt.", 6065478);
        log.LogEnd(LastID);
    end;

    local procedure SetupUpOneReport(ThisCompanyname: Text; RepType: integer; ID: Integer)
    var
        ReportSelections: Record "Report Selections";
    begin
        ReportSelections.ChangeCompany(ThisCompanyname);
        ReportSelections.SetRange(Usage, RepType);
        if ReportSelections.FindFirst() then begin
            ReportSelections."Report ID" := ID;
            ReportSelections.Modify();
        end else begin
            ReportSelections.Usage := RepType;
            ReportSelections."Report ID" := ID;
            ReportSelections.Insert();
        end;
    end;

    local procedure SetupLogo(ThisCompanyname: Text; MasterCompany: Record "Company Information")
    var
        CompanyInformation: Record "Company Information";

    begin
        LastID := Log.LogStart(ThisCompanyname, 11, 'SetupLogo');
        CompanyInformation.ChangeCompany(ThisCompanyname);
        CompanyInformation.get();
        CompanyInformation.Picture := MasterCompany.Picture;
        CompanyInformation.Modify();
        log.LogEnd(LastID);
    end;

    local procedure UpdateDictionary(ThisCompanyname: Text)
    var
        DictionaryTranslationL365: Record "Dictionary Translation L365";
        DictionaryL365: Record DictionaryL365;
    begin
        LastID := Log.LogStart(ThisCompanyname, 12, 'UpdateDictionary');
        DictionaryL365.ChangeCompany(ThisCompanyname);
        DictionaryTranslationL365.ChangeCompany(ThisCompanyname);

        DictionaryL365."Text string" := 'CrMemo Date';
        DictionaryL365."Search text" := 'CrMemo Date';
        if DictionaryL365.Insert() then;

        DictionaryTranslationL365."Text string" := DictionaryL365."Text string";
        DictionaryTranslationL365."Language code" := '';
        DictionaryTranslationL365.Translation := 'Kreditnotadato';
        if DictionaryTranslationL365.Insert() then;
        DictionaryTranslationL365."Text string" := DictionaryL365."Text string";
        DictionaryTranslationL365."Language code" := 'DK';
        DictionaryTranslationL365.Translation := 'Kreditnotadato';
        if DictionaryTranslationL365.Insert() then;
        DictionaryTranslationL365."Text string" := DictionaryL365."Text string";
        DictionaryTranslationL365."Language code" := 'ENU';
        DictionaryTranslationL365.Translation := 'Credit memo date';
        if DictionaryTranslationL365.Insert() then;

        DictionaryL365."Text string" := 'CrMemoNo';
        DictionaryL365."Search text" := 'CrMemoNo';
        if DictionaryL365.Insert() then;

        DictionaryTranslationL365."Text string" := DictionaryL365."Text string";
        DictionaryTranslationL365."Language code" := '';
        DictionaryTranslationL365.Translation := 'Kreditnotanr.';
        if DictionaryTranslationL365.Insert() then;
        DictionaryTranslationL365."Text string" := DictionaryL365."Text string";
        DictionaryTranslationL365."Language code" := 'DK';
        DictionaryTranslationL365.Translation := 'Kreditnotanr.';
        if DictionaryTranslationL365.Insert() then;
        DictionaryTranslationL365."Text string" := DictionaryL365."Text string";
        DictionaryTranslationL365."Language code" := 'ENU';
        DictionaryTranslationL365.Translation := 'Credit memo no.';
        if DictionaryTranslationL365.Insert() then;

        DictionaryL365."Text string" := 'Invoice Date';
        DictionaryL365."Search text" := 'Invoice Date';
        if DictionaryL365.Insert() then;

        DictionaryTranslationL365."Text string" := DictionaryL365."Text string";
        DictionaryTranslationL365."Language code" := '';
        DictionaryTranslationL365.Translation := 'Fakturadato.';
        if DictionaryTranslationL365.Insert() then;
        DictionaryTranslationL365."Text string" := DictionaryL365."Text string";
        DictionaryTranslationL365."Language code" := 'DK';
        DictionaryTranslationL365.Translation := 'Fakturadato';
        if DictionaryTranslationL365.Insert() then;
        DictionaryTranslationL365."Text string" := DictionaryL365."Text string";
        DictionaryTranslationL365."Language code" := 'ENU';
        DictionaryTranslationL365.Translation := 'Invoice Date';
        if DictionaryTranslationL365.Insert() then;

        DictionaryL365."Text string" := 'Invoice';
        DictionaryL365."Search text" := 'Invoice';
        if DictionaryL365.Insert() then;

        DictionaryTranslationL365."Text string" := DictionaryL365."Text string";
        DictionaryTranslationL365."Language code" := '';
        DictionaryTranslationL365.Translation := 'Faktura';
        if DictionaryTranslationL365.Insert() then;
        DictionaryTranslationL365."Text string" := DictionaryL365."Text string";
        DictionaryTranslationL365."Language code" := 'DK';
        DictionaryTranslationL365.Translation := 'Faktura';
        if DictionaryTranslationL365.Insert() then;
        DictionaryTranslationL365."Text string" := DictionaryL365."Text string";
        DictionaryTranslationL365."Language code" := 'ENU';
        DictionaryTranslationL365.Translation := 'Faktura';
        if DictionaryTranslationL365.Insert() then;

        log.LogEnd(LastID);
    end;

    local procedure CreateMissingTimeEntry(ThisCompanyname: Text)
    var
        id: Integer;
    begin
        if StartSession(id, codeunit::CreateMissingEntries4AllComp, ThisCompanyname) then;
    end;

    local procedure UpdateAllSearchFields(ThisCompanyname: Text)
    var
        id: Integer;
    begin
        if StartSession(id, codeunit::UpdateAllSearchField4AllComp, ThisCompanyname) then;
    end;

    local procedure TransferMastertoSlaveCompanies(ThisCompanyname: Text)
    var
        TemplateL365: Record TemplateL365;
        DataSourceHeaderL365: Record "Data Source Header L365";
        DataSourceFilterLineL365: Record "Data Source Filter Line L365";
        DataSourceLineL365: Record "Data Source Line L365";
        CustomReportLayout: Record "Custom Report Layout";
        ReportLayoutSelection: Record "Report Layout Selection";

        MTemplateL365: Record TemplateL365;
        MDataSourceHeaderL365: Record "Data Source Header L365";
        MDataSourceFilterLineL365: Record "Data Source Filter Line L365";
        MDataSourceLineL365: Record "Data Source Line L365";
        MCustomReportLayout: Record "Custom Report Layout";
        MReportLayoutSelection: Record "Report Layout Selection";
    begin
        LastID := Log.LogStart(ThisCompanyname, 15, 'Transfer2OtherCompanies');

        MTemplateL365.ChangeCompany(MasterCompanyName);
        MDataSourceHeaderL365.ChangeCompany(MasterCompanyName);
        MDataSourceFilterLineL365.ChangeCompany(MasterCompanyName);
        MDataSourceLineL365.ChangeCompany(MasterCompanyName);
        MReportLayoutSelection.ChangeCompany(MasterCompanyName);
        MCustomReportLayout.ChangeCompany(MasterCompanyName);

        TemplateL365.ChangeCompany(ThisCompanyname);
        DataSourceHeaderL365.ChangeCompany(ThisCompanyname);
        DataSourceFilterLineL365.ChangeCompany(ThisCompanyname);
        DataSourceLineL365.ChangeCompany(ThisCompanyname);
        ReportLayoutSelection.ChangeCompany(ThisCompanyname);
        CustomReportLayout.ChangeCompany(ThisCompanyname);

        if MTemplateL365.FindSet() then begin
            repeat
                TemplateL365.TransferFields(MTemplateL365);
                if not TemplateL365.Insert() then begin
                    TemplateL365.find('=');
                    TemplateL365.TransferFields(MTemplateL365, false);
                    TemplateL365.Modify();
                end;



            until MTemplateL365.Next() = 0;
        end;

        if MDataSourceHeaderL365.FindSet() then begin
            repeat
                DataSourceHeaderL365.TransferFields(MDataSourceHeaderL365);
                if not DataSourceHeaderL365.Insert() then begin
                    DataSourceHeaderL365.Find('=');
                    DataSourceHeaderL365.TransferFields(MDataSourceHeaderL365, false);
                    DataSourceHeaderL365.Modify();
                end;
            until MDataSourceHeaderL365.Next() = 0;
        end;
        if MDataSourceFilterLineL365.FindSet() then begin
            repeat
                DataSourceFilterLineL365.TransferFields(MDataSourceFilterLineL365);
                if not DataSourceFilterLineL365.Insert() then begin
                    DataSourceFilterLineL365.find('=');
                    DataSourceFilterLineL365.TransferFields(MDataSourceFilterLineL365, false);
                    DataSourceFilterLineL365.Modify();
                end;
            until MDataSourceFilterLineL365.Next() = 0;
        end;
        if MDataSourceLineL365.FindSet() then begin
            repeat
                DataSourceLineL365.TransferFields(MDataSourceLineL365);
                if not DataSourceLineL365.Insert() then begin
                    DataSourceLineL365.find('=');
                    DataSourceLineL365.TransferFields(MDataSourceLineL365, false);
                    DataSourceLineL365.Modify();
                end;
            until MDataSourceLineL365.Next() = 0;
        end;
        //Only for master company, datapercompany = false
        if ThisCompanyname = MasterCompanyName then begin
            MCustomReportLayout.SetRange("Company Name", MasterCompanyName);
            if MCustomReportLayout.FindSet() then begin
                repeat
                    CustomReportLayout := MCustomReportLayout;
                    CustomReportLayout."Company Name" := ThisCompanyname;
                    if not CustomReportLayout.Insert() then
                        CustomReportLayout.Modify();
                until MCustomReportLayout.Next() = 0;
            end;
            MReportLayoutSelection.SetRange("Company Name", MasterCompanyName);
            if MReportLayoutSelection.FindSet() then begin
                repeat
                    ReportLayoutSelection := MReportLayoutSelection;
                    ReportLayoutSelection."Company Name" := ThisCompanyname;
                    if not ReportLayoutSelection.Insert() then
                        ReportLayoutSelection.Modify();
                until MReportLayoutSelection.next = 0;
            end;
        end;


        Log.LogEnd(LastID);
    end;


    var
        Company: Record Company;
        LogoCompany: Record Company;
        MasterCompanyName: Text;
        LogoCompanyInf: Record "Company Information";
        Log: Record Navokat2BCsetupStatus;
        LastID: Integer;
}