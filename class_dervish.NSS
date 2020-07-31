#include "nwn2_inc_spells"
#include "aaa_constants"

//Made by edmaster44(DM_Odin) for the Dervish Class PRC

//Armor Bonus for Dervish
void Dervish_AC_Bonus(object oPC, int nSpell)
{
object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST,OBJECT_SELF);

if ((oArmor != OBJECT_INVALID && GetArmorRank(oArmor) == ARMOR_RANK_NONE) ||  oArmor == OBJECT_INVALID)
	{
		int nSpellId = SPELLABILITY_DERVISH_AC_BONUS;
		
		if (GetHasSpellEffect(nSpellId,oPC))
			RemoveSpellEffects(nSpellId, oPC, oPC);	
				
//Ac bonus
	int nAmount = 1;			
		int nLevel = GetLevelByClass(CLASS_DERVISH, oPC);
		if (nLevel >= 9 ) 
        {   nAmount = 2; }
	
		
		effect eAC = EffectACIncrease(nAmount,AC_DODGE_BONUS);		
		eAC = SetEffectSpellId(eAC,nSpellId);
		eAC = SupernaturalEffect(eAC);
							
		DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, oPC, HoursToSeconds(48)));
	}
	else
		SendMessageToPC(oPC, "Dervish only gain an AC bonus when wearing no armor or light armor.");


}
//A thousand cuts Feat for Dervish
void A_Thousand_Cuts(object oPC, int nSpell)
{
	effect eSlash = EffectDamageIncrease(DAMAGE_BONUS_2d6, DAMAGE_TYPE_SLASHING);
	eSlash = SupernaturalEffect(eSlash);
	eSlash = SetEffectSpellId(eSlash, SPELLABILITY_THOUSAND_CUTS );	
	DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSlash, oPC));		
}
//Defensive Parry.
void Dervish_Defensive_Parry(object oPC, int nSpell)
{

if (GetHasSpellEffect(nSpell,oPC))
			RemoveSpellEffects(nSpell, oPC, oPC);	
			
	int nAmount = 4;				
	effect eAC = EffectACIncrease(nAmount,AC_DODGE_BONUS);
	eAC = SetEffectSpellId(eAC,nSpell);
	eAC = SupernaturalEffect(eAC);
	if (GetActionMode(oPC, ACTION_MODE_COMBAT_EXPERTISE) == TRUE)
	{	DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC, oPC)); }
	 else if (GetActionMode(oCreature, ACTION_MODE_IMPROVED_COMBAT_EXPERTISE) == TRUE)
	{
		DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC, oPC));
		}
	}
