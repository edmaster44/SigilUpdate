#include "nwn2_inc_spells"
#include "aaa_constants"
#include "ps_inc_equipment"
#include "x2_inc_itemprop"


//Made by edmaster44(DM_Odin) for the Dervish Class PRC
// edited by FlattedFifth, made helper function, bailed on effect already existing,
// added slashing weapon requirement

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
	int bHasEffect = GetHasSpellEffect(nSpellId, oPC);
	int bQualifies = GetQualifiesDervishFX(oPC, nSpellId);
	//bail if they had the effect to begin with, also remove if they shouldn't have
	if (bHasEffect){
		if (!bQualifies)
			PS_RemoveEffects(oPC, nSpellId);
		
		return; 
	}
	if (!bQualifies)
		return;
				
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
	int bHasEffect = GetHasSpellEffect(nSpellId, oPC);
	int bQualifies = GetQualifiesDervishFX(oPC, nSpellId);
	//bail if they had the effect to begin with, also remove if they shouldn't have
	if (bHasEffect){
		if (!bQualifies)
			PS_RemoveEffects(oPC, nSpellId);
		
		return; 
	}
	if (!bQualifies)
		return;
	
	// get the right hand weapon, if not both melee and slashing, remove effect and bail
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	if (!IPGetIsMeleeWeapon(oWeapon) || !IPGetIsSlashingWeapon(oWeapon)){
		SendMessageToPC(oPC, "A Thousand Cuts only works on slashing melee weapons");
		if (bHasEffect)
			PS_RemoveEffects(oPC, nSpellId);
		return;
	}
	// get left hand weapon. If it's a weapon, check for slashing. Note that this will allow an
	// empty off hand or a torch because it will only check for slashing if it's a weapon
	oWeapon = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
	if (IPGetIsMeleeWeapon(oWeapon)){
		if (!IPGetIsSlashingWeapon(oWeapon)){
			SendMessageToPC(oPC, "A Thousand Cuts will not work if your off-hand weapon is not slashing.");
			if (bHasEffect)
				PS_RemoveEffects(oPC, nSpellId);
			return;
		}
	}
	
	
	effect eSlash = EffectDamageIncrease(DAMAGE_BONUS_2d6, DAMAGE_TYPE_SLASHING);
	eSlash = SupernaturalEffect(eSlash);
	eSlash = SetEffectSpellId(eSlash, nSpellId);
	SignalEvent(oPC, EventSpellCastAt(oPC, nSpellId, FALSE));
	DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSlash, oPC)); 
}	