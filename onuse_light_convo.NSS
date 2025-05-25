

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
	if (GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="candle")
		{
		FX_SEF="fx_candle";
		iLightEffect=VFX_DUR_LIGHT_YELLOW_5;
		}
	else if (GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="torch")
		{
		FX_SEF="fx_torchglow";
		iLightEffect=VFX_DUR_LIGHT_ORANGE_10;
		}
	else if (GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="fireplace")
		{
		FX_SEF="fx_fireplace";
		iLightEffect=VFX_DUR_LIGHT_ORANGE_15;
		}
	else if (GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="bonfire")
		{
		FX_SEF="fx_bonfire";
		iLightEffect=VFX_DUR_LIGHT_ORANGE_20;
		}
	else if (GetLocalString(OBJECT_SELF,"LIGHT_TYPE")=="lamp")
		{
		FX_SEF="fx_lampglow";
		iLightEffect=VFX_DUR_LIGHT_ORANGE_20;
		}

		//other flame types here
	else
		{
		//default
		SetLocalString(oSelf,"LIGHT_TYPE","default");
		FX_SEF="fx_candle";
		iLightEffect=VFX_DUR_LIGHT_ORANGE_10;
		}
		
		
		
	//if not currently on
    if (GetLocalInt(OBJECT_SELF,"NW_L_AMION") == 0)
    {
		SendMessageToPC(oCaller,"You light the flame.");
					
		
	    //turn on light from the placeable and play animation if any
		PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);
      	DelayCommand(0.4,SetPlaceableIllumination(oSelf, TRUE));
      	SetLocalInt(oSelf,"NW_L_AMION",1);
      	DelayCommand(0.5,RecomputeStaticLighting(GetArea(oSelf)));
			
		//apply lighting
		effect eLight=EffectVisualEffect(iLightEffect);
      	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLight, oSelf);
	  	
		//define flame effect
		effect eFX = EffectNWN2SpecialEffectFile(FX_SEF);
	  	
		//debug
			
		//apply flame effect to x_object ipoints within a small radius
		iNumberOfFlames=GetLocalInt(oSelf,"NUMBER_FLAMES");
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
			
		ActionStartConversation(oCaller, "", TRUE);
    }
    else
    {
		SendMessageToPC(oCaller,"You extinguish the flame.");
		//turn off lights

	  	PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE);
		
		//deactivate light
      	DelayCommand(0.4,SetPlaceableIllumination(oSelf, FALSE));
		
		//set local variable to off
      	SetLocalInt(OBJECT_SELF,"NW_L_AMION",0);

		//remove flame effect to x_object ipoints within a small radius
		iNumberOfFlames=GetLocalInt(oSelf,"NUMBER_FLAMES");
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
		
				