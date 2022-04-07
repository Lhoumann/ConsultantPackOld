codeunit 71116 "Time Queue Events L365CP"
{
    [EventSubscriber(ObjectType::Table, Database::"Job Queue Entry", 'OnBeforeInsertEvent', '', true, true)]
    local procedure OnBeforeInsertJobQueueEntry(var rec: Record "Job Queue Entry")
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        // Insert Consultant Pack version of the codeuint in JobQueue instead of the BaseApp version.
        if (rec."Object Type to Run" = rec."Object Type to Run"::Codeunit) and (rec."Object ID to Run" = Codeunit::"Time Queue Background L365") then begin
            JobQueueEntry.SetRange("Object Type to Run", JobQueueEntry."Object Type to Run"::Codeunit);
            JobQueueEntry.SetRange("Object ID to Run", Codeunit::"Time Queue Background L365CP");
            if JobQueueEntry.IsEmpty() then begin
                rec.Validate("Object ID to Run", Codeunit::"Time Queue Background L365CP");
                rec."No. of Minutes between Runs" := 1;
            end else
                rec.Validate(Status, Rec.Status::"On Hold");
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Job Queue Entry", 'OnBeforeSetStatusValue', '', true, true)]
    local procedure OnBeforeSetStatusValue(var JobQueueEntry: Record "Job Queue Entry"; var xJobQueueEntry: Record "Job Queue Entry"; var NewStatus: Option)
    begin
        if (JobQueueEntry."Object Type to Run" = JobQueueEntry."Object Type to Run"::Codeunit)
            and (JobQueueEntry."Object ID to Run" = Codeunit::"Time Queue Background L365")
        then begin
            NewStatus := JobQueueEntry.Status::"On Hold";
        end;
    end;
}