#include "ps_inc_melee"
#include "x2_inc_itemprop"
#include "x2_inc_spellhook"
#include "aaa_constants"
#include "nwn2_inc_spells"

void main()
{
	object oPC = OBJECT_SELF;
	object oTarget	= GetSpellTargetObject();
	int nSpell = GetSpellId();
	int Warmind = CLASS_TYPE_WARMIND;
	int nType;
	int nAttack;
	effect eDamage;
	int nSaveType;
	effect nVFXHit;
	effect eKnock = EffectKnockdown();
	int nDmg;
	int nDamageType;
	 nDamageType = DAMAGE_TYPE_BLUDGEONING;
	

	if (!PS_GetTargetInRange(oPC, oTarget, GetSpellFeatId(), TRUE))
		return;


//	nAttack = AttemptMeleeAttackMainHand(oPC, oTarget, "Trip", 1, "1attack01", 1,nSpell);
	if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC)) nAttack = AttemptMeleeAttackMainHand(oPC, oTarget, "Sweeping Strike", 1, "1attack01", 1,nSpell);
		
		if (nAttack == 2 && GetHasFeat(FEAT_CHAIN_OF_OVERWHELMING_FORCE,oPC))
		{
			nDmg = d10(8); // added by FlattedFifth, June 2, 2024
			nDamageType = DAMAGE_TYPE_MAGICAL;
			eDamage = EffectDamage(nDmg, nDamageType, DAMAGE_POWER_NORMAL, FALSE);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnock, oTarget, 12.0);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
		}
		else if (nAttack == 2)
		{	nDmg = d10(8);
			
			eDamage = EffectDamage(nDmg, nDamageType, DAMAGE_POWER_NORMAL, FALSE);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
		}
		else if (nAttack == 1&& GetHasFeat(FEAT_CHAIN_OF_OVERWHELMING_FORCE,oPC))
		{	
			nDamageType = DAMAGE_TYPE_MAGICAL;
			nDmg = d10(6);
			
			eDamage = EffectDamage(nDmg, nDamageType, DAMAGE_POWER_NORMAL, FALSE);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnock, oTarget, 12.0);
		
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
			
		}
		else if (nAttack == 1)
		{
					nDmg = d10(6);
			
			eDamage = EffectDamage(nDmg, nDamageType, DAMAGE_POWER_NORMAL, FALSE);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
		}
		else 
		{	SendMessageToPC(oPC, "Your attack missed!");
			return;	
		}

}