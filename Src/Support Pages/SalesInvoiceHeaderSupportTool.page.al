page 71106 "SalesInvoiceHeaderSupportTool"
{
    Caption = 'Sales Invoice Header';
    PageType = List;
    SourceTable = "Sales Invoice Header";
    Permissions = tabledata "Sales Invoice Header" = rm;

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
                field("Order Date"; "Order Date")
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
                field("Order No."; "Order No.")
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
                field("Sell-to Post Code"; "Sell-to Post Code")
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
                field("Order No. Series"; "Order No. Series")
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
                field("Invoice Discount Calculation"; "Invoice Discount Calculation")
                {
                    ApplicationArea = All;
                }
                field("Invoice Discount Value"; "Invoice Discount Value")
                {
                    ApplicationArea = All;
                }
                field("Prepayment No. Series"; "Prepayment No. Series")
                {
                    ApplicationArea = All;
                }
                field("Prepayment Invoice"; "Prepayment Invoice")
                {
                    ApplicationArea = All;
                }
                field("Prepayment Order No."; "Prepayment Order No.")
                {
                    ApplicationArea = All;
                }
                field("Quote No."; "Quote No.")
                {
                    ApplicationArea = All;
                }
                field("Last Email Sent Time"; "Last Email Sent Time")
                {
                    ApplicationArea = All;
                }
                field("Last Email Sent Status"; "Last Email Sent Status")
                {
                    ApplicationArea = All;
                }
                field("Sent as Email"; "Sent as Email")
                {
                    ApplicationArea = All;
                }
                field("Last Email Notif Cleared"; "Last Email Notif Cleared")
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
                field("Payment Instructions"; "Payment Instructions")
                {
                    ApplicationArea = All;
                }
                field("Payment Instructions Name"; "Payment Instructions Name")
                {
                    ApplicationArea = All;
                }
                field("Payment Reference"; "Payment Reference")
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
                field("Payment Service Set ID"; "Payment Service Set ID")
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
                field("Coupled to CRM"; "Coupled to CRM")
                {
                    ApplicationArea = All;
                }
                field("Direct Debit Mandate ID"; "Direct Debit Mandate ID")
                {
                    ApplicationArea = All;
                }
                field(Closed; Closed)
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
                field(Reversed; Reversed)
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
                field("Price Calculation Method"; "Price Calculation Method")
                {
                    ApplicationArea = All;
                }
                field("Allow Line Disc."; "Allow Line Disc.")
                {
                    ApplicationArea = All;
                }
                field("Get Shipment Used"; "Get Shipment Used")
                {
                    ApplicationArea = All;
                }
                field(Id; Id)
                {
                    ApplicationArea = All;
                }
                field("Draft Invoice SystemId"; "Draft Invoice SystemId")
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
                field(ReversedL365; ReversedL365)
                {
                    ApplicationArea = All;
                }
                field("Copy of Invoice No. L365"; "Copy of Invoice No. L365")
                {
                    ApplicationArea = All;
                }
                field("Invoice Status L365"; "Invoice Status L365")
                {
                    ApplicationArea = All;
                }
                field("Total Fee L365"; "Total Fee L365")
                {
                    ApplicationArea = All;
                }
                field("Total Disbursment Amount L365"; "Total Disbursment Amount L365")
                {
                    ApplicationArea = All;
                }
                field("Foreign VAT No. L365"; "Foreign VAT No. L365")
                {
                    ApplicationArea = All;
                }
                field("Rent Contract No. L365"; "Rent Contract No. L365")
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
                field("Account Invoice L365"; "Account Invoice L365")
                {
                    ApplicationArea = All;
                }
                field("Acc. Inv. Allocation No. L365"; "Acc. Inv. Allocation No. L365")
                {
                    ApplicationArea = All;
                }
                field("Account Invoice Settled L365"; "Account Invoice Settled L365")
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
                field("Disbursment Period Filter L365"; "Disbursment Period Filter L365")
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
                field("No. Of Bundles Sent L365"; "No. Of Bundles Sent L365")
                {
                    ApplicationArea = All;
                }
                field("Document Delivery Method L365"; "Document Delivery Method L365")
                {
                    ApplicationArea = All;
                }
                field("IC Invoice L365"; "IC Invoice L365")
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