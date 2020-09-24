//::///////////////////////////////////////////////
//:: Invocation: Eldritch Spear (Warlock Spelllike effect)
//:: NW_S0_IEldSpear.nss
//:://////////////////////////////////////////////
/*
    Does 1d6 Dmg per "ranking" of Eldritch Blast.
    Longer range than normal Eldritch Blast.
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: June 20, 2005
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001


#include "nw_i0_invocatns"
#include "x2_inc_spellhook" 

void main() {

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
	
	object oTarget = GetSpellTargetObject();
	int nID = GetSpellId();
	
	switch (nID) {
		case 813: DoEldritchBlast( OBJECT_SELF, oTarget, FALSE, TRUE ); break; //vanilla spear
		case 2200: DoEssenceDrainingBlast( OBJECT_SELF, oTarget, FALSE, TRUE ); break; //draining spear
		case 2201: DoEssenceFrightfulBlast( OBJECT_SELF, oTarget, FALSE, TRUE ); break; //frightful spear
		case 2202: DoEssenceBeshadowedBlast( OBJECT_SELF, oTarget, FALSE, TRUE ); break; //beshadowed spear
		case 2203: DoEssenceBrimstoneBlast( OBJECT_SELF, oTarget, FALSE, TRUE ); break; //brimstone spear
		case 2204: DoEssenceHellrimeBlast( OBJECT_SELF, oTarget, FALSE, TRUE ); break; //hellrime spear
		case 2205: DoEssenceBewitchingBlast( OBJECT_SELF, oTarget, FALSE, TRUE ); break; //bewitching spear
		case 2206: DoEssenceNoxiousBlast( OBJECT_SELF, oTarget, FALSE, TRUE ); break; //noxious spear
		case 2207: DoEssenceVitriolicBlast( OBJECT_SELF, oTarget, FALSE, TRUE ); break; //vitriolic spear
		case 2208: DoEssenceUtterdarkBlast( OBJECT_SELF, oTarget, FALSE, TRUE ); break; //utterdark spear
		case 2209: DoEssenceHinderingBlast( OBJECT_SELF, oTarget, FALSE, TRUE ); break; //hindering spear
		case 2210: DoEssenceBindingBlast( OBJECT_SELF, oTarget, FALSE, TRUE ); break; //binding spear
	}
	
	
}