pageextension 71105 SharePointSetupL365CP extends "SharePoint Setup L365"
{

    actions
    {
        addlast(Processing)
        {

            action(SetupTestEnvironmentL365CP)
            {
                ApplicationArea = All;
                Caption = 'Setup Test Environment'; // DAN = 'Opsæt testmiljø'
                ToolTip = 'Prepares a newly created sandbox copy of a production environment for testing, by removing conenctions to production SharePoint and other external links. SharePoint sites in BC are deleted, but can be recreated with links to a testing SharePoint site from the SharePoint Sites page'; //DAN='Forbereder en nyligt oprettet sandkasse kopi af et produktionsmiljø til test ved at fjerne afskære fiorbindelser til produktions SharePoint samt andre eksterne forbindelser. Alle SharePoint websteder i BC slettes, men kan senere genskabes via SharePoint Websteder siden.'
                Image = UpdateXML;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Ellipsis = true;
                RunObject = codeunit "SetupTestEnvironmentL365CP";

                trigger OnAction()
                var
                begin

                end;

            }
        }
    }
}
