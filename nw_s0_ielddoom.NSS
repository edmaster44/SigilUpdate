//::///////////////////////////////////////////////
//:: Invocation: Eldritch Doom (Warlock Spelllike effect)
//:: NW_S0_IEldDoom.nss
//:://////////////////////////////////////////////
/*
    Does 1d6 Dmg per "ranking" of Eldritch Blast.
    Targets all creatures in a 20' Area.
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: August 22, 2005
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001


#include "nw_i0_invocatns"
#include "x2_inc_spellhook" 

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
	
	int nID = GetSpellId();

	if (nID == 839) {
    	DoShapeEldritchDoom();
		return;
	}
	
	int nDoomVFX = VFX_INVOCATION_ELDRITCH_AOE;	// default Doom is Eldritch

	// adjust the VFX according to the essence
    if ( nID == 2255 )         { nDoomVFX = VFX_INVOCATION_DRAINING_DOOM; }
    else if ( nID == 2256 )   { nDoomVFX = VFX_INVOCATION_FRIGHTFUL_DOOM; }
    else if ( nID == 2257 )  { nDoomVFX = VFX_INVOCATION_BESHADOWED_DOOM; }
    else if ( nID == 2258 )   { nDoomVFX = VFX_INVOCATION_BRIMSTONE_DOOM; }
    else if ( nID == 2259 )    { nDoomVFX = VFX_INVOCATION_HELLRIME_DOOM; }
    else if ( nID == 2260 )  { nDoomVFX = VFX_INVOCATION_BEWITCHING_DOOM; }
    else if ( nID == 2261 )     { nDoomVFX = VFX_INVOCATION_NOXIOUS_DOOM; }
    else if ( nID == 2262 )   { nDoomVFX = VFX_INVOCATION_VITRIOLIC_DOOM; }
    else if ( nID == 2263 )   { nDoomVFX = VFX_INVOCATION_UTTERDARK_DOOM; }
    else if ( nID == 2264 )   { nDoomVFX = VFX_INVOCATION_HINDERING_DOOM; }
    else if ( nID == 2265 )     { nDoomVFX = VFX_INVOCATION_BINDING_DOOM; }
 
   //Declare major variables
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetSpellTargetLocation();

    // Visual on the Location itself...
    effect eExplode = EffectVisualEffect( nDoomVFX );
	if (IsHellfireBlastActive()) eExplode = EffectVisualEffect( VFX_INVOCATION_BRIMSTONE_DOOM );
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);

    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        // Handle combined Eldritch Essence Effects, if any
        DoEldritchCombinedEffects(oTarget, FALSE, TRUE);
		switch (nID) {
			case 2255: DoEssenceDrainingBlast( OBJECT_SELF, oTarget, TRUE, FALSE, TRUE ); break; //draining spear
			case 2256: DoEssenceFrightfulBlast( OBJECT_SELF, oTarget, TRUE, FALSE, TRUE ); break; //frightful spear
			case 2257: DoEssenceBeshadowedBlast( OBJECT_SELF, oTarget, TRUE, FALSE, TRUE ); break; //beshadowed spear
			case 2258: DoEssenceBrimstoneBlast( OBJECT_SELF, oTarget, TRUE, FALSE, TRUE ); break; //brimstone spear
			case 2259: DoEssenceHellrimeBlast( OBJECT_SELF, oTarget, TRUE, FALSE, TRUE ); break; //hellrime spear
			case 2260: DoEssenceBewitchingBlast( OBJECT_SELF, oTarget, TRUE, FALSE, TRUE ); break; //bewitching spear
			case 2261: DoEssenceNoxiousBlast( OBJECT_SELF, oTarget, TRUE, FALSE, TRUE ); break; //noxious spear
			case 2262: DoEssenceVitriolicBlast( OBJECT_SELF, oTarget, TRUE, FALSE, TRUE ); break; //vitriolic spear
			case 2263: DoEssenceUtterdarkBlast( OBJECT_SELF, oTarget, TRUE, FALSE, TRUE ); break; //utterdark spear
			case 2264: DoEssenceHinderingBlast( OBJECT_SELF, oTarget, TRUE, FALSE, TRUE ); break; //hindering spear
			case 2265: DoEssenceBindingBlast( OBJECT_SELF, oTarget, TRUE, FALSE, TRUE ); break; //binding spear
		}

        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
	
	if (IsHellfireBlastActive() && nHellfireConDmg > 0)
	{
		HellfireShieldFeedbackMsg(nHellfireConDmg, STRREF_HELLFIRE_BLAST_NAME, OBJECT_SELF);
		nHellfireConDmg = 0;
	}
	
	DoHellfireDamage();
}