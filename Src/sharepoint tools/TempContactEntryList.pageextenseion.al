pageextension 71103 "Temp Cont. Entry List L365CP" extends "Temp Contact Entry List L365"
{
    actions
    {
        addlast(processing)
        {
            action(AddDefaultFoldersL365CP)
            {
                ApplicationArea = All;
                Caption = 'Add Default Folders'; //DAN = 'Tlføj standardmapper',     
                Image = Refresh;

                trigger OnAction();
                var
                    Contact: Record Contact;
                    ContactFolder: Record "Contact Folder L365";
                    SharePointIntegration: Codeunit "SharePoint Integration L365";
                    ContactEntryMgt: Codeunit "Contact Entry Mgt. L365";

                begin
                    if rec."Contact No." <> '' then
                        Contact.Get(Rec."Contact No.")
                    else
                        Contact.Get(Rec.GetRangeMax("Contact No."));
                    ContactFolder.SetRange("Contact No.", Contact."No.");
                    ContactFolder.FindSet(); // Test that ContactFolders are actually present; else that is the error
                    // Todo: Create default ContactFolders if they are missing - see report 6065404 "Create Contact Folders L365"
                    SharePointIntegration.CreateContactFolders(Contact."No."); // Creates folders in SharePoint only
                    Commit();
                    // Sync correspondence with SharePoint 
                    //ContactEntryMgt.LoadTempEntries(Contact."No.",rec,true); // calling the SP sync directly
                    if rec.COUNT < 1000 then
                        rec.DELETEALL;
                    ContactEntryMgt.OnLoadTempEntries(Contact."No.", Rec, true);
                    Message(AddFoldersCompletedMsg);
                end;
            }
        }
    }

    var
        AddFoldersCompletedMsg: label 'Default folders ar now added.'; //DAN = 'Standardmapper er nu tilføjet.'

}