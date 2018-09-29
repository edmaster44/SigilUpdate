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

void main()
{
    //Declare major variables
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
	
	if (GetHasFeat(WILDSHAPE_BGFEAT_WOODLAND,OBJECT_SELF,TRUE) == TRUE) 
		iWildshapeBGFeat = WILDSHAPE_BGFEAT_WOODLAND;
	if (GetHasFeat(WILDSHAPE_BGFEAT_ELEMENTAL,OBJECT_SELF,TRUE) == TRUE) 
		iWildshapeBGFeat = WILDSHAPE_BGFEAT_ELEMENTAL;
	if (GetHasFeat(WILDSHAPE_BGFEAT_JUNGLE,OBJECT_SELF,TRUE) == TRUE) 
		iWildshapeBGFeat = WILDSHAPE_BGFEAT_JUNGLE;
	if (GetHasFeat(WILDSHAPE_BGFEAT_DESERT,OBJECT_SELF,TRUE) == TRUE) 
		iWildshapeBGFeat = WILDSHAPE_BGFEAT_DESERT;
	if (GetHasFeat(WILDSHAPE_BGFEAT_UNDERDARK,OBJECT_SELF,TRUE) == TRUE) 
		iWildshapeBGFeat = WILDSHAPE_BGFEAT_UNDERDARK;
	if (GetHasFeat(WILDSHAPE_BGFEAT_COLD,OBJECT_SELF,TRUE) == TRUE) 
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
    ePoly = SupernaturalEffect(ePoly);
	ePoly = EffectLinkEffects( ePoly, eVis );
	ePoly = SupernaturalEffect(ePoly);
		
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_WILD_SHAPE, FALSE));

    int bWeapon = StringToInt(Get2DAString("polymorph","MergeW",nPoly)) == 1;
    int bArmor  = StringToInt(Get2DAString("polymorph","MergeA",nPoly)) == 1;
    int bItems  = StringToInt(Get2DAString("polymorph","MergeI",nPoly)) == 1;

    object oWeaponOld = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
    object oArmorOld = GetItemInSlot(INVENTORY_SLOT_CHEST,OBJECT_SELF);
    object oRing1Old = GetItemInSlot(INVENTORY_SLOT_LEFTRING,OBJECT_SELF);
    object oRing2Old = GetItemInSlot(INVENTORY_SLOT_RIGHTRING,OBJECT_SELF);
    object oAmuletOld = GetItemInSlot(INVENTORY_SLOT_NECK,OBJECT_SELF);
    object oCloakOld  = GetItemInSlot(INVENTORY_SLOT_CLOAK,OBJECT_SELF);
    object oBootsOld  = GetItemInSlot(INVENTORY_SLOT_BOOTS,OBJECT_SELF);
    object oBeltOld = GetItemInSlot(INVENTORY_SLOT_BELT,OBJECT_SELF);
    object oHelmetOld = GetItemInSlot(INVENTORY_SLOT_HEAD,OBJECT_SELF);
    object oShield    = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,OBJECT_SELF);
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
    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, OBJECT_SELF, HoursToSeconds(nDruidLevel));
	
	// Now get VFX that should really be applied
	string sVFX = Get2DAString("polymorph", "VFX", nPoly);
	if (sVFX != "")
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectNWN2SpecialEffectFile(sVFX), OBJECT_SELF, HoursToSeconds(nDruidLevel));

    object oWeaponNew = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,OBJECT_SELF);
	object oWeaponNew1 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,OBJECT_SELF);
    object oWeaponNew2 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,OBJECT_SELF);
    object oArmorNew = GetItemInSlot(INVENTORY_SLOT_CARMOUR,OBJECT_SELF);

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