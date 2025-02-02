#include "ff_safevar"

#include "ServerExts"

const float ANIM_EPSILON = 0.0001f;

void Animation_Debug(object oPC, string Text)
{
	SendMessageToPC(oPC,"Animation_Debug: " + Text);
}

void PlayKemoAnimation(object oTarget, string sAnim)	//so it returns a void
{
	PlayCustomAnimation(oTarget,sAnim,1);
}

void Animation_SendPositionUpdates(object PCObject, object Area, vector Position)
{
	object Player;

	Player = GetFirstPC();
	while (Player != OBJECT_INVALID)
	{
		if ((GetArea(Player) == Area) &&
		    (GetScriptHidden(Player) == FALSE))
		{
//			Animation_Debug(PCObject,"Send initial position for " + GetName(PCObject) + " to " + GetName(Player));
			ServerExts_SendObjectDisplayPositionUpdate(Player, PCObject, Position);
		}

		Player = GetNextPC();
	}
}

void main(int adjust)
{
	//	PS_SetLocalString(OBJECT_SELF,"StoredAnimation",sAnim); // stores the animation name for re-triggering
	//	PS_SetLocalFloat(OBJECT_SELF,"StoredDelay",fDelay); // stores the delay for re-triggering
	//	object oPoint = PS_GetLocalObject(oPC,"AnimationPoint");
	//	string sAnim = PS_GetLocalString(oPC,"StoredAnimationIdle");
	//	PS_SetLocalLocation(oTarget,"AnimationLocation",GetLocation(oTarget));
	
	//	PS_SetLocalFloat(PCObject, ANIM_HEIGHT, HeightAdjustment);
	//	PS_SetLocalLocation(PCObject, ANIM_ORIGIN_POSITION, GetLocation(PCObject));
	//	PS_SetLocalString(PCObject, ANIM_NAME, AnimationName);
	//	PS_SetLocalInt(PCObject, ANIM_LOOP, AnimationLoop);

	object oPC = OBJECT_SELF;
	string AnimationName = PS_GetLocalString(oPC,"StoredAnimation");
	vector Position = GetPosition(oPC);
	object Area = GetArea(oPC);
	
	float HeightAdjustment;
	
	if(adjust == 0) HeightAdjustment = 0.01;
	else HeightAdjustment = adjust * 0.10;

//	Animation_Debug(oPC, "Playing animation " + AnimationName + " for creature " + GetName(oPC));
	if (fabs(HeightAdjustment) > ANIM_EPSILON)
	{
		Position.z += HeightAdjustment;
		Animation_SendPositionUpdates(oPC, Area, Position);
		//PlayKemoAnimation(oPC,AnimationName);
//		Animation_Debug(oPC,"Sending height adjustment of " + FloatToString(HeightAdjustment));
	}

	int fAnim = PS_GetLocalInt(Area,"FloatAnimation");

	PS_SetLocalInt(Area,"FloatAnimation",fAnim-1);
	if(fAnim < 0) fAnim = 0;		
	PS_SetLocalInt(Area,"FloatAnimation",fAnim+1);
	object oPoint = PS_GetLocalObject(oPC,"AnimationPoint");
	if (oPoint != OBJECT_INVALID)
	{
		//SendMessageToPC(oPC,"Setting floating variable to: "+FloatToString(HeightAdjustment));
		PS_SetLocalFloat(oPoint,"AnimAdjust",HeightAdjustment);
	}
	
//	if(FindSubString(PS_GetLocalString(oPC,"StoredAnimationIdle"),"idle") > -1) PlayCustomAnimation(oPC, AnimationName, 1);
//	else PlayCustomAnimation(oPC, AnimationName, 0);
}