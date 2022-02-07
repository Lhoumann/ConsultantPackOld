pageextension 71107 "Abakion Legal Import Log L365" extends "Importlog L365"
{
    actions
    {
        addafter("Importer kontaktposter")
        {
            action(ImportTimeL365)
            {
                ApplicationArea = All;
                Caption = 'Import Time Entries'; // DAN = 'Importer tidsposter';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                var
                    ImportTime: Codeunit "Import Time L365";

                begin
                    CLEAR(ImportTime);
                    ImportTime.run;
                end;
            }
        }
    }
}
