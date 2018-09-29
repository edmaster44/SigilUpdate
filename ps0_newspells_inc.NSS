#include "x2_inc_spellhook"
#include "aaa_constants"
#include "X0_I0_SPELLS"
#include "nw_i0_spells"
#include "ps_inc_functions"
#include "nwn2_inc_spells"
#include "ps_inc_faction"
#include "x2_inc_itemprop"
#include "x2_inc_toollib"
#include "nwn2_inc_metmag"

/*	This is the include file for new spells for Bards, Clerics, Druids, Paladins, Rangers, and Wizards.

	//////////////////////////////////////////////////////////////////////////////////////////
	//////////					Let The Magic Begin!								//////////
	//////////////////////////////////////////////////////////////////////////////////////////	*/

void PS_Spell_DreadWord(object oPC, object oTarget, int nSpell)
{
	if (!X2PreSpellCastCode())
    {	return;	}
	
    int nLevel 		= GetCasterLevel(oPC);
	effect eVis		= EffectNWN2SpecialEffectFile("sp_beshadowed_hit", oTarget);
	effect eDread	= EffectAbilityDecrease(ABILITY_CHARISMA, d3(1));
	effect eLink	= EffectLinkEffects(eVis, eDread);
	effect eFail	= EffectNWN2SpecialEffectFile("fx_b_spell_failure01", oPC);
			
	if (GetAlignmentGoodEvil(oPC) != ALIGNMENT_GOOD)
	{	SendMessageToPC(oPC, "The Dread Word only effects good creatures.");
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eFail, oPC);	}
	else
	{	SignalEvent(oTarget, EventSpellCastAt(oPC, nSpell));
		if(!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, oPC))
		{	ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);	}
	}
}

void PS_Spell_Gutwrench(object oPC, object oTarget, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}

	effect eDeath 		= EffectDeath(TRUE);
    effect eSpurt 		= EffectNWN2SpecialEffectFile("bloodspurt", oTarget);
		eDeath			= EffectLinkEffects(eDeath, eSpurt);
	effect ePuddle		= EffectNWN2SpecialEffectFile("fx_bloodstain1", oTarget);
	effect eBeam		= EffectBeam(VFX_BEAM_NECROMANCY, oTarget, BODY_NODE_CHEST);
	effect eAbsorb		= EffectNWN2SpecialEffectFile("fx_sp_vampiric_feast_hit01", oPC);
	effect eAbsHeal		= EffectTemporaryHitpoints(d6(4));
	effect eFail		= EffectNWN2SpecialEffectFile("fx_b_spell_failure", oPC);
	int nCasterLevel	= GetHitDice(oPC) / 2;
	int nSaveDC			= 10 + nCasterLevel + GetAbilityModifier(ABILITY_CHARISMA, oPC);
	int nDamage			= d6(10);
    effect eDam			= EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE, DAMAGE_POWER_NORMAL, TRUE);

	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{	SignalEvent(oTarget, EventSpellCastAt(oPC, nSpell));
		// Check for "no discernable anatomy"
		if (PS_GetHasDiscernableAnatomy(oTarget) == FALSE)
		{   SendMessageToPCByStrRef(oPC, 16780102);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eFail, oPC);
			return;		}
		
        if(!MyResistSpell(OBJECT_SELF, oTarget))
        {	if(!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, oPC))
            {	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);
				DelayCommand(0.5f, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, ePuddle, GetLocation(oTarget), 30.0f));
				DelayCommand(0.6f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oPC, 3.0f));
				DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eAbsorb, oPC));
				DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAbsHeal, oPC, HoursToSeconds(24)));	}
            else
            {	eDam = EffectLinkEffects(eDam, eSpurt);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);	}
        }
    }
}

void PS_Spell_FreezingFog(object oPC, location lTarget, int nSpell)
{
	if (!X2PreSpellCastCode())
    {	return;		}

    effect eFog 		= EffectAreaOfEffect(AOE_PER_FREEZINGFOG);
	effect eRime		= EffectAreaOfEffect(AOE_PER_GREASE);
	float fDuration		= TurnsToSeconds(GetCasterLevel(oPC));

    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eFog, lTarget, fDuration);
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eRime, lTarget, fDuration);
}