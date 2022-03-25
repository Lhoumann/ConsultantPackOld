page 71103 "Import Cont. Stag. WsheetL365"
{
    ApplicationArea = All;
    Caption = 'Import Contact Staging List'; //DAN= 'Import kontakter kladde'
    PageType = Worksheet;
    SourceTable = "Contact Staging L365";
    UsageCategory = Administration;
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {

                field("Type"; Rec."Import Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field("No. Of Errros"; "No. Of Errors")
                {
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    var
                        ImportLog: Record "ImportLog L365";
                    begin
                        ImportLog.SetRange("Primary Key", "No.");
                        ImportLog.SetRange("Import Type", "Import Type");
                        page.RunModal(page::"Importlog L365", ImportLog);

                    end;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    ApplicationArea = All;
                }
                field("Name 2"; Rec."Name 2")
                {
                    ToolTip = 'Specifies the value of the Name 2 field.';
                    ApplicationArea = All;
                }
                field("Extended Name"; Rec."Extended Name")
                {
                    ToolTip = 'Specifies the value of the Extended Name field.';
                    ApplicationArea = All;
                }

                field(Address; Rec.Address)
                {
                    ToolTip = 'Specifies the value of the Address field.';
                    ApplicationArea = All;
                }
                field("Address 2"; Rec."Address 2")
                {
                    ToolTip = 'Specifies the value of the Address 2 field.';
                    ApplicationArea = All;

                }
                field("Post Code"; Rec."Post Code")
                {
                    ToolTip = 'Specifies the value of the Post Code field.';
                    ApplicationArea = All;
                }
                field(City; Rec.City)
                {
                    ToolTip = 'Specifies the value of the City field.';
                    ApplicationArea = All;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ToolTip = 'Specifies the value of the Country/Region Code field.';
                    ApplicationArea = All;
                }
                field(AttentionL365; Rec.AttentionL365)
                {
                    ToolTip = 'Specifies the value of the Attention field.';
                    ApplicationArea = All;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ToolTip = 'Specifies the value of the Email field.';
                    ApplicationArea = All;
                }
                field("EAN No."; Rec."EAN No.")
                {
                    ToolTip = 'Specifies the value of the EAN No. field.';
                    ApplicationArea = All;
                    Visible = ClientAndPartyRelated;
                }
                field("Archive Date L365"; Rec."Archive Date L365")
                {
                    ToolTip = 'Specifies the value of the Archive Date field.';
                    ApplicationArea = All;
                    Visible = MatterReleated;
                }
                field("Archive Index"; Rec."Archive Index")
                {
                    ToolTip = 'Specifies the value of the Archive Index field.';
                    ApplicationArea = All;
                    Visible = MatterReleated;
                }
                field(Archived; Rec.Archived)
                {
                    ToolTip = 'Specifies the value of the Archived field.';
                    ApplicationArea = All;
                    Visible = MatterReleated;
                }

                field("Bank Account No. L365"; Rec."Bank Account No. L365")
                {
                    ToolTip = 'Specifies the value of the Bank Account No. field.';
                    ApplicationArea = All;
                    Visible = ClientAndPartyRelated;
                }
                field("Bank Branch No. L365"; Rec."Bank Branch No. L365")
                {
                    ToolTip = 'Specifies the value of the Bank Branch No. field.';
                    ApplicationArea = All;
                    Visible = ClientAndPartyRelated;
                }
                field("Billing Employee"; Rec."Billing Employee")
                {
                    ToolTip = 'Specifies the value of the Billing Employee field.';
                    ApplicationArea = All;
                    Visible = MatterReleated;
                }
                field("Birth Date L365"; Rec."Birth Date L365")
                {
                    ToolTip = 'Specifies the value of the Birth Date field.';
                    ApplicationArea = All;
                    Visible = ClientAndPartyRelated;
                }
                field(Blocked; Rec.Blocked)
                {
                    ToolTip = 'Specifies the value of the Blocked field.';
                    ApplicationArea = All;
                }
                field("Case Worker"; Rec."Case Worker")
                {
                    ToolTip = 'Specifies the value of the Sagsbehandler field.';
                    ApplicationArea = All;
                    Visible = MatterReleated;
                }
                field("Case worker 2"; Rec."Case worker 2")
                {
                    ToolTip = 'Specifies the value of the Sagsbehandler2 field.';
                    ApplicationArea = All;
                    Visible = MatterReleated;
                }

                field("Civil Court No. L365"; Rec."Civil Court No. L365")
                {
                    ToolTip = 'Specifies the value of the Civil Court No. field.';
                    ApplicationArea = All;
                    Visible = MatterReleated;
                }
                field("Civil Registration No. L365"; Rec."Civil Registration No. L365")
                {
                    ToolTip = 'Specifies the value of the Civil Registration No. field.';
                    ApplicationArea = All;
                }
                field("Client Documentation"; Rec."Client Documentation")
                {
                    ToolTip = 'Specifies the value of the Client Documentation field.';
                    ApplicationArea = All;
                }
                field("Client Reference L365"; Rec."Client Reference L365")
                {
                    ToolTip = 'Specifies the value of the Client Reference field.';
                    ApplicationArea = All;
                }
                field(Comment; Rec.Comment)
                {
                    ToolTip = 'Specifies the value of the Comment field.';
                    ApplicationArea = All;
                }
                field(Company; Rec.Company)
                {
                    ToolTip = 'Specifies the value of the Company field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Company No."; Rec."Company No.")
                {
                    ToolTip = 'Specifies the value of the Company No. field.';
                    ApplicationArea = All;
                }
                field(Contact; Rec.Contact)
                {
                    ToolTip = 'Specifies the value of the Contact field.';
                    ApplicationArea = All;
                }
                field("Court Locked L365"; Rec."Court Locked L365")
                {
                    ToolTip = 'Specifies the value of the Retskreds låst field.';
                    ApplicationArea = All;
                    Visible = MatterReleated;
                }

                field("Court No."; Rec."Court No.")
                {
                    ToolTip = 'Specifies the value of the Retskredsnr field.';
                    ApplicationArea = All;
                }
                field("Creation Date L365"; Rec."Creation Date L365")
                {
                    ToolTip = 'Specifies the value of the Creation Date field.';
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the value of the Currency Code field.';
                    ApplicationArea = All;
                }
                field("Customer Posting Group"; Rec."Customer Posting Group")
                {
                    ToolTip = 'Specifies the value of the Customer Posting Group field.';
                    ApplicationArea = All;
                    Visible = ClientRelated;
                }
                field("Customer Template Code L365"; Rec."Customer Template Code L365")
                {
                    ToolTip = 'Specifies the value of the Customer Template Code field.';
                    ApplicationArea = All;
                    Visible = ClientRelated;
                }

                field("Ending Date"; Rec."Ending Date")
                {
                    ToolTip = 'Specifies the value of the Ending Date field.';
                    ApplicationArea = All;
                    Visible = ClientRelated;
                }

                field("Fax No."; Rec."Fax No.")
                {
                    ToolTip = 'Specifies the value of the Fax No. field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Fin. Charge Terms Code"; Rec."Fin. Charge Terms Code")
                {
                    ToolTip = 'Specifies the value of the Fin. Charge Terms Code field.';
                    ApplicationArea = All;
                    Visible = ClientRelated;
                }
                field("First Name"; Rec."First Name")
                {
                    ToolTip = 'Specifies the value of the First Name field.';
                    ApplicationArea = All;
                    Visible = ClientAndPartyRelated;
                }
                field("Former No. L365"; Rec."Former No. L365")
                {
                    ToolTip = 'Specifies the value of the Former No. field.';
                    ApplicationArea = All;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ToolTip = 'Specifies the value of the Gen. Bus. Posting Group field.';
                    ApplicationArea = All;
                    Visible = ClientRelated;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                    ApplicationArea = All;
                    Visible = ClientRelated;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                    ApplicationArea = All;
                    Visible = ClientRelated;
                }
                field("Home Page"; Rec."Home Page")
                {
                    ToolTip = 'Specifies the value of the Home Page field.';
                    ApplicationArea = All;
                }
                field("Inv. Recepient"; Rec."Inv. Recepient")
                {
                    ToolTip = 'Specifies the value of the Inv. Recepient field.';
                    ApplicationArea = All;
                    Visible = MatterReleated;
                }
                field("Invoice Copies"; Rec."Invoice Copies")
                {
                    ToolTip = 'Specifies the value of the Invoice Copies field.';
                    ApplicationArea = All;
                    Visible = ClientRelated;
                }
                field("Job No. Sequence L365"; Rec."Job No. Sequence L365")
                {
                    ToolTip = 'Specifies the value of the Job No. Sequence field.';
                    ApplicationArea = All;
                    Visible = ClientRelated;
                }
                field("Job Sub Type Code L365"; Rec."Job Sub Type Code L365")
                {
                    ToolTip = 'Specifies the value of the Job Sub Type Code field.';
                    ApplicationArea = All;
                    Visible = MatterReleated;
                }
                field("Job Title"; Rec."Job Title")
                {
                    ToolTip = 'Specifies the value of the Job Title field.';
                    ApplicationArea = All;
                    Visible = MatterReleated;
                }
                field("Job Type Code L365"; Rec."Job Type Code L365")
                {
                    ToolTip = 'Specifies the value of the Job Type Code field.';
                    ApplicationArea = All;
                    Visible = MatterReleated;
                }
                field("KOB No."; Rec."KOB No.")
                {
                    ToolTip = 'Specifies the value of the KOB No. field.';
                    ApplicationArea = All;
                    Visible = ClientAndPartyRelated;
                }
                field("Language Code"; Rec."Language Code")
                {
                    ToolTip = 'Specifies the value of the Language Code field.';
                    ApplicationArea = All;
                    Visible = ClientAndPartyRelated;
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ToolTip = 'Specifies the value of the Last Date Modified field.';
                    ApplicationArea = All;
                }
                field("Legal Conn. Matter No."; Rec."Legal Conn. Matter No.")
                {
                    ToolTip = 'Specifies the value of the AdvforbSagsnr field.';
                    ApplicationArea = All;
                    Visible = MatterReleated;
                }
                field("Legal Connection"; Rec."Legal Connection")
                {
                    ToolTip = 'Specifies the value of the Advokatforbindelse field.';
                    ApplicationArea = All;
                    Visible = MatterReleated;
                }
                field("Maculation Date"; Rec."Maculation Date")
                {
                    ToolTip = 'Specifies the value of the Maculation Date field.';
                    ApplicationArea = All;
                    Visible = MatterReleated;
                }
                field("Middle Name"; Rec."Middle Name")
                {
                    ToolTip = 'Specifies the value of the Middle Name field.';
                    ApplicationArea = All;
                    Visible = ClientAndPartyRelated;
                }
                field("Mobile Phone No."; Rec."Mobile Phone No.")
                {
                    ToolTip = 'Specifies the value of the Mobile Phone No. field.';
                    ApplicationArea = All;
                }
                field(Municipal; Rec.Municipal)
                {
                    ToolTip = 'Specifies the value of the Municipal field.';
                    ApplicationArea = All;
                    Visible = MatterReleated;
                }
                field("Municipal No."; Rec."Municipal No.")
                {
                    ToolTip = 'Specifies the value of the Kommunenr field.';
                    ApplicationArea = All;
                    Visible = MatterReleated;
                }
                field("Our Account No."; Rec."Our Account No.")
                {
                    ToolTip = 'Specifies the value of the Our Account No. field.';
                    ApplicationArea = All;
                    Visible = ClientRelated;
                }
                field("Part 1 Relation Code"; Rec."Part 1 Relation Code")
                {
                    ToolTip = 'Specifies the value of the Part 1 Relation Code field.';
                    ApplicationArea = All;
                    Visible = MatterReleated;
                }
                field("Part 2 Relation Code"; Rec."Part 2 Relation Code")
                {
                    ToolTip = 'Specifies the value of the Part 2 Relation Code field.';
                    ApplicationArea = All;
                    Visible = MatterReleated;
                }
                field("Party 1"; Rec."Party 1")
                {
                    ToolTip = 'Specifies the value of the Party 1 field.';
                    ApplicationArea = All;
                    Visible = MatterReleated;
                }
                field("Party 2"; Rec."Party 2")
                {
                    ToolTip = 'Specifies the value of the Party 2 field.';
                    ApplicationArea = All;
                    Visible = MatterReleated;
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ToolTip = 'Specifies the value of the Payment Terms Code field.';
                    ApplicationArea = All;
                    Visible = ClientRelated;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ToolTip = 'Specifies the value of the Phone No. field.';
                    ApplicationArea = All;
                    Visible = ClientAndPartyRelated;
                }
                field(Placement; Rec.Placement)
                {
                    ToolTip = 'Specifies the value of the Placement field.';
                    ApplicationArea = All;
                    Visible = MatterReleated;
                }

                field("Primary Industry Group"; Rec."Primary Industry Group")
                {
                    ToolTip = 'Specifies the value of the Primary Industry Group field.';
                    ApplicationArea = All;
                    Visible = ClientRelated;
                }
                field("Private Phone No."; Rec."Private Phone No.")
                {
                    ToolTip = 'Specifies the value of the Private Phone No. field.';
                    ApplicationArea = All;
                }

                field(Refferal; Rec.Refferal)
                {
                    ToolTip = 'Specifies the value of the Sagsoverdrager field.';
                    ApplicationArea = All;
                    Visible = MatterReleated;
                }
                field("Reminder Terms Code"; Rec."Reminder Terms Code")
                {
                    ToolTip = 'Specifies the value of the Reminder Terms Code field.';
                    ApplicationArea = All;
                    Visible = ClientRelated;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Responsible Employee"; Rec."Responsible Employee")
                {
                    ToolTip = 'Specifies the value of the Responsible Employee field.';
                    ApplicationArea = All;
                    Visible = ClientRelated;
                }
                field("Responsible Lawyer"; Rec."Responsible Lawyer")
                {
                    ToolTip = 'Specifies the value of the AnsvarligJurist field.';
                    ApplicationArea = All;
                    Visible = MatterReleated;
                }
                field("SE-nummer L365"; Rec."SE-nummer L365")
                {
                    ToolTip = 'Specifies the value of the SE-nummer field.';
                    ApplicationArea = All;
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ToolTip = 'Specifies the value of the Salesperson Code field.';
                    ApplicationArea = All;
                    Visible = ClientRelated;
                }
                field("Salutation Code"; Rec."Salutation Code")
                {
                    ToolTip = 'Specifies the value of the Salutation Code field.';
                    ApplicationArea = All;
                    Visible = ClientAndPartyRelated;
                }
                field("Search Name"; Rec."Search Name")
                {
                    ToolTip = 'Specifies the value of the Search Name field.';
                    ApplicationArea = All;
                }
                field(Secretary; Rec.Secretary)
                {
                    ToolTip = 'Specifies the value of the Sekretær field.';
                    ApplicationArea = All;
                    Visible = MatterReleated;
                }
                field("Short Note L365"; Rec."Short Note L365")
                {
                    ToolTip = 'Specifies the value of the Short Note field.';
                    ApplicationArea = All;
                }

                field("Sur Name"; Rec."Sur Name")
                {
                    ToolTip = 'Specifies the value of the Sur Name field.';
                    ApplicationArea = All;
                    Visible = ClientAndPartyRelated;
                }


                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ToolTip = 'Specifies the value of the VAT Bus. Posting Group field.';
                    ApplicationArea = All;
                    Visible = ClientRelated;
                }
                field("VAT Registered L365"; Rec."VAT Registered L365")
                {
                    ToolTip = 'Specifies the value of the VAT Registered field.';
                    ApplicationArea = All;
                    Visible = ClientAndPartyRelated;
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ToolTip = 'Specifies the value of the VAT Registration No. field.';
                    ApplicationArea = All;
                }
                field("VIP Client L365"; Rec."VIP Client L365")
                {
                    ToolTip = 'Specifies the value of the VIP Client field.';
                    Visible = ClientRelated;
                    ApplicationArea = All;
                }


            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(OnlyClients)
            {
                ApplicationArea = All;
                Caption = 'Clients';
                ToolTip = 'Show only Clients';
                Image = Customer;
                Promoted = true;
                trigger OnAction()
                begin
                    SetRange("Import Type", "Import Type"::Client);
                    ClientAndPartyRelated := true;
                    ClientRelated := true;
                    MatterReleated := false;
                    CurrPage.Update();
                end;

            }
            action(OnlyMatters)
            {
                ApplicationArea = All;
                Caption = 'Matters';
                ToolTip = 'Show only Matters';
                Image = Job;
                Promoted = true;
                trigger OnAction()
                begin
                    SetRange("Import Type", "Import Type"::Matter);
                    ClientAndPartyRelated := false;
                    ClientRelated := false;
                    MatterReleated := true;
                    CurrPage.Update();
                end;

            }
            action(OnlyParties)
            {
                ApplicationArea = All;
                Caption = 'Parties';
                ToolTip = 'Show only Parties';
                Image = Vendor;
                Promoted = true;
                trigger OnAction()
                begin
                    SetRange("Import Type", "Import Type"::Party);
                    ClientAndPartyRelated := true;
                    ClientRelated := true;
                    MatterReleated := false;
                    CurrPage.Update();
                end;

            }
            group(Import)
            {
                Caption = 'Import';
                action(ImportClients)
                {
                    Caption = 'Import Clients';
                    RunObject = codeunit "Import Clients2 L365";
                    ApplicationArea = All;
                }
                action(ImportParties)
                {
                    Caption = 'Import Parties';
                    RunObject = codeunit "Import Parties2 L365";
                    ApplicationArea = All;
                }
                action(ImportMatters)
                {
                    Caption = 'Import Matters';
                    RunObject = codeunit "Import Matters2 L365";
                    ApplicationArea = All;
                }
            }
            group(Validation)
            {
                Caption = 'Validation';
                action(ValidateNoSeries)
                {
                    Caption = 'Validate No. Series';
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        ExcelImportToolMgtL365.ValidateNoSeries();
                    end;
                }
                action(ValidateFields)
                {
                    Caption = 'Validate Fields';
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        ExcelImportToolMgtL365.ValidateClientFields();
                        ExcelImportToolMgtL365.ValidateMatterFields();
                        ExcelImportToolMgtL365.ValidatePartyFields();
                    end;
                }

            }
            group(Create)
            {
                Caption = 'Create';
                action(CreateClients)
                {
                    Caption = 'Create Clients';
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        ExcelImportToolMgtL365.CreateClientsFromStaging();
                    end;
                }
                action(CreateParties)
                {
                    Caption = 'Create Parties';
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        ExcelImportToolMgtL365.CreatePartiesFromStaging();
                    end;
                }
                action(CreateMattesr)
                {
                    Caption = 'Create Matters';
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        ExcelImportToolMgtL365.CreateMattersFromStaging();
                    end;
                }

            }





        }
        area(Navigation)
        {
            action(ShowLog)
            {
                Caption = 'Show Log';
                ApplicationArea = All;
                RunObject = page "Importlog L365";
                Image = Log;
            }

        }

    }
    var
        ExcelImportToolMgtL365: Codeunit ExcelImportToolMgtL365;
        [InDataSet]
        ClientRelated, MatterReleated, PartyRelated, ClientAndPartyRelated : Boolean;
}
