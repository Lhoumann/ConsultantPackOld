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
        TimeEntry.SetFilter("First Validation Error", '%1', '');
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
    var
        QueueHandler: Codeunit "Queue Handler L365";

    begin
        if not QueueHandler.CheckJobQueue(codeunit::"Time Queue Background L365") then
            QueueHandler.AddJobQueue(codeunit::"Time Queue Background L365", 5);
    end;

    procedure AddJobQueues();
    var
        QueueHandler: Codeunit "Queue Handler L365";

    begin
        QueueHandler.AddJobQueue(codeunit::"Time Queue Background L365", 5);
    end;

    procedure RemoveJobQueues()
    var
        QueueHandler: Codeunit "Queue Handler L365";

    begin
        QueueHandler.RemoveJobQueue(codeunit::"Time Queue Background L365");
    end;
}