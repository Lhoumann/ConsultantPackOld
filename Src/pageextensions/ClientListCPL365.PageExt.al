pageextension 71111 "Client List CP L365" extends "Client List L365"
{
    actions
    {
        addlast(reporting)
        {
            action(ClientReminderListCPL365)
            {
                Caption = 'Client/Reminderlist'; // DAN = 'Klient/rykkerliste'
                ApplicationArea = All;
                Image = Reminder;
                RunObject = report "Client/Reminder List L365";
            }
        }
    }
}