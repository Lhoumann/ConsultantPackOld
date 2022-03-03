/// <summary>
/// This is a run-once tool to fix a datamigration error described on bug CO0256-121 (actually description is on Zendesk ticket 3086444)
/// In short: Navokat had modified the link to Table with an 4th option "Job". Now in BC Microsoft has added 4th option Employee.
/// The old Navokat Job link is no longer needed so the problem is fixed 2022-03-03 by setting af fileter in datamigration and by this cleanup report 
/// to be run on alredy migrated BC customers.
/// </summary>
report 71101 "DeleteEmpContactBusRel L365CP"
{
    Caption = 'Import SharePoint Websites from CSV file';
    UsageCategory = Tasks;
    ApplicationArea = All;
    ProcessingOnly = true;
    UseRequestPage = false;

    var
        ContactBusinessRelation: Record "Contact Business Relation";

    trigger OnPreReport()
    var
    begin
        if Confirm('Delete all Contact Business Relations where Link to Table is Employee?', false) then begin
            ContactBusinessRelation.SetRange("Link to Table", ContactBusinessRelation."Link to Table"::Employee);
            ContactBusinessRelation.DeleteAll();
            Message('All Contact Business Relations where Link to Table is Employee is now deleted');
        end else
            Error('Cancelled');
    end;
}