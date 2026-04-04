#include "nwn2_inc_spells"
#include "aaa_constants"
#include "ps_inc_equipment"


//Made by edmaster44(DM_Odin) for the Dervish Class PRC
// edited by FlattedFifth, made helper function, bailed on effect already existing

//helper function to qualify for dervish fx
int GetQualifiesDervishFX(object oPC, int nSpellId){
	
	if (GetLevelByClass(CLASS_STALWART_DEFENDER,oPC) >0 ){
		SendMessageToPC(oPC, "Dervish abilities will not stack with Stalwart Defender");
		return FALSE;
	}

	if (!NoHeavyArmorOrShield(oPC)){ 
		SendMessageToPC(oPC,"Dervish abilities only work when wearing no armor or light armor.");
		return FALSE;
	}
	return TRUE;
}

void Dervish_AC_Bonus(object oPC, int nSpell)
{
	int nSpellId = SPELLABILITY_DERVISH_AC_BONUS;
	//bail if they had the effect to begin with, also remove if they shouldn't have
	if (GetHasSpellEffect(nSpellId, oPC)){
		if (!GetQualifiesDervishFX(oPC, nSpellId))
			PS_RemoveEffects(oPC, nSpellId);
		
		return; 
	}
				
	//Ac bonus
	int nAmount = 1;			
	if (GetLevelByClass(CLASS_DERVISH, oPC) >= 9 ) nAmount = 2;
		
	effect eAC = EffectACIncrease(nAmount,AC_DODGE_BONUS);		
	eAC = SetEffectSpellId(eAC,nSpellId);
	eAC = SupernaturalEffect(eAC);
	SignalEvent(oPC, EventSpellCastAt(oPC, nSpellId, FALSE));						
	DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC, oPC));
}
	



//A thousand cuts Feat for Dervish
void A_Thousand_Cuts(object oPC, int nSpell)
{
	int nSpellId = SPELLABILITY_THOUSAND_CUTS;
	//bail if they had the effect to begin with, also remove if they shouldn't have
	if (GetHasSpellEffect(nSpellId, oPC)){
		if (!GetQualifiesDervishFX(oPC, nSpellId))
			PS_RemoveEffects(oPC, nSpellId);
		
		return;
	}
	
	effect eSlash = EffectDamageIncrease(DAMAGE_BONUS_2d6, DAMAGE_TYPE_SLASHING);
	eSlash = SupernaturalEffect(eSlash);
	eSlash = SetEffectSpellId(eSlash, nSpellId);
	SignalEvent(oPC, EventSpellCastAt(oPC, nSpellId, FALSE));
	DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSlash, oPC)); 
}	