#include "nw_i0_spells"

const int GOD_MODE = -9999;
const int SUPER_DAMAGE = -9998;

void ToggleGodMode(object oPC)
{
	if (GetHasSpellEffect(GOD_MODE, oPC) == TRUE)
	{
		RemoveEffectsFromSpell(oPC, GOD_MODE);
		DelayCommand(0.0f, ForceRest(oPC));
		return;
	}	
	effect eFX = EffectBonusHitpoints(20000);
	eFX = EffectLinkEffects(eFX, EffectBonusHitpoints(20000));
	eFX = EffectLinkEffects(eFX, EffectRegenerate(20000, 6.0));
	eFX = EffectLinkEffects(eFX, EffectSpellImmunity(SPELL_ALL_SPELLS));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_DEATH));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_DOMINATE));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_PARALYSIS));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_CONFUSED));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_DEAFNESS));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_BLINDNESS));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_SILENCE));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_DEAFNESS));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_SLEEP));
	eFX = EffectLinkEffects(eFX, EffectTrueSeeing());
	eFX = SupernaturalEffect(eFX);
	eFX = SetEffectSpellId(eFX, GOD_MODE);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, oPC);
}

void SuperDamage(object oPC)
{
	if (GetHasSpellEffect(SUPER_DAMAGE, oPC) == TRUE)
	{
		RemoveEffectsFromSpell(oPC, SUPER_DAMAGE);
		return;
	}
	effect eFX = EffectBABMinimum(100);
	eFX = EffectLinkEffects(eFX, EffectDamageIncrease(DAMAGE_BONUS_40, DAMAGE_TYPE_MAGICAL));
	eFX = EffectLinkEffects(eFX, EffectDamageIncrease(DAMAGE_BONUS_40, DAMAGE_TYPE_DIVINE));
	eFX = EffectLinkEffects(eFX, EffectDamageIncrease(DAMAGE_BONUS_40, DAMAGE_TYPE_POSITIVE));
	eFX = EffectLinkEffects(eFX, EffectDamageIncrease(DAMAGE_BONUS_40, DAMAGE_TYPE_NEGATIVE));
	eFX = EffectLinkEffects(eFX, EffectDamageIncrease(DAMAGE_BONUS_40, DAMAGE_TYPE_SONIC));
	eFX = SupernaturalEffect(eFX);
	eFX = SetEffectSpellId(eFX, SUPER_DAMAGE);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, oPC);
}

void OpenShop(object oPC)
{
	object oSTORE = GetObjectByTag("sigil_store");
	OpenStore(oSTORE, oPC);
}

void Relevel(object oPC)
{
	int nXP = GetXP(oPC);
	SetXP(oPC, 0);
	DelayCommand(0.0f, SetXP(oPC, nXP));
}

void Teleport(object oPC, int nINPUT)
{
	string sTELEPORT;
	switch (nINPUT)
	{
		case 1: sTELEPORT = "ysgard_castleenter"; break;
		case 2: sTELEPORT = "ysgard_topinner"; break;
		case 3: sTELEPORT = "muspel_entrance"; break;
		default: return;
	}
	object oTELEPORT = GetObjectByTag(sTELEPORT);
	if (oTELEPORT == OBJECT_INVALID) return;
	AssignCommand(oPC, JumpToObject(oTELEPORT));
}

void main (int nCOMMAND, int nINPUT)
{
	object oPC = GetPCSpeaker();
	switch (nCOMMAND)
	{
		case 0: SetLocalInt(oPC, "DIFF", nINPUT); break;
		case 1: ToggleGodMode(oPC); break;
		case 2: OpenShop(oPC); break;
		case 3: ExportSingleCharacter(oPC); break;
		case 4: Relevel(oPC); break;
		case 5: Teleport(oPC, nINPUT); break;
		case 6: SuperDamage(oPC); break;
	}
}