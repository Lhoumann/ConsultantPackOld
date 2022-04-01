pageextension 71110 "ImportSetupExt" extends "Import Setup L365"
{
    layout
    {
        addafter("Auto Create Post Codes")
        {
            field("Auto Create Employee"; "Auto Create Employee")
            {
                ApplicationArea = All;
            }
        }
    }
}
