//New Dragon form setup

#include "x2_inc_itemprop"

void main()
{

    int nSpell = GetSpellId();
    object oCreature = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_DUR_POLYMORPH);
	eVis = SupernaturalEffect(eVis);
    effect ePoly;
    int nPoly = POLYMORPH_TYPE_COW;	
    int nMetaMagic = GetMetaMagicFeat();
    int nDuration = GetCasterLevel(oCreature);
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }


    if (nSpell == 707)
    {
        nPoly = POLYMORPH_TYPE_RED_DRAGON;

        if (nDuration >= 27)
        {
            nPoly = 380;
        }
    }
    else if (nSpell == 708)
    {
        nPoly = POLYMORPH_TYPE_BLUE_DRAGON;
        if (nDuration >= 27)
        {
            nPoly = 376;
        }
    }
    else if (nSpell == 709)
    {
        nPoly = POLYMORPH_TYPE_BLACK_DRAGON;
        if (nDuration >= 27)
        {
            nPoly = 377;
        }
}
    else
    {
        nPoly = 313;
        if (nDuration >= 27)
        {
            nPoly = 378;
        }
    }

    ePoly = EffectPolymorph(nPoly, FALSE, TRUE);	// AFW-OEI 11/27/2006: Use 3rd boolean to say this is a wildshape polymorph.
	ePoly = EffectLinkEffects( ePoly, eVis );
	ePoly = SupernaturalEffect(ePoly);
		
    //Fire cast spell at event for the specified target
    SignalEvent(oCreature, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_WILD_SHAPE, FALSE));

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
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, OBJECT_SELF, HoursToSeconds(nDuration));
	
	// Now get VFX that should really be applied
	string sVFX = Get2DAString("polymorph", "VFX", nPoly);
	if (sVFX != "")
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectNWN2SpecialEffectFile(sVFX), OBJECT_SELF, HoursToSeconds(nDuration));

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