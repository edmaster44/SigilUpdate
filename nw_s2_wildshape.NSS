//::///////////////////////////////////////////////
//:: Wild Shape
//:: NW_S2_WildShape
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Allows the Druid to change into animal forms.

    Updated: Sept 30 2003, Georg Z.
      * Made Armor merge with druid to make forms
        more useful.

*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 22, 2002
//:://////////////////////////////////////////////
//:: AFW-OEI 06/08/2006:
//::	Remove panther
//:: AFW-OEI 07/29/2006:
//:: 	Default to brown bear
#include "x2_inc_itemprop"
#include "x2_inc_spellhook"

void RemoveMonkAC(object oPC){
	if (GetLevelByClass(CLASS_TYPE_MONK, oPC) == 0)
		return;
	else if (PS_GetHasEffectById(oPC, SPELLABILITY_WILD_SHAPE)){
		if (!PS_GetHasEffectById(oPC, 4727)){ //id 4727 reserved for monk ac penalty
			int nWis = GetAbilityModifier(ABILITY_WISDOM, oPC);
			effect ePenalty = EffectACDecrease(nWis, AC_SHIELD_ENCHANTMENT_BONUS);
			ePenalty = SetEffectSpellId(ePenalty, 4727);
			ePenalty = SupernaturalEffect(ePenalty);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePenalty, oPC, HoursToSeconds(24));
		}
		DelayCommand(3.0, RemoveMonkAC(oPC));
	} else PS_RemoveEffects(oPC, 4727);
}

void main()
{
    //Declare major variables
	object oPC = OBJECT_SELF;
	
	if (GetAlignmentLawChaos(oPC) != ALIGNMENT_NEUTRAL && 
		GetAlignmentGoodEvil(oPC) != ALIGNMENT_NEUTRAL){
		SendMessageToPC(oPC, "Your alignment has strayed too far from Balance to use Wildshape.");
		return;
	}

	int nSpell = GetSpellId(); 

	
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_DUR_POLYMORPH);
	eVis = SupernaturalEffect(eVis);	// AFW-OEI 12/07/2006: Make it so you can't dispel the visual effect, which was dispelling wildshape.
    effect ePoly;
    int nPoly = POLYMORPH_TYPE_COW;	// AFW-OEI 06/08/2006: Default -- something's gone wrong if you actually become a cow.
    int nMetaMagic = GetMetaMagicFeat();
    int nDruidLevel = GetLevelByClass(CLASS_TYPE_DRUID);
    
	
	// Just setup some consts here.. bad Loki, bad!
	int WILDSHAPE_BGFEAT_WOODLAND = 2853;
	int WILDSHAPE_BGFEAT_ELEMENTAL = 2854;
	int WILDSHAPE_BGFEAT_JUNGLE = 2855;
	int WILDSHAPE_BGFEAT_DESERT = 2856;
	int WILDSHAPE_BGFEAT_UNDERDARK = 2857;
	int WILDSHAPE_BGFEAT_COLD = 2858;
	int iWildshapeBGFeat = 0;
	
	if (GetHasFeat(WILDSHAPE_BGFEAT_WOODLAND,oPC,TRUE) == TRUE) 
		iWildshapeBGFeat = WILDSHAPE_BGFEAT_WOODLAND;
	if (GetHasFeat(WILDSHAPE_BGFEAT_ELEMENTAL,oPC,TRUE) == TRUE) 
		iWildshapeBGFeat = WILDSHAPE_BGFEAT_ELEMENTAL;
	if (GetHasFeat(WILDSHAPE_BGFEAT_JUNGLE,oPC,TRUE) == TRUE) 
		iWildshapeBGFeat = WILDSHAPE_BGFEAT_JUNGLE;
	if (GetHasFeat(WILDSHAPE_BGFEAT_DESERT,oPC,TRUE) == TRUE) 
		iWildshapeBGFeat = WILDSHAPE_BGFEAT_DESERT;
	if (GetHasFeat(WILDSHAPE_BGFEAT_UNDERDARK,oPC,TRUE) == TRUE) 
		iWildshapeBGFeat = WILDSHAPE_BGFEAT_UNDERDARK;
	if (GetHasFeat(WILDSHAPE_BGFEAT_COLD,oPC,TRUE) == TRUE) 
		iWildshapeBGFeat = WILDSHAPE_BGFEAT_COLD;
	
	// Now let's figure out the value of nPolymorph
	int iPolyBase = 314; //Basic Druid Weak STR form at 314.
	// Let's turn those feat numbers into something we can work with.  If none of the feats we have 0 (offset)
	// so let's reduce the WOODLAND feat to equial 1...
	// and this is so not going to be extendtable if someone takes further polymporph slots (likely) or further
	// feat slots (possible), but its a nice shortcut for now...
	if (iWildshapeBGFeat != 0)
		iWildshapeBGFeat = iWildshapeBGFeat - WILDSHAPE_BGFEAT_WOODLAND	+ 1; // woodland = 1 then, elemental 2 etc.

	// now, which form do we want? 401=STR, 403=DEX, 404=CON, 405=STR.  That's a pain, let's make them 0-3.
	
	if (nSpell == 401)
	{ 
		nSpell = 0;
	}
	else if (nSpell > 402 & nSpell < 406)
	{
		nSpell = nSpell - 402;
	}
	else
	{
		// need a hack/catch for right click wildshape which seems to pass undetermined value.
		// in this case, they get the bear equivalent.
		nSpell = 0;
	}
	
	int iDireFormOffset = 0;
	if (nDruidLevel >= 12)
	{
		// we want the Dire forms, which are 4 higher in the list than their basic forms
		iDireFormOffset = 4;
	}
	
	// Now comes the clever part.  Well... i think its clever!!!
	nPoly = iPolyBase + (iWildshapeBGFeat * 8) + iDireFormOffset + nSpell;
	
		
/*				
    if (nSpell == 403)
    {
        nPoly = POLYMORPH_TYPE_WOLF;

        if (nDuration >= 12)
        {
            nPoly = POLYMORPH_TYPE_DIRE_WOLF;
        }
    }
    else if (nSpell == 404)
    {
        nPoly = POLYMORPH_TYPE_BOAR;
        if (nDuration >= 12)
        {
            nPoly = POLYMORPH_TYPE_DIRE_BOAR;
        }
    }
    else if (nSpell == 405)
    {
        nPoly = POLYMORPH_TYPE_BADGER;
        if (nDuration >= 12)
        {
            nPoly = POLYMORPH_TYPE_DIRE_BADGER;
        }
    }
    else
	// actually spell ID = 401
    {
        nPoly = POLYMORPH_TYPE_BROWN_BEAR;
        if (nDuration >= 12) 
        {
            nPoly = POLYMORPH_TYPE_DIRE_BROWN_BEAR;
        }
    }
*/

    ePoly = EffectPolymorph(nPoly, FALSE, TRUE);	// AFW-OEI 11/27/2006: Use 3rd boolean to say this is a wildshape polymorph.
	ePoly = EffectLinkEffects( ePoly, eVis );
	ePoly = SetEffectSpellId(ePoly, SPELLABILITY_WILD_SHAPE);
	ePoly = SupernaturalEffect(ePoly);
		
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(oPC, SPELLABILITY_WILD_SHAPE, FALSE));

    int bWeapon = StringToInt(Get2DAString("polymorph","MergeW",nPoly)) == 1;
    int bArmor  = StringToInt(Get2DAString("polymorph","MergeA",nPoly)) == 1;
    int bItems  = StringToInt(Get2DAString("polymorph","MergeI",nPoly)) == 1;

    object oWeaponOld = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
    object oArmorOld = GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
    object oRing1Old = GetItemInSlot(INVENTORY_SLOT_LEFTRING,oPC);
    object oRing2Old = GetItemInSlot(INVENTORY_SLOT_RIGHTRING,oPC);
    object oAmuletOld = GetItemInSlot(INVENTORY_SLOT_NECK,oPC);
    object oCloakOld  = GetItemInSlot(INVENTORY_SLOT_CLOAK,oPC);
    object oBootsOld  = GetItemInSlot(INVENTORY_SLOT_BOOTS,oPC);
    object oBeltOld = GetItemInSlot(INVENTORY_SLOT_BELT,oPC);
    object oHelmetOld = GetItemInSlot(INVENTORY_SLOT_HEAD,oPC);
    object oShield    = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
    if (GetIsObjectValid(oShield))
    {
        if (GetBaseItemType(oShield) !=BASE_ITEM_LARGESHIELD &&
            GetBaseItemType(oShield) !=BASE_ITEM_SMALLSHIELD &&
            GetBaseItemType(oShield) !=BASE_ITEM_TOWERSHIELD)
        {
            oShield = OBJECT_INVALID;
        }
    }




    //Apply the VFX impact and effects
    ClearAllActions(); // prevents an exploit
    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, oPC, HoursToSeconds(nDruidLevel));
	
	// apply the removal of monk ac bonus
	//DelayCommand(3.0, RemoveMonkAC(oPC)); // is this unnecessary? Is server exts doing this already?
	
	// Now get VFX that should really be applied
	string sVFX = Get2DAString("polymorph", "VFX", nPoly);
	if (sVFX != "")
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectNWN2SpecialEffectFile(sVFX), oPC, HoursToSeconds(nDruidLevel));

    object oWeaponNew = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oPC);
	object oWeaponNew1 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oPC);
    object oWeaponNew2 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oPC);
    object oArmorNew = GetItemInSlot(INVENTORY_SLOT_CARMOUR,oPC);

    if (bWeapon)
    {
            IPWildShapeCopyItemProperties(oWeaponOld,oWeaponNew, TRUE);
            IPWildShapeCopyItemProperties(oWeaponOld,oWeaponNew1, TRUE);
            IPWildShapeCopyItemProperties(oWeaponOld,oWeaponNew2, TRUE);	
    }
    if (bArmor)
    {
        IPWildShapeCopyItemProperties(oShield,oArmorNew);
        IPWildShapeCopyItemProperties(oHelmetOld,oArmorNew);
        IPWildShapeCopyItemProperties(oArmorOld,oArmorNew);
    }
    if (bItems)
    {
        IPWildShapeCopyItemProperties(oRing1Old,oArmorNew);
        IPWildShapeCopyItemProperties(oRing2Old,oArmorNew);
        IPWildShapeCopyItemProperties(oAmuletOld,oArmorNew);
        IPWildShapeCopyItemProperties(oCloakOld,oArmorNew);
        IPWildShapeCopyItemProperties(oBootsOld,oArmorNew);
        IPWildShapeCopyItemProperties(oBeltOld,oArmorNew);
    }
	
}