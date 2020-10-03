void main()
{
	object oPC = GetPCSpeaker();
	SendMessageToPC(oPC, "launching appearance changer");
	
	DisplayGuiScreen(oPC,"SCREEN_APPEARENCE_CHANGER", FALSE, "appearence_changer.xml");
}