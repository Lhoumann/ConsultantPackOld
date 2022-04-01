tableextension 71104 "ImportLogL365Ext" extends "ImportLog L365"
{
    fields
    {
        field(70101; "Entry Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Warning,Error;
            OptionCaption = 'Warning,Error'; //DAN = 'Advarsel,Fejl'
        }
        field(70102; "Date Type Validation"; Boolean)
        {
            DataClassification = CustomerContent;

        }

    }

}