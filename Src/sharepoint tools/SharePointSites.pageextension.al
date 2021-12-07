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
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Ellipsis = true;
                RunObject = report "Create Contact Folders L365";

                trigger OnAction()
                var

                begin

                end;


            }
        }
    }
}
