pageextension 71101 "Import Log L365" extends "Importlog L365"
{
    actions
    {
        modify("Importer klienter")
        {
            Visible = false;
        }
        addafter("Importer klienter")
        {
            action(ImportClientExcelL365)
            {
                ApplicationArea = All;
                Caption = 'Import Clients'; // DAN = Importer klienter';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                var
                    ImportClients: Codeunit "Import Clients L365";

                begin
                    CLEAR(ImportClients);
                    ImportClients.RUN;
                end;
            }
        }
        modify("Importer sager")
        {
            Visible = false;
        }
        addafter("Importer sager")
        {
            action(ImportMatterExcelL365)
            {
                ApplicationArea = All;
                Caption = 'Import Matters'; // DAN = Importer sager';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                var
                    ImportMatters: Codeunit "Import Matters L365";

                begin
                    CLEAR(ImportMatters);
                    ImportMatters.RUN;
                end;
            }
        }
    }
}