//::///////////////////////////////////////////////
//:: Mass Inflict Light Wounds (WAS: [Circle of Doom])
//:: [NW_S0_MaInfMod.nss]
//:://////////////////////////////////////////////
//:: All enemies of the caster take 4d8 damage +1
//:: per caster level (max 40).  Undead are healed
//:: for the same amount
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: August 01, 2005
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update Pass By: Preston W, On: July 25, 2001

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-20 by Georg
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
    object oTarget;
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_INFLICT_5);
    effect eVis2 = EffectVisualEffect(VFX_IMP_HEALING_X);
    effect eFNF = EffectVisualEffect(VFX_FNF_LOS_EVIL_10);
    effect eHeal;
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    //Limit Caster Level
    if(nCasterLevel > 40)
    {
        nCasterLevel = 40;
    }
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    float fDelay;
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetSpellTargetLocation());
    //Get first target in the specified area
    oTarget =GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, GetSpellTargetLocation());
    while (GetIsObjectValid(oTarget))
    {
        fDelay = GetRandomDelay();
        //Roll damage
        nDamage = d8(16) + nCasterLevel;
        //Make metamagic checks
        nDamage = ApplyMetamagicVariableMods(nDamage, 128 + nCasterLevel);

        //If the target is an allied undead it is healed
        if(GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
        {
			if(spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, OBJECT_SELF))
        	{
            	//Fire cast spell at event for the specified target
            	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
            	//Set the heal effect
            	eHeal = EffectHeal(nDamage);
            	//Apply the impact VFX and healing effect
            	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget));
            	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
        	}
			else
			{
				FloatingTextStrRefOnCreature(184683, OBJECT_SELF, FALSE);
				return;
			}
        }
        else
        {
           if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
           {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
                //Make an SR Check
                if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
                {
                    if (MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NEGATIVE, OBJECT_SELF, fDelay))
                    {
                        nDamage = nDamage/2;
                    }
                    //Set Damage
                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
                    //Apply impact VFX and damage
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
            }
        }
        //Get next target in the specified area
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, GetSpellTargetLocation());
    }
}