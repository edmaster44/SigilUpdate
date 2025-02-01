#include "ff_safevar"

#include "ginc_param_const"
#include "kemo_includes"

void main(string sNumber,string sLaptype)
{
	object oPC = OBJECT_SELF;
	
	if (sNumber == "a") sLaptype = "kemo_lapsit_";
	else if (sNumber == "b") sLaptype = "kemo_lapsitb_";
	else if (sNumber == "c") sLaptype = "kemo_lapsitc_";
	else if (sNumber == "d") sLaptype = "kemo_lapsitd_";
	
	string sAnimB = sLaptype + "1";
	string sAnimC = sAnimB + "i";

//	SendMessageToPC(oPC,"Playing animation b: "+sAnimB);
//	SendMessageToPC(oPC,"Playing animation c: "+sAnimC);
		
	StoreAnimation(sAnimB,1.0f);
	StoreIdle(sAnimC);
	PS_SetLocalLocation(oPC,"AnimationLocation",GetLocation(oPC));
	AnimationLoop(oPC,GetLocation(oPC)); // fires the looping idle animation
	DisplayGuiScreen(oPC, "KEMO_ANIM_ADJUST", FALSE, "kemo_anim_adjust.xml");
			
	return;
	
	if (sNumber == "a")
		DisplayGuiScreen(oPC,"KEMO_ANIM_LAPSIT",FALSE,"kemo_anim_lapsit.xml");
	else if (sNumber == "b")
		DisplayGuiScreen(oPC,"KEMO_ANIM_LAPSITB",FALSE,"kemo_anim_lapsitb.xml");
	else if (sNumber == "c")
		DisplayGuiScreen(oPC,"KEMO_ANIM_LAPSITC",FALSE,"kemo_anim_lapsitc.xml");
	else if (sNumber == "d")
		DisplayGuiScreen(oPC,"KEMO_ANIM_LAPSITD",FALSE,"kemo_anim_lapsitd.xml");
	else
	{	
		string sAnimB = sLaptype + sNumber;
		string sAnimC = sAnimB + "i";

		StoreAnimation(sAnimB,1.0f);
		StoreIdle(sAnimC);
		PS_SetLocalLocation(oPC,"AnimationLocation",GetLocation(oPC));
		AnimationLoop(oPC,GetLocation(oPC)); // fires the looping idle animation
	}
}