pageextension 71106 "AbakionLegalSetupExtL365" extends "AbakionLegal Setup L365"
{
    layout
    {


    }
    actions
    {
        addafter(Register)
        {
            action(ClearGUID)
            {
                Caption = 'Clear App Guid'; //DAN = 'Nulstil App GUID til licens'
                ApplicationArea = All;
                Image = Delete;
                trigger OnAction()
                var
                    SetupGUID: Record "Setup GUID L365";
                begin
                    SetupGUID.Deleteall();
                end;

            }
        }
    }
}