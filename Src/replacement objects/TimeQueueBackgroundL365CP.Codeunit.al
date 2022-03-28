/// <summary>
/// Copy of codeunit 6065423 "Time Queue Background L365" 
/// with smalle fix of infinite loop in in OnRun.
/// Can be used in on JobQueueENtrues until permanent fix is releasen in Abakion Legal
/// Todo: Add index to TimeENtry table to improve performance and perhaps make the check more frequent
/// </summary>
codeunit 71115 "Time Queue Background L365CP"
{
    SingleInstance = true;
    //Single Instance background worker

    trigger OnRun()
    var
        i: Integer;
    begin
        for i := 1 to 4 do begin
            ProcessEntries();
            sleep(60000);
        end;
    end;

    procedure ProcessEntries()
    var
        TimeEntry: Record "Time Entry L365";
        TimeEntryMgt: Codeunit "Time Entry Mgt. L365";

    begin
        TimeEntry.SetFilter("Synch Status", '<>%1', TimeEntry."Synch Status"::"In Synch");
        TimeEntry.Setrange("Validation Failed", false);
        //TimeEntry.SetFilter("First Validation Error", '%1', '');
        if TimeEntry.FindSet() then
            repeat
                if TimeEntryMgt.UpdateTimeEntry(TimeEntry) then begin
                    TimeEntry.Modify();
                    Commit;
                end else begin
                    TimeEntry."First Validation Error" := copystr(GetLastErrorText, 1, MaxStrLen(TimeEntry."First Validation Error"));
                    TimeEntry."Synch Status" := TimeEntry."Synch Status"::Failed;
                    TimeEntry.Modify();
                    Commit();
                end;
            until TimeEntry.next = 0;
    end;

    [TryFunction]
    procedure TryCheckJobQueues()
    begin
        CheckJobQueues();
    end;

    procedure CheckJobQueues();
    begin
        if not CheckJobQueue(codeunit::"Time Queue Background L365") then
            AddJobQueue(codeunit::"Time Queue Background L365");
    end;

    procedure AddJobQueues();
    begin
        AddJobQueue(codeunit::"Time Queue Background L365");
    end;

    procedure RemoveJobQueues()
    begin
        RemoveJobQueue(codeunit::"Time Queue Background L365");
    end;

    local procedure CheckJobQueue(CodeunitNo: Integer): Boolean
    var
        JobQueueEntry: Record "Job Queue Entry";

    begin
        JobQueueEntry.SetRange("Object Type to Run", JobQueueEntry."Object Type to Run"::Codeunit);
        JobQueueEntry.SetRange("Object ID to Run", CodeunitNo);
        JobQueueEntry.SetFilter(Status, '%1|%2', JobQueueEntry.Status::Ready, JobQueueEntry.Status::"In Process");
        exit(not JobQueueEntry.IsEmpty);
    end;

    local procedure AddJobQueue(CodeunitNo: Integer)
    var
        JobQueueEntry: Record "Job Queue Entry";

    begin
        JobQueueEntry.SetRange("Object Type to Run", JobQueueEntry."Object Type to Run"::Codeunit);
        JobQueueEntry.SetRange("Object ID to Run", CodeunitNo);
        if JobQueueEntry.FindFirst then begin
            JobQueueEntry."No. of Minutes between Runs" := 5;
            JobQueueEntry."Run on Mondays" := true;
            JobQueueEntry."Run on Tuesdays" := true;
            JobQueueEntry."Run on Wednesdays" := true;
            JobQueueEntry."Run on Thursdays" := true;
            JobQueueEntry."Run on Fridays" := true;
            JobQueueEntry."Run on Saturdays" := true;
            JobQueueEntry."Run on Sundays" := true;
            JobQueueEntry."Recurring Job" := true;
            JobQueueEntry."Earliest Start Date/Time" := CurrentDateTime;
            JobQueueEntry.Modify;
            JobQueueEntry.Restart;
        end else begin
            Clear(JobQueueEntry);
            JobQueueEntry.Validate("Object Type to Run", JobQueueEntry."Object Type to Run"::Codeunit);
            JobQueueEntry.Validate("Object ID to Run", CodeunitNo);
            JobQueueEntry."No. of Minutes between Runs" := 5;
            JobQueueEntry."Run on Mondays" := true;
            JobQueueEntry."Run on Tuesdays" := true;
            JobQueueEntry."Run on Wednesdays" := true;
            JobQueueEntry."Run on Thursdays" := true;
            JobQueueEntry."Run on Fridays" := true;
            JobQueueEntry."Run on Saturdays" := true;
            JobQueueEntry."Run on Sundays" := true;
            JobQueueEntry."Recurring Job" := true;
            JobQueueEntry."Earliest Start Date/Time" := CurrentDateTime;
            JobQueueEntry.Insert(true);
            JobQueueEntry.Restart;
        end;
    end;

    local procedure RemoveJobQueue(CodeunitNo: Integer)
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        JobQueueEntry.SetRange("Object Type to Run", JobQueueEntry."Object Type to Run"::Codeunit);
        JobQueueEntry.SetRange("Object ID to Run", CodeunitNo);
        if JobQueueEntry.FindFirst() then begin
            JobQueueEntry.CancelTask();
            JobQueueEntry.DeleteTask();
        end;
    end;
}