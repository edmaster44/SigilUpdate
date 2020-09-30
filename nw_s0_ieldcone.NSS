//::///////////////////////////////////////////////
//:: Invocation: Eldritch Cone (Warlock Spelllike effect)
//:: NW_S0_IEldCone.nss
//:://////////////////////////////////////////////
/*
    Does 1d6 Dmg per "ranking" of Eldritch Blast.
    Targets all creatures in a 30' Cone.
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

	if (nID == 833) {
   	 	DoShapeEldritchCone();
		return;
	}
	
	location lTargetLocation = GetSpellTargetLocation();
    object oTarget;
    float fMaxDelay = 1.0;
	int nConeVFX = VFX_INVOCATION_ELDRITCH_AOE;	// default cone is Eldritch
	
	
	switch (nID) {
		case 2244: nConeVFX = VFX_INVOCATION_DRAINING_DOOM; break; //draining spear
		case 2245: nConeVFX = VFX_INVOCATION_FRIGHTFUL_DOOM; break; //frightful spear
		case 2246: nConeVFX = VFX_INVOCATION_BESHADOWED_DOOM; break; //beshadowed spear
		case 2247: nConeVFX = VFX_INVOCATION_BRIMSTONE_DOOM; break; //brimstone spear
		case 2248: nConeVFX = VFX_INVOCATION_HELLRIME_DOOM; break; //hellrime spear
		case 2249: nConeVFX = VFX_INVOCATION_BEWITCHING_DOOM; break; //bewitching spear
		case 2250: nConeVFX = VFX_INVOCATION_NOXIOUS_DOOM; break; //noxious spear
		case 2251: nConeVFX = VFX_INVOCATION_VITRIOLIC_DOOM; break; //vitriolic spear
		case 2252: nConeVFX = VFX_INVOCATION_UTTERDARK_DOOM; break; //utterdark spear
		case 2253: nConeVFX = VFX_INVOCATION_HINDERING_DOOM; break; //hindering spear
		case 2254: nConeVFX = VFX_INVOCATION_BINDING_DOOM; break; //binding spear
	}

	effect eCone = EffectVisualEffect( nConeVFX );
	if (IsHellfireBlastActive()) eCone = EffectVisualEffect( VFX_INVOCATION_BRIMSTONE_DOOM );
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCone, OBJECT_SELF, fMaxDelay);
	
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 7.0, GetLocation(OBJECT_SELF), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while(GetIsObjectValid(oTarget))
    {
        if (oTarget != OBJECT_SELF) {
		
        	// Handle combined Eldritch Essence Effects, if any
        	DoEldritchCombinedEffects(oTarget, FALSE, TRUE);
			
			switch (nID) {
				case 2244: DoEssenceDrainingBlast( OBJECT_SELF, oTarget, TRUE, FALSE, TRUE ); break; //draining spear
				case 2245: DoEssenceFrightfulBlast( OBJECT_SELF, oTarget, TRUE, FALSE, TRUE ); break; //frightful spear
				case 2246: DoEssenceBeshadowedBlast( OBJECT_SELF, oTarget, TRUE, FALSE, TRUE ); break; //beshadowed spear
				case 2247: DoEssenceBrimstoneBlast( OBJECT_SELF, oTarget, TRUE, FALSE, TRUE ); break; //brimstone spear
				case 2248: DoEssenceHellrimeBlast( OBJECT_SELF, oTarget, TRUE, FALSE, TRUE ); break; //hellrime spear
				case 2249: DoEssenceBewitchingBlast( OBJECT_SELF, oTarget, TRUE, FALSE, TRUE ); break; //bewitching spear
				case 2250: DoEssenceNoxiousBlast( OBJECT_SELF, oTarget, TRUE, FALSE, TRUE ); break; //noxious spear
				case 2251: DoEssenceVitriolicBlast( OBJECT_SELF, oTarget, TRUE, FALSE, TRUE ); break; //vitriolic spear
				case 2252: DoEssenceUtterdarkBlast( OBJECT_SELF, oTarget, TRUE, FALSE, TRUE ); break; //utterdark spear
				case 2253: DoEssenceHinderingBlast( OBJECT_SELF, oTarget, TRUE, FALSE, TRUE ); break; //hindering spear
				case 2254: DoEssenceBindingBlast( OBJECT_SELF, oTarget, TRUE, FALSE, TRUE ); break; //binding spear
			}
			
        }

        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 7.0, GetLocation(OBJECT_SELF), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
	if (IsHellfireBlastActive() && nHellfireConDmg > 0)
	{
		HellfireShieldFeedbackMsg(nHellfireConDmg, STRREF_HELLFIRE_BLAST_NAME, OBJECT_SELF);
		nHellfireConDmg = 0;
	}
	
	DoHellfireDamage();
	
}