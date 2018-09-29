#include "ps_inc_functions"
#include "nw_i0_spells"

void main()
{
	object oPC				= OBJECT_SELF;
	object oItem			= GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
	int iBaseItemType 		= GetBaseItemType(oItem);
	int iBonus;
	int iACBonus;
	int nSpellID; 
	
	RemoveSpellEffects(SPELLLIKE_HEAVY_ARMOR_OPTIMIZATION, oPC, oPC);
	RemoveSpellEffects(SPELLLIKE_HEAVY_ARMOR_OPTIMIZATION_GREATER, oPC, oPC);
	RemoveSpellEffects(SPELLLIKE_HEAVY_ARMOR_OPTIMIZATION_EPIC, oPC, oPC);
	
	if( iBaseItemType == BASE_ITEM_ARMOR && GetArmorRank(oItem) == ARMOR_RANK_HEAVY)
	{	if(GetHasFeat(FEAT_HEAVY_ARMOR_OPTIMIZATION_EPIC,oPC))
		{	nSpellID = SPELLLIKE_HEAVY_ARMOR_OPTIMIZATION_EPIC;
			iBonus = 5;		iACBonus = 4;	}
		else if(GetHasFeat(FEAT_HEAVY_ARMOR_OPTIMIZATION_GREATER, oPC))
		{	nSpellID = SPELLLIKE_HEAVY_ARMOR_OPTIMIZATION_GREATER;
			iBonus = 3;		iACBonus = 2;	}
		else if(GetHasFeat(FEAT_HEAVY_ARMOR_OPTIMIZATION, oPC))
		{	nSpellID = SPELLLIKE_HEAVY_ARMOR_OPTIMIZATION;
			iBonus = 1;		iACBonus = 1;	}
		else
		{	iBonus = 0;		iACBonus = 0;}
		int iArmorRulesType = GetArmorRulesType(oItem);
		string sACCheck 	= Get2DAString("armorrulestats", "ACCHECK", iArmorRulesType);
		int iACCheck		= abs(StringToInt(sACCheck));
		if (iBonus < iACCheck)
		{	iACCheck = iBonus;	}
		int iACCheckS		= iACCheck;
		if (GetHasFeat(FEAT_MARQCAMB_SILENT_METAL, oPC))
		{	string sSMCheck = Get2DAString("armorrulestats", "ACCHECK", iArmorRulesType);
			iACCheckS	= 0;	}
		effect eHide	= EffectSkillIncrease(SKILL_HIDE, iACCheckS);
		effect eSilent	= EffectSkillIncrease(SKILL_MOVE_SILENTLY, iACCheckS);
		effect eTumble	= EffectSkillIncrease(SKILL_TUMBLE, iACCheck);
		effect eParry	= EffectSkillIncrease(SKILL_PARRY, iACCheck);
		effect eTrap	= EffectSkillIncrease(SKILL_SET_TRAP, iACCheck);
		effect eAC		= EffectACIncrease(iACBonus, AC_DODGE_BONUS);
		effect eLink	= EffectLinkEffects(eHide, eSilent);
			eLink		= EffectLinkEffects(eLink, eTumble);
			eLink		= EffectLinkEffects(eLink, eParry);
			eLink		= EffectLinkEffects(eLink, eTrap);
			eLink		= EffectLinkEffects(eLink, eAC);
			eLink		= SetEffectSpellId(eLink, nSpellID);
			eLink 		= SupernaturalEffect(eLink);
		
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
		SendMessageToPC(oPC, "+" + IntToString(iACCheck) + " bonus added to armor check dependent feats.");
		SendMessageToPC(oPC, "+" + IntToString(iACBonus) + " bonus Dodge AC added.");
}	}