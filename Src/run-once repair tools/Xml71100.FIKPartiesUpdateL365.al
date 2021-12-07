/// <summary>
/// Creaded by CSO 2021-12-07 for Jira #A202-44
/// This XML Port is built to fix one specific Advo+ migration error, and to be used only once.
///  
/// </summary>
xmlport 71100 "FIK Parties update L365"
{
    Direction = Import;
    Format = VariableText;
    FieldSeparator = ';';
    TextEncoding = UTF8;

    Caption = 'FIK Parties update L365';
    schema
    {
        textelement(RootNodeName)
        {
            tableelement(PaymentId; "Payment ID L365")
            {
                AutoSave = false;
                AutoUpdate = false;
                AutoReplace = false;
                textelement(ImportedJobNo)
                {
                }
                textelement(ImportedPaymentId)
                {
                }
                textelement(ImportedInvoiceNo)
                {
                }
                textelement(ImportedType)
                {
                }
                textelement(ImportedNumber)
                {
                }
                textelement(ImportedPaymentIdSQL)
                {
                }
                textelement(ImportedTextCode)
                {
                }
                textelement(ImportedPostingText)
                {
                }
                textelement(ImportedFIKId)
                {
                }

                trigger OnAfterInitRecord()
                begin

                end;

                trigger OnBeforeInsertRecord()
                begin
                    LineCount += 1;
                    Case ImportedType of
                        'Type':
                            ; // Header so do nothing
                        'Part':
                            begin
                                PaymentId.SetRange("FIK-ID", ImportedFIKId);
                                PaymentId.FindFirst();
                                PaymentId."Job No." := ImportedJobNo;
                                PaymentId."Party No." := 'P' + ImportedNumber;
                                PaymentId.Modify();
                                UpdateCount += 1;
                            end;
                        else
                            SkipCount += 1;
                    end;

                end;

                trigger OnBeforeModifyRecord()
                begin

                end;

            }
        }
    }


    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }


    var
        LineCount: Integer;
        UpdateCount: Integer;
        SkipCount: Integer;

    trigger OnPostXmlPort()
    begin
        Message('Imported %1 lines including header. Updated %2 PaymentIds. Skipped %3 lines', LineCount, UpdateCount, SkipCount);
    end;

}
