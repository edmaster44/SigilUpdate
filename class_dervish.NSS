#include "x2_inc_spellhook"
#include "aaa_constants"
#include "X0_I0_SPELLS"
#include "nw_i0_spells"


//Made by edmaster44(DM_Odin) for the Dervish Class PRC

//Armor Bonus for Dervish
void Dervish_AC_Bonus(object oPC, int nSpell)
{
object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST,OBJECT_SELF);

if ((oArmor != OBJECT_INVALID && GetArmorRank(oArmor) == ARMOR_RANK_NONE) ||  oArmor == OBJECT_INVALID)
	{
		
				
//Ac bonus
	int nAmount = 1;			
		int nLevel = GetLevelByClass(CLASS_DERVISH, oPC);
		if (nLevel >= 9 ) 
        {   nAmount = 2; }
	
		float fDuration = 9999.99f;
		effect eAC = EffectACIncrease(nAmount,AC_DODGE_BONUS);		
		eAC = SetEffectSpellId(eAC,nSpell);
		eAC = SupernaturalEffect(eAC);
							
		DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, oPC, fDuration));
	}
	else
		SendMessageToPC(oPC, "Dervish only gain an AC bonus when wearing no armor or light armor.");


}
//A thousand cuts Feat for Dervish
void A_Thousand_Cuts(object oPC, int nSpell)
{	
	float fDuration = 9999.99f;
	effect eSlash = EffectDamageIncrease(DAMAGE_BONUS_2d6, DAMAGE_TYPE_SLASHING);
	eSlash = SupernaturalEffect(eSlash);
	eSlash = SetEffectSpellId(eSlash, nSpell);	
	DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSlash, oPC,fDuration));		
}
//Defensive Parry.
void Dervish_Defensive_Parry(object oPC, int nSpell)
{
if (GetHasFeat(FEAT_DERVISH_DEFENSIVE_PARRY, oPC))
		{
			if (GetActionMode(oPC, ACTION_MODE_COMBAT_EXPERTISE) || GetActionMode(oPC, ACTION_MODE_IMPROVED_COMBAT_EXPERTISE)  )
			{
				if (!GetHasSpellEffect(nSpell,oPC))
				{
						effect eDefParry = EffectACIncrease(4);
						eDefParry = SetEffectSpellId(eDefParry, nSpell);
						eDefParry = SupernaturalEffect(eDefParry);
						DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDefParry, oPC, HoursToSeconds(24)));			
						SendMessageToPC(oPC, "Defensive Parry enabled.");						
				}
			}
			else
			{
				if (GetHasSpellEffect(nSpell,oPC))
				{
					RemoveSpellEffects(nSpell, OBJECT_SELF, oPC);
					SendMessageToPC(oPC, "Defensive Parry disabled.");						
				}
	}
	}
	}