/**********************************************************
* Function created for SCOD server by Agony_Aunt/Loki_666 *
**********************************************************/

const float STEALING_CURSE_DURATION = 30.0;

void main()
{
	object oItem = GetModuleItemAcquired();
    object oPC = GetModuleItemAcquiredBy();

	// need to return object to chest?
	DestroyObject(oItem, 0.0);
		
	if (GetLocalInt(oPC, "BEEN_CAUGHT_STEALING") != TRUE)
	{
		SetLocalInt(oPC, "BEEN_CAUGHT_STEALING", TRUE);
		DelayCommand(STEALING_CURSE_DURATION, SetLocalInt(oPC, "BEEN_CAUGHT_STEALING", FALSE));
		DelayCommand(2.0, FloatingTextStringOnCreature("<color=red><b><i>THIEF!!!!", oPC, FALSE, STEALING_CURSE_DURATION));
		SendMessageToPC(oPC, "<color=red>The chest was warded! You have been affected by a spell of compulsion!");
		AssignCommand(oPC, SpeakString("<color=red><b><i>I am a dirty stinking thief!", TALKVOLUME_TALK));
	}
}