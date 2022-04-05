codeunit 71113 "ExcelImportToolMgtL365"
{
    trigger OnRun()
    begin

    end;

    procedure CreateMattersFromStaging(var Staging: Record "Contact Staging L365")
    var
        Matter: Record Contact;
        Matter2: Record Contact;

        Job: Record Job;
        Client: Record Contact;
        Archived, ValidateJobType, Update : Boolean;
        ContFolder: Record "Contact Folder L365";
        JobType: Record "Contact Job Type L365";
        JobSubtype: Record "Contact Job Subtype L365";
        JobTask: Record "Job Task";
        ArchiveLog: Record "Archive Log L365";
        Archive: Record ArchiveL365;
        AbakionLegalSetup: Record "AbakionLegal Setup L365";
        NavokatBasic: Codeunit "Basic L365";
        RelationTypeSetup: Record "Relation Type Setup L365";
        CustomerTemplate: Record "Customer Templ.";
        SearchMgt: Codeunit "Search Management L365";
        EmployeeCont: record Contact;


        //JobInvInterval: Record "Job Inv. Interval L365";
        InitJobNo: Code[20];
        MainJobNo: Code[20];

        Text0100: Label '%1 already exist and you have not allowed updates.'; // DAN = '%1 findes allerede og du har ikke tilladt opdatering.'        
        RecordNo, NextArchiveLogEntry : Integer;
        Text0101: Label 'The values does not exist in the underlying table'; // DAN = 'Værdien findes ikke i den bagvedliggende tabel.'
        Text0102: Label 'The Party does not exist in the underlying table.'; // DAN = 'Parten findes ikke i den bagvedliggende tabel.'
        Text0103: Label 'The Legal Connection does not exist in the underlying table.'; // DAN = 'Advokatforbindelsen findes ikke i den bagvedliggende tabel.'
        Text0104: Label 'The Client does not exist in the underlying table.'; // DAN = 'Klienten findes ikke i den bagvedliggende tabel.'
        Text0105: Label 'No. of Lines imported:%1\No. of Lines with errors:%2'; // DAN = 'Antal linjer, der er importeret:%1\Antal linjer, der med fejl:%2'
        Text0106: Label 'Imported'; // DAN = 'Importeret'

    begin
        ImportSetup.Get();
        AbakionLegalSetup.Get();
        Staging.FilterGroup(44);
        Staging.SetRange("Import Type", Staging."Import Type"::Matter);
        Staging.SetFilter(Status, '%1|%2', Staging.Status::OK, Staging.Status::Warning);
        Staging.FilterGroup(0);

        if Staging.FindSet() then begin
            repeat
                InitJobNo := '';
                MainJobNo := '';
                RecordHasError := false;

                if (ImportSetup."Use Matter No. Series") then begin
                    Staging."No." := NavokatBasic.CalcJobNo(Staging."Company No.", staging."Job Type Code L365",
                                                            staging."Job Sub Type Code L365", InitJobNo, MainJobNo)
                end else
                    Matter."No." := Staging."No.";

                Matter.SetHideValidationDialog(true);
                Matter."Company No." := Staging."Company No.";
                Matter.Validate("Extended Name L365", Staging."Extended Name");
                Matter."Search Name" := Staging."Search Name";
                Matter."Client Reference L365" := Staging."Client Reference L365";
                Matter."Job Type Code L365" := Staging."Job Type Code L365";
                Matter."Job Sub Type Code L365" := Staging."Job Type Code L365";
                Matter."Former No. L365" := Staging."Former No. L365";
                Matter."Creation Date L365" := Staging."Creation Date L365";


                OnCreateMatter(Matter, Staging);
                //TODO:Handle fields from separate module
                /*
                if (JobInvInterval.GET(ValidateFieldLength(InvoiceInterval, MAXSTRLEN(Cont."Invoice Interval L365"), Cont.FIELDCAPTION("Invoice Interval L365")))) then
                    Cont."Invoice Interval L365" := JobInvInterval.Code;
                
                if (EVALUATE(Cont."Next Invoice Date L365", NextInvoiceDate)) then;
                if (EVALUATE(Cont."Collect Settlement L365", CollectSettlement)) then;                
                    
                    if (EVALUATE(Cont2.SpecifDocumentationDemandsL365, SpecificDocumentationDemands)) then
                        Cont2.MODIFY;
                    if (EVALUATE(Cont2."Fee Documentation L365", FeeDocumentation)) then
                        Cont2.MODIFY;
                    
                */

                Archived := Staging.Archived;

                Matter."Language Code" := Staging."Language Code";
                Matter.AttentionL365 := Staging.AttentionL365;
                Matter."Import Source Code L365" := 'LEGAL365';
                if ValidateJobType and ((Staging."Job Type Code L365" <> '') or (Staging."Job Sub Type Code L365" <> '')) then begin
                    if not JobType.GET(Staging."Job Type Code L365") then begin
                        if not ImportSetup."Auto Create Matter Types" then begin
                            LogError(Staging."Import Type", JobType.TABLECAPTION, JobType.FIELDCAPTION(Code), Matter."No.", Staging."Job Type Code L365", '', STRSUBSTNO(Text0101));
                        end else begin
                            JobType.Code := Staging."Job Type Code L365";
                            JobType.Description := Text0106;
                            JobType.INSERT;
                        end;
                    end;

                    if not JobSubtype.GET(Staging."Job Type Code L365", Staging."Job Sub Type Code L365") then begin
                        if not ImportSetup."Auto Create Matter Types" then begin
                            LogError(Staging."Import Type", JobSubtype.TABLECAPTION, JobSubtype.FIELDCAPTION(JobSubtype."Subtype Code"), Matter."No.", Staging."Job Sub Type Code L365", '', STRSUBSTNO(Text0101));

                        end else begin
                            JobSubtype."Type Code" := Staging."Job Type Code L365";
                            JobSubtype."Subtype Code" := Staging."Job Sub Type Code L365";
                            JobSubtype.Description := Text0106;
                            JobSubtype.INSERT;
                        end;
                    end;
                end;

                if not Client.GET(Staging."Company No.") then begin
                    if not ImportSetup."Auto Create Clients" then begin
                        LogError(Staging."Import Type", Client.TABLECAPTION, Client.FIELDCAPTION("No."), Matter."No.", Staging."Company No.", '', STRSUBSTNO(Text0104));
                    end else begin
                        Client.INIT;
                        Client."No." := Staging."Company No.";
                        Client.Name := Text0106;
                        Client."Contact Type L365" := AbakionLegalSetup."Client Contact Type";
                        Client."Customer Template Code L365" := CustomerTemplate.Code;
                        Client.INSERT(true);
                    end;
                end;

                //validate Globalrealtions not supported yet

                Update := false;

                if Matter2.GET(Matter."No.") then begin
                    if not ImportSetup."Overwrite Existing Records" then begin
                        LogError(Staging."Import Type", Matter.TABLECAPTION, '', Matter."No.", '', '', STRSUBSTNO(Text0100, Matter.TABLECAPTION));
                    end else begin
                        Update := true;
                    end;
                end else begin
                    CLEAR(Matter2);
                end;

                if not RecordHasError then begin
                    //Clean-up any data from prev. import
                    if Matter."No." <> '' then begin
                        ContFolder.SETRANGE("Contact No.", Matter."No.");
                        ContFolder.DELETEALL;
                        JobTask.SETRANGE("Job No.", Matter."No.");
                        JobTask.DELETEALL;
                    end;

                    //Go create/update
                    Matter2 := Matter;
                    Matter2.SetHideValidationDialog(true);
                    Matter2.Type := Matter2.Type::Person;
                    Matter2."Contact Type L365" := AbakionLegalSetup."Job Contact Type";
                    Matter2.validate("Company No.");

                    if not Update then begin //INSERT
                        Matter2.SETRANGE("Contact Type L365", AbakionLegalSetup."Job Contact Type");
                        Matter2.INSERT(true);
                        Matter2.SETRANGE("Contact Type L365");
                        Client.GET(Matter."Company No.");
                        if NavokatBasic.GetCustomerNo(Client."No.") = '' then begin
                            Client.TESTFIELD("Customer Template Code L365");
                            Client.SetHideValidationDialog(true);
                            Client.SetCustNoL365(true, Client."No.", false);
                            Client.CreateCustomer(Client."Customer Template Code L365");
                        end;
                        NavokatBasic.CreateJob2(Matter2."No.", Client."No.", true);
                        Staging.Status := Staging.Status::Created;
                        Staging.Modify();
                    end else begin
                        Matter2.MODIFY(true);
                        Staging.Status := Staging.Status::Updated;
                        Staging.Modify();
                    end;


                    Job.GET(Matter2."No.");
                    Job."Creation Date" := Matter."Creation Date L365";

                    if Archived then begin
                        Matter2."Contact Type L365" := AbakionLegalSetup."Archive Job Contact Type";
                        Matter2."Archive Date L365" := Staging."Archive Date L365";
                        Matter2.MODIFY;

                        Job.ArchivedL365 := true;
                        Job."Ending Date" := Matter2."Archive Date L365";

                        ArchiveLog.RESET;
                        ArchiveLog.SETRANGE("Job ID", Matter2."No.");
                        ArchiveLog.DELETEALL;

                        ArchiveLog.RESET;
                        if ArchiveLog.FINDLAST then
                            NextArchiveLogEntry := ArchiveLog."Entry No." + 1
                        else
                            NextArchiveLogEntry := 1;
                        CLEAR(ArchiveLog);
                        ArchiveLog."Entry No." := NextArchiveLogEntry;
                        ArchiveLog."Archive No." := JobSubtype."Default Archive";
                        ArchiveLog."Contact ID" := Matter2."Company No.";
                        ArchiveLog."Job ID" := Matter2."No.";
                        ArchiveLog.Type := ArchiveLog.Type::"Full Archive";
                        ArchiveLog."Archive Date" := Matter2."Archive Date L365";
                        if Archive.GET(JobSubtype."Default Archive") then
                            ArchiveLog."Maculation Date" := CALCDATE(Archive."Maculation Date", Matter2."Archive Date L365");
                        ArchiveLog."Archive Index" := Staging."Archive Index";
                        ArchiveLog."Global Relation 1 Code" := Matter2."Global Relation 1 Code L365";
                        ArchiveLog."Global Relation 2 Code" := Matter2."Global Relation 2 Code L365";
                        ArchiveLog."Global Relation 3 Code" := Matter2."Global Relation 3 Code L365";
                        ArchiveLog."Global Relation 4 Code" := Matter2."Global Relation 4 Code L365";
                        ArchiveLog."Global Relation 5 Code" := Matter2."Global Relation 5 Code L365";
                        ArchiveLog."Global Relation 6 Code" := Matter2."Global Relation 6 Code L365";
                        ArchiveLog."Security Set ID" := Matter2."Security Set ID L365";
                        ArchiveLog.Comment := Text0106;
                        ArchiveLog.INSERT;
                    end;
                    Job.Modify();


                    //Create PartyRelations

                    if Staging."Party 1" <> '' then begin
                        if Staging."Part 1 Relation Code" <> '' then begin
                            CreateRelation(Matter2."No.", Staging."Party 1", Staging."Part 1 Relation Code");
                        end else begin
                            CreateRelation(Matter2."No.", Staging."Party 1", AbakionLegalSetup."Party Contact Type");
                        end;
                    end;
                    if Staging."Party 2" <> '' then begin
                        if Staging."Part 2 Relation Code" <> '' then begin
                            CreateRelation(Matter2."No.", Staging."Party 2", Staging."Part 2 Relation Code");
                        end else begin
                            CreateRelation(Matter2."No.", Staging."Party 2", AbakionLegalSetup."Party Contact Type");
                        end;
                    end;
                    if Staging."Legal Connection" <> '' then begin
                        CreateRelation(Matter2."No.", Staging."Legal Connection", AbakionLegalSetup."Relation Type - Legal Conn.");
                    end;

                    if Staging."Inv. Recepient" <> '' then begin
                        CreateRelation(Matter2."No.", Staging."Inv. Recepient", AbakionLegalSetup."Relation Type - Invoice Rec.");
                    end;

                    /* if CONTROLLER <> '' then begin
                        CreateRelation(Matter2."No.", CONTROLLER, AbakionLegalSetup."Relation Type - Administrator");
                    end; */
                    /*                 if AFREGNING <> '' then begin
                                        CreateRelation(Matter2."No.", AFREGNING, AbakionLegalSetup."Relation Type - Billing");
                                    end;
                                    if KLIENTANS1 <> '' then begin
                                        CreateRelation(Matter2."No.", KLIENTANS1, AbakionLegalSetup."Relation Type - Client Resp.");
                                     end;*/
                    if Staging."Case Worker" <> '' then begin
                        if not EmployeeCont.get(Staging."Case Worker") then
                            CreateEmployee(Staging."Case Worker");
                        CreateRelation(Matter2."No.", Staging."Case Worker", AbakionLegalSetup."Relation Type - Case Attorney");
                    end;
                    if Staging.Secretary <> '' then begin
                        if not EmployeeCont.get(Staging.Secretary) then
                            CreateEmployee(Staging.Secretary);
                        CreateRelation(Matter2."No.", Staging.Secretary, AbakionLegalSetup."Relation Type - Secretary");
                    end;
                    if Staging."Responsible Lawyer" <> '' then begin
                        if not EmployeeCont.get(Staging."Responsible Lawyer") then
                            CreateEmployee(Staging."Responsible Lawyer");
                        CreateRelation(Matter2."No.", Staging."Responsible Lawyer", AbakionLegalSetup."Relation Type - Responsible");
                    end;

                    if Staging."Case worker 2" <> '' then begin
                        if not EmployeeCont.get(Staging."Case worker 2") then
                            CreateEmployee(Staging."Case worker 2");
                        CreateRelation(Matter2."No.", Staging."Case worker 2", RelationTypeSetup."Relation Type - Case Off. 2");
                    end;
                    SearchMgt.BuildSearchWords(Matter2."No.");
                    Matter2.Find();
                    Matter2."Creation Date L365" := Matter."Creation Date L365";
                    Matter2.Modify(true);
                end;

            until Staging.Next() = 0;
        end;


    end;

    procedure CreateClientsFromStaging(var Staging: Record "Contact Staging L365")
    var
        Client: Record Contact;
        Client2: Record Contact;
        Employee: Record Contact;
        ContactRel: Record "Contact Relation L365";
        CustTemplate: Record "Customer Templ.";
        AbakionLegalSetup: Record "AbakionLegal Setup L365";
        PostCode: Record "Post Code";
        SearchMgt: Codeunit "Search Management L365";
        Update, ValidatePostCode : Boolean;
        RelMgt: Codeunit "Global Relation Mgt. L365";
        Text0100: Label '%1 already exists and you have not allowed updates.'; // DAN = '%1 findes allerede og du har ikke tilladt opdatering.'
        Text0101: Label 'The Value does not exist in the underlying table.'; // DAN = 'Værdien findes ikke i den bagvedliggende tabel.'
        Text0102: Label 'No. of Lines imported:%1\No. of Lines with errors:%2'; // DAN = 'Antal linjer, der er importeret:%1\Antal linjer, der med fejl:%2'
        Text0103: Label '%1 must not be blank.'; // DAN = '%1 må ikke være blank'
        Text0104: Label 'Client Responsible does not exist.'; // DAN = 'Klientansvarlig findes ikke.'
    begin
        ImportSetup.Get();
        Staging.FilterGroup(44);
        Staging.SetRange("Import Type", Staging."Import Type"::Client);
        Staging.SetFilter(Status, '%1|%2', Staging.Status::OK, Staging.Status::Warning);
        Staging.FilterGroup(0);
        if Staging.FindSet() then begin
            repeat
                RecordHasError := false;
                Client.INIT;
                Client.SetHideValidationDialog(true);
                Client."No." := Staging."No.";
                Client."Company No." := Client."No.";
                Client.Name := Staging.Name;
                Client."Name 2" := Staging."Name 2";
                Client."Search Name" := Staging."Search Name";
                Client.Address := Staging.Address;
                Client."Address 2" := Staging."Address 2";
                Client."Post Code" := Staging."Post Code";
                Client.City := Staging.City;
                Client."Country/Region Code" := Staging."Country/Region Code";
                Client."VIP Client L365" := Staging."VIP Client L365";
                Client."E-Mail" := Staging."E-Mail";
                Client."Phone No." := Staging."Phone No.";
                Client."Private Phone No. L365" := Staging."Private Phone No.";
                Client."Fax No." := Staging."Fax No.";
                Client."Home Page" := Staging."Home Page";
                Client."Mobile Phone No." := Staging."Mobile Phone No.";
                Client."VAT Registration No." := Staging."VAT Registration No.";
                Client."SE-nummer L365" := Staging."SE-nummer L365";
                Client."Civil Registration No. L365" := Staging."Civil Registration No. L365";
                Client."Language Code" := Staging."Language Code";
                Client.AttentionL365 := Staging.AttentionL365;
                Client."Bank Branch No. L365" := Staging."Bank Branch No. L365";
                Client."Bank Account No. L365" := Staging."Bank Account No. L365";
                Client."Customer Template Code L365" := Staging."Customer Template Code L365";
                Client."First Name" := Staging."First Name";
                Client."Middle Name" := Staging."Middle Name";
                Client.Surname := Staging."Sur Name";
                Client."Salutation Code" := Staging."Salutation Code";
                Client."Commercial Terms L365" := Staging.Comment;
                Client.UpdatePostCodeCityL365();

                Client."Import Source Code L365" := 'LEGAL365';
                if ValidatePostCode and (Staging."Post Code" <> '') then begin
                    PostCode.SETRANGE(Code, Staging."Post Code");
                    if PostCode.ISEMPTY then begin
                        if not ImportSetup."Auto Create Post Codes" then
                            LogError(Staging."Import Type", Client.TABLECAPTION, Client.FIELDCAPTION("Post Code"), Client."No.", Client."Post Code", '', STRSUBSTNO(Text0101))
                        else begin
                            PostCode.Code := Client."Post Code";
                            PostCode.City := Client.City;
                            PostCode."Country/Region Code" := Client."Country/Region Code";
                            PostCode.INSERT;
                        end;
                    end;

                end;
                if Client."Customer Template Code L365" = '' then begin
                    if not CustTemplate.FINDFIRST then
                        LogError(Staging."Import Type", Client.TABLECAPTION, '', Client."No.", '', '', STRSUBSTNO(Text0103, Client.FIELDCAPTION("Customer Template Code L365")))
                    else
                        Client."Customer Template Code L365" := CustTemplate.Code;
                end;

                Update := false;
                if not RecordHasError then begin
                    if Client2.GET(Client."No.") then begin
                        if not ImportSetup."Overwrite Existing Records" then begin
                            LogError(Staging."Import Type", Client.TABLECAPTION, '', Client."No.", '', '', STRSUBSTNO(Text0100, Client.TABLECAPTION));
                        end else
                            Update := true;
                    end else
                        CLEAR(Client2);

                    if not RecordHasError then begin
                        Client2 := Client;
                        Client2.Type := Client2.Type::Company;
                        Client2."Company Name" := Client2.Name;
                        Client2."Contact Type L365" := AbakionLegalSetup."Client Contact Type";
                        if not Update then begin //INSERT
                            Client2.SETRANGE("Contact Type L365", AbakionLegalSetup."Client Contact Type");
                            if (not Employee.GET(Staging."Responsible Employee")) and (Staging."Responsible Employee" <> '') then begin
                                LogError(Staging."Import Type", Client.TABLECAPTION, '', Client."No.", Staging."Responsible Employee", '', Text0104);
                            end else begin
                                Client2.INSERT(true);
                                if Staging."Responsible Employee" <> '' then begin
                                    CLEAR(ContactRel);
                                    ContactRel."Contact 1" := Client2."No.";
                                    ContactRel.VALIDATE("Contact 2", Staging."Responsible Employee");
                                    ContactRel.VALIDATE("Relation Code", AbakionLegalSetup."Relation Type - Client Resp.");
                                    ContactRel.INSERT(true);
                                end;
                                Staging.Status := Staging.Status::Created;
                                Staging.Modify();
                            end;
                        end else begin //MODIFY
                            if (not Employee.GET(Staging."Responsible Employee")) and (Staging."Responsible Employee" <> '') then begin
                                LogError(Staging."Import Type", Client.TABLECAPTION, '', Client."No.", Staging."Responsible Employee", '', Text0104);
                            end else begin
                                Client2.MODIFY(true);
                                if Staging."Responsible Employee" <> '' then begin
                                    ContactRel.SETRANGE("Contact 1", Client2."No.");
                                    ContactRel.SETRANGE("Relation Code", AbakionLegalSetup."Relation Type - Client Resp.");
                                    if ContactRel.FINDFIRST then begin
                                        ContactRel.VALIDATE("Contact 2", Staging."Responsible Employee");
                                        ContactRel.MODIFY(true);
                                    end;
                                end;
                                Staging.Status := Staging.Status::Updated;
                                Staging.Modify();
                            end;
                        end;
                        if not RecordHasError then begin
                            Client2."Customer Template Code L365" := Client."Customer Template Code L365";
                            Client2.MODIFY;
                            SearchMgt.BuildSearchWords(Client2."No.");
                            RelMgt.Update(Client2."No.");
                        end;

                    end;

                end;

            until Staging.Next() = 0;
        end;
    end;

    procedure CreatePartiesFromStaging(var Staging: Record "Contact Staging L365")
    var
        Text0100: Label '%1 already exists and you did not allow updates.'; // DAN = '%1 findes allerede og du har ikke tilladt opdatering.'
        Text0101: Label 'The Value does not exist in the underlying table.'; // DAN = 'Værdien findes ikke i den bagvedliggende tabel.'
        SearchManagement: Codeunit "Search Management L365";
        Party: Record Contact;
        Party2: Record Contact;
        AbakionLegalSetup: Record "AbakionLegal Setup L365";
        StartTime: DateTime;
        ValidatePostCode, Update : Boolean;
        PostCode: Record "Post Code";
    begin
        ImportSetup.Get();
        AbakionLegalSetup.Get();
        Staging.FilterGroup(44);
        Staging.SetRange(Staging."Import Type", Staging."Import Type"::Party);
        Staging.SetFilter(Status, '%1|%2', Staging.Status::OK, Staging.Status::Warning);
        Staging.FilterGroup(0);
        if Staging.FindSet() then begin
            repeat
                RecordHasError := false;
                Party.INIT;
                party.SetHideValidationDialog(true);
                Party."No." := Staging."No.";
                Party."Company No." := Party."No.";
                Party.Name := Staging.Name;
                Party."Name 2" := Staging."Name 2";
                Party."Search Name" := Staging."Search Name";
                Party.Address := Staging.Address;
                Party."Address 2" := Staging."Address 2";
                Party."Post Code" := Staging."Post Code";
                Party.City := Staging.City;
                Party."Country/Region Code" := Staging."Country/Region Code";
                Party."E-Mail" := Staging."E-Mail";
                Party."Phone No." := Staging."Phone No.";
                Party."Private Phone No. L365" := Staging."Private Phone No.";
                Party."Fax No." := Staging."Fax No.";
                Party."Home Page" := Staging."Home Page";
                Party."Mobile Phone No." := Staging."Mobile Phone No.";
                Party."VAT Registration No." := Staging."VAT Registration No.";
                Party."Civil Registration No. L365" := Staging."Civil Registration No. L365";
                Party."Language Code" := Staging."Language Code";
                Party.AttentionL365 := Staging.AttentionL365;
                Party."Bank Branch No. L365" := Staging."Bank Branch No. L365";
                Party."Bank Account No. L365" := Staging."Bank Account No. L365";
                Party."Birth Date L365" := Staging."Birth Date L365";
                Party."Job Title" := Staging."Job Title";
                Party."First Name" := Staging."First Name";
                Party."Middle Name" := Staging."Middle Name";
                Party.Surname := Staging."Sur Name";
                Party."Salutation Code" := Staging."Salutation Code";
                Party.UpdatePostCodeCityL365();

                Party."Import Source Code L365" := 'LEGAL365';
                if ValidatePostCode and (Staging."Post Code" <> '') then begin
                    PostCode.SETRANGE(Code, Staging."Post Code");
                    if PostCode.ISEMPTY then begin
                        if not ImportSetup."Auto Create Post Codes" then
                            LogError(Staging."Import Type", Party.TABLECAPTION, Party.FIELDCAPTION("Post Code"), Party."No.", Party."Post Code", '', STRSUBSTNO(Text0101))
                        else begin
                            PostCode.Code := Party."Post Code";
                            PostCode.City := Party.City;
                            PostCode."Country/Region Code" := Party."Country/Region Code";
                            PostCode.INSERT;
                        end;
                    end;
                end;
                Update := false;
                RecordHasError := false;
                if not RecordHasError then begin
                    if Party2.GET(Party."No.") then begin
                        if not ImportSetup."Overwrite Existing Records" then begin
                            LogError(Staging."Import Type", Party.TABLECAPTION, '', Party."No.", '', '', STRSUBSTNO(Text0100, Party.TABLECAPTION));
                        end else
                            Update := true;
                    end else begin
                        CLEAR(Party2);
                    end;

                    if not RecordHasError then begin
                        Party2 := Party;
                        Party2.Type := Party2.Type::Company;
                        Party2."Contact Type L365" := AbakionLegalSetup."Party Contact Type";
                        if not Update then begin
                            Party2.SETRANGE("Contact Type L365", AbakionLegalSetup."Party Contact Type");
                            Party2.INSERT(true);
                            Staging.Status := Staging.Status::Created;
                            Staging.Modify();
                        end else begin
                            Party2.MODIFY(true);
                            Staging.Status := Staging.Status::Updated;
                            Staging.Modify();
                        end;

                        SearchManagement.BuildSearchWords(Party2."No.");
                    end;

                end;
            until Staging.Next() = 0;
        end;

    end;

    procedure CreateContactRelationsFromStaging(var StagingRel: Record "Contact Relation Staging L365")
    var
        Text0100: Label '%1 already exists and you did not allow updates.'; // DAN = '%1 findes allerede og du har ikke tilladt opdatering.'
        Text0101: Label 'The Value does not exist in the underlying table.'; // DAN = 'Værdien findes ikke i den bagvedliggende tabel.'
        SearchManagement: Codeunit "Search Management L365";
        Cont1, Cont2 : Record Contact;
        AbakionLegalSetup: Record "AbakionLegal Setup L365";
        StartTime: DateTime;
        Update: Boolean;

    begin
        ImportSetup.Get();
        AbakionLegalSetup.Get();
        StagingRel.FilterGroup(44);
        StagingRel.SetFilter(Status, '%1|%2', StagingRel.Status::OK, StagingRel.Status::Warning);
        StagingRel.FilterGroup(0);
        if StagingRel.FindSet() then begin
            repeat
                RecordHasError := false;
                update := CreateRelation(StagingRel."Contact 1 No.", StagingRel."Contact 2 No.", StagingRel."Relation Code", StagingRel.Attention,
                                            StagingRel."Attention E-mail", StagingRel."Attention Invoice E-Mail", StagingRel."Attention Phone No.",
                                            StagingRel."Block Interaction");

                if not Update then begin
                    StagingRel.Status := StagingRel.Status::Created;
                    StagingRel.Modify();
                end else begin
                    StagingRel.Status := StagingRel.Status::Updated;
                    StagingRel.Modify();
                end;
            until StagingRel.Next() = 0;
        end;

    end;

    procedure ValidateNoSeries()
    var
        ClientStaging: Record "Contact Staging L365";
        MatterStaging: Record "Contact Staging L365";
        PartyStaging: Record "Contact Staging L365";
        Cont: Record Contact;
        LegalSetup: Record "AbakionLegal Setup L365";
    begin
        LegalSetup.Get();
        //Check staging Clients
        ClientStaging.SetRange("Import Type", ClientStaging."Import Type"::Client);
        if ClientStaging.FindSet() then begin
            repeat
                MatterStaging.SetRange("Import Type", MatterStaging."Import Type"::Matter);
                MatterStaging.SetRange("No.", ClientStaging."No.");
                if MatterStaging.FindSet() then begin
                    LogError(ClientStaging."Import Type", 'Client', '', ClientStaging."No.", MatterStaging."No.", '', 'No. Overlap with at least one matter (Staging)');
                    ClientStaging.Status := ClientStaging.Status::Error;
                    ClientStaging.Modify();
                    repeat
                        LogError(MatterStaging."Import Type", 'Matter', '', MatterStaging."No.", ClientStaging."No.", '', 'No. Overlap with Client (Staging)');
                        MatterStaging.Status := MatterStaging.Status::Error;
                        MatterStaging.Modify()
                    until MatterStaging.Next() = 0;
                end;
                PartyStaging.SetRange("Import Type", PartyStaging."Import Type"::Party);
                PartyStaging.SetRange("No.", ClientStaging."No.");
                if PartyStaging.FindSet() then begin
                    LogError(ClientStaging."Import Type", 'Client', '', ClientStaging."No.", PartyStaging."No.", '', 'No. Overlap with at least one party (staging)');
                    ClientStaging.Status := ClientStaging.Status::Error;
                    ClientStaging.Modify();
                    repeat
                        LogError(PartyStaging."Import Type", 'Party', '', PartyStaging."No.", ClientStaging."No.", '', 'No. Overlap with Client (Staging)');
                        PartyStaging.Status := MatterStaging.Status::Error;
                        PartyStaging.Modify()
                    until PartyStaging.Next() = 0;
                end;
                //Check existing Matters
                cont.SetFilter("Contact Type L365", '%1|%2', LegalSetup."Job Contact Type", LegalSetup."Archive Job Contact Type");
                Cont.SetRange("No.", ClientStaging."No.");
                if cont.FindFirst() then begin
                    LogError(ClientStaging."Import Type", 'Client', '', MatterStaging."No.", ClientStaging."No.", '', 'No. Overlap with existing Matter');
                    ClientStaging.Status := ClientStaging.Status::Error;
                    ClientStaging.Modify();
                end;

                //Check existing Party
                cont.SetFilter("Contact Type L365", LegalSetup."Party Contact Type");
                Cont.SetRange("No.", ClientStaging."No.");
                if cont.FindFirst() then begin
                    LogError(ClientStaging."Import Type", 'Client', '', MatterStaging."No.", ClientStaging."No.", '', 'No. Overlap with existing Party');
                    ClientStaging.Status := ClientStaging.Status::Error;
                    ClientStaging.Modify();
                end;
            until ClientStaging.Next() = 0;

        end;
        //Check Staging Matters
        MatterStaging.Reset();
        MatterStaging.SetRange("Import Type", MatterStaging."Import Type"::Matter);
        if MatterStaging.FindSet() then begin
            repeat
                // against staging parties
                PartyStaging.SetRange("Import Type", PartyStaging."Import Type"::Party);
                PartyStaging.SetRange("No.", MatterStaging."No.");
                if PartyStaging.FindSet() then begin
                    LogError(MatterStaging."Import Type", 'Matter', '', MatterStaging."No.", PartyStaging."No.", '', 'No. Overlap with at least one party (staging)');
                    MatterStaging.Status := MatterStaging.Status::Error;
                    MatterStaging.Modify();
                    repeat
                        LogError(PartyStaging."Import Type", 'Party', '', PartyStaging."No.", MatterStaging."No.", '', 'No. Overlap with Matter (staging)');
                        PartyStaging.Status := MatterStaging.Status::Error;
                        PartyStaging.Modify()
                    until PartyStaging.Next() = 0;
                end;

                //Check staging existing Party
                cont.SetFilter("Contact Type L365", LegalSetup."Party Contact Type");
                Cont.SetRange("No.", MatterStaging."No.");
                if cont.FindFirst() then begin
                    LogError(MatterStaging."Import Type", 'Matter', '', MatterStaging."No.", Cont."No.", '', 'No. Overlap with existing Party');
                    matterStaging.Status := MatterStaging.Status::Error;
                    matterStaging.Modify();
                end;

                //Check staging Matter existing Clients
                cont.SetFilter("Contact Type L365", LegalSetup."Client Contact Type");
                Cont.SetRange("No.", MatterStaging."No.");
                if cont.FindFirst() then begin
                    LogError(MatterStaging."Import Type", 'Matter', '', MatterStaging."No.", Cont."No.", '', 'No. Overlap with existing Client');
                    MatterStaging.Status := MatterStaging.Status::Error;
                    MatterStaging.Modify();
                end;
            until MatterStaging.Next() = 0;

        end;
        //Check Staging Parties
        PartyStaging.Reset();
        PartyStaging.SetRange("Import Type", MatterStaging."Import Type"::Party);
        if PartyStaging.FindSet() then begin
            repeat
                //Check staging Party existing Client
                cont.SetFilter("Contact Type L365", LegalSetup."Client Contact Type");
                Cont.SetRange("No.", PartyStaging."No.");
                if cont.FindFirst() then begin
                    LogError(PartyStaging."Import Type", 'Party', '', PartyStaging."No.", Cont."No.", '', 'No. Overlap with existing Client');
                    PartyStaging.Status := ClientStaging.Status::Error;
                    PartyStaging.Modify();
                end;

                //Check staging Party existing Matters
                Cont.SetFilter("Contact Type L365", '%1|%2', LegalSetup."Job Contact Type", LegalSetup."Archive Job Contact Type");
                Cont.SetRange("No.", partyStaging."No.");
                if cont.FindFirst() then begin
                    LogError(PartyStaging."Import Type", 'Party', '', PartyStaging."No.", Cont."No.", '', 'No. Overlap with existing Matter');
                    PartyStaging.Status := PartyStaging.Status::Error;
                    PartyStaging.Modify();
                end;
            until PartyStaging.Next() = 0;
        end;
    end;


    local procedure LogError(ImportType: Integer; TableCaption: Text; FieldCaption: Text; PrimaryKey: Text; FieldValue: Text; FieldValue2: Text; ErrorDescription: Text);
    var
        ImportLog: Record "ImportLog L365";
    begin

        if not ImportLog.FINDLAST then;
        ImportLog.INIT;

        ImportLog."Import Type" := ImportType;
        ImportLog."Entry No." += 1;
        ImportLog."Import Time" := StartTime;
        ImportLog."Import By" := USERID;
        ImportLog."Table Name" := TableCaption;
        ImportLog."Primary Key" := PrimaryKey;
        ImportLog."Field Name" := FieldCaption;
        ImportLog."Field Value" := FieldValue;
        ImportLog."Field Value 2" := FieldValue2;
        ImportLog."Error Description" := ErrorDescription;
        ImportLog."Entry Type" := ImportLog."Entry Type"::Error;
        ImportLog.INSERT;
        RecordHasError := true;
    end;

    local procedure LogWarning(ImportType: Integer; TableCaption: Text; FieldCaption: Text; PrimaryKey: Text; FieldValue: Text; FieldValue2: Text; ErrorDescription: Text; IsDatapTypeValidate: Boolean);
    var
        ImportLog: Record "ImportLog L365";
    begin

        if not ImportLog.FINDLAST then;
        ImportLog.INIT;

        ImportLog."Import Type" := ImportType;
        ImportLog."Entry No." += 1;
        ImportLog."Import Time" := StartTime;
        ImportLog."Import By" := USERID;
        ImportLog."Table Name" := TableCaption;
        ImportLog."Primary Key" := PrimaryKey;
        ImportLog."Field Name" := FieldCaption;
        ImportLog."Field Value" := FieldValue;
        ImportLog."Field Value 2" := FieldValue2;
        ImportLog."Error Description" := ErrorDescription;
        ImportLog."Entry Type" := ImportLog."Entry Type"::Warning;
        ImportLog."Date Type Validation" := IsDatapTypeValidate;
        ImportLog.INSERT;
        RecordHasError := true;
    end;

    procedure ValidateClientFields()
    var
        ContStaging: Record "Contact Staging L365";
        Cont2, Cont3 : Record Contact;
        PostCode: Record "Post Code";
        CountryRegion: Record "Country/Region";
        Language: Record Language;
        CustTemplate: Record "Customer Templ.";
        MailManagement: Codeunit "Mail Management";
        Update: Boolean;
        AlreadyExistsErr: Label '%1 already exists and you have not allowed updates.'; // DAN = '%1 findes allerede og du har ikke tilladt opdatering.'
        UnderlyingTableErr: Label 'The Value does not exist in the underlying table.'; // DAN = 'Værdien findes ikke i den bagvedliggende tabel.'
        NotBlankErr: Label '%1 must not be blank.'; // DAN = '%1 må ikke være blank'
        ClientResponsibleNotExistsErr: Label 'Client Responsible does not exist.'; // DAN = 'Klientansvarlig findes ikke.'
    begin
        ImportSetup.Get();
        ContStaging.SetRange("Import Type", ContStaging."Import Type"::Client);
        if ContStaging.FindSet() then begin
            ClearLog(ContStaging);
            repeat
                ContStaging.Status := ContStaging.Status::Imported;
                if ImportSetup."Validate Post Codes" and (ContStaging."Post Code" <> '') then begin
                    PostCode.SETRANGE(Code, ContStaging."Post Code");
                    if PostCode.ISEMPTY then begin
                        if not ImportSetup."Auto Create Post Codes" then begin
                            LogError(ContStaging."Import Type", ContStaging.TABLECAPTION, ContStaging.FIELDCAPTION("Post Code"), ContStaging."No.", ContStaging."Post Code", '', STRSUBSTNO(UnderlyingTableErr));
                            if ContStaging.Status = ContStaging.Status::Imported then
                                ContStaging.Status := ContStaging.Status::Warning;
                        end;

                    end;
                end;
                if ContStaging."Language Code" <> '' then begin
                    if not Language.get(ContStaging."Language Code") then begin
                        LogError(ContStaging."Import Type", ContStaging.TABLECAPTION, ContStaging.FIELDCAPTION("Language Code"), ContStaging."No.", ContStaging."Language Code", '', STRSUBSTNO(UnderlyingTableErr));
                        if ContStaging.Status = ContStaging.Status::Imported then
                            ContStaging.Status := ContStaging.Status::Warning;
                    end;
                end;
                if ContStaging."Country/Region Code" <> '' then begin
                    if not CountryRegion.get(ContStaging."Country/Region Code") then begin
                        LogError(ContStaging."Import Type", ContStaging.TABLECAPTION, ContStaging.FIELDCAPTION("Country/Region Code"), ContStaging."No.", ContStaging."Country/Region Code", '', STRSUBSTNO(UnderlyingTableErr));
                        ContStaging.Status := ContStaging.Status::Error;
                    end;
                end;

                if ContStaging."E-Mail" <> '' then begin
                    if not MailManagement.CheckValidEmailAddress(ContStaging."E-Mail") then begin
                        LogError(ContStaging."Import Type", ContStaging.TABLECAPTION, ContStaging.FIELDCAPTION("E-Mail"), ContStaging."No.", ContStaging."E-Mail", '', GetLastErrorText());
                        ContStaging.Status := ContStaging.Status::Error;
                    end;
                end;


                if ContStaging."Customer Template Code L365" = '' then begin
                    if not CustTemplate.FINDFIRST then begin
                        LogError(ContStaging."Import Type", ContStaging.TABLECAPTION, '', ContStaging."No.", '', '', STRSUBSTNO(NotBlankErr, ContStaging.FIELDCAPTION("Customer Template Code L365")));
                        ContStaging.Status := ContStaging.Status::Error;
                    end;
                end else begin
                    if not CustTemplate.get(ContStaging."Customer Template Code L365") then begin
                        LogError(ContStaging."Import Type", ContStaging.TABLECAPTION, ContStaging.FIELDCAPTION("Customer Template Code L365"), ContStaging."No.", ContStaging."Customer Template Code L365", '', STRSUBSTNO(UnderlyingTableErr, ContStaging.FIELDCAPTION("Customer Template Code L365")));
                        ContStaging.Status := ContStaging.Status::Error;
                    end;

                end;

                if Cont2.GET(ContStaging."No.") then begin
                    if (not Cont3.GET(ContStaging."Responsible Employee")) and (ContStaging."Responsible Employee" <> '') then begin
                        LogError(ContStaging."Import Type", ContStaging.TABLECAPTION, '', ContStaging."No.", ContStaging."Responsible Employee", '', ClientResponsibleNotExistsErr);
                        if ContStaging.Status = ContStaging.Status::Imported then
                            ContStaging.Status := ContStaging.Status::Warning;
                    end;
                    if not ImportSetup."Overwrite Existing Records" then begin
                        LogError(ContStaging."Import Type", ContStaging.TABLECAPTION, '', ContStaging."No.", '', '', STRSUBSTNO(AlreadyExistsErr, ContStaging.TABLECAPTION));
                        ContStaging.Status := ContStaging.Status::Error;
                    end;
                end;
                if ContStaging.Status = ContStaging.Status::Imported then
                    ContStaging.Status := ContStaging.Status::OK;
                ContStaging.Modify();

            until ContStaging.Next() = 0;
        end;

    end;



    procedure ValidateMatterFields()
    var
        ContStaging: Record "Contact Staging L365";
        ClientStaging: Record "Contact Staging L365";
        Cont: Record Contact;
        BusinessRelation: Record "Business Relation";
        JobRelCont: Record Contact;
        JobType: Record "Contact Job Type L365";
        JobSubType: Record "Contact Job Subtype L365";
        UnderlyingTableErr: Label 'The values does not exist in the underlying table'; // DAN = 'Værdien findes ikke i den bagvedliggende tabel.'                        
        ClientNotExistsErr: Label 'Client does not exists in (also not in staging)';//DAN = 'Klienten findes ikke (heller ikke i kladde)
        EmployeeAutoCreateWarn: Label 'Employee will be autocreated'; //DAN = 'Medarbejder blev autooprettet'
        MandatoryErr: Label 'Field value is mandatory'; //DAN = 'Feltværdi er obligatorisk'
    begin
        ImportSetup.Get();
        ContStaging.SetRange("Import Type", ContStaging."Import Type"::Matter);
        if ContStaging.FindSet() then begin
            ClearLog(ContStaging);
            repeat
                ContStaging.Status := ContStaging.Status::Imported;
                if ContStaging."Part 1 Relation Code" <> '' then begin
                    if not BusinessRelation.get(ContStaging."Part 1 Relation Code") then begin
                        LogError(ContStaging."Import Type", BusinessRelation.TABLECAPTION, BusinessRelation.FIELDCAPTION(Code), ContStaging."No.", ContStaging."Part 1 Relation Code", '', STRSUBSTNO(UnderlyingTableErr));
                        ContStaging.Status := ContStaging.Status::Error;
                    end;
                end;
                if ContStaging."Part 2 Relation Code" <> '' then begin
                    if not BusinessRelation.get(ContStaging."Part 2 Relation Code") then begin
                        LogError(ContStaging."Import Type", BusinessRelation.TABLECAPTION, BusinessRelation.FIELDCAPTION(Code), ContStaging."No.", ContStaging."Part 2 Relation Code", '', STRSUBSTNO(UnderlyingTableErr));
                        ContStaging.Status := ContStaging.Status::Error;
                    end;
                end;
                if ContStaging."Party 1" <> '' then begin
                    if not JobRelCont.GET(ContStaging."Party 1") then begin
                        LogError(ContStaging."Import Type", JobRelCont.TABLECAPTION, ContStaging.FIELDCAPTION("Party 1"), ContStaging."No.", ContStaging."Party 1", '', STRSUBSTNO(UnderlyingTableErr));
                        if ContStaging.Status = ContStaging.Status::Imported then
                            ContStaging.Status := ContStaging.Status::Warning;

                    end;
                end;
                if ContStaging."Party 2" <> '' then begin
                    if not JobRelCont.GET(ContStaging."Party 2") then begin
                        LogError(ContStaging."Import Type", JobRelCont.TABLECAPTION, ContStaging.FIELDCAPTION("Party 2"), ContStaging."No.", ContStaging."Party 2", '', STRSUBSTNO(UnderlyingTableErr));
                        if ContStaging.Status = ContStaging.Status::Imported then
                            ContStaging.Status := ContStaging.Status::Warning;

                    end;
                end;
                if ContStaging."Legal Connection" <> '' then begin
                    if not JobRelCont.GET(ContStaging."Legal Connection") then begin
                        LogError(ContStaging."Import Type", JobRelCont.TABLECAPTION, ContStaging.FIELDCAPTION("Legal Connection"), ContStaging."No.", ContStaging."Legal Connection", '', STRSUBSTNO(UnderlyingTableErr));
                        if ContStaging.Status = ContStaging.Status::Imported then
                            ContStaging.Status := ContStaging.Status::Warning;

                    end;
                end;
                if ContStaging."Inv. Recepient" <> '' then begin
                    if not JobRelCont.GET(ContStaging."Inv. Recepient") then begin
                        LogError(ContStaging."Import Type", JobRelCont.TABLECAPTION, ContStaging.FIELDCAPTION("Inv. Recepient"), ContStaging."No.", ContStaging."Inv. Recepient", '', STRSUBSTNO(UnderlyingTableErr));
                        if ContStaging.Status = ContStaging.Status::Imported then
                            ContStaging.Status := ContStaging.Status::Warning;
                    end;
                end;
                if ContStaging.Secretary <> '' then begin
                    if not JobRelCont.GET(ContStaging.Secretary) then begin
                        if not ImportSetup."Auto Create Employee" then begin
                            LogError(ContStaging."Import Type", JobRelCont.TABLECAPTION, ContStaging.FIELDCAPTION(Secretary), ContStaging."No.", ContStaging.Secretary, '', STRSUBSTNO(UnderlyingTableErr));
                            if ContStaging.Status = ContStaging.Status::Imported then
                                ContStaging.Status := ContStaging.Status::Error;
                        end else begin
                            LogWarning(ContStaging."Import Type", JobRelCont.TABLECAPTION, ContStaging.FIELDCAPTION(Secretary), ContStaging."No.", ContStaging.Secretary, '', EmployeeAutoCreateWarn, false);
                            if ContStaging.Status = ContStaging.Status::Imported then
                                ContStaging.Status := ContStaging.Status::Warning;
                        end;

                    end;
                end;
                if ContStaging."Case Worker" <> '' then begin
                    if not JobRelCont.GET(ContStaging."Case Worker") then begin
                        if not ImportSetup."Auto Create Employee" then begin
                            LogError(ContStaging."Import Type", JobRelCont.TABLECAPTION, ContStaging.FIELDCAPTION("Case Worker"), ContStaging."No.", ContStaging."Case Worker", '', STRSUBSTNO(UnderlyingTableErr));
                            if ContStaging.Status = ContStaging.Status::Imported then
                                ContStaging.Status := ContStaging.Status::Error;
                        end else begin
                            LogWarning(ContStaging."Import Type", JobRelCont.TABLECAPTION, ContStaging.FIELDCAPTION("Case Worker"), ContStaging."No.", ContStaging."Case Worker", '', EmployeeAutoCreateWarn, false);
                            if ContStaging.Status = ContStaging.Status::Imported then
                                ContStaging.Status := ContStaging.Status::Warning;
                        end;
                    end;
                end;
                if ContStaging."Case worker 2" <> '' then begin
                    if not JobRelCont.GET(ContStaging."Case worker 2") then begin
                        if not ImportSetup."Auto Create Employee" then begin
                            LogError(ContStaging."Import Type", JobRelCont.TABLECAPTION, ContStaging.FIELDCAPTION("Case worker 2"), ContStaging."No.", ContStaging."Case Worker 2", '', STRSUBSTNO(UnderlyingTableErr));
                            if ContStaging.Status = ContStaging.Status::Imported then
                                ContStaging.Status := ContStaging.Status::Error;
                        end else begin
                            LogWarning(ContStaging."Import Type", JobRelCont.TABLECAPTION, ContStaging.FIELDCAPTION("Case worker 2"), ContStaging."No.", ContStaging."Case Worker 2", '', EmployeeAutoCreateWarn, false);
                            if ContStaging.Status = ContStaging.Status::Imported then
                                ContStaging.Status := ContStaging.Status::Warning;
                        end;
                    end;
                end;
                if ContStaging."Responsible Lawyer" <> '' then begin
                    if not JobRelCont.GET(ContStaging."Responsible Lawyer") then begin
                        if not ImportSetup."Auto Create Employee" then begin
                            LogError(ContStaging."Import Type", JobRelCont.TABLECAPTION, ContStaging.FIELDCAPTION("Responsible Lawyer"), ContStaging."No.", ContStaging."Responsible Lawyer", '', STRSUBSTNO(UnderlyingTableErr));
                            if ContStaging.Status = ContStaging.Status::Imported then
                                ContStaging.Status := ContStaging.Status::Error;
                        end else begin
                            LogWarning(ContStaging."Import Type", JobRelCont.TABLECAPTION, ContStaging.FIELDCAPTION("Responsible Lawyer"), ContStaging."No.", ContStaging."Responsible Lawyer", '', EmployeeAutoCreateWarn, false);
                            if ContStaging.Status = ContStaging.Status::Imported then
                                ContStaging.Status := ContStaging.Status::Warning;
                        end;
                    end;
                end;

                if ContStaging."Company No." = '' then begin
                    //Field mandatory
                    LogError(ContStaging."Import Type", ContStaging.TABLECAPTION, ContStaging.FIELDCAPTION("Company No."), ContStaging."No.", '', '', STRSUBSTNO(MandatoryErr));
                    ContStaging.Status := ContStaging.Status::Error;
                end else begin
                    //Remap to OldClietn no.?

                    ClientStaging.SetRange("No.", ContStaging."Company No.");
                    if (not cont.get(ContStaging."Company No.")) and ClientStaging.IsEmpty and (not ImportSetup."Auto Create Clients") then begin
                        LogError(ContStaging."Import Type", ContStaging.TABLECAPTION, ContStaging.FIELDCAPTION("Company No."), ContStaging."No.", ContStaging."Company No.", '', STRSUBSTNO(ClientNotExistsErr));
                        ContStaging.Status := ContStaging.Status::Error;
                    end;
                end;

                if ImportSetup."Validate Matter Types" then begin
                    if (ContStaging."Job Type Code L365" <> '') then begin
                        if not JobType.GET(ContStaging."Job Type Code L365") then begin
                            if not ImportSetup."Auto Create Matter Types" then begin
                                LogError(ContStaging."Import Type", JobType.TABLECAPTION, ContStaging.FIELDCAPTION("Job Type Code L365"), ContStaging."No.", ContStaging."Job Type Code L365", '', STRSUBSTNO(UnderlyingTableErr));
                                ContStaging.Status := ContStaging.Status::Error;
                            end;
                        end;
                    end;
                    if (ContStaging."Job Sub Type Code L365" <> '') then begin
                        if not JobSubtype.GET(ContStaging."Job Type Code L365", ContStaging."Job Sub Type Code L365") then begin
                            if not ImportSetup."Auto Create Matter Types" then begin
                                LogError(ContStaging."Import Type", JobSubtype.TABLECAPTION, ContStaging.FIELDCAPTION("Job Sub Type Code L365"), ContStaging."No.", ContStaging."Job Sub Type Code L365", '', STRSUBSTNO(UnderlyingTableErr));
                                ContStaging.Status := ContStaging.Status::Error;
                            end;
                        end;
                    end;
                end;




                if ContStaging.Status = ContStaging.Status::Imported then
                    ContStaging.Status := ContStaging.Status::OK;
                ContStaging.Modify();

            until ContStaging.next() = 0;
        end;
    end;

    procedure ValidatePartyFields()

    var
        ContStaging: Record "Contact Staging L365";
        PostCode: Record "Post Code";
        CountryRegion: Record "Country/Region";
        Language: Record Language;
        Cont2: Record Contact;
        Text0100: Label '%1 already exists and you did not allow updates.'; // DAN = '%1 findes allerede og du har ikke tilladt opdatering.'
        UnderlyingTableErr: Label 'The Value does not exist in the underlying table.'; // DAN = 'Værdien findes ikke i den bagvedliggende tabel.'
    begin
        ImportSetup.Get();
        ContStaging.SetRange("Import Type", ContStaging."Import Type"::Party);
        if ContStaging.FindSet() then begin
            ClearLog(ContStaging);
            repeat
                ContStaging.Status := ContStaging.Status::Imported;
                if ImportSetup."Validate Post Codes" and (ContStaging."Post Code" <> '') then begin
                    PostCode.SETRANGE(Code, ContStaging."Post Code");
                    if PostCode.ISEMPTY then begin
                        if not ImportSetup."Auto Create Post Codes" then begin
                            LogError(ContStaging."Import Type", ContStaging.TABLECAPTION, ContStaging.FIELDCAPTION("Post Code"), ContStaging."No.", ContStaging."Post Code", '', STRSUBSTNO(UnderlyingTableErr));
                            if ContStaging.Status = ContStaging.Status::Imported then
                                ContStaging.Status := ContStaging.Status::Warning;
                        end;

                    end;
                end;
                if ContStaging."Language Code" <> '' then begin
                    if not Language.get(ContStaging."Language Code") then begin
                        LogError(ContStaging."Import Type", ContStaging.TABLECAPTION, ContStaging.FIELDCAPTION("Language Code"), ContStaging."No.", ContStaging."Language Code", '', STRSUBSTNO(UnderlyingTableErr));
                        if ContStaging.Status = ContStaging.Status::Imported then
                            ContStaging.Status := ContStaging.Status::Warning;
                    end;
                end;
                if ContStaging."Country/Region Code" <> '' then begin
                    if not CountryRegion.get(ContStaging."Country/Region Code") then begin
                        LogError(ContStaging."Import Type", ContStaging.TABLECAPTION, ContStaging.FIELDCAPTION("Country/Region Code"), ContStaging."No.", ContStaging."Country/Region Code", '', STRSUBSTNO(UnderlyingTableErr));
                        ContStaging.Status := ContStaging.Status::Error;
                    end;
                end;
                if Cont2.GET(ContStaging."No.") then begin
                    if not ImportSetup."Overwrite Existing Records" then begin
                        LogError(ContStaging."Import Type", ContStaging.TABLECAPTION, '', ContStaging."No.", '', '', STRSUBSTNO(Text0100, ContStaging.TABLECAPTION));
                        ContStaging.Status := ContStaging.Status::Error;
                    end;
                end;
                if ContStaging.Status = ContStaging.Status::Imported then
                    ContStaging.Status := ContStaging.Status::OK;
                ContStaging.Modify();

            until ContStaging.Next() = 0;
        end;
    end;

    procedure ValidateContactRelationFields()

    var
        ContRelStaging: Record "Contact Relation Staging L365";
        ContStaging: Record "Contact Staging L365";
        Cont2: Record Contact;
        BusinessRelation: Record "Business Relation";
        ImportLog: Record "ImportLog L365";
        AlreadyExistsErr: Label '%1 already exists and you did not allow updates.'; // DAN = '%1 findes allerede og du har ikke tilladt opdatering.'
        UnderlyingTableErr: Label 'The Value does not exist in the underlying table or staging table.'; // DAN = 'Værdien findes ikke i den bagvedliggende tabel eller importtabel'
    begin
        ImportSetup.Get();
        ImportLog.SetRange("Import Type", ImportLog."Import Type"::Matter);
        ImportLog.SetRange("Table Name", ContRelStaging.TABLECAPTION);
        ImportLog.DeleteAll();
        if ContRelStaging.FindSet() then begin
            repeat
                ContRelStaging.Status := ContRelStaging.Status::Imported;

                if not Cont2.GET(ContRelStaging."Contact 1 No.") then begin
                    ContStaging.Reset();
                    ContStaging.SetRange("No.", ContRelStaging."Contact 1 No.");
                    if ContStaging.IsEmpty then begin
                        LogError(ContStaging."Import Type"::Matter, ContRelStaging.TABLECAPTION, '', ContRelStaging."Contact 1 No.", '', ContRelStaging."Contact 2 No.", STRSUBSTNO(UnderlyingTableErr, ContRelStaging.TABLECAPTION));
                        ContRelStaging.Status := ContRelStaging.Status::Error;
                    end;

                end;
                if not Cont2.GET(ContRelStaging."Contact 2 No.") then begin
                    ContStaging.Reset();
                    ContStaging.SetRange("No.", ContRelStaging."Contact 2 No.");
                    if ContStaging.IsEmpty then begin
                        LogError(ContStaging."Import Type"::Matter, ContRelStaging.TABLECAPTION, '', ContRelStaging."Contact 2 No.", '', ContRelStaging."Contact 1 No.", STRSUBSTNO(UnderlyingTableErr, ContRelStaging.TABLECAPTION));
                        ContRelStaging.Status := ContRelStaging.Status::Error;
                    end;
                end;
                if (ContRelStaging."Relation Code" <> '') and (not BusinessRelation.Get(ContRelStaging."Relation Code")) then begin
                    LogError(ContStaging."Import Type"::Matter, ContRelStaging.TABLECAPTION, '', ContRelStaging."Contact 1 No.", ContRelStaging."Relation Code", ContRelStaging."Contact 2 No.", STRSUBSTNO(UnderlyingTableErr, BusinessRelation.TABLECAPTION));
                    ContRelStaging.Status := ContRelStaging.Status::Error;
                end;
                if ContRelStaging.Status = ContRelStaging.Status::Imported then
                    ContRelStaging.Status := ContRelStaging.Status::OK;
                ContRelStaging.Modify();

            until ContRelStaging.Next() = 0;
        end;
    end;

    local procedure CreateEmployee(Initials: code[20])
    var
        Employee: Record Employee;
        Basic: Codeunit "Basic L365";
    begin
        Employee.Init();
        Employee."No." := Initials;
        Employee.NameL365 := Employee."No.";
        Employee.Initials := Initials;
        Employee.Insert();
        Basic.CreateEntitiesByEmployeeExt(Employee, true);
    end;

    local procedure CreateRelation(Cont1: Code[20]; Cont2: Code[20]; Rel: Code[20]): Boolean;
    var
        ContRel: Record "Contact Relation L365";
        Update: Boolean;
    begin
        if Cont2 <> '' then begin
            ContRel.SETRANGE("Contact 1", Cont1);
            ContRel.SETRANGE("Relation Code", Rel);
            if not ContRel.IsEmpty then begin
                Update := true;
                ContRel.DELETEALL;
                CLEAR(ContRel);
            end;
            ContRel.HideValidationDialog(true);
            ContRel."Contact 1" := Cont1;
            ContRel.VALIDATE("Contact 2", Cont2);
            ContRel.VALIDATE("Relation Code", Rel);
            ContRel.INSERT(true);
        end;
        exit(Update);
    end;

    local procedure CreateRelation(Cont1: Code[20]; Cont2: Code[20]; Rel: Code[20]; Attention: Text[100]; AttEmail: Text[80]; AttInvEmail: text[80]; AttPhone: Text[30]; Block: Boolean): Boolean;
    var
        ContRel: Record "Contact Relation L365";
        Update: Boolean;
    begin
        if Cont2 <> '' then begin
            ContRel.SETRANGE("Contact 1", Cont1);
            ContRel.SETRANGE("Relation Code", Rel);
            if not ContRel.IsEmpty then begin
                Update := true;
                ContRel.DELETEALL;
                CLEAR(ContRel);
            end;
            ContRel.HideValidationDialog(true);
            ContRel."Contact 1" := Cont1;
            ContRel.VALIDATE("Contact 2", Cont2);
            ContRel.VALIDATE("Relation Code", Rel);
            ContRel.Attention := Attention;
            ContRel."Attention E-mail" := AttEmail;
            ContRel."Contact 2 Inv. E-Mail" := AttInvEmail;
            ContRel."Attention Phone No." := AttPhone;
            ContRel."Block Interactions" := Block;
            ContRel.INSERT(true);
        end;
        exit(Update);
    end;

    local procedure ClearLog(var ContactStage: Record "Contact Staging L365")
    var
        ImportLog: record "ImportLog L365";
    begin
        ImportLog.setrange("Import Type", ContactStage."Import Type");
        ImportLog.SetRange("Date Type Validation", false);
        ImportLog.DeleteAll();
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCreateMatter(var Matter: Record Contact; ContactStaging: Record "Contact Staging L365")
    begin
    end;

    var
        RecordHasError: Boolean;
        StartTime: DateTime;
        ImportSetup: Record "Import Setup L365";
}