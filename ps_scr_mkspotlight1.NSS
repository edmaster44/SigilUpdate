#include "ff_safevar"

void main()
{
       object oSpotlight = GetObjectByTag("mkspotlight1");
       object oCrystal = GetObjectByTag("mkcrystal1");
	   effect eBeam = EffectNWN2SpecialEffectFile("fx_ps_mk_spotlighttarget",oCrystal);
	   
// OBJECT_SELF is the placeable being used
if(PS_GetLocalInt(OBJECT_SELF, "TurnedOn") == 1) // If the light is already "on"
   {
   // Do whatever and remove the VFX, it is already on, so now we want to turn it off
   RemoveSEFFromObject(oSpotlight, "fx_ps_mk_spotlighttarget" );
   PS_DeleteLocalInt(OBJECT_SELF, "TurnedOn"); // Remove the variable telling the script it is on
   }
else // The light is not already "on"
   {
   // Do whatever and apply the VFX since the light is "off"
   ApplyEffectToObject(DURATION_TYPE_PERMANENT,eBeam,oSpotlight,3.0f);
   PS_SetLocalInt(OBJECT_SELF, "TurnedOn", 1); // Set local int so script knows light is now "on"
   }
}