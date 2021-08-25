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
        addlast(Creation)
        {
            action(CloseRemCLE)
            {
                ApplicationArea = All;
                Caption = 'Close Remaining CLEs'; // DAN = 'Luk restbeløb'
                Image = Tools;
                RunObject = Report "Close Remaining CLEs2 L365";

            }
            action(FixContactBusRel)
            {
                ApplicationArea = All;
                Caption = 'Fix converted contact busines relations';
                Image = Tools;

                trigger OnAction()
                var
                    ContactBusinessRelation: Record "Contact Business Relation";

                begin
                    ContactBusinessRelation.SetRange("Link to Table", "Contact Business Relation Link To Table"::Employee);
                    ContactBusinessRelation.DeleteAll();
                end;

            }
        }
    }
}