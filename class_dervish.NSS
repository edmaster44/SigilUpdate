#include "nwn2_inc_spells"
#include "aaa_constants"
#include "ps_inc_equipment"

//Made by edmaster44(DM_Odin) for the Dervish Class PRC

//Armor Bonus for Dervish
void Dervish_AC_Bonus(object oPC, int nSpell)
{
object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST,OBJECT_SELF);


if (GetLevelByClass(CLASS_STALWART_DEFENDER,oPC) >0 )
{ SendMessageToPC(oPC, "Your Armor Bonus will not stack with Stalwart Defender");
	return;}


if (!NoHeavyArmorOrShield(oPC))
{ SendMessageToPC(oPC,"Your Dervish AC Bonus will not function in Armor Heavier than Light");
return;}
	
		int nSpellId = SPELLABILITY_DERVISH_AC_BONUS;
		
		if (GetHasSpellEffect(nSpellId,oPC))
			RemoveSpellEffects(nSpellId, oPC, oPC);	
				
//Ac bonus
	int nAmount = 1;			
		int nLevel = GetLevelByClass(CLASS_DERVISH, oPC);
		if (nLevel >= 9 ) 
        {   nAmount = 2; }
		if (GetHasFeat(FEAT_DERVISH_DEFENSIVE_PARRY,oPC))
		{ nAmount = 5;}
	
		float fDuration = 9999.99f;
		effect eAC = EffectACIncrease(nAmount,AC_DODGE_BONUS);		
		eAC = SetEffectSpellId(eAC,nSpellId);
		eAC = SupernaturalEffect(eAC);
							
		DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, oPC, fDuration));
	}
	



//A thousand cuts Feat for Dervish
void A_Thousand_Cuts(object oPC, int nSpell)
{	



if (GetLevelByClass(CLASS_STALWART_DEFENDER,oPC) >0 )
{ SendMessageToPC(oPC, "A thousand Cuts will not stack with Stalwart Defender");
	return;}
	


object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST,OBJECT_SELF);

if (!NoHeavyArmorOrShield(oPC))
{ SendMessageToPC(oPC,"A Thousand Cuts only works when wearing no armor or light armor.");}
	
	
	int nSpellId = SPELLABILITY_THOUSAND_CUTS;
	
	if (GetHasSpellEffect(nSpellId,oPC))
		RemoveSpellEffects(nSpellId, oPC, oPC);	
	float fDuration = 9999.99f;
	effect eSlash = EffectDamageIncrease(DAMAGE_BONUS_2d6, DAMAGE_TYPE_SLASHING);
	eSlash = SupernaturalEffect(eSlash);
	eSlash = SetEffectSpellId(eSlash, nSpellId );	
	DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSlash, oPC,fDuration)); 
	
		
		
}
//Defensive Parry.
/* void Dervish_Defensive_Parry(object oPC, int nSpell)
{
int nSpell = SPELLABILITY_DERVISH_DEFENSIVE_PARRY;
int nAction = GetCurrentAction(oPC);
	if (GetHasSpellEffect(nSpell,oPC))
				{
					RemoveSpellEffects(nSpell, OBJECT_SELF, oPC);	
					SendMessageToPC(oPC, "Defensive Parry disabled.");
					}
		if (GetHasFeat(FEAT_DERVISH_DEFENSIVE_PARRY,oPC))
			{
			if (nAction == ACTION_MODE_COMBAT_EXPERTISE || nAction== ACTION_MODE_IMPROVED_COMBAT_EXPERTISE)
			{
				
						effect eDefParry = EffectACIncrease(4);
						eDefParry = SetEffectSpellId(eDefParry, nSpell);
						eDefParry = SupernaturalEffect(eDefParry);
						DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDefParry, oPC, HoursToSeconds(24)));			
						SendMessageToPC(oPC, "Defensive Parry enabled.");						
				}
}
} */