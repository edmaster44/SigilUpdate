#include "ff_safevar"

// KEMO 2/09 --- called from KEMO_ANIM GUI

#include "kemo_includes"

void main(int bFull)
{
	object oPC = OBJECT_SELF;
	string sAnim = PS_GetLocalString(oPC,"StoredAnimation");
	string sAnimB = PS_GetLocalString(oPC,"StoredAnimationIdle");
	float fDelay = PS_GetLocalFloat(oPC,"StoredDelay");
	PS_SetLocalLocation(oPC,"AnimationLocation",GetLocation(oPC));
	
	if (!bFull)
	{
		AnimationLoop(oPC,GetLocation(oPC));
	}
	else
	{
		PlayKemoAnimation(oPC,sAnim);
		DelayCommand(fDelay,AnimationLoop(oPC,GetLocation(oPC)));
	}
}