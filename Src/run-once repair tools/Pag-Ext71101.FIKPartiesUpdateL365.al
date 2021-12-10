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
            action(ClearDocumentNoFromSelected)
            {
                ApplicationArea = All;
                Caption = 'Clear Document No. On Selected Payment Id''s';
                ToolTip = '';
                Image = UpdateXML;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Ellipsis = true;

                trigger OnAction()
                var
                    PaymentID: Record "Payment ID L365";
                begin
                    CurrPage.SetSelectionFilter(PaymentID);
                    if Confirm('Clear Document No. on %1 selected Payment Id records?', false, PaymentID.Count) then begin
                        PaymentID.ModifyAll("Document No.", '');
                        Message('Cleared Document No on selected Payment Id records');
                    end;
                end;
            }
        }
    }
}
