pageextension 71104 SharePointSitesL365CP extends "SharePoint Sites L365"
{

    actions
    {
        addlast(Processing)
        {

            action(CreateContactFoldersL365CP)
            {
                ApplicationArea = All;
                Caption = 'Create Default Folders for Contacts'; // DAN = 'Opret Standard Mapper til Kontakter'
                Image = UpdateXML;
                Promoted = false;
                Ellipsis = true;
                RunObject = report "Create Contact Folders L365";

                trigger OnAction()
                var
                begin
                end;
            }
            action(ImportWebsitesL365CP)
            {
                ApplicationArea = All;
                Caption = 'Import Websites'; // DAN = 'Importer Websteder'
                Image = Import;
                Promoted = false;
                Ellipsis = true;
                RunObject = report "ImportSharePointWebsitesL365CP";

                trigger OnAction()
                var
                begin
                end;
            }
        }
    }
}
