// kemo_animation
// 7/13/08 modified by KEMO for Custom Animations; called by conversation through gui_hss_pc_tool
// 2/09 now called by KEMO_ANIM GUI

#include "ginc_param_const"
#include "kemo_includes"

/*void main(string sAnimA, int iFrames, int iNoLoop)
{
	object oTarget = OBJECT_SELF;
	float fFrames = IntToFloat(iFrames); // frames of first animation (usually between 60 and 120)
	float fFramerate = 1.0/30.0;
	float fDelayUntilStart = fFrames*fFramerate; // duration of first anim based on frames

	fDelayUntilStart = fDelayUntilStart * RacialDelay(oTarget);
	
	string sAnimB = "kemo_" + sAnimA;
	string sAnimC = sAnimB + "i";

	if (iNoLoop) sAnimC = "idle"; // if this is a fireandforget animation, break the loop
								  // with an idle instead of animation #2

	StoreAnimation(sAnimB,fDelayUntilStart);
	StoreIdle(sAnimC);
	SetLocalLocation(oTarget,"AnimationLocation",GetLocation(oTarget));

	PlayKemoAnimation(oTarget,sAnimB); // fires the transitional animation
		// a graphical bug causes some races to lose their eyes and lips on a non-looping animation,
		// so this uses a loop on animation #1, which must be ~30 frames longer than the frame count ---
		// this prevents the "jump" between animations, and may help counteract possible server lag
		// issues
	DelayCommand(fDelayUntilStart,AnimationLoop(oTarget,GetLocation(oTarget))); // fires the looping idle animation
}*/

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

void main(string sAnimA, int iFrames, int iNoLoop)
{
	object oTarget = OBJECT_SELF;

	if(GetIsDM(OBJECT_SELF))
	{
	oTarget = GetPlayerCurrentTarget(OBJECT_SELF);
	if (oTarget == OBJECT_INVALID) oTarget = OBJECT_SELF;
	}
	
	float fFrames = IntToFloat(iFrames); // frames of first animation (usually between 60 and 120)
	float fFramerate = 1.0/30.0;
	float fDelayUntilStart = fFrames*fFramerate; // duration of first anim based on frames

	fDelayUntilStart = fDelayUntilStart * RacialDelay(oTarget);
	
	string sAnimB = "kemo_" + sAnimA;
	string sAnimC = sAnimB + "i";
	
	if(sAnimA == "smoking")
	{sAnimB = "smoking";sAnimC = "smoking"; iNoLoop = 0;}
	
	if (iNoLoop) sAnimC = "idle"; // if this is a fireandforget animation, break the loop
								  // with an idle instead of animation #2

	StoreAnimation(sAnimB,fDelayUntilStart);
	StoreIdle(sAnimC);
	SetLocalLocation(oTarget,"AnimationLocation",GetLocation(oTarget));

	PlayKemoAnimation(oTarget,sAnimB); // fires the transitional animation
		// a graphical bug causes some races to lose their eyes and lips on a non-looping animation,
		// so this uses a loop on animation #1, which must be ~30 frames longer than the frame count ---
		// this prevents the "jump" between animations, and may help counteract possible server lag
		// issues
	DelayCommand(fDelayUntilStart,AnimationLoop(oTarget,GetLocation(oTarget))); // fires the looping idle animation
	DelayCommand(fDelayUntilStart,DisplayGuiScreen(oTarget, "KEMO_ANIM_ADJUST", FALSE, "kemo_anim_adjust.xml"));
	
	vector Position = GetPosition(oTarget);
	Position.z += 0.0;
	
	Animation_SendPositionUpdates(oTarget, GetArea(oTarget), Position);	
}