pageextension 71102 PostCodeSetupToolsL365 extends "Post Codes"
{
    actions
    {
        addlast(processing)
        {
            action(AddDKAsDefault)
            {
                Caption = 'Add DK as default to Post Codes with missing country code'; // DAN = 'Tilføj DK som standard til postnumre med manglende landekode'
                ApplicationArea = All;
                Image = Delete;
                Ellipsis = true;

                trigger OnAction()
                var
                    ConsultantOnlyQst: Label 'This should only be used by consultants. Do you wish to proceed?'; // DAN = 'Denne funktion må kun benyttes af konsulenter. Ønsker du at forsætte?'
                    FinishedMsg: Label 'Finished updating %1 post codes wiith missing country codes'; // DAN = 'Færdig med at opdatere %1 postnumre med manglende landekoder'
                    PostCode: Record "Post Code";
                    MissingCount: Integer;

                begin
                    if not Confirm(ConsultantOnlyQst) then
                        exit;
                    PostCode.SetRange("Country/Region Code", '');
                    MissingCount := PostCode.Count;
                    PostCode.ModifyAll("Country/Region Code", 'DK');
                    Message(FinishedMsg, MissingCount);
                end;
            }
        }
    }
}
