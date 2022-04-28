codeunit 71115 "UpgradeCodeunits"
{
    Permissions = tabledata "Sales Invoice Line" = rimd,
                  tabledata "Sales Cr.Memo Line" = rimd;
    procedure PerformUpgradeA3111010()
    var
        InvSuggSummaryLineL365: Record "Inv. Sugg. Summary Line L365";
        InvAllocSummaryLineL365: Record "Inv. Alloc. Summary Line L365";
        ArchAllocSummaryLineL365: Record "Arch. Alloc. Summary Line L365";
        ArchivedAllocSumLineL365: Record "Archived Alloc. Sum. Line L365";
        UpgradeTag: Codeunit "Upgrade Tag";
        ReasonLbl: Label 'CompanyName-Reason-20211214', Locked = true;

    begin
        if InvSuggSummaryLineL365.FindSet() then begin
            repeat
                InvAllocSummaryLineL365.TransferFields(InvSuggSummaryLineL365, true);
                InvAllocSummaryLineL365."Job Task No." := '10';
                if InvAllocSummaryLineL365.Insert() then;
            until InvSuggSummaryLineL365.Next() = 0;
            InvSuggSummaryLineL365.Deleteall();
        end;
        if ArchAllocSummaryLineL365.FindSet() then begin
            repeat
                ArchivedAllocSumLineL365.TransferFields(ArchAllocSummaryLineL365, true);
                ArchivedAllocSumLineL365."Job Task No." := '10';
                if not ArchAllocSummaryLineL365.Combine then begin
                    ArchivedAllocSumLineL365."Job Task Sub Page Filter" := '10';
                end;

                if ArchivedAllocSumLineL365.Insert() then;
            until ArchAllocSummaryLineL365.next = 0;
            ArchAllocSummaryLineL365.DeleteAll();

        end;
        //tmp test mowe
        if ArchivedAllocSumLineL365.FindSet() then begin
            repeat
                if not ArchivedAllocSumLineL365.Combine then begin
                    ArchivedAllocSumLineL365."Job Sub Page Filter" := ArchivedAllocSumLineL365."Job No.";
                    ArchivedAllocSumLineL365."Job Task Sub Page Filter" := '10';
                    ArchivedAllocSumLineL365.Modify();
                end;
            until ArchivedAllocSumLineL365.next = 0;
            //todo remove above
        end;

        if not UpgradeTag.HasUpgradeTag(ReasonLbl) then
            UpgradeTag.SetUpgradeTag(ReasonLbl);
    end;

    procedure PerformUpgradeA3111056()
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        SalesLine: Record "Sales Line";
        UpgradeTag: Codeunit "Upgrade Tag";
        ReasonLbl: Label 'LineType Added', Locked = true;

    begin
        if SalesLine.FindSet() then begin
            repeat
                if SalesLine."Allocation No. L365" <> '' then
                    SalesLine."Line Type L365" := SalesLine."Line Type L365"::Fee;
                if SalesLine."Disburs. Applies-to ID L365" <> '' then
                    SalesLine."Line Type L365" := Salesline."Line Type L365"::Disbursement;
                if SalesLine."Amount Information L365" <> 0 then
                    SalesLine."Line Type L365" := SalesLine."Line Type L365"::Payment;
                SalesLine.Modify();
            until SalesLine.Next() = 0;
        end;
        SalesInvoiceLine.reset;
        SalesInvoiceLine.SetFilter("Allocation No. L365", '<>%1', '');
        SalesInvoiceLine.ModifyAll("Line Type L365", SalesInvoiceLine."Line Type L365"::Fee);
        SalesInvoiceLine.reset;
        SalesInvoiceLine.SetFilter("Disburs. Applies-to ID L365", '<>%1', '');
        SalesInvoiceLine.ModifyAll("Line Type L365", SalesInvoiceLine."Line Type L365"::Disbursement);
        SalesInvoiceLine.reset;
        SalesInvoiceLine.setrange(Type, SalesInvoiceLine.Type::" ");
        SalesInvoiceLine.Setfilter("Amount information L365", '<>0');
        SalesInvoiceLine.ModifyAll("Line Type L365", SalesInvoiceLine."Line Type L365"::Payment);
        SalesInvoiceLine.setrange(Type, SalesInvoiceLine.Type::" ");
        SalesInvoiceLine.Setfilter("Amount information L365", '0');
        SalesInvoiceLine.ModifyAll("Line Type L365", SalesInvoiceLine."Line Type L365"::Comment);

        SalesCrMemoLine.reset;
        SalesCrMemoLine.Setfilter("Allocation No. L365", '<>%1', '');
        SalesCrMemoLine.ModifyAll("Line Type L365", SalesInvoiceLine."Line Type L365"::Fee);
        SalesCrMemoLine.reset;
        SalesCrMemoLine.Setfilter("Disburs. Applies-to ID L365", '<>%1', '');
        SalesCrMemoLine.ModifyAll("Line Type L365", SalesInvoiceLine."Line Type L365"::Disbursement);
        SalesCrMemoLine.reset;
        SalesCrMemoLine.Setfilter("Amount information L365", '<>0');
        SalesCrMemoLine.ModifyAll("Line Type L365", SalesInvoiceLine."Line Type L365"::Payment);
        SalesCrMemoLine.reset;
        SalesCrMemoLine.SetRange(Type, SalesCrMemoLine.Type::" ");
        SalesCrMemoLine.Setfilter("Amount information L365", '0');
        SalesCrMemoLine.ModifyAll("Line Type L365", SalesInvoiceLine."Line Type L365"::Comment);

        if not UpgradeTag.HasUpgradeTag(ReasonLbl) then
            UpgradeTag.SetUpgradeTag(ReasonLbl);
    end;

    procedure PerformUpgradeA3111233()
    var
        ToDo: Record "To-do";
        ToDoL365: Record "To-do L365";
        ReasonLbl: Label 'To-do replacement', Locked = true;
        UpgradeTag: Codeunit "Upgrade Tag";

    begin
        if ToDo.findset() then
            repeat
                clear(ToDoL365);
                ToDoL365.TransferFields(ToDo);
                ToDoL365.Insert();
            until ToDo.next() = 0;

        if not UpgradeTag.HasUpgradeTag(ReasonLbl) then
            UpgradeTag.SetUpgradeTag(ReasonLbl);
    end;

    procedure PerformUpgradeA3111260()
    var
        ArchivedAllocLine: Record "Archived Alloc. Line L365";
        SalesInvoiceLine: Record "Sales Invoice Line";
        InvoicingSetup: Record "Invoicing Setup L365";
        LSetup: Record "AbakionLegal Setup L365";
        GLsetup: Record "General Ledger Setup";
        tempDimensionSetEntry: Record "Dimension Set Entry" temporary;
        DimensionSetEntry2: Record "Dimension Set Entry";
        DimensionManagement: Codeunit DimensionManagement;
        DimensionManagementL365: Codeunit "Dimension Management L365";
        NewDimSetID: Integer;
        Resource: Record Resource;
        DefaultDimension: Record "Default Dimension";
        UpgradeTag: Codeunit "Upgrade Tag";
        ReasonLbl: Label 'Update Employee Dim On Allocations', Locked = true;

    begin
        //Enable Allocation by EmployeeDim
        if not InvoicingSetup.get then
            exit;

        if not LSetup.get then
            exit;

        if not GLsetup.get then
            exit;

        if LSetup."Employee Dimension" <> '' then begin
            case LSetup."Employee Dimension" of
                glsetup."Global Dimension 2 Code":
                    begin
                        InvoicingSetup."Fee Alloc. By Dimension 2" := true;
                    end;
                GLsetup."Shortcut Dimension 3 Code":
                    begin
                        InvoicingSetup."Fee Alloc. By Dimension 3" := true;
                    end;
                GLSetup."Shortcut Dimension 4 Code":
                    begin
                        InvoicingSetup."Fee Alloc. By Dimension 4" := true;
                    end;
                GLSetup."Shortcut Dimension 5 Code":
                    begin
                        InvoicingSetup."Fee Alloc. By Dimension 5" := true;
                    end;
                GLSetup."Shortcut Dimension 6 Code":
                    begin
                        InvoicingSetup."Fee Alloc. By Dimension 6" := true;
                    end;
                GLSetup."Shortcut Dimension 7 Code":
                    begin
                        InvoicingSetup."Fee Alloc. By Dimension 7" := true;
                    end;
                GLSetup."Shortcut Dimension 8 Code":
                    begin
                        InvoicingSetup."Fee Alloc. By Dimension 8" := true;
                    end;
            end;
            InvoicingSetup.Modify();
        end;
        //Update Archived Allocations DimSetID, to use EmployeeDim and other defaults dims from resource
        if ArchivedAllocLine.FindSet() then begin
            repeat
                //Add Res.no as dim
                DimensionManagement.GetDimensionSet(tempDimensionSetEntry, ArchivedAllocLine."Dimension Set ID");
                tempDimensionSetEntry."Dimension Code" := LSetup."Employee Dimension";
                tempDimensionSetEntry.Validate("Dimension Value Code", ArchivedAllocLine."Resource No.");
                if tempDimensionSetEntry.insert then;
                //Add Dimensions from SalesInvoiceLine for Resource as Dim (Only Dim codes from Default Dimensions are considered)
                DefaultDimension.SetRange("Table ID", Database::Resource);
                DefaultDimension.SetRange("No.", ArchivedAllocLine."Resource No.");
                if DefaultDimension.FindSet() then begin
                    repeat
                        tempDimensionSetEntry."Dimension Code" := DefaultDimension."Dimension Code";
                        SalesInvoiceLine.SetRange("Allocation No. L365", ArchivedAllocLine."Allocation No.");
                        SalesInvoiceLine.SetRange("No.", ArchivedAllocLine."Resource No.");
                        if SalesInvoiceLine.FindLast() then begin
                            DimensionSetEntry2.SetRange("Dimension Set ID", SalesInvoiceLine."Dimension Set ID");
                            DimensionSetEntry2.SetRange("Dimension Code", DefaultDimension."Dimension Code");
                            if DimensionSetEntry2.FindFirst() then begin
                                tempDimensionSetEntry.Validate("Dimension Value Code", DefaultDimension."Dimension Value Code");
                                if tempDimensionSetEntry.insert then;
                            end;
                        end;
                    until DefaultDimension.Next() = 0;
                end;

                NewDimSetID := DimensionManagement.GetDimensionSetID(tempDimensionSetEntry);
                if NewDimSetID <> ArchivedAllocLine."Dimension Set ID" then begin
                    ArchivedAllocLine."Dimension Set ID" := NewDimSetID;
                    DimensionManagementL365.UpdateGlobalDimFromDimSetIDExt(ArchivedAllocLine."Dimension Set ID", ArchivedAllocLine."Shortcut Dimension 1 Code",
                                                                        ArchivedAllocLine."Shortcut Dimension 2 Code", ArchivedAllocLine."Global Dimension 3 Code", ArchivedAllocLine."Global Dimension 4 Code",
                                                                        ArchivedAllocLine."Global Dimension 5 Code", ArchivedAllocLine."Global Dimension 6 Code",
                                                                        ArchivedAllocLine."Global Dimension 7 Code", ArchivedAllocLine."Global Dimension 8 Code");
                    ArchivedAllocLine.Modify();
                end;
            until ArchivedAllocLine.Next() = 0;
        end;

        if not UpgradeTag.HasUpgradeTag(ReasonLbl) then
            UpgradeTag.SetUpgradeTag(ReasonLbl);
    end;

    procedure PerformUpgradeVP0059584()
    var
        Cont: Record Contact;
        ContactRelation: Record "Contact Relation L365";
        AbakionLegalSetup: Record "AbakionLegal Setup L365";
        ReasonLbl: Label 'Update Split percentages', Locked = true;
        UpgradeTag: Codeunit "Upgrade Tag";

    begin
        if not AbakionLegalSetup.get then
            exit;

        Cont.SetFilter("Contact Type L365", '%1|%2', AbakionLegalSetup."Job Contact Type", AbakionLegalSetup."Archive Job Contact Type");
        if Cont.FindSet() then begin
            repeat
                ContactRelation.SetRange("Contact 1", cont."No.");
                ContactRelation.SetRange("Relation Code", AbakionLegalSetup."Relation Type - Invoice Rec.");
                if ContactRelation.FindFirst() then begin
                    ContactRelation."Salary Split Percent" := 100;
                    ContactRelation."Disburs. Split Percent" := 100;
                    ContactRelation.Modify();

                    ContactRelation.SetRange("Relation Code", AbakionLegalSetup."Client Contact Type");
                    if ContactRelation.FindFirst() then begin
                        ContactRelation."Salary Split Percent" := 0;
                        ContactRelation."Disburs. Split Percent" := 0;
                        ContactRelation.Modify();
                    end;
                end else begin
                    ContactRelation.SetRange("Relation Code", AbakionLegalSetup."Client Contact Type");
                    if ContactRelation.FindFirst() then begin
                        ContactRelation."Salary Split Percent" := 100;
                        ContactRelation."Disburs. Split Percent" := 100;
                        ContactRelation.Modify();
                    end;
                end;
            until cont.Next() = 0;
        end;
        if not UpgradeTag.HasUpgradeTag(ReasonLbl) then
            UpgradeTag.SetUpgradeTag(ReasonLbl);
    end;

    procedure PerformUpgradeSummaryCode()
    var
        ReasonLbl: Label 'Update SummaryCodes', Locked = true;
        UpgradeTag: Codeunit "Upgrade Tag";
        SummaryCode: Record "Summary Code L365";
    begin
        if SummaryCode.FindSet() then begin
            repeat
                if SummaryCode.Fee then
                    SummaryCode."Line Type" := SummaryCode."Line Type"::Fee;
                if SummaryCode."Disburs.VAT Prod. Posting Grp." <> '' then
                    SummaryCode."Line Type" := SummaryCode."Line Type"::Disbursement;
                if SummaryCode."Payment Default" then
                    SummaryCode."Line Type" := SummaryCode."Line Type"::Payment;
                if (not SummaryCode.Fee) and (SummaryCode."Disburs.VAT Prod. Posting Grp." = '') and (not SummaryCode."Payment Default") then
                    SummaryCode."Line Type" := SummaryCode."Line Type"::Comment;
                SummaryCode.Modify()
            until SummaryCode.Next() = 0;
        end;
        if not UpgradeTag.HasUpgradeTag(ReasonLbl) then
            UpgradeTag.SetUpgradeTag(ReasonLbl);
    end;

}