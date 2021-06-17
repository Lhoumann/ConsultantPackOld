pageextension 71100 "VAT Posting Setup" extends "VAT Posting Setup"
{
    actions
    {
        addlast(processing)
        {
            action(DeleteWithoutCheck)
            {
                Caption = 'Delete w/o check'; // DAN = 'Slet uden kontrol'
                ApplicationArea = All;
                Image = Delete;

                trigger OnAction()
                var
                    ConsultantOnly: Label 'This should only be used by consultants. Do you wish to proceed?'; // DAN = 'Denne funktion må kun benyttes af konsulenter. Ønsker du at forsætte?'

                begin
                    if Confirm(ConsultantOnly) then
                        Rec.Delete();

                end;
            }
        }
    }
}