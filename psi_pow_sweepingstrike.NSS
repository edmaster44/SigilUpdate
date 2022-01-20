#include "ps_inc_melee"
#include "x2_inc_itemprop"
#include "x2_inc_spellhook"
#include "aaa_constants"
#include "nwn2_inc_spells"

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
	if (GetHasFeat(FEAT_CHAIN_OF_OVERWHELMING_FORCE,oPC))
		{	
		nDamageType = DAMAGE_TYPE_MAGICAL;
		nVFXHit =EffectVisualEffect(VFX_HIT_SPELL_ENCHANTMENT);
		}
	else nDamageType = DAMAGE_TYPE_BLUDGEONING;


//	nAttack = AttemptMeleeAttackMainHand(oPC, oTarget, "Trip", 1, "1attack01", 1,nSpell);
	if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC)) nAttack = AttemptMeleeAttackMainHand(oPC, oTarget, "Sweeping Strike", 1, "1attack01", 1,nSpell);
		if (nAttack == 2)
		{	nDmg = d10(8);
			
			eDamage = EffectDamage(nDmg, nDamageType, DAMAGE_POWER_NORMAL, FALSE);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnock, oPC, 12.0);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
		}
		else if (nAttack == 1)
		{	
		
			nDmg = d10(6);
			
			eDamage = EffectDamage(nDmg, nDamageType, DAMAGE_POWER_NORMAL, FALSE);
			//ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnock, oPC, 12.0);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
			
		}
		else 
		{	SendMessageToPC(oPC, "Your attack missed!");
			return;	
		}

}