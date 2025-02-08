#include "ff_safevar"

//
//  Turn Lights On Off
//  puk_lights
//  By:Puket
//  01/13/07
//  give me credit
//
//
//	2/28/07 modified by Lochlainn
//	reads local string LIGHT_TYPE to determine the fx to use and light brightness
//	optionally reads local integer NUMBER_FLAMES to set the number of fx's to
//	use (for multiple sources like the candelabras).
//
//	Thanks to Puket whose code forms the basis for these placeables.
//
//  Place this on the OnUsed Event of a Torch/Candle/Streetlamp etc. for Light and FX
//
////////////////////////////////////////////////////////////////////////////



string FX_SEF;
int iLightEffect;
object oNearest;
object oCaller=GetLastUsedBy();
object oSelf = OBJECT_SELF;
int iNumberOfFlames;

void main()
{

	
	

		//define the type of light in local string
	if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="candle")
		{
		FX_SEF="fx_candle";
		iLightEffect=VFX_DUR_LIGHT_YELLOW_5;
		}
	else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="torch")
		{
		FX_SEF="fx_torchglow";
		iLightEffect=VFX_DUR_LIGHT_ORANGE_10;
		}
	else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="fireplace")
		{
		FX_SEF="fx_fireplace";
		iLightEffect=VFX_DUR_LIGHT_ORANGE_15;
		}
	else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="bonfire")
		{
		FX_SEF="fx_bonfire";
		iLightEffect=VFX_DUR_LIGHT_ORANGE_20;
		}
	else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="lamp")
		{
		FX_SEF="fx_lampglow";
		iLightEffect=VFX_DUR_LIGHT_ORANGE_20;
		}
	else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="cave")
		{
		FX_SEF="fx_cavebeam_1";
		}
	else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="dancing")
		{
		FX_SEF="fx_gem_energy_blue";
		iLightEffect=VFX_DUR_LIGHT_BLUE_10;
		}
	else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="barrier")
		{
		FX_SEF="fx_spirit_trap_barrier02";
		iLightEffect=VFX_DUR_LIGHT_BLUE_20;
		}
	else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="jammerball")
		{
		FX_SEF="fx_tiny_ball";
		iLightEffect=VFX_DUR_LIGHT_BLUE_20;
		}
	else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="jammerscreen")
		{
		FX_SEF="vfx_rds_gate1";
		iLightEffect=VFX_DUR_LIGHT_BLUE_10;
		}
	else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="orbred")
		{
		FX_SEF="NONE";
		iLightEffect=VFX_DUR_LIGHT_RED_20;
		}
	else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="orbpurple")
		{
		FX_SEF="NONE";
		iLightEffect=VFX_DUR_LIGHT_PURPLE_20;
		}
	else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="orbblue")
		{
		FX_SEF="NONE";
		iLightEffect=VFX_DUR_LIGHT_BLUE_20;
		}
	else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="orbwhite")
		{
		FX_SEF="NONE";
		iLightEffect=VFX_DUR_LIGHT_WHITE_20;
		}
	else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="orbyellow")
		{
		FX_SEF="NONE";
		iLightEffect=VFX_DUR_LIGHT_YELLOW_20;
		}
	else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="orborange")
		{
		FX_SEF="NONE";
		iLightEffect=VFX_DUR_LIGHT_ORANGE_20;
		}
		
	else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="snowfall")
		{
		FX_SEF="fx_snowfall";
		iLightEffect=VFX_DUR_LIGHT_BLUE_10;
		}
		
		//other flame types here
	else
		{
		//default
		PS_SetLocalString(oSelf,"LIGHT_TYPE","default");
		FX_SEF="fx_candle";
		iLightEffect=VFX_DUR_LIGHT_ORANGE_10;
		}
		
		
		
	//if not currently on
    if (PS_GetLocalInt(OBJECT_SELF,"NW_L_AMION") == 0)
    {
	if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="candle")
		SendMessageToPC(oCaller,"You light the candle.");
		
    else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="torch")
		SendMessageToPC(oCaller,"You light the torch.");
		
    else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="fireplace")
		SendMessageToPC(oCaller,"You light the fireplace.");
	
    else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="bonfire")
		SendMessageToPC(oCaller,"You light the bonfire.");
		
	else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="lamp")
		SendMessageToPC(oCaller,"You light the lamp.");	
		
	else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="cave")	
		SendMessageToPC(oCaller,"You activate the display lights.");
		
	else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="dancing")	
		SendMessageToPC(oCaller,"You activate the dancing lights.");
		
	else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="barrier")	
		SendMessageToPC(oCaller,"You activate the containment barrier.");

	else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="jammerball")	
		SendMessageToPC(oCaller,"You activate the orb.");
		
	else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="jammerscreen")	
		SendMessageToPC(oCaller,"You activate the viewer.");
		
	else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="orbred")	
		SendMessageToPC(oCaller,"You activate the orb.");
		
	else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="orbpurple")	
		SendMessageToPC(oCaller,"You activate the orb.");
		
	else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="orbblue")	
		SendMessageToPC(oCaller,"You activate the orb.");
		
	else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="orbwhite")	
		SendMessageToPC(oCaller,"You activate the orb.");
		
	else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="orbyellow")	
		SendMessageToPC(oCaller,"You activate the orb.");
		
	else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="orborange")	
		SendMessageToPC(oCaller,"You activate the orb.");
		
	    //turn on light from the placeable and play animation if any
		PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);
      	DelayCommand(0.4,SetPlaceableIllumination(oSelf, TRUE));
      	PS_SetLocalInt(oSelf,"NW_L_AMION",1);
      	DelayCommand(0.5,RecomputeStaticLighting(GetArea(oSelf)));
			
		//apply lighting
		effect eLight=EffectVisualEffect(iLightEffect);
      	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLight, oSelf);
	  	
		//define flame effect
		effect eFX = EffectNWN2SpecialEffectFile(FX_SEF);
	  	
		//debug
			
		//apply flame effect to x_object ipoints within a small radius
		iNumberOfFlames=PS_GetLocalInt(oSelf,"NUMBER_FLAMES");
		if (iNumberOfFlames<1) 
		{
		iNumberOfFlames=1;
		}
		
		
		int i;
		for (i=1;i<=iNumberOfFlames;i=i+1)
			{
			oNearest = GetNearestObjectByTag("light_object", oSelf, i);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, oNearest);
			}
    }
    else
    {
	
	if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="candle")
		SendMessageToPC(oCaller,"You extinguish the candle.");
		
    else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="torch")
		SendMessageToPC(oCaller,"You extinguish the torch.");
		
    else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="fireplace")
		SendMessageToPC(oCaller,"You extinguish the fireplace.");
	
    else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="bonfire")
		SendMessageToPC(oCaller,"You extinguish the bonfire.");
		
	else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="lamp")
		SendMessageToPC(oCaller,"You extinguish the lamp.");	
		
	else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="cave")	
		SendMessageToPC(oCaller,"You deactivate the display lights.");
		
	else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="dancing")	
		SendMessageToPC(oCaller,"You deactivate the dancing lights.");
		
	else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="barrier")	
		SendMessageToPC(oCaller,"You deactivate the containment barrier.");
		
	else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="jammerball")	
		SendMessageToPC(oCaller,"You deactivate the orb.");
		
	else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="jammerscreen")	
		SendMessageToPC(oCaller,"You deactivate the viwer.");
		
	else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="orbred")	
		SendMessageToPC(oCaller,"You deactivate the orb.");
		
	else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="orbpurple")	
		SendMessageToPC(oCaller,"You deactivate the orb.");
		
	else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="orbblue")	
		SendMessageToPC(oCaller,"You deactivate the orb.");
		
	else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="orbwhite")	
		SendMessageToPC(oCaller,"You deactivate the orb.");
		
	else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="orbyellow")	
		SendMessageToPC(oCaller,"You deactivate the orb.");
		
	else if (PS_GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="orborange")	
		SendMessageToPC(oCaller,"You deactivate the orb.");




	  	PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE);
		
		//deactivate light
      	DelayCommand(0.4,SetPlaceableIllumination(oSelf, FALSE));
		
		//set local variable to off
      	PS_SetLocalInt(OBJECT_SELF,"NW_L_AMION",0);

		//remove flame effect to x_object ipoints within a small radius
		iNumberOfFlames=PS_GetLocalInt(oSelf,"NUMBER_FLAMES");
		if (iNumberOfFlames<1) 
			{
			iNumberOfFlames=1;
			}
			
			
			int i;
			for (i=1;i<=iNumberOfFlames;i=i+1)
				{
				oNearest = GetNearestObjectByTag("light_object", oSelf, i);
				RemoveSEFFromObject(oNearest,FX_SEF);
				}	  
		
			DelayCommand(0.9,RecomputeStaticLighting(GetArea(oSelf)));
		  	effect eEffect = GetFirstEffect(oSelf);
			while (GetIsEffectValid(eEffect) == TRUE)
				{
	   	     	if (GetEffectType(eEffect) == EFFECT_TYPE_VISUALEFFECT) RemoveEffect(oSelf, eEffect);
	        	eEffect = GetNextEffect(oSelf);
				}
		}
}
		
				