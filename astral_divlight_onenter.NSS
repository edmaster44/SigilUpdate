// Created by Agony_Aunt/Loki_666
// used for Astral Plane - Divinty Leech

void main()
{
	object oPC = GetEnteringObject();
	
	if (GetIsPC(oPC))
	{
		SendMessageToPC(oPC, "<COLOR=YELLOW><i>You are bathed in a Divine Light, your body seems to fill with energy!");
		
		object oNPC = GetObjectByTag("astral_leech_ghyris");
		AssignCommand(oNPC, SpeakString("You fool! Get out of there!", TALKVOLUME_TALK));
	}
}