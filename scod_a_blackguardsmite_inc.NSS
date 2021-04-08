#include "ps_inc_melee"
#include "x2_inc_itemprop"
#include "x2_inc_spellhook"
#include "aaa_constants"
#include "nwn2_inc_spells"
#include "ps_adjust_knight"




	// Use this to fix infinite range for instant feats.
int CancelIfNotInMeleeRange(object oCaller, object oTarget, int nFeatID)
{
	if (GetDistanceBetween(oCaller, oTarget) > 30.0f) // Melee range seems to be around a little less then 3.0f, so picked a number
	{                                                // a little higher to give some loose.
		SendMessageToPC(oCaller, "Target out of range.");
		ResetFeatUses(oCaller, nFeatID, FALSE, TRUE);
		return FALSE;
	}	
	return TRUE;
}


void blackguardsmite(object oPC, object oTarget, int nSpell )
{

	int nKnight = KnightLevels(oPC);
	int iChaBonus = GetAbilityModifier(ABILITY_CHARISMA, oPC);
	effect eBonus =  EffectAttackIncrease(iChaBonus);
	eBonus =SupernaturalEffect(eBonus);
	int nType;
	int nAttack;
	effect eDamage;
	int nSaveType;
	effect nVFXHit;
	int nDmg;
	//int nDamageType;
//*	if (GetHasFeat(FEAT_KNIGHT,oPC))
//		{	
//		nType = DAMAGE_TYPE_MAGICAL;
//		nVFXHit =EffectVisualEffect(VFX_HIT_SPELL_ENCHANTMENT);
//		} 
		
	 if(GetHasFeat(FEAT_BLACKGUARD,oPC))
		{
		 nType =DAMAGE_TYPE_NEGATIVE;
	 nVFXHit =EffectVisualEffect(VFX_HIT_SPELL_INFLICT_1);
		}	

if (GetAlignmentGoodEvil(oTarget) !=  ALIGNMENT_GOOD)
{ SendMessageToPC(oPC,"You cannot smite a target that isn't good");
return;}
	if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC)) nAttack = AttemptMeleeAttackMainHand(oPC, oTarget, "Trip", 1, "1attack01", 1,nSpell);
		if (nAttack == 2)
		{	nDmg = nKnight +iChaBonus* 2;
			
			eDamage = EffectDamage(nDmg, nType, DAMAGE_POWER_NORMAL, TRUE);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonus, oPC, 12.0);
			DelayCommand(0.1,ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
		}
		else if (nAttack == 1)
		{	nDmg = nKnight + iChaBonus;	
			eDamage = EffectDamage(nDmg, nType, DAMAGE_POWER_NORMAL, TRUE);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eBonus, oPC, 6.0);
			DelayCommand(0.1,ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
		}
		else 
		{	SendMessageToPC(oPC, "Your attack missed!");
			return;	
		}

}