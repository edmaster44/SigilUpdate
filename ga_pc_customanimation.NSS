#include "ginc_param_const"

void PlayCustomAnimationWrapper(object oTarget, string sAnim, int bLoop)	//so it returns a void
{
	PlayCustomAnimation(oTarget,sAnim,bLoop);
}

void main(string sAnim, int bLoop=0, float fDelayUntilStart=0.0f)
{
	object oTarget = GetPCSpeaker();
	
	if (GetIsObjectValid(oTarget))
	{
		if (fDelayUntilStart==0.0f)
			PlayCustomAnimation(oTarget,sAnim,bLoop);
		else
			DelayCommand(fDelayUntilStart,PlayCustomAnimationWrapper(oTarget,sAnim,bLoop));//place the delaycommand on the creature as well
	}
}