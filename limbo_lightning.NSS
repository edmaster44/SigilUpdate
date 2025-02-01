#include "ff_safevar"

void main ()
{
	//Should this even been running?
	object oNearestPC = GetNearestCreature(1, 1);
	if (GetIsObjectValid(oNearestPC) == FALSE || GetArea(oNearestPC) != GetArea(OBJECT_SELF))
	{
		DestroyObject(OBJECT_SELF);
		return;
	}

	object oLight = GetNearestObjectByTag("lt_storm_limbo");
	object oThunder = GetNearestObjectByTag("sound_thunder");
	int myCount = PS_GetLocalInt(OBJECT_SELF, "myCount");
	int nRoll = d6();
	float nDec = ((d10())/5.0);
	if (myCount == nRoll)
	{
		SetLightActive(oLight, TRUE);
		DelayCommand(nDec, SoundObjectPlay(oThunder));
		DelayCommand((nDec+0.5), SetLightActive(oLight, FALSE));
		DelayCommand((nDec+3.0), SoundObjectStop(oThunder));
	}
	PS_SetLocalInt(OBJECT_SELF, "myCount", myCount+1);
	myCount = PS_GetLocalInt(OBJECT_SELF, "myCount");
	if (myCount > 6)
		PS_SetLocalInt(OBJECT_SELF, "myCount", 0);
		
//	SpeakString("LIGHTNING!", TALKVOLUME_SHOUT);
}