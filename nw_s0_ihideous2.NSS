//::///////////////////////////////////////////////
//:: Invocation: Dark One's Own Luck
//:: NW_S0_IDrkOnLck.nss
//:://////////////////////////////////////////////
/*
    Gives a +(Charisma Modifier) bonus to all Saving
    Throws for 24 hours.
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: June 19, 2005
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001


// JLR - OEI 08/24/05 -- Metamagic changes
#include "nwn2_inc_spells"
#include "nw_i0_spells"
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

/*
    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
*/

// End of Spell Cast Hook

	//Fellblade Vampiric Drain ability
	if (GetHasFeat(2906, OBJECT_SELF)) {
		int nDamage = GetLevelByClass(80, OBJECT_SELF);
	    effect eHeal = EffectHeal(nDamage);
		object oTarget = GetSpellTargetObject();
	    if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
	    {
	        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) &&
	            GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD &&
	            GetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT &&
	            !GetHasSpellEffect(SPELL_NEGATIVE_ENERGY_PROTECTION, oTarget))
	        {
	    		effect eVisHeal = EffectVisualEffect(VFX_IMP_HEALING_S);
	            RemoveTempHitPoints();
	            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisHeal, OBJECT_SELF);
	            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eHeal, OBJECT_SELF);
	        }
	    }
	}

	DoShapeHideousBlow();
}