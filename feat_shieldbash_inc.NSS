#include "x2_inc_spellhook"
#include "X0_I0_SPELLS"
#include "ps_inc_functions"
#include "ps_inc_equipment"
#include "ps_inc_advscript"
#include "nw_i0_spells"
#include "ed_wildmagic"
#include "x0_i0_match"
#include "ps_inc_melee"
#include "x2_inc_itemprop"

int BASH_MELEE = 0;
int BASH_THROWN = 1;
int BASH_AGILE = 2;

void DoBash(object oPC, object oTarget, int nSpell, int nBash){

	int nDam;
	int nSize;
	int nTotal;
	int nSaveDC;
	object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
	int nType = GetBaseItemType(oShield);
	int nAbility;
	if (nBash == BASH_AGILE) nAbility = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
	else nAbility = GetAbilityModifier(ABILITY_STRENGTH, oPC);
	
	switch (nType){
		case BASE_ITEM_SMALLSHIELD:{
			nDam = d6(6);
			nSize = 1;
			break;
		}
		case BASE_ITEM_LARGESHIELD:{
			nDam = d6(9);
			nSize = 2;
			break;
		}
		case BASE_ITEM_TOWERSHIELD:{
			nDam = d6(12);
			nSize = 4;
			break;
		}
		default:{
			SendMessageToPC(oPC,"You require a shield to use this feat.");
			return;
		}
	}
	nDam += nAbility;
	nTotal = nSize + (nAbility / 2);
	nSaveDC = 10 + (GetBaseAttackBonus(oPC) / 2) + nTotal;
	if (GetHasFeat(FEAT_IMPROVED_SHIELDBASH,oPC)){
		nDam += d6(3);
		nSaveDC += 4;
	}
	
	effect eFX;
	if (nBash == BASH_AGILE) eFX = EffectKnockdown();
	else eFX = EffectParalyze();
	
	int iHit;
	if (nBash == BASH_MELEE)
		iHit = AttemptMeleeAttackMainHand(oPC, oTarget, "Shield Bash", 1, "*shieldbash", 0, nSpell);
	else if (nBash == BASH_THROWN)
		iHit = AttemptMeleeAttackMainHand(oPC, oTarget, "Shield Throw", 1, "*shieldbash", 1, nSpell);
	else iHit = AttemptMeleeAttackMainHand(oPC, oTarget,"Agile Strike", 1, "*shieldbash", 0, nSpell);
	
	float fDur = RoundsToSeconds(nSaveDC);
	if(iHit > 0){
		if (iHit == 2) nDam *= 2;
		effect eHurt = EffectDamage(nDam, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_NORMAL, TRUE);
		ApplyEffectToObject(DURATION_TYPE_INSTANT,eHurt,oTarget);
		
		int nSavingThrow;
		if (nBash == BASH_AGILE) nSavingThrow = SAVING_THROW_REFLEX;
		else nSavingThrow = SAVING_THROW_FORT;
		
		if (!MySavingThrow(nSavingThrow, oTarget, nSaveDC, SAVING_THROW_TYPE_NONE, oPC, 0.1, nSpell))
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eFX, oTarget, fDur);
		
		if (GetLocalInt(oPC, "ArcaneBashOn") == 1)
			DoWildMagic(oPC, oTarget, nSpell);
	}
}

void Shield_Bash(object oPC, object oTarget, int nSpell ){
	DoBash(oPC, oTarget, nSpell, BASH_MELEE);
}


void Shield_Throw(object oPC, object oTarget, int nSpell ){
	DoBash(oPC, oTarget, nSpell, BASH_THROWN);
}


void Agile_Strike(object oPC, object oTarget, int nSpell ){
	DoBash(oPC, oTarget, nSpell, BASH_AGILE);
}

void DeactivateArcaneBash(object oPC, int id, int idneeded){
	AssignCommand(oPC, ClearAllActions());

	if (id != GetLocalInt(oPC, "ArcaneBashId") && idneeded == 1 || GetLocalInt(oPC, "ArcaneBashOn") == 0)
		return;
	if (GetLocalInt(oPC, "ArcaneBashOn") == 1)
		FloatingTextStringOnCreature("*Arcane Bash Deactivated!*", oPC, TRUE, 3.0f);
		DeleteLocalInt(oPC, "ArcaneBashOn");

	RemoveAnySpellEffects(SPELLFEAT_ARCANEBASH, oPC);

}


void Arcane_Bash(object oPC, int nSpell)
{

RemoveAnySpellEffects(SPELLFEAT_ARCANEBASH, oPC);

	AssignCommand(oPC, ClearAllActions());

	if (GetLocalInt(oPC, "ArcaneBashOn") == 1)
	{
		SendMessageToPC(oPC, "Arcane Bash is already activated. Please wait 45 seconds.");
		return;
	}

	effect eVfx = EffectNWN2SpecialEffectFile("sp_bewilderment");
	eVfx = SetEffectSpellId(eVfx, nSpell);
	eVfx = ExtraordinaryEffect(eVfx);

	if (nSpell == SPELLFEAT_ARCANEBASH)
		FloatingTextStringOnCreature("*Arcane Bash Activated!*", oPC, TRUE, 3.0f);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVfx, oPC, 45.0f);

	int id = Random(1000);

	if (nSpell == SPELLFEAT_ARCANEBASH)
		SetLocalInt(oPC, "ArcaneBashOn", 1);
	SetLocalInt(oPC, "ArcaneBashId", id);

	DelayCommand(45.0f, DeactivateArcaneBash(oPC, id, 1));	
	
}