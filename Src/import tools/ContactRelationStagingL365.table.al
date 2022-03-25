table 71102 "Contact Relation Staging L365"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Contact 1 No."; Code[20])
        {
            Caption = 'Contact 1No.';
        }
        field(2; "Contact 2 No."; Code[20])
        {
            Caption = 'Contact 2 No.';
        }
        field(3; "Relation Code"; Code[20])
        {
            Caption = 'Relation Code';
        }
        field(4; "Your Reference"; Text[250])
        {
            Caption = 'Your Reference';
        }
        field(5; Attention; Text[100])
        {
            Caption = 'Attention';
        }
        field(6; "Attention Phone No."; Text[50])
        {
            Caption = 'Attention Phone No.';
        }
        field(7; "Attention E-mail"; Text[80])
        {
            Caption = 'Attention E-Email';
        }
        field(8; "Block Interaction"; boolean)
        {
            Caption = 'Block Interaction';
        }

        field(14; "Attention Invoice E-Mail"; text[80])
        {
            Caption = 'Attention Invoice E-Mail';
        }
        field(15; "GLN No."; Code[20])
        {
            Caption = 'GLN No.';
        }
        field(100; "New Contact 1 No."; Code[20])
        {
            Caption = 'New Contact 1No.';
        }
        field(101; "New Contact 2 No."; Code[20])
        {
            Caption = 'New Contact 2 No.';
        }


        /* field(202; "No. Of Errors"; Integer)
        {
            Caption = 'No. Of Errors';
            FieldClass = FlowField;
            CalcFormula = count("ImportLog L365" where("Import Type" = field("Import Type"), "Primary Key" = field("No.")));
            Editable = false;
        } */
        field(201; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = "OK","Imported","Error","Warning";
            OptionCaption = 'OK,Imported,Error,Warning';
        }


    }


    keys
    {
        key(PK; "Contact 1 No.", "Contact 2 No.")
        {
            Clustered = true;
        }
    }
    trigger OnDelete()
    var
        ImportLog: Record "ImportLog L365";
    begin
        //importlog.setrange("Primary Key", "No.");
        //importlog.DeleteAll();
    end;
}