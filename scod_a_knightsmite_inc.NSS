#include "ps_inc_melee"
#include "x2_inc_itemprop"
#include "x2_inc_spellhook"
#include "ps_inc_functions"
#include "nwn2_inc_spells"
#include "ps_adjust_knight"

void KnightSmite(object oPC, object oTarget, int nSpell )
{
	if (!PS_GetTargetInRange(oPC, oTarget, GetSpellFeatId()))
		return;

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
	int nDamageType;
	if (GetHasFeat(FEAT_KNIGHT,oPC))
		{	
		nDamageType = DAMAGE_TYPE_MAGICAL;
		nVFXHit =EffectVisualEffect(VFX_HIT_SPELL_ENCHANTMENT);
		}

		
//**	else if(GetHasFeat(FEAT_BLACKGUARD,oPC))
//			{
//		 nType =DAMAGE_TYPE_NEGATIVE;
//		 nVFXHit =EffectVisualEffect(VFX_HIT_SPELL_INFLICT_1);
//			}	**//


//	nAttack = AttemptMeleeAttackMainHand(oPC, oTarget, "Trip", 1, "1attack01", 1,nSpell);
	if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC)) nAttack = AttemptMeleeAttackMainHand(oPC, oTarget, "Knight Smite", 1, "1attack01", 1,nSpell);
		if (nAttack == 2)
		{	nDmg = nKnight * iChaBonus;
			
			eDamage = EffectDamage(nDmg, nDamageType, DAMAGE_POWER_NORMAL, TRUE);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonus, oPC, 12.0);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
		}
		else if (nAttack == 1)
		{	nDmg = nKnight + iChaBonus;	
			eDamage = EffectDamage(nDmg, DAMAGE_TYPE_PIERCING, DAMAGE_POWER_NORMAL, TRUE);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eBonus, oPC, 6.0);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
		}
		else 
		{	SendMessageToPC(oPC, "Your attack missed!");
			return;	
		}

}