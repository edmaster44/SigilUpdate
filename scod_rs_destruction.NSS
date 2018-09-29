//::///////////////////////////////////////////////
//:: Destruction
//:: NW_S0_Destruc
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The target creature is destroyed if it fails a
    Fort save, otherwise it takes 10d6 damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 13, 2001
//:://////////////////////////////////////////////

#include "x0_I0_SPELLS"    
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

// End of Spell Cast Hook


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nDamage;
	int nCha = GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF);
	int nSave = 17 + nCha;
	int nCasterLvl = GetHitDice(OBJECT_SELF);
    effect eDeath = EffectDeath();
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_IMP_DESTRUCTION);
	
	if (nCasterLvl < 19)
	{
		SendMessageToPC(OBJECT_SELF, "You cannot yet use this ability.");

	}
	else
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{
	        //Fire cast spell at event for the specified target
	        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DESTRUCTION));
			
			//Make sure the target is not immune to death effects
			if (GetIsImmune(oTarget, IMMUNITY_TYPE_DEATH))
			{   
				FloatingTextStrRefOnCreature(184683, OBJECT_SELF, FALSE);
				return;
			}
			
			//Make SR check
	        if(!MyResistSpell(OBJECT_SELF, oTarget))
	        {
	            //Make a saving throw check
	            if(!/*Fort Save*/ MySavingThrow(SAVING_THROW_FORT, oTarget, nSave, SAVING_THROW_TYPE_DEATH))
	            {
	                //Apply the VFX impact and effects
	                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);
	            }
	            else
	            {
	                nDamage = d6(10);
	                
	                //Set damage effect
	                eDam = EffectDamage(nDamage, DAMAGE_TYPE_DIVINE);
	                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
	            }
	            //Apply VFX impact
	            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	        }
	    }
	}
}