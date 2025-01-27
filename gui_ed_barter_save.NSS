void main()
{
    object oPC = OBJECT_SELF;
    if(!GetIsObjectValid(oPC) || GetIsDM(oPC) || GetLocalInt(oPC,"LastSaved") == 1) return;
    SendMessageToPC(oPC,"Saving your character post barter . . .");
    DelayCommand(3.0f,ExportSingleCharacter(oPC));
    
    SetLocalInt(oPC,"LastSaved",1);
    DelayCommand(5.0f,DeleteLocalInt(oPC,"LastSaved"));
}