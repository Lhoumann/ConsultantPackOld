pageextension 71108 "CompanyInfoUPG" extends "Company Information"
{
    layout
    {
        addafter(General)
        {
            field(MasterCompany; MasterCompany)
            {
                ApplicationArea = All;
            }
        }

    }
}