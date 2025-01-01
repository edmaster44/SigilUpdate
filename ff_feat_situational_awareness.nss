#include "nw_i0_spells"
#include "x2_inc_spellhook"


// IMPORTANT: If DisableTumbleAC in xp_dae.ini is set to 0, this constant should be set to FALSE.
// If DisableTumbleAC in xp_dae.ini is set to 1, this should be set to TRUE. Otherwise this 
// feat will not give the correct AC if the character has tumble skill ( for example, for a class or feat 
// prerequisite). Other settings of DisableTumbleAC not recommended with this feat. 
// Best results in terms of not only this feat but also overall pve balance is probably 
// DisableTumbleAC = 0 and this constant FALSE.
const int TUMBLE_DISABLED_BY_DAE = FALSE;

void main(){
	int nId = GetSpellId();
	object oPC = OBJECT_SELF;
	
	RemoveEffectsFromSpell(oPC, nId);
	
	int nLevel = GetHitDice(oPC);
	int nTumble = GetSkillRank(SKILL_TUMBLE, oPC, TRUE);
	int nAcFromLvl = (nLevel + 3) / 10;
	int nAcFromTumble = nTumble / 10;
	int nAC = nAcFromLvl - nAcFromTumble;
	if (TUMBLE_DISABLED_BY_DAE) nAC = nAcFromLvl;
	if (nAC > 0){
		effect eAC = EffectACIncrease(nAC, AC_DODGE_BONUS, AC_VS_DAMAGE_TYPE_ALL);
		eAC = SupernaturalEffect(eAC);
		eAC = SetEffectSpellId(eAC, nId);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC, oPC);
	}
}