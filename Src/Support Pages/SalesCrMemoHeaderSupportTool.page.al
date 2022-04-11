page 71108 "SalesCrMemoHeaderSupportTool"
{
    Caption = 'Sales Cr.Memo Header';
    PageType = List;
    SourceTable = "Sales Cr.Memo Header";
    Permissions = tabledata "Sales Cr.Memo Header" = rm;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                    ApplicationArea = All;
                }
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Bill-to Customer No."; "Bill-to Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Bill-to Name"; "Bill-to Name")
                {
                    ApplicationArea = All;
                }
                field("Bill-to Name 2"; "Bill-to Name 2")
                {
                    ApplicationArea = All;
                }
                field("Bill-to Address"; "Bill-to Address")
                {
                    ApplicationArea = All;
                }
                field("Bill-to Address 2"; "Bill-to Address 2")
                {
                    ApplicationArea = All;
                }
                field("Bill-to City"; "Bill-to City")
                {
                    ApplicationArea = All;
                }
                field("Bill-to Contact"; "Bill-to Contact")
                {
                    ApplicationArea = All;
                }
                field("Your Reference"; "Your Reference")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Code"; "Ship-to Code")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Name"; "Ship-to Name")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Name 2"; "Ship-to Name 2")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Address"; "Ship-to Address")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Address 2"; "Ship-to Address 2")
                {
                    ApplicationArea = All;
                }
                field("Ship-to City"; "Ship-to City")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Contact"; "Ship-to Contact")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Shipment Date"; "Shipment Date")
                {
                    ApplicationArea = All;
                }
                field("Posting Description"; "Posting Description")
                {
                    ApplicationArea = All;
                }
                field("Payment Terms Code"; "Payment Terms Code")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; "Due Date")
                {
                    ApplicationArea = All;
                }
                field("Payment Discount %"; "Payment Discount %")
                {
                    ApplicationArea = All;
                }
                field("Pmt. Discount Date"; "Pmt. Discount Date")
                {
                    ApplicationArea = All;
                }
                field("Shipment Method Code"; "Shipment Method Code")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Customer Posting Group"; "Customer Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Currency Factor"; "Currency Factor")
                {
                    ApplicationArea = All;
                }
                field("Customer Price Group"; "Customer Price Group")
                {
                    ApplicationArea = All;
                }
                field("Prices Including VAT"; "Prices Including VAT")
                {
                    ApplicationArea = All;
                }
                field("Invoice Disc. Code"; "Invoice Disc. Code")
                {
                    ApplicationArea = All;
                }
                field("Customer Disc. Group"; "Customer Disc. Group")
                {
                    ApplicationArea = All;
                }
                field("Language Code"; "Language Code")
                {
                    ApplicationArea = All;
                }
                field("Salesperson Code"; "Salesperson Code")
                {
                    ApplicationArea = All;
                }
                field(Comment; Comment)
                {
                    ApplicationArea = All;
                }
                field("No. Printed"; "No. Printed")
                {
                    ApplicationArea = All;
                }
                field("On Hold"; "On Hold")
                {
                    ApplicationArea = All;
                }
                field("Applies-to Doc. Type"; "Applies-to Doc. Type")
                {
                    ApplicationArea = All;
                }
                field("Applies-to Doc. No."; "Applies-to Doc. No.")
                {
                    ApplicationArea = All;
                }
                field("Bal. Account No."; "Bal. Account No.")
                {
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                }
                field("Amount Including VAT"; "Amount Including VAT")
                {
                    ApplicationArea = All;
                }
                field("VAT Registration No."; "VAT Registration No.")
                {
                    ApplicationArea = All;
                }
                field("Reason Code"; "Reason Code")
                {
                    ApplicationArea = All;
                }
                field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("EU 3-Party Trade"; "EU 3-Party Trade")
                {
                    ApplicationArea = All;
                }
                field("Transaction Type"; "Transaction Type")
                {
                    ApplicationArea = All;
                }
                field("Transport Method"; "Transport Method")
                {
                    ApplicationArea = All;
                }
                field("VAT Country/Region Code"; "VAT Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field("Sell-to Customer Name"; "Sell-to Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Sell-to Customer Name 2"; "Sell-to Customer Name 2")
                {
                    ApplicationArea = All;
                }
                field("Sell-to Address"; "Sell-to Address")
                {
                    ApplicationArea = All;
                }
                field("Sell-to Address 2"; "Sell-to Address 2")
                {
                    ApplicationArea = All;
                }
                field("Sell-to City"; "Sell-to City")
                {
                    ApplicationArea = All;
                }
                field("Sell-to Contact"; "Sell-to Contact")
                {
                    ApplicationArea = All;
                }
                field("Bill-to Post Code"; "Bill-to Post Code")
                {
                    ApplicationArea = All;
                }
                field("Bill-to County"; "Bill-to County")
                {
                    ApplicationArea = All;
                }
                field("Bill-to Country/Region Code"; "Bill-to Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field("Sell-to Post Code"; "Sell-to Post Code")
                {
                    ApplicationArea = All;
                }
                field("Sell-to County"; "Sell-to County")
                {
                    ApplicationArea = All;
                }
                field("Sell-to Country/Region Code"; "Sell-to Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Post Code"; "Ship-to Post Code")
                {
                    ApplicationArea = All;
                }
                field("Ship-to County"; "Ship-to County")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Country/Region Code"; "Ship-to Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field("Bal. Account Type"; "Bal. Account Type")
                {
                    ApplicationArea = All;
                }
                field("Exit Point"; "Exit Point")
                {
                    ApplicationArea = All;
                }
                field(Correction; Correction)
                {
                    ApplicationArea = All;
                }
                field("Document Date"; "Document Date")
                {
                    ApplicationArea = All;
                }
                field("External Document No."; "External Document No.")
                {
                    ApplicationArea = All;
                }
                field("Area"; "Area")
                {
                    ApplicationArea = All;
                }
                field("Transaction Specification"; "Transaction Specification")
                {
                    ApplicationArea = All;
                }
                field("Payment Method Code"; "Payment Method Code")
                {
                    ApplicationArea = All;
                }
                field("Shipping Agent Code"; "Shipping Agent Code")
                {
                    ApplicationArea = All;
                }
                field("Package Tracking No."; "Package Tracking No.")
                {
                    ApplicationArea = All;
                }
                field("Pre-Assigned No. Series"; "Pre-Assigned No. Series")
                {
                    ApplicationArea = All;
                }
                field("No. Series"; "No. Series")
                {
                    ApplicationArea = All;
                }
                field("Pre-Assigned No."; "Pre-Assigned No.")
                {
                    ApplicationArea = All;
                }
                field("User ID"; "User ID")
                {
                    ApplicationArea = All;
                }
                field("Source Code"; "Source Code")
                {
                    ApplicationArea = All;
                }
                field("Tax Area Code"; "Tax Area Code")
                {
                    ApplicationArea = All;
                }
                field("Tax Liable"; "Tax Liable")
                {
                    ApplicationArea = All;
                }
                field("VAT Bus. Posting Group"; "VAT Bus. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("VAT Base Discount %"; "VAT Base Discount %")
                {
                    ApplicationArea = All;
                }
                field("Prepmt. Cr. Memo No. Series"; "Prepmt. Cr. Memo No. Series")
                {
                    ApplicationArea = All;
                }
                field("Prepayment Credit Memo"; "Prepayment Credit Memo")
                {
                    ApplicationArea = All;
                }
                field("Prepayment Order No."; "Prepayment Order No.")
                {
                    ApplicationArea = All;
                }
                field("Sell-to Phone No."; "Sell-to Phone No.")
                {
                    ApplicationArea = All;
                }
                field("Sell-to E-Mail"; "Sell-to E-Mail")
                {
                    ApplicationArea = All;
                }
                field("Work Description"; "Work Description")
                {
                    ApplicationArea = All;
                }
                field("Dimension Set ID"; "Dimension Set ID")
                {
                    ApplicationArea = All;
                }
                field("Document Exchange Identifier"; "Document Exchange Identifier")
                {
                    ApplicationArea = All;
                }
                field("Document Exchange Status"; "Document Exchange Status")
                {
                    ApplicationArea = All;
                }
                field("Doc. Exch. Original Identifier"; "Doc. Exch. Original Identifier")
                {
                    ApplicationArea = All;
                }
                field(Paid; Paid)
                {
                    ApplicationArea = All;
                }
                field("Remaining Amount"; "Remaining Amount")
                {
                    ApplicationArea = All;
                }
                field("Cust. Ledger Entry No."; "Cust. Ledger Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Invoice Discount Amount"; "Invoice Discount Amount")
                {
                    ApplicationArea = All;
                }
                field(Cancelled; Cancelled)
                {
                    ApplicationArea = All;
                }
                field(Corrective; Corrective)
                {
                    ApplicationArea = All;
                }
                field("Campaign No."; "Campaign No.")
                {
                    ApplicationArea = All;
                }
                field("Sell-to Contact No."; "Sell-to Contact No.")
                {
                    ApplicationArea = All;
                }
                field("Bill-to Contact No."; "Bill-to Contact No.")
                {
                    ApplicationArea = All;
                }
                field("Opportunity No."; "Opportunity No.")
                {
                    ApplicationArea = All;
                }
                field("Responsibility Center"; "Responsibility Center")
                {
                    ApplicationArea = All;
                }
                field("Shipping Agent Service Code"; "Shipping Agent Service Code")
                {
                    ApplicationArea = All;
                }
                field("Return Order No."; "Return Order No.")
                {
                    ApplicationArea = All;
                }
                field("Return Order No. Series"; "Return Order No. Series")
                {
                    ApplicationArea = All;
                }
                field("Price Calculation Method"; "Price Calculation Method")
                {
                    ApplicationArea = All;
                }
                field("Allow Line Disc."; "Allow Line Disc.")
                {
                    ApplicationArea = All;
                }
                field("Get Return Receipt Used"; "Get Return Receipt Used")
                {
                    ApplicationArea = All;
                }
                field(Id; Id)
                {
                    ApplicationArea = All;
                }
                field("Draft Cr. Memo SystemId"; "Draft Cr. Memo SystemId")
                {
                    ApplicationArea = All;
                }
                field("Invoice Period Filter L365"; "Invoice Period Filter L365")
                {
                    ApplicationArea = All;
                }
                field("Pay-to Bank Account Info L365"; "Pay-to Bank Account Info L365")
                {
                    ApplicationArea = All;
                }
                field("External Invoice Period L365"; "External Invoice Period L365")
                {
                    ApplicationArea = All;
                }
                field("Created By L365"; "Created By L365")
                {
                    ApplicationArea = All;
                }
                field("Job No. L365"; "Job No. L365")
                {
                    ApplicationArea = All;
                }
                field("Reversed By L365"; "Reversed By L365")
                {
                    ApplicationArea = All;
                }
                field("Foreign VAT No. L365"; "Foreign VAT No. L365")
                {
                    ApplicationArea = All;
                }
                field("Posted Settlement No. L365"; "Posted Settlement No. L365")
                {
                    ApplicationArea = All;
                }
                field("Allocation No. L365"; "Allocation No. L365")
                {
                    ApplicationArea = All;
                }
                field("Sell-to Address 3 L365"; "Sell-to Address 3 L365")
                {
                    ApplicationArea = All;
                }
                field("Bill-to Address 3 L365"; "Bill-to Address 3 L365")
                {
                    ApplicationArea = All;
                }
                field("Bill-to Contact Phone No. L365"; "Bill-to Contact Phone No. L365")
                {
                    ApplicationArea = All;
                }
                field("Bill-to Contact E-Mail L365"; "Bill-to Contact E-Mail L365")
                {
                    ApplicationArea = All;
                }
                field("PDF Created L365"; "PDF Created L365")
                {
                    ApplicationArea = All;
                }
                field("PDF Creation Time L365"; "PDF Creation Time L365")
                {
                    ApplicationArea = All;
                }
                field("Document Delivery Method L365"; "Document Delivery Method L365")
                {
                    ApplicationArea = All;
                }
                field("Global Relation 1 Code L365"; "Global Relation 1 Code L365")
                {
                    ApplicationArea = All;
                }
                field("Global Relation 2 Code L365"; "Global Relation 2 Code L365")
                {
                    ApplicationArea = All;
                }
                field("Global Relation 3 Code L365"; "Global Relation 3 Code L365")
                {
                    ApplicationArea = All;
                }
                field("Last Sent L365"; "Last Sent L365")
                {
                    ApplicationArea = All;
                }
                field("Last Internal Mail Sent L365"; "Last Internal Mail Sent L365")
                {
                    ApplicationArea = All;
                }
                field("Extended Reference L365"; "Extended Reference L365")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}