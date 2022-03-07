table 71100 "Navokat2BCsetupStatus"
{
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; "Company Name"; Text[100])
        {
            DataClassification = SystemMetadata;
        }
        field(3; "Started"; DateTime)
        {
            DataClassification = SystemMetadata;
        }
        field(4; Ended; DateTime)
        {
            DataClassification = SystemMetadata;
        }
        field(5; Lenght; Duration)
        {
            DataClassification = SystemMetadata;
        }
        field(6; "Job Name"; Text[50])
        {
            DataClassification = SystemMetadata;
        }
        field(7; "Job Id"; Integer)
        {
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }

    }

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    procedure LogStart(Companyname: Text; Jobid: Integer; JobName: Text): Integer;
    var
        Navokat2BCsetupStatus2: Record Navokat2BCsetupStatus;
    begin
        Navokat2BCsetupStatus2."Company Name" := "Company Name";
        Navokat2BCsetupStatus2."Job Id" := Jobid;
        Navokat2BCsetupStatus2."Job Name" := copystr(JobName, 1, MaxStrLen(Navokat2BCsetupStatus2."Job Name"));
        Navokat2BCsetupStatus2.Started := CurrentDateTime;
        Navokat2BCsetupStatus2.Insert();
    end;

    procedure LogEnd(EntryNo: Integer)
    var
        Navokat2BCsetupStatus2: Record Navokat2BCsetupStatus;
    begin
        Navokat2BCsetupStatus2.SetRange("Entry No.", EntryNo);
        Navokat2BCsetupStatus2.FindLast();
        Navokat2BCsetupStatus2.Ended := CurrentDateTime;
    end;

}