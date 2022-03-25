table 71101 "Contact Staging L365"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
        }
        field(3; "Search Name"; Code[100])
        {
            Caption = 'Search Name';
        }
        field(4; "Name 2"; Text[50])
        {
            Caption = 'Name 2';
        }
        field(5; Address; Text[100])
        {
            Caption = 'Address';
        }
        field(6; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(7; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
        }
        field(8; City; Text[30])
        {
            Caption = 'City';
        }
        field(9; Contact; Text[100])
        {
            Caption = 'Contact';
        }
        field(10; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
        }
        field(11; "Fax No."; Text[30])
        {
            Caption = 'Fax No.';
        }
        field(12; "Home Page"; Text[80])
        {
            Caption = 'Home Page';
        }
        field(13; "E-Mail"; Text[80])
        {
            Caption = 'Email';
        }
        field(14; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
        }
        field(15; "Global Dimension 2 Code"; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
        }
        field(16; "Customer Posting Group"; Code[20])
        {
            Caption = 'Customer Posting Group';
        }
        field(17; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
        }
        field(18; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
        }
        field(19; "Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code';
        }
        field(20; "Fin. Charge Terms Code"; Code[10])
        {
            Caption = 'Fin. Charge Terms Code';
        }
        field(21; "Salesperson Code"; Code[20])
        {
            Caption = 'Salesperson Code';
        }
        field(22; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
        }
        field(23; "Invoice Copies"; Integer)
        {
            Caption = 'Invoice Copies';
        }
        field(24; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';
        }
        field(25; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
        }
        field(26; "Reminder Terms Code"; Code[10])
        {
            Caption = 'Reminder Terms Code';
        }
        field(27; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
        }
        field(28; "EAN No."; Code[13])
        {
            Caption = 'EAN No.';
        }
        field(29; "Job No. Sequence L365"; Code[11])
        {
            Caption = 'Job No. Sequence'; // DAN = 'Sagsnr. sekvens'
        }
        field(30; "VAT Registered L365"; Boolean)
        {
            Caption = 'VAT Registered'; // DAN = 'Momsregistreret'
        }
        field(31; "Our Account No."; Text[20])
        {
            Caption = 'Our Account No.';
        }
        field(32; "Vendor Posting Group"; Code[20])
        {
            Caption = 'Vendor Posting Group';
        }
        field(33; "Purchaser Code"; Code[20])
        {
            Caption = 'Purchaser Code';
        }
        field(34; "Civil Registration No. L365"; Code[20])
        {
            Caption = 'Civil Registration No.'; // DAN = 'CPR Nr.'      
        }
        field(35; "Former No. L365"; Code[20])
        {
            Caption = 'Former No.'; // DAN = 'Tidligere Nummer'
        }
        field(36; AttentionL365; Text[50])
        {
            Caption = 'Attention'; // DAN = 'Attention'
        }
        field(37; "Job Title"; Text[30])
        {
            Caption = 'Job Title';
        }
        field(38; "SE-nummer L365"; Text[30])
        {
            Caption = 'SE-nummer'; // DAN = 'SE-nummer'        
        }
        field(39; "Creation Date L365"; Date)
        {
            Caption = 'Creation Date'; // DAN = 'Oprettet dato'
        }
        field(40; "Birth Date L365"; Date)
        {
            Caption = 'Birth Date'; // DAN = 'Fødselsdato'        
        }
        field(41; "KOB No."; Text[80])
        {
            Caption = 'KOB No.';
        }
        field(42; "Court No."; Code[20])
        {
            Caption = 'Retskredsnr';
        }
        field(43; "Municipal"; Code[20])
        {
            Caption = 'Municipal';
        }
        field(44; "Company No."; Code[20])
        {
            Caption = 'Company No.';
        }
        field(45; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
        }
        field(46; "Job Sub Type Code L365"; Code[10])
        {
            Caption = 'Job Sub Type Code'; // DAN = 'Sagsundertype'
        }
        field(47; "Client Reference L365"; Text[50])
        {
            Caption = 'Client Reference'; // DAN = 'Klientreference'
        }
        field(48; "Court Locked L365"; Boolean)
        {
            Caption = 'Retskreds låst'; // DAN = 'Retskreds låst'
        }
        field(49; "Short Note L365"; Text[50])
        {
            Caption = 'Short Note'; // DAN = 'Kort kommentar'
        }
        field(50; "Civil Court No. L365"; Code[50])
        {
            Caption = 'Civil Court No.'; // DAN = 'Civilretsnr.'
        }
        field(51; "Archived"; Boolean)
        {
            Caption = 'Archived';
        }
        field(52; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(53; "Maculation Date"; Date)
        {
            Caption = 'Maculation Date';
        }
        field(54; "Placement"; Text[80])
        {
            Caption = 'Placement';
        }
        field(55; "Archive Index"; Code[20])
        {
            Caption = 'Archive Index';
        }
        field(56; "Archive Date L365"; Date)
        {
            Caption = 'Archive Date'; // DAN = 'Arkivdato'
        }
        field(57; "Case Worker"; Code[20])
        {
            Caption = 'Sagsbehandler';
        }
        field(58; "Case worker 2"; Code[20])
        {
            Caption = 'Sagsbehandler2';
        }
        field(59; "Responsible Lawyer"; Code[20])
        {
            Caption = 'AnsvarligJurist';
        }
        field(60; "Secretary"; Code[20])
        {
            Caption = 'Sekretær';
        }
        field(61; "Municipal No."; Code[20])
        {
            Caption = 'Kommunenr';
        }

        field(63; "Legal Connection"; Code[20])
        {
            Caption = 'Advokatforbindelse';
        }
        field(64; "Refferal"; Code[20])
        {
            Caption = 'Sagsoverdrager';
        }
        field(65; "Import Type"; Option)
        {
            Caption = 'Type';
            OptionMembers = "Party","Client","Matter","Vendor","Contact Person";
        }
        field(66; "Blocked"; Boolean)
        {
            Caption = 'Blocked';
        }
        field(68; "Billing Employee"; Code[20])
        {
            Caption = 'Billing Employee';
        }
        field(69; "Assigned Employee"; Code[20])
        {
            Caption = 'Assigned Employee';
        }
        field(70; "Responsible Employee"; Code[20])
        {
            Caption = 'Responsible Employee';
        }
        field(71; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
        }
        field(72; "Comment"; Text[1024])
        {
            Caption = 'Comment';
        }
        field(73; "Client Documentation"; Boolean)
        {
            Caption = 'Client Documentation';
        }
        field(74; "Primary Industry Group"; Code[10])
        {
            Caption = 'Primary Industry Group';
        }
        field(75; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = "OK","Imported","Error","Warning";
            OptionCaption = 'OK,Imported,Error,Warning';
        }
        field(76; "Company"; Text[100])
        {
            Caption = 'Company';
        }
        field(77; "Legal Conn. Matter No."; Text[100])
        {
            Caption = 'AdvforbSagsnr';
        }
        field(78; "Extended Name"; Text[2048])
        {
            Caption = 'Extended Name';
        }
        field(79; "Job Type Code L365"; code[10])
        {
            Caption = 'Job Type Code';
        }
        field(80; "Party 1"; code[20])
        {
            Caption = 'Party 1';
        }
        field(81; "Party 2"; code[20])
        {
            Caption = 'Party 2';
        }
        field(82; "Inv. Recepient"; Code[20])
        {
            Caption = 'Inv. Recepient';
        }
        field(83; "Part 1 Relation Code"; Code[20])
        {
            Caption = 'Part 1 Relation Code';
        }
        field(84; "Part 2 Relation Code"; Code[20])
        {
            Caption = 'Part 2 Relation Code';
        }
        field(85; "VIP Client L365"; Boolean)
        {
            Caption = 'VIP Client';
        }
        field(86; "Private Phone No."; Text[30])
        {
            Caption = 'Private Phone No.';
        }
        field(87; "Mobile Phone No."; Text[30])
        {
            Caption = 'Mobile Phone No.';
        }
        field(88; "Bank Branch No. L365"; Text[20])
        {
            Caption = 'Bank Branch No.';
        }
        field(89; "Bank Account No. L365"; text[30])
        {
            Caption = 'Bank Account No.';
        }
        field(90; "Customer Template Code L365"; Text[10])
        {
            Caption = 'Customer Template Code';
        }
        field(91; "First Name"; Text[50])
        {
            Caption = 'First Name';
        }
        field(92; "Middle Name"; Text[50])
        {
            Caption = 'Middle Name';
        }
        field(93; "Sur Name"; Text[50])
        {
            Caption = 'Sur Name';
        }
        field(94; "Salutation Code"; Text[10])
        {
            Caption = 'Salutation Code';
        }        

        field(202; "No. Of Errors"; Integer)
        {
            Caption = 'No. Of Errors';
            FieldClass = FlowField;
            CalcFormula = count("ImportLog L365" where("Import Type" = field("Import Type"), "Primary Key" = field("No.")));
            Editable = false;
        }


    }


    keys
    {
        key(PK; "Import Type", "No.")
        {
            Clustered = true;
        }
    }
    trigger OnDelete()
    var
        ImportLog: Record "ImportLog L365";
    begin
        Importlog.setrange("Import Type", "Import Type");
        importlog.setrange("Primary Key", "No.");
        importlog.DeleteAll();
    end;
}