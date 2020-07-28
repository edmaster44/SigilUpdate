#include "nwn2_inc_spells"
#include "aaa_constants"

//Made by edmaster44(DM_Odin)


//void Dervish_Slash(oPC, nSpell)
//{
		
//	effect eSlash = EffectDamageIncrease(DAMAGE_BONUS_2d6, DAMAGE_TYPE_SLASHING);
//	eSlash = SupernaturalEffect(eSlash);
//	eSlash = SetEffectSpellId(eSlash, SPELLABILITY_THOUSAND_CUTS );	
//	float fDuration = RoundsToSeconds(10);
//	DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSlash, OBJECT_SELF, fDuration));		
//}

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
	
		
		effect eLink = EffectACIncrease(nAmount);		
		eLink = SetEffectSpellId(eLink,nSpellId);
		eLink = SupernaturalEffect(eLink);
							
		DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, HoursToSeconds(48)));
	}
	else
		SendMessageToPC(oPC, "Dervish only gain an AC bonus when wearing no armor or light armor.");


}