//::///////////////////////////////////////////////
//:: Prayer
//:: NW_S0_Prayer.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Allies gain +1 Attack, damage, saves, skill checks
    Enemies gain -1 to these stats
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 25, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 22, 2001

// JLR - OEI 08/24/05 -- Metamagic changes
#include "nwn2_inc_spells"
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 
#include "ps_inc_functions"

void main()
{
	if (!X2PreSpellCastCode())
    {	return;	}

    //Declare major variables
    object oTarget;
    effect ePosVis = EffectVisualEffect(VFX_DUR_SPELL_PRAYER);
    effect eNegVis = EffectVisualEffect(VFX_DUR_SPELL_PRAYER_VIC);
    effect eImpact = EffectVisualEffect(VFX_HIT_AOE_ENCHANTMENT);

    int nBonus = 1;
	int nBonus2 = 1;
	if (GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
	{	nBonus = 4;	}
	if (GetAlignmentGoodEvil(oTarget) == ALIGNMENT_GOOD)
	{	nBonus2 = 4;	}
		
	effect eBonAttack;
    effect eBonSave;
    effect eBonDam;
    effect eBonSkill;
    effect ePosLink;

    effect eNegAttack;
    effect eNegSave;
    effect eNegDam;
    effect eNegSkill;
    effect eNegLink;

    float fDuration = RoundsToSeconds(PS_GetCasterLevel(OBJECT_SELF));

    //Metamagic duration check
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    //Apply Impact
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());

    //Get the first target in the radius around the caster
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
    	//if(GetIsFriend(oTarget))
		if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, OBJECT_SELF ))
    	{
            //Fire spell cast at event for target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 14302, FALSE));
			if (GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
			{	nBonus = 4;	}
			eBonAttack = EffectAttackIncrease(nBonus);
 			eBonSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus);
    		eBonDam = EffectDamageIncrease(nBonus, DAMAGE_TYPE_SLASHING);
    		eBonSkill = EffectSkillIncrease(SKILL_ALL_SKILLS, nBonus);
		    ePosLink = EffectLinkEffects(eBonAttack, eBonSave);
    		ePosLink = EffectLinkEffects(ePosLink, eBonDam);
    		ePosLink = EffectLinkEffects(ePosLink, eBonSkill);
			ePosLink = EffectLinkEffects(ePosLink, ePosVis);
			//Apply VFX impact and bonus effects
            ApplyEffectToObject(nDurType, ePosLink, oTarget, fDuration);
        }
        else if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            //Fire spell cast at event for target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 14302));

            if(!MyResistSpell(OBJECT_SELF, oTarget))
            {
                if (GetAlignmentGoodEvil(oTarget) == ALIGNMENT_GOOD)
				{	nBonus2 = 4;	}
    			eNegAttack = EffectAttackDecrease(nBonus2);
    			eNegSave = EffectSavingThrowDecrease(SAVING_THROW_ALL, nBonus2);
   				eNegDam = EffectDamageDecrease(nBonus, DAMAGE_TYPE_SLASHING);
    			eNegSkill = EffectSkillDecrease(SKILL_ALL_SKILLS, nBonus2);
    			eNegLink = EffectLinkEffects(eNegAttack, eNegSave);
    			eNegLink = EffectLinkEffects(eNegLink, eNegDam);
    			eNegLink = EffectLinkEffects(eNegLink, eNegSkill);
				eNegLink = EffectLinkEffects(eNegLink, eNegVis);
				//Apply VFX impact and bonus effects
				ApplyEffectToObject(nDurType, eNegLink, oTarget, fDuration);
            }
        }
        //Get the next target in the specified area around the caster
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    }
}