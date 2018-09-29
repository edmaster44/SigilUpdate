//::///////////////////////////////////////////////
//:: Holy Sword
//:: X2_S0_HolySwrd
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*  Grants holy avenger properties.	*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 28, 2002
//:://////////////////////////////////////////////
//:: Updated by Andrew Nobbs May 08, 2003
//:: 2003-07-07: Stacking Spell Pass, Georg Zoeller
//:: PKM-OEI 07.08.06: VFX update for NWN2

#include "ps_inc_functions"
#include "x2_inc_itemprop"
#include "x2_inc_spellhook"
#include "x2_inc_toollib"

const int IP_CONST_ONHIT_CASTSPELL_HOLYSWORD = 146;

// This part is needed to prevent a bug that will temporarly remove +EB from weapon if it's already at +nEB
int CanBeEnhanced(object oWEAPON, int nEB)
{
	itemproperty iPROP = GetFirstItemProperty(oWEAPON);
	while (GetIsItemPropertyValid(iPROP) == TRUE)
	{
		if (GetItemPropertyType(iPROP) == ITEM_PROPERTY_ENHANCEMENT_BONUS)
		{
			if (GetItemPropertyDurationType(iPROP) == DURATION_TYPE_PERMANENT)
			{
				if (GetItemPropertyCostTableValue(iPROP) >= nEB) return FALSE;
			}
		}
		iPROP = GetNextItemProperty(oWEAPON);
	}
	return TRUE;
}

void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!X2PreSpellCastCode()) return;
	
	//Declar major variables
	object oPC = OBJECT_SELF;
	object oWEAPON = IPGetTargetedOrEquippedMeleeWeapon();
	
	//Run the spell if target is a valid a weapon
    if (GetIsObjectValid(oWEAPON) == FALSE) FloatingTextStrRefOnCreature(83615, oPC);
	else
    {
		int nLVL = PS_GetCasterLevel(oPC);
		float fDUR = RoundsToSeconds(nLVL);
		if (GetLastSpellCastClass() == CLASS_TYPE_PALADIN) fDUR = fDUR * 10.0;
		if (GetMetaMagicFeat() == METAMAGIC_EXTEND) fDUR = fDUR * 2.0;
		object oTARGET = GetSpellTargetObject();
        SignalEvent(oWEAPON, EventSpellCastAt(oPC, GetSpellId(), FALSE));
		effect eVFX = EffectVisualEffect(VFX_DUR_SPELL_HOLY_SWORD);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, GetItemPossessor(oWEAPON), fDUR);
		if (CanBeEnhanced(oWEAPON, 5) == TRUE) IPSafeAddItemProperty(oWEAPON, ItemPropertyEnhancementBonus(5), fDUR);
		IPSafeAddItemProperty(oWEAPON, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_HOLYSWORD, nLVL), fDUR);
		IPSafeAddItemProperty(oWEAPON, ItemPropertyVisualEffect(ITEM_VISUAL_HOLY), fDUR);
        TLVFXPillar(VFX_IMP_GOOD_HELP, GetLocation(oTARGET), 4, 0.0f, 6.0f);
        DelayCommand(1.0f, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SUNSTRIKE), GetLocation(oTARGET)));
    }
}