pageextension 71101 "FIK Parties Update L365" extends "Payment IDs L365"
{
    actions
    {
        addlast(Processing)
        {
            action(ImportPartiesFIK)
            {
                ApplicationArea = All;
                Caption = 'Import Parties FIK file';
                ToolTip = 'Imports a csv file exported from Lexsos Advo+ NAV and updates JobNo and PartyNo. in PaymentID table of the imported FIK Nos. See Zendesk #3080917 for details';
                Image = UpdateXML;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Ellipsis = true;
                RunObject = xmlport "FIK Parties update L365";

                trigger OnAction()
                var
                begin

                end;
            }
        }
    }
}
