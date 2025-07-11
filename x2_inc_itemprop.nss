//v1.00

//::///////////////////////////////////////////////
//:: Item Property Functions
//:: x2_inc_itemprop
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*

    Holds item property and item modification
    specific code.

    If you look for anything specific to item
    properties, your chances are good to find it
    in here.

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-06-05
//:: Last Update: 2003-10-07
//:://////////////////////////////////////////////
//  ChazM 4/17/06 Updated IPGetItemPropertyByID()
//  ChazM 10/16/06 fixed ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP and ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT in IPGetItemPropertyByID()
//  ChazM 11/13/06 fixed ITEM_PROPERTY_SPELL_RESISTANCE, ITEM_PROPERTY_DAMAGE_VULNERABILITY, ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC in IPGetItemPropertyByID() (found by Webscav)
// ChazM-OEI 3/21/07 - Added support for ItemPropertyBonusHitpoints()
// ChazM 7/2/07 - Removed constant (now in NWSCRIPT)
// Added new creature weapons to 

//void main(){}
// *  The tag of the ip work container, a placeable which has to be set into each
// *  module that is using any of the crafting functions.


#include "aaa_constants"

const string  X2_IP_WORK_CONTAINER_TAG = "x2_plc_ipbox";
// *  2da for the AddProperty ItemProperty
const string X2_IP_ADDRPOP_2DA = "des_crft_props" ;
// *  2da for the Poison Weapon Itemproperty
const string X2_IP_POISONWEAPON_2DA = "des_crft_poison" ;
// *  2da for armor appearance
const string X2_IP_ARMORPARTS_2DA = "des_crft_aparts" ;
// *  2da for armor appearance
const string X2_IP_ARMORAPPEARANCE_2DA = "des_crft_appear" ;

// * Base custom token for item modification conversations (do not change unless you want to change the conversation too)
const int    XP_IP_ITEMMODCONVERSATION_CTOKENBASE = 12220;
const int    X2_IP_ITEMMODCONVERSATION_MODE_TAILOR = 0;
const int    X2_IP_ITEMMODCONVERSATION_MODE_CRAFT = 1;

// * Number of maximum item properties allowed on most items
const int    X2_IP_MAX_ITEM_PROPERTIES = 8;

// *  Constants used with the armor modification system
const int    X2_IP_ARMORTYPE_NEXT = 0;
const int    X2_IP_ARMORTYPE_PREV = 1;
const int    X2_IP_ARMORTYPE_RANDOM = 2;
const int    X2_IP_WEAPONTYPE_NEXT = 0;
const int    X2_IP_WEAPONTYPE_PREV = 1;
const int    X2_IP_WEAPONTYPE_RANDOM = 2;

// *  Policy constants for IPSafeAddItemProperty()
const int    X2_IP_ADDPROP_POLICY_REPLACE_EXISTING = 0;
const int    X2_IP_ADDPROP_POLICY_KEEP_EXISTING = 1;
const int    X2_IP_ADDPROP_POLICY_IGNORE_EXISTING =2;

// * Base Item Constants for Creature Equipped Weapons - Added by Ceremorph
// * These are all the old creature weapons
const int	BASE_ITEM_CREEQ_SLASH_M		= 160;
const int	BASE_ITEM_CREEQ_PIERC_M		= 161;
const int	BASE_ITEM_CREEQ_BLUDG_M		= 162;
const int	BASE_ITEM_CREEQ_SLASH_S		= 163;
const int	BASE_ITEM_CREEQ_PIERC_S		= 164;
const int	BASE_ITEM_CREEQ_BLUDG_S		= 165;
const int	BASE_ITEM_CREEQ_SLASH_L		= 166;
const int	BASE_ITEM_CREEQ_PIERC_L		= 167;
const int	BASE_ITEM_CREEQ_BLUDG_L		= 168;
const int	BASE_ITEM_CREEQ_PRCSL_M		= 169;
const int	BASE_ITEM_CREEQ_PRCSL_S		= 170;
const int 	BASE_ITEM_CREEQ_PRCSL_L		= 171;
const int	BASE_ITEM_CREEQ_PRCBL_M		= 172;
const int 	BASE_ITEM_CREEQ_PRCBL_S		= 173;
const int 	BASE_ITEM_CREEQ_PRCBL_L		= 174;

//New creature weapons
const int 	BASE_ITEM_CREEQ_CLAW		= 176;
const int 	BASE_ITEM_CREEQ_BITE		= 177;
const int 	BASE_ITEM_CREEQ_SLAM		= 178;
const int 	BASE_ITEM_CREEQ_CLAW_LARGE	= 179;
//Someone had made this medium, thereby making the resref with _lrg a lie and therefore misleanding in the toolset, and 
//making it large again would have screwed it up for players who have it already and depend on it being medium
const int 	BASE_ITEM_CREEQ_BITE_LARGE	= 180; 
const int 	BASE_ITEM_CREEQ_CLAW_TINY	= 181;
const int 	BASE_ITEM_CREEQ_SLAM_TINY	= 182;
const int 	BASE_ITEM_CREEQ_SLAM_MED	= 183;
const int 	BASE_ITEM_CREEQ_BITE_TINY	= 184;
const int 	BASE_ITEM_CREEQ_BITE_LRG	= 185; //New large

int IPGetIsWeapon(object oItem, int nItem = -1);


//get the max stack size of the item
int IPGetMaxStackSize(object oItem);

// what it says on the box. returns true if the 2 itemproperties are the same
int IPGetItemPropertiesIdentical(itemproperty ip1, itemproperty ip2, int bIgnoreDuration = FALSE);

// returns true if the item is any craftable item that can have a metal component
int IPGetIsForgedItem(object oItem, int nItem = -1);

// returns true if item is a thrown quiver or ammo quiver
int IPGetIsQuiver(object oItem, int nItem = -1);

// *  returns true if weapon is blugeoning (used for poison)
// If you only have the id because you're checking in the general instead 
// of a specific object,enter OBJECT_INVALID for oItem. Set bOnly to FALSE
// if you want to include weapons that are both bludgeoning and piercing,
// like morningstar
int IPGetIsBludgeoningWeapon(object oItem, int nItem = -1, int bOnly = TRUE);

// Returns TRUE if a creature weapon.
// If you only have the id because you're checking in the general instead 
// of a specific object, enter OBJECT_INVALID for oItem.
int IPGetIsCreatureEquippedWeapon(object oItem, int nItem = -1);

// *  return TRUE if oItem is a melee weapon
// If you only have the id because you're checking in the general instead 
// of a specific object,enter OBJECT_INVALID for oItem.
int IPGetIsMeleeWeapon(object oItem, int nItem = -1);

// *  returns true if weapon is piercing
// If you only have the id because you're checking in the general instead 
// of a specific object,enter OBJECT_INVALID for oItem. Set bOnly to FALSE
// if you want to include weapons that are both bludgeoning and piercing,
// like morningstar, and both slashing and piercing, like halberd
int IPGetIsPiercingWeapon(object oItem, int nItem = -1, int bOnly = TRUE);

// *  return TRUE if oItem is a projectile or projectile quiver
// If you only have the id because you're checking in the general instead 
// of a specific object,enter OBJECT_INVALID for oItem.
int IPGetIsProjectile(object oItem, int nItem = -1);

// *  return TRUE if oItem is a thrown or thrown quiver
// If you only have the id because you're checking in the general instead 
// of a specific object,enter OBJECT_INVALID for oItem.
int IPGetIsThrownWeapon(object oItem, int nItem = -1);


// only returns true on bow, xbow, and sling
// If you only have the id because you're checking in the general instead 
// of a specific object,enter OBJECT_INVALID for oItem.
int IPGetIsLauncher(object oItem, int nItem = -1);

// *  returns TRUE if oItem is a bow, xbow, sling, thrown, or thrown quiver
// If you only have the id because you're checking in the general instead 
// of a specific object, enter OBJECT_INVALID for oItem.
int IPGetIsRangedWeapon(object oItem, int nItem = -1);

//Get is instrument
int IPGetIsInstrument(object oItem, int nItem = -1);


// *  returns true if weapon is slashing
// If you only have the id because you're checking in the general instead 
// of a specific object,enter OBJECT_INVALID for oItem. Set bOnly to FALSE
// if you want to include weapons that are both slashing and piercing, like halberd
int IPGetIsSlashingWeapon(object oItem, int nItem = -1, int bOnly = TRUE);

// gets the weapon size category from baseitems.2da. Returns -1 on error. If you
// If you only have the id because you're checking in the general instead 
// of a specific object,enter OBJECT_INVALID for oItem.
int IPGetWeaponSize(object oItem, int nItem = -1);

// return the content of the new "WeaponCategory" column of baseitems.2da
// If you only have the id because you're checking in the general instead 
// of a specific object,enter OBJECT_INVALID for oItem.
string IPGetWeaponCategory(object oItem, int nItem = -1);


// *  removes all itemproperties with matching nItemPropertyType and nItemPropertyDuration
void  IPRemoveMatchingItemProperties( object oItem, int nItemPropertyType, int nItemPropertyDuration = DURATION_TYPE_TEMPORARY, int nItemPropertySubType = -1 );

// *  Removes ALL item properties from oItem matching nItemPropertyDuration
void  IPRemoveAllItemProperties( object oItem, int nItemPropertyDuration = DURATION_TYPE_TEMPORARY );

// *  returns TRUE if item can be equipped.
// *  Uses Get2DAString, so do not use in a loop!
int IPGetIsItemEquipable(object oItem, int nBaseType = -1);

// *  Changes the color of an item armor
// *  oItem        - The armor
// *  nColorType   - ITEM_APPR_ARMOR_COLOR_* constant
// *  nColor       - color from 0 to 63
// *  Since oItem is destroyed in the process, the function returns
// *  the item created with the color changed
object IPDyeArmor( object oItem, int nColorType, int nColor );

// *  Returns the container used for item property and appearance modifications in the
// *  module. If it does not exist, create it.
object IPGetIPWorkContainer( object oCaller = OBJECT_SELF );

// *  This function needs to be rather extensive and needs to be updated if there are new
// *  ip types we want to use, but it goes into the item property include anyway
itemproperty IPGetItemPropertyByID( int nPropID, int nParam1 = 0, int nParam2 = 0, int nParam3 = 0, int nParam4 = 0 );

// *  Return the IP_CONST_CASTSPELL_* ID matching to the SPELL_* constant given in nSPELL_ID
// *  This uses Get2DAString, so it is slow. Avoid using in loops!
// *  returns -1 if there is no matching property for a spell
int IPGetIPConstCastSpellFromSpellID(int nSpellID, int nCasterLvl = 1);

// *  Returns TRUE if an item has ITEM_PROPERTY_ON_HIT and the specified nSubType
// *  possible values for nSubType can be taken from IPRP_ONHIT.2da
// *  popular ones:
// *  5 - Daze   19 - ItemPoison   24 - Vorpal
int   IPGetItemHasItemOnHitPropertySubType( object oTarget, int nSubType );

// *  Returns the number of possible armor part variations for the specified part
// *  nPart - ITEM_APPR_ARMOR_MODEL_* constant
// *  Uses Get2DAString, so do not use in loops
int   IPGetNumberOfAppearances( int nPart );

// *  Returns the next valid appearance type for oArmor
// *  nPart - ITEM_APPR_ARMOR_MODEL_* constant
// *  Uses Get2DAString, so do not use in loops
int   IPGetNextArmorAppearanceType(object oArmor, int nPart);

// *  Returns the previous valid appearance type for oArmor
// *  nPart - ITEM_APPR_ARMOR_MODEL_* constant
// *  Uses Get2DAString, so do not use in loops
int   IPGetPrevArmorAppearanceType(object oArmor, int nPart);

// *  Returns a random valid appearance type for oArmor
// *  nPart - ITEM_APPR_ARMOR_MODEL_* constant
// *  Uses Get2DAString, so do not use in loops
int   IPGetRandomArmorAppearanceType(object oArmor, int nPart);

// * Returns a new armor based of oArmor with nPartModified
// * nPart - ITEM_APPR_ARMOR_MODEL_* constant of the part to be changed
// * nMode -
// *        X2_IP_ARMORTYPE_NEXT    - next valid appearance
// *        X2_IP_ARMORTYPE_PREV    - previous valid apperance;
// *        X2_IP_ARMORTYPE_RANDOM  - random valid appearance;
// *
// * bDestroyOldOnSuccess - Destroy oArmor in process?
// * Uses Get2DAString, so do not use in loops
object IPGetModifiedArmor(object oArmor, int nPart, int nMode, int bDestroyOldOnSuccess);

// *  Add an item property in a safe fashion, preventing unwanted stacking
// *  Parameters:
// *   oItem     - the item to add the property to
// *   ip        - the itemproperty to add
// *   fDuration - set 0.0f to add the property permanent, anything else is temporary
// *   nAddItemPropertyPolicy - How to handle existing properties. Valid values are:
// *      X2_IP_ADDPROP_POLICY_REPLACE_EXISTING - remove any property of the same type, subtype, durationtype before adding;
// *      X2_IP_ADDPROP_POLICY_KEEP_EXISTING - do not add if any property with same type, subtype and durationtype already exists;
// *      X2_IP_ADDPROP_POLICY_IGNORE_EXISTING - add itemproperty in any case - Do not Use with OnHit or OnHitSpellCast props!
// *
// *  bIgnoreDurationType - If set to TRUE, an item property will be considered identical even if the DurationType is different. Be careful when using this
// *                        with X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, as this could lead to a temporary item property removing a permanent one
// *  bIgnoreSubType      - If set to TRUE an item property will be considered identical even if the SubType is different.
void  IPSafeAddItemProperty(object oItem, itemproperty ip, float fDuration =0.0f, int nAddItemPropertyPolicy = X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, int bIgnoreDurationType = FALSE, int bIgnoreSubType = FALSE);

// *  Wrapper for GetItemHasItemProperty that returns true if
// *  oItem has an itemproperty that matches ipCompareTo by Type AND DurationType AND SubType
// *  nDurationType = Valid DURATION_TYPE_* or -1 to ignore
// *  bIgnoreSubType - If set to TRUE an item property will be considered identical even if the SubType is different.
int   IPGetItemHasProperty(object oItem, itemproperty ipCompareTo, int nDurationType, int bIgnoreSubType = FALSE);

// *  returns FALSE it the item has no sequencer property
// *  returns number of spells that can be stored in any other case
int   IPGetItemSequencerProperty(object oItem);

// *  returns TRUE if the item has the OnHit:IntelligentWeapon property.
int   IPGetIsIntelligentWeapon(object oItem);

// *  Mapping between numbers and power constants for ITEM_PROPERTY_DAMAGE_BONUS
// *  returns the appropriate ITEM_PROPERTY_DAMAGE_POWER_* constant for nNumber
int   IPGetDamagePowerConstantFromNumber(int nNumber);

// *  returns the appropriate ITEM_PROPERTY_DAMAGE_BONUS_= constant for nNumber
// *  Do not pass in any number <1 ! Will return -1 on error
int   IPGetDamageBonusConstantFromNumber(int nNumber);

// *  Special Version of Copy Item Properties for use with greater wild shape
// *  oOld - Item equipped before polymorphing (source for item props)
// *  oNew - Item equipped after polymorphing  (target for item props)
// *  bWeapon - Must be set TRUE when oOld is a weapon.
void  IPWildShapeCopyItemProperties(object oOld, object oNew, int bWeapon = FALSE);

// *  Returns the current enhancement bonus of a weapon (+1 to +20), 0 if there is
// *  no enhancement bonus. You can test for a specific type of enhancement bonus
// *  by passing the appropritate ITEM_PROPERTY_ENHANCEMENT_BONUS* constant into
// *  nEnhancementBonusType
int   IPGetWeaponEnhancementBonus(object oWeapon, int nEnhancementBonusType = ITEM_PROPERTY_ENHANCEMENT_BONUS);

// *  Shortcut function to set the enhancement bonus of a weapon to a certain bonus
// *  Specifying bOnlyIfHigher as TRUE will prevent a bonus lower than the requested
// *  bonus from being applied. Valid values for nBonus are 1 to 20.
void  IPSetWeaponEnhancementBonus(object oWeapon, int nBonus, int bOnlyIfHigher = TRUE);

// *  Shortcut function to upgrade the enhancement bonus of a weapon by the
// *  number specified in nUpgradeBy. If the resulting new enhancement bonus
// *  would be out of bounds (>+20), it will be set to +20
void  IPUpgradeWeaponEnhancementBonus(object oWeapon, int nUpgradeBy);

// *  Returns TRUE if a character has any item equipped that has the itemproperty
// *  defined in nItemPropertyConst in it (ITEM_PROPERTY_* constant)
int   IPGetHasItemPropertyOnCharacter(object oPC, int nItemPropertyConst);

// *  Returns an integer with the number of properties present oItem
int   IPGetNumberOfItemProperties(object oItem);


// ----------------------------------------------------------------------------
// * Returns TRUE if the object is finessable. Finessable weapons are rapiers 
// * and whips if they aren't larger than the creature's size, and any weapon 
// * smaller than the creature's size. Unarmed strikes are also finessable.
// ----------------------------------------------------------------------------
int IPGetIsFinessableWeapon(object oPC, object oWeapon);

// ----------------------------------------------------------------------------
// * Returns TRUE if the object is light. Light weapons are any weapon that is
// * smaller than the creature's size. Unarmed strikes are also light.
// ----------------------------------------------------------------------------
int IPGetIsLightWeapon(object oPC, object oWeapon);
//------------------------------------------------------------------------------
//                         I M P L E M E N T A T I O N
//------------------------------------------------------------------------------

int IPGetIsWeapon(object oItem, int nItem = -1){
	if (oItem != OBJECT_INVALID) nItem = GetBaseItemType(oItem);
	int nDice = StringToInt(Get2DAString("baseitems", "NumDice", nItem));
	if (nDice <= 0) return FALSE;
	return TRUE;
}

int IPGetMaxStackSize(object oItem){
	int nItem = GetBaseItemType(oItem);
	return StringToInt(Get2DAString("baseitems", "Stacking", nItem));
}

int IPGetItemPropertiesIdentical(itemproperty ip1, itemproperty ip2, int bIgnoreDuration = FALSE){
	int nType = GetItemPropertyType(ip1);
	if (nType != GetItemPropertyType(ip2)) return FALSE;
	if (GetItemPropertyCostTable(ip1) != GetItemPropertyCostTable(ip2)) return FALSE;
	if (!bIgnoreDuration){
		if (GetItemPropertyDurationType(ip1) != GetItemPropertyDurationType(ip2)) return FALSE;
	}
	
	int bCompSub = FALSE;
	int bCompParam = FALSE;
	int bCompSpec = FALSE;

	// find which properties of the ip go into its creation so we know which to compare
	if (nType == 26 || (nType >= 35 && nType <= 38) || nType == 43 || nType == 47 ||
		nType == 71 || nType == 75){
			return TRUE; // these ip types have no parameters
	} else if (nType == 12 || (nType >= 62 && nType <= 65) || nType == 79 ||
		nType == 83 || nType == 100){
			bCompSub = TRUE;
	} else if (nType == 0 || (nType >= 2 && nType <= 5) || (nType >= 7 && nType <= 9) ||
		(nType >= 13 && nType <= 20) || (nType >= 22 && nType <= 24) || 
		(nType >= 27 && nType <= 29) || (nType >= 57 && nType <= 59) || 
		nType == 40 || nType == 41 || nType == 44 || nType == 49 || 
		nType == 50 || nType == 52 || nType == 70 || nType == 82){
			bCompSub = TRUE; bCompParam = TRUE;
	} else if (nType == 48){
		bCompSub = TRUE; bCompParam = TRUE; bCompSpec = TRUE;
	} else if (nType == 72){
		bCompSub = TRUE; bCompSpec = TRUE;
	} else if (nType == 81){
		bCompSpec = TRUE;
	} else {
		bCompParam = TRUE;
	}
	
	if (bCompSub){
		if (GetItemPropertySubType(ip1) != GetItemPropertySubType(ip2)) return FALSE;
	}
	if (bCompParam){
		if (GetItemPropertyCostTableValue(ip1) != GetItemPropertyCostTableValue(ip2)) return FALSE;
	}
	if (bCompSpec){
		if (GetItemPropertyParam1Value(ip1) != GetItemPropertyParam1Value(ip2)) return FALSE;
	}
	return TRUE;
}

// ----------------------------------------------------------------------------
// Removes all itemproperties with matching nItemPropertyType and
// nItemPropertyDuration (a DURATION_TYPE_* constant)
// ----------------------------------------------------------------------------
void IPRemoveMatchingItemProperties(object oItem, int nItemPropertyType, int nItemPropertyDuration = DURATION_TYPE_TEMPORARY, int nItemPropertySubType = -1)
{
    itemproperty ip = GetFirstItemProperty(oItem);

    // valid ip?
    while (GetIsItemPropertyValid(ip))
    {
        // same property type?
        if ((GetItemPropertyType(ip) == nItemPropertyType))
        {
            // same duration or duration ignored?
            if (GetItemPropertyDurationType(ip) == nItemPropertyDuration || nItemPropertyDuration == -1)
            {
                 // same subtype or subtype ignored
                 if  (GetItemPropertySubType(ip) == nItemPropertySubType || nItemPropertySubType == -1)
                 {
                      // Put a warning into the logfile if someone tries to remove a permanent ip with a temporary one!
                      /*if (nItemPropertyDuration == DURATION_TYPE_TEMPORARY &&  GetItemPropertyDurationType(ip) == DURATION_TYPE_PERMANENT)
                      {
                         WriteTimestampedLogEntry("x2_inc_itemprop:: IPRemoveMatchingItemProperties() - WARNING: Permanent item property removed by temporary on "+GetTag(oItem));
                      }
                      */
                      RemoveItemProperty(oItem, ip);
                 }
            }
        }
        ip = GetNextItemProperty(oItem);
    }
}

// ----------------------------------------------------------------------------
// Removes ALL item properties from oItem matching nItemPropertyDuration
// ----------------------------------------------------------------------------
void IPRemoveAllItemProperties(object oItem, int nItemPropertyDuration = DURATION_TYPE_TEMPORARY)
{
    itemproperty ip = GetFirstItemProperty(oItem);
    while (GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyDurationType(ip) == nItemPropertyDuration)
        {
            RemoveItemProperty(oItem, ip);
        }
        ip = GetNextItemProperty(oItem);
    }
}

// ----------------------------------------------------------------------------
// returns TRUE if item can be equipped. Uses Get2DAString, so do not use in a loop!
// ----------------------------------------------------------------------------
int IPGetIsItemEquipable(object oItem, int nBaseType = -1){
	if (oItem != OBJECT_INVALID) nBaseType = GetBaseItemType(oItem);

    // fix, if we get BASE_ITEM_INVALID (usually because oItem is invalid), we
    // need to make sure that this function returns FALSE
    if(nBaseType==BASE_ITEM_INVALID) return FALSE;

    string sResult = Get2DAString("baseitems","EquipableSlots",nBaseType);
    return  (sResult != "0x00000");
}

// ----------------------------------------------------------------------------
// Changes the color of an item armor
// oItem        - The armor
// nColorType   - ITEM_APPR_ARMOR_COLOR_* constant
// nColor       - color from 0 to 63
// Since oItem is destroyed in the process, the function returns
// the item created with the color changed
// ----------------------------------------------------------------------------
object IPDyeArmor(object oItem, int nColorType, int nColor)
{
        object oRet = CopyItemAndModify(oItem,ITEM_APPR_TYPE_ARMOR_COLOR,nColorType,nColor,TRUE);
        DestroyObject(oItem); // remove old item
        return oRet; //return new item
}

// ----------------------------------------------------------------------------
// Returns the container used for item property and appearance modifications in the
// module. If it does not exist, it is created
// ----------------------------------------------------------------------------
object IPGetIPWorkContainer(object oCaller = OBJECT_SELF)
{
    object oRet = GetObjectByTag(X2_IP_WORK_CONTAINER_TAG);
    if (oRet == OBJECT_INVALID)
    {
        oRet = CreateObject(OBJECT_TYPE_PLACEABLE,X2_IP_WORK_CONTAINER_TAG,GetLocation(oCaller));
        effect eInvis =  EffectVisualEffect( VFX_DUR_CUTSCENE_INVISIBILITY);
        eInvis = ExtraordinaryEffect(eInvis);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,eInvis,oRet);
        if (oRet == OBJECT_INVALID)
        {
            WriteTimestampedLogEntry("x2_inc_itemprop - critical: Missing container with tag " +X2_IP_WORK_CONTAINER_TAG + "!!");
        }
    }


    return oRet;
}


int IPGetIsFinessableWeapon(object oPC, object oWeapon)
{
	if(!GetIsObjectValid(oWeapon))
	{
		return TRUE;
	}
	
	int nMyWeapon = GetBaseItemType(oWeapon);
	string sWeaponSize = Get2DAString("baseitems", "WeaponSize", nMyWeapon);
	int bMonkeyGrip = GetHasFeat(FEAT_MONKEY_GRIP);
	
	if(nMyWeapon == 163 || nMyWeapon == 164 || nMyWeapon == 165 || nMyWeapon == 170 || nMyWeapon == 173 ) // Creature weapons
	{
		return TRUE;
	}

	
	if(sWeaponSize != "****" && sWeaponSize != "")
	{
		int nMyWeaponSize = StringToInt(sWeaponSize);
		int iMySize	= GetCreatureSize(oPC);
		if(bMonkeyGrip)
		{
			iMySize += 1;
		}
		
		if (((nMyWeapon != BASE_ITEM_RAPIER && nMyWeapon != 111) && nMyWeaponSize >= iMySize) 
		|| ((nMyWeapon == BASE_ITEM_RAPIER || nMyWeapon == 111) && nMyWeaponSize > iMySize) 
		|| nMyWeapon == 58
		|| bMonkeyGrip && IPGetIsLightWeapon(oPC, oWeapon))
		{
			return FALSE;
		}
	
		return TRUE;
	}
	
	return FALSE;
}

int IPGetIsLightWeapon(object oPC, object oWeapon)
{
	if(!GetIsObjectValid(oWeapon))
	{
		return TRUE;
	}
	
	int nMyWeapon = GetBaseItemType(oWeapon);
	string sWeaponSize = Get2DAString("baseitems", "WeaponSize", nMyWeapon);
	if(sWeaponSize != "****" && sWeaponSize != "")
	{ 
		int nMyWeaponSize = StringToInt(sWeaponSize);
		int iMySize	= GetCreatureSize(oPC);
		if ((nMyWeaponSize < iMySize) && (nMyWeapon != 58))
		{
			return TRUE;
		}
	
		return FALSE;
	}
	
	return TRUE;
}


/*
sorted list of item property constants from NWScript.nss
int ITEM_PROPERTY_ABILITY_BONUS                            = 0 ;
int ITEM_PROPERTY_AC_BONUS                                 = 1 ;
int ITEM_PROPERTY_AC_BONUS_VS_ALIGNMENT_GROUP              = 2 ;
int ITEM_PROPERTY_AC_BONUS_VS_DAMAGE_TYPE                  = 3 ;
int ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP                 = 4 ;
int ITEM_PROPERTY_AC_BONUS_VS_SPECIFIC_ALIGNMENT           = 5 ;
int ITEM_PROPERTY_ARCANE_SPELL_FAILURE                     = 84;
int ITEM_PROPERTY_ATTACK_BONUS                             = 56 ;
int ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP          = 57 ;
int ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP             = 58 ;
int ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT       = 59 ;
int ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION               = 11 ;
int ITEM_PROPERTY_BONUS_FEAT                               = 12 ;
int ITEM_PROPERTY_BONUS_HITPOINTS                          = 66 ;
int ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N              = 13 ;
int ITEM_PROPERTY_CAST_SPELL                               = 15 ;
int ITEM_PROPERTY_DAMAGE_BONUS                             = 16 ;
int ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP          = 17 ;
int ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP             = 18 ;
int ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT       = 19 ;
int ITEM_PROPERTY_DAMAGE_REDUCTION              		   = 90 ; 
int ITEM_PROPERTY_DAMAGE_REDUCTION_DEPRECATED              = 22 ; // not called
int ITEM_PROPERTY_DAMAGE_RESISTANCE                        = 23 ;
int ITEM_PROPERTY_DAMAGE_VULNERABILITY                     = 24 ;
int ITEM_PROPERTY_DARKVISION                               = 26 ;
int ITEM_PROPERTY_DECREASED_ABILITY_SCORE                  = 27 ;
int ITEM_PROPERTY_DECREASED_AC                             = 28 ;
int ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER                = 60 ;
int ITEM_PROPERTY_DECREASED_DAMAGE                         = 21 ;
int ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER           = 10 ;
int ITEM_PROPERTY_DECREASED_SAVING_THROWS                  = 49 ;
int ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC         = 50 ;
int ITEM_PROPERTY_DECREASED_SKILL_MODIFIER                 = 29 ;
int ITEM_PROPERTY_ENHANCED_CONTAINER_REDUCED_WEIGHT        = 32 ;
int ITEM_PROPERTY_ENHANCEMENT_BONUS                        = 6 ;
int ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP     = 7 ;
int ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP        = 8 ;
int ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT = 9 ;
int ITEM_PROPERTY_EXTRA_MELEE_DAMAGE_TYPE                  = 33 ;
int ITEM_PROPERTY_EXTRA_RANGED_DAMAGE_TYPE                 = 34 ;
int ITEM_PROPERTY_FREEDOM_OF_MOVEMENT                      = 75 ;
int ITEM_PROPERTY_HASTE                                    = 35 ;
int ITEM_PROPERTY_HEALERS_KIT                              = 80;
int ITEM_PROPERTY_HOLY_AVENGER                             = 36 ;
int ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE                     = 20 ;
int ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS                   = 37 ;
int ITEM_PROPERTY_IMMUNITY_SPECIFIC_SPELL                  = 53 ;
int ITEM_PROPERTY_IMMUNITY_SPELL_SCHOOL                    = 54 ;
int ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL                 = 78 ;
int ITEM_PROPERTY_IMPROVED_EVASION                         = 38 ;
int ITEM_PROPERTY_KEEN                                     = 43 ;
int ITEM_PROPERTY_LIGHT                                    = 44 ;
int ITEM_PROPERTY_MASSIVE_CRITICALS                        = 74 ;
int ITEM_PROPERTY_MIGHTY                                   = 45 ;
int ITEM_PROPERTY_MIND_BLANK                               = 46 ;
int ITEM_PROPERTY_MONSTER_DAMAGE                           = 77 ;
int ITEM_PROPERTY_NO_DAMAGE                                = 47 ;
int ITEM_PROPERTY_ON_HIT_PROPERTIES                        = 48 ;
int ITEM_PROPERTY_ON_MONSTER_HIT                           = 72 ;
int ITEM_PROPERTY_ONHITCASTSPELL                           = 82;
int ITEM_PROPERTY_POISON                                   = 76 ; // no longer working, poison is now a on_hit subtype
int ITEM_PROPERTY_REGENERATION                             = 51 ;
int ITEM_PROPERTY_REGENERATION_VAMPIRIC                    = 67 ;
int ITEM_PROPERTY_SAVING_THROW_BONUS                       = 40 ;
int ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC              = 41 ;
int ITEM_PROPERTY_SKILL_BONUS                              = 52 ;
int ITEM_PROPERTY_SPECIAL_WALK                             = 79;
int ITEM_PROPERTY_SPELL_RESISTANCE                         = 39 ;
int ITEM_PROPERTY_THIEVES_TOOLS                            = 55 ;
int ITEM_PROPERTY_TRAP                                     = 70 ;
int ITEM_PROPERTY_TRUE_SEEING                              = 71 ;
int ITEM_PROPERTY_TURN_RESISTANCE                          = 73 ;
int ITEM_PROPERTY_UNLIMITED_AMMUNITION                     = 61 ;
int ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP           = 62 ;
int ITEM_PROPERTY_USE_LIMITATION_CLASS                     = 63 ;
int ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE               = 64 ;
int ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT        = 65 ;
//int ITEM_PROPERTY_USE_LIMITATION_TILESET                   = 66 ; <- replaced by ITEM_PROPERTY_BONUS_HITPOINTS
int ITEM_PROPERTY_VISUALEFFECT	                           = 83;
int ITEM_PROPERTY_WEIGHT_INCREASE                          = 81;

*/	

	
// ----------------------------------------------------------------------------
// This function needs to be rather extensive and needs to be updated if there are new
// ip types we want to use, but it goes into the item property include anyway
// ChazM - updated 11/17/06
// ----------------------------------------------------------------------------
itemproperty IPGetItemPropertyByID(int nPropID, int nParam1 = 0, int nParam2 = 0, int nParam3 = 0, int nParam4 = 0)
{
   itemproperty ipRet;

   if (nPropID == ITEM_PROPERTY_ABILITY_BONUS) // 0 
   {
        ipRet = ItemPropertyAbilityBonus(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_AC_BONUS) // 1 
   {
        ipRet = ItemPropertyACBonus(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_AC_BONUS_VS_ALIGNMENT_GROUP) // 2
   {
        ipRet = ItemPropertyACBonusVsAlign(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_AC_BONUS_VS_DAMAGE_TYPE) // 3
   {
        ipRet = ItemPropertyACBonusVsDmgType(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP) // 4
   {
        ipRet = ItemPropertyACBonusVsRace(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_AC_BONUS_VS_SPECIFIC_ALIGNMENT) // 5
   {
        ipRet = ItemPropertyACBonusVsSAlign(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_ARCANE_SPELL_FAILURE) // 84
   {
        ipRet = ItemPropertyArcaneSpellFailure(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_ATTACK_BONUS) //56
   {
        ipRet = ItemPropertyAttackBonus(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP) //57
   {
        ipRet = ItemPropertyAttackBonusVsAlign(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP) // 58
   {
        ipRet = ItemPropertyAttackBonusVsRace(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT) // 59
   {
        ipRet = ItemPropertyAttackBonusVsSAlign(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION) // 11
   {
        ipRet = ItemPropertyWeightReduction(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_BONUS_FEAT) // 12
   {
        ipRet = ItemPropertyBonusFeat(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N) // 13
   {
        ipRet = ItemPropertyBonusLevelSpell(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_CAST_SPELL) // 15
   {
        ipRet = ItemPropertyCastSpell(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_DAMAGE_BONUS) // 16
   {
        ipRet = ItemPropertyDamageBonus(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP) // 17
   {
        ipRet = ItemPropertyDamageBonusVsAlign(nParam1, nParam2, nParam3);
   }
   else if (nPropID == ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP) // 18
   {
        ipRet = ItemPropertyDamageBonusVsRace(nParam1, nParam2, nParam3);
   }
   else if (nPropID == ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT) // 19
   {
        ipRet = ItemPropertyDamageBonusVsSAlign(nParam1, nParam2, nParam3);
   }
   else if (nPropID == ITEM_PROPERTY_DAMAGE_REDUCTION) // 22 // JLR-OEI 04/03/06: NOW it is 85 (old one is deprecated!)
   {
        ipRet = ItemPropertyDamageReduction(nParam1, nParam2, nParam3, nParam4);
   }
   else if (nPropID == ITEM_PROPERTY_DAMAGE_RESISTANCE) // 23
   {
        ipRet = ItemPropertyDamageResistance(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_DAMAGE_VULNERABILITY) // 24
   {
        ipRet = ItemPropertyDamageVulnerability(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_DARKVISION) // 26
   {
        ipRet = ItemPropertyDarkvision();
   }
   else if (nPropID == ITEM_PROPERTY_DECREASED_ABILITY_SCORE) // 27
   {
        ipRet = ItemPropertyDecreaseAbility(nParam1,nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_DECREASED_AC) // 28
   {
        ipRet = ItemPropertyDecreaseAC(nParam1,nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER) // 60
   {
        ipRet = ItemPropertyAttackPenalty(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_DECREASED_DAMAGE) // 21
   {
        ipRet = ItemPropertyDamagePenalty(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER) // 10
   {
        ipRet = ItemPropertyEnhancementPenalty(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_DECREASED_SAVING_THROWS) // 49
   {
        ipRet = ItemPropertyReducedSavingThrow(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC) // 50
   {
        ipRet = ItemPropertyReducedSavingThrowVsX(nParam1, nParam2);
   }
    else if (nPropID == ITEM_PROPERTY_DECREASED_SKILL_MODIFIER) //29
   {
        ipRet = ItemPropertyDecreaseSkill(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_ENHANCED_CONTAINER_REDUCED_WEIGHT) //32
   {
        ipRet = ItemPropertyContainerReducedWeight(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_ENHANCEMENT_BONUS) // 6
   {
        ipRet = ItemPropertyEnhancementBonus(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP) // 7
   {
        ipRet = ItemPropertyEnhancementBonusVsAlign(nParam1,nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT) // 8
   {
        ipRet = ItemPropertyEnhancementBonusVsSAlign(nParam1,nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP) // 9
   {
        ipRet = ItemPropertyEnhancementBonusVsRace(nParam1,nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_EXTRA_MELEE_DAMAGE_TYPE) // 33
   {
        ipRet = ItemPropertyExtraMeleeDamageType(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_EXTRA_RANGED_DAMAGE_TYPE) // 34
   {
        ipRet = ItemPropertyExtraRangeDamageType(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_FREEDOM_OF_MOVEMENT) // 75
   {
        ipRet = ItemPropertyFreeAction();
   }
   else if (nPropID == ITEM_PROPERTY_HASTE) // 35
   {
        ipRet = ItemPropertyHaste();
   }
   else if (nPropID == ITEM_PROPERTY_HEALERS_KIT) // 80
   {
        ipRet = ItemPropertyHealersKit(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_HOLY_AVENGER) // 36
   {
        ipRet = ItemPropertyHolyAvenger();
   }
   else if (nPropID == ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE) // 20
   {
        ipRet = ItemPropertyDamageImmunity(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS) // 37
   {
        ipRet = ItemPropertyImmunityMisc(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_IMMUNITY_SPECIFIC_SPELL) // 53
   {
        ipRet = ItemPropertySpellImmunitySpecific(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_IMMUNITY_SPELL_SCHOOL) // 54
   {
        ipRet = ItemPropertySpellImmunitySchool(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL) // 78 
   {
        ipRet = ItemPropertyImmunityToSpellLevel(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_IMPROVED_EVASION) // 38
   {
        ipRet = ItemPropertyImprovedEvasion();
   }
   else if (nPropID == ITEM_PROPERTY_KEEN) // 43
   {
        ipRet = ItemPropertyKeen();
   }
   else if (nPropID == ITEM_PROPERTY_LIGHT) // 44
   {
        ipRet = ItemPropertyLight(nParam1,nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_MASSIVE_CRITICALS) // 74
   {
        ipRet = ItemPropertyMassiveCritical(nParam1);
   }
/*	
   else if (nPropID == ITEM_PROPERTY_MIGHTY) // 45
   {
        ipRet = ?(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_MIND_BLANK) // 46
   {
        ipRet = ?(nParam1);
   }
*/	
   else if (nPropID == ITEM_PROPERTY_MONSTER_DAMAGE) // 77
   {
        ipRet = ItemPropertyMonsterDamage(nParam1);
   }
   else if (nPropID == ITEM_PROPERTY_NO_DAMAGE) // 47
   {
        ipRet = ItemPropertyNoDamage();
   }
   else if (nPropID == ITEM_PROPERTY_ON_HIT_PROPERTIES) // 48
   {
        ipRet = ItemPropertyOnHitProps(nParam1, nParam2, nParam3);
   }
   else if (nPropID == ITEM_PROPERTY_ON_MONSTER_HIT) // 72
   {
        ipRet = ItemPropertyOnMonsterHitProperties(nParam1, nParam2);
   }
   else if (nPropID == ITEM_PROPERTY_ONHITCASTSPELL) // 82
   {
        ipRet = ItemPropertyOnHitCastSpell(nParam1, nParam2);
   }
/*	
   else if (nPropID == ITEM_PROPERTY_POISON) // 76
   {	
		//NWSCRIPT.nss: no longer working, poison is now a on_hit subtype
        ipRet = ();
   }
*/
	else if (nPropID == ITEM_PROPERTY_REGENERATION) // 51
	{
	     ipRet = ItemPropertyRegeneration(nParam1);
	}
	else if (nPropID == ITEM_PROPERTY_REGENERATION_VAMPIRIC) // 67
	{
	     ipRet = ItemPropertyVampiricRegeneration(nParam1);
	}
	else if (nPropID == ITEM_PROPERTY_SAVING_THROW_BONUS) // 40
	{
	     ipRet = ItemPropertyBonusSavingThrow(nParam1, nParam2);
	}
	else if (nPropID == ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC) // 41
	{
	     ipRet = ItemPropertyBonusSavingThrowVsX(nParam1, nParam2);
	}
	
	else if (nPropID == ITEM_PROPERTY_SKILL_BONUS) // 52
	{
	     ipRet = ItemPropertySkillBonus(nParam1, nParam2);
	}
	else if (nPropID == ITEM_PROPERTY_SPECIAL_WALK) // 79
	{
	     ipRet = ItemPropertySpecialWalk(nParam1);
	}
	else if (nPropID == ITEM_PROPERTY_SPELL_RESISTANCE)
	{
	     ipRet = ItemPropertyBonusSpellResistance(nParam1); // 39
	}
	else if (nPropID == ITEM_PROPERTY_THIEVES_TOOLS)
	{
	     ipRet = ItemPropertyThievesTools(nParam1); // 55
	}
	else if (nPropID == ITEM_PROPERTY_TRAP) // 70
	{
	     ipRet = ItemPropertyTrap(nParam1, nParam2);
	}
	else if (nPropID == ITEM_PROPERTY_TRUE_SEEING) // 71
	{
	     ipRet = ItemPropertyTrueSeeing();
	}
	else if (nPropID == ITEM_PROPERTY_TURN_RESISTANCE) // 73
	{
	     ipRet = ItemPropertyTurnResistance(nParam1);
	}
	else if (nPropID == ITEM_PROPERTY_UNLIMITED_AMMUNITION) // 61
	{
	     ipRet = ItemPropertyUnlimitedAmmo(nParam2);
	}
	else if (nPropID == ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP) // 62
	{
	     ipRet = ItemPropertyLimitUseByAlign(nParam1);
	}
	else if (nPropID == ITEM_PROPERTY_USE_LIMITATION_CLASS) // 63
	{
	     ipRet = ItemPropertyLimitUseByClass(nParam1);
	}
	else if (nPropID == ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE) // 64
	{
	     ipRet = ItemPropertyLimitUseByRace(nParam1);
	}
	else if (nPropID == ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT) // 65
	{
	     ipRet = ItemPropertyLimitUseBySAlign(nParam1);
	}
/*
	else if (nPropID == ITEM_PROPERTY_USE_LIMITATION_TILESET) // 66
	{
	     ipRet = ();
	}
*/

	else if (nPropID == ITEM_PROPERTY_VISUALEFFECT) // 83
	{
	     ipRet = ItemPropertyVisualEffect(nParam1);
	}
	else if (nPropID == ITEM_PROPERTY_WEIGHT_INCREASE) // 81 
	{
	     ipRet = ItemPropertyWeightIncrease(nParam1);
	}
	else if (nPropID == ITEM_PROPERTY_BONUS_HITPOINTS) // 86
	{
	     ipRet = ItemPropertyBonusHitpoints(nParam1);
	}

   return ipRet;
}

int IPGetWeaponSize(object oItem, int nItem = -1){
	if (oItem != OBJECT_INVALID) nItem = GetBaseItemType(oItem);
	string sWeaponSize = Get2DAString("baseitems", "WeaponSize", nItem);
	if(sWeaponSize == "****" || sWeaponSize == "") return -1;
	return StringToInt(sWeaponSize);
}

//Returns value in WeaponCategory column of baseitems
string IPGetWeaponCategory(object oItem, int nItem = -1){
	if (oItem != OBJECT_INVALID) nItem = GetBaseItemType(oItem);
	return GetStringLowerCase(Get2DAString("baseitems", "WeaponCategory", nItem));
}

//Get is instrument
int IPGetIsInstrument(object oItem, int nItem = -1){
	if (oItem != OBJECT_INVALID) nItem = GetBaseItemType(oItem);
	if (nItem == BASE_ITEM_DRUM || nItem == BASE_ITEM_FLUTE || nItem == BASE_ITEM_MANDOLIN)
		return TRUE;
	return FALSE;
}

int IPGetIsQuiver(object oItem, int nItem = -1){
	if (oItem != OBJECT_INVALID) nItem = GetBaseItemType(oItem);
	string sType = IPGetWeaponCategory(OBJECT_INVALID, nItem);
	if (FindSubString(sType, "quiver") != -1) return TRUE;
	return FALSE;
}

int IPGetIsForgedItem(object oItem, int nItem = -1){
	if (oItem == OBJECT_INVALID && nItem == -1) return FALSE;
	if (oItem != OBJECT_INVALID) nItem = GetBaseItemType(oItem);
	if (IPGetIsQuiver(OBJECT_INVALID, nItem)) return TRUE;
	if (IPGetIsItemEquipable(OBJECT_INVALID, nItem)) return TRUE;
	int nNumRows = GetNum2DARows("scod_craft_baseitems");
	int i;
	for (i = 0; i < nNumRows; i++){
		if (StringToInt(Get2DAString("scod_craft_baseitems", "ID", i)) == nItem)
			return TRUE;
	}
	return FALSE;
}

// ----------------------------------------------------------------------------
// Returns TRUE if oItem is a projectile or projectile "quiver"
// ----------------------------------------------------------------------------
int IPGetIsProjectile(object oItem, int nItem = -1){
	string sType = IPGetWeaponCategory(oItem, nItem);
	if (FindSubString(sType, "projectile") != -1) return TRUE;
	return FALSE;
	/* deprecated, FlattedFifth Aug 1, 2024
  int nBT = GetBaseItemType(oItem);
  return (nBT == BASE_ITEM_ARROW || nBT == BASE_ITEM_BOLT || nBT == BASE_ITEM_BULLET);
  */
}

//Returns TRUE if oItem is thrown or thrown "quiver"
int IPGetIsThrownWeapon(object oItem, int nItem = -1){
	string sType = IPGetWeaponCategory(oItem, nItem);
	if (FindSubString(sType, "thrown") != -1) return TRUE;
	return FALSE;
}

// returns true for slings, bows, and xbows but not thrown
int IPGetIsLauncher(object oItem, int nItem = -1){
	string sType = IPGetWeaponCategory(oItem, nItem);
	if (FindSubString(sType, "launcher") != -1) return TRUE;
	return FALSE;
}

// ----------------------------------------------------------------------------
// Returns TRUE if oItem is a bow, sling, xbow, thrown, or thrown quiver
// ----------------------------------------------------------------------------
int IPGetIsRangedWeapon(object oItem, int nItem = -1){
	//if (oItem == OBJECT_INVALID){
		string sType = IPGetWeaponCategory(oItem, nItem);
		if (FindSubString(sType, "launcher") != -1 || 
			FindSubString(sType, "thrown") != -1){
				return TRUE;
			}
			return FALSE;
	//}
    //else return GetWeaponRanged(oItem); // doh !
}

// ----------------------------------------------------------------------------
// Returns TRUE if oItem is a melee weapon
// ----------------------------------------------------------------------------
int IPGetIsMeleeWeapon(object oItem, int nItem = -1){
	string sString = IPGetWeaponCategory(oItem, nItem);
	return (FindSubString(sString, "melee") != -1);
    /* deprecated, FlattedFifth Aug 1, 2024
	//Declare major variables
    int nItem = GetBaseItemType(oItem);

    if((nItem == BASE_ITEM_BASTARDSWORD) ||
      (nItem == BASE_ITEM_BATTLEAXE) ||
      (nItem == BASE_ITEM_DOUBLEAXE) ||
      (nItem == BASE_ITEM_GREATAXE) ||
      (nItem == BASE_ITEM_GREATSWORD) ||
      (nItem == BASE_ITEM_HALBERD) ||
      (nItem == BASE_ITEM_HANDAXE) ||
      (nItem == BASE_ITEM_KAMA) ||
      (nItem == BASE_ITEM_KATANA) ||
      (nItem == BASE_ITEM_KUKRI) ||
      (nItem == BASE_ITEM_LONGSWORD) ||
      (nItem == BASE_ITEM_SCIMITAR) ||
      (nItem == BASE_ITEM_SCYTHE) ||
      (nItem == BASE_ITEM_SICKLE) ||
      (nItem == BASE_ITEM_TWOBLADEDSWORD) ||
      (nItem == BASE_ITEM_CLUB) ||
      (nItem == BASE_ITEM_DAGGER) ||
      (nItem == BASE_ITEM_DIREMACE) ||
      (nItem == BASE_ITEM_HEAVYFLAIL) ||
      (nItem == BASE_ITEM_LIGHTFLAIL) ||
      (nItem == BASE_ITEM_LIGHTHAMMER) ||
      (nItem == BASE_ITEM_LIGHTMACE) ||
      (nItem == BASE_ITEM_MORNINGSTAR) ||
      (nItem == BASE_ITEM_QUARTERSTAFF) ||
      (nItem == BASE_ITEM_MAGICSTAFF) ||
      (nItem == BASE_ITEM_RAPIER) ||
      (nItem == BASE_ITEM_WHIP) ||
      (nItem == BASE_ITEM_SHORTSPEAR) ||
      (nItem == BASE_ITEM_SHORTSWORD) ||
      (nItem == BASE_ITEM_WARHAMMER)  ||
	  (nItem == BASE_ITEM_MACE)	||
	  (nItem == BASE_ITEM_FALCHION)	||
	  (nItem == BASE_ITEM_FLAIL)	||
	  (nItem == BASE_ITEM_SPEAR)	||
	  (nItem == BASE_ITEM_WARMACE)	||
	  (nItem == BASE_ITEM_CGIANT_SWORD)	||
	  (nItem == BASE_ITEM_CGIANT_AXE)	||
	  (nItem == BASE_ITEM_ALLUSE_SWORD)	||
      (nItem == BASE_ITEM_DWARVENWARAXE) ||
	  (nItem == 150) ||
	  (nItem == 151) ||
	  (nItem == 152) || // these 3 are giant weapons.
	  (nItem == 202) || 
	  (nItem == BASE_ITEM_CREEQ_CLAW) || // these 5 are creature weapons.
	  (nItem == BASE_ITEM_CREEQ_BITE) || // these 5 are creature weapons.
	  (nItem == BASE_ITEM_CREEQ_SLAM) || // these 5 are creature weapons.
	  (nItem == BASE_ITEM_CREEQ_CLAW_LARGE) || // these 5 are creature weapons.
	  (nItem == BASE_ITEM_CREEQ_BITE_LARGE) || // these 5 are creature weapons.
	  (nItem == BASE_ITEM_CREEQ_CLAW_TINY) || //The following 5 are new creature weapons
	  (nItem == BASE_ITEM_CREEQ_SLAM_TINY) ||
	  (nItem == BASE_ITEM_CREEQ_SLAM_MED) ||
	  (nItem == BASE_ITEM_CREEQ_BITE_TINY) ||
	  (nItem == BASE_ITEM_CREEQ_BITE_LRG))
   {
        return TRUE;
   }
   return FALSE;
   */
}

// Added by Ceremorph for SCoD
int IPGetIsCreatureEquippedWeapon(object oItem, int nItem = -1){
	return (FindSubString(IPGetWeaponCategory(oItem, nItem), "creature") != -1);
	/* deprecated, FlattedFifth Aug 1, 2024
    //Declare major variables
    int nItem = GetBaseItemType(oItem);

	if((nItem == BASE_ITEM_CREEQ_BLUDG_L) ||
		(nItem == BASE_ITEM_CREEQ_BLUDG_M) ||
		(nItem == BASE_ITEM_CREEQ_BLUDG_S) ||
		(nItem == BASE_ITEM_CREEQ_PIERC_L) ||
		(nItem == BASE_ITEM_CREEQ_PIERC_M) ||
		(nItem == BASE_ITEM_CREEQ_PIERC_S) ||
		(nItem == BASE_ITEM_CREEQ_PRCBL_L) ||
		(nItem == BASE_ITEM_CREEQ_PRCBL_M) ||
		(nItem == BASE_ITEM_CREEQ_PRCBL_S) ||
		(nItem == BASE_ITEM_CREEQ_PRCSL_L) ||
		(nItem == BASE_ITEM_CREEQ_PRCSL_M) ||
		(nItem == BASE_ITEM_CREEQ_PRCSL_S) ||
		(nItem == BASE_ITEM_CREEQ_SLASH_L) ||
		(nItem == BASE_ITEM_CREEQ_SLASH_M) ||
		(nItem == BASE_ITEM_CREEQ_SLASH_S) ||
		(nItem == BASE_ITEM_CREEQ_CLAW) ||
		(nItem == BASE_ITEM_CREEQ_BITE) ||
		(nItem == BASE_ITEM_CREEQ_SLAM) ||
		(nItem == BASE_ITEM_CREEQ_CLAW_LARGE) ||
		(nItem == BASE_ITEM_CREEQ_BITE_LARGE) ||
		(nItem == BASE_ITEM_CREEQ_CLAW_TINY) ||
		(nItem == BASE_ITEM_CREEQ_SLAM_TINY) ||
		(nItem == BASE_ITEM_CREEQ_SLAM_MED) ||
		(nItem == BASE_ITEM_CREEQ_BITE_TINY) ||
		(nItem == BASE_ITEM_CREEQ_BITE_LRG))
	{
        return TRUE;
	}
	return FALSE;
	*/
}

// ----------------------------------------------------------------------------
// Returns TRUE if weapon is a blugeoning weapon
// Uses Get2DAString!
// ----------------------------------------------------------------------------
int IPGetIsBludgeoningWeapon(object oItem, int nItem = -1, int bOnly = TRUE){
  if (oItem != OBJECT_INVALID) nItem = GetBaseItemType(oItem);
  int nWeapon =  ( StringToInt(Get2DAString("baseitems","WeaponType", nItem)));
  // 2 = bludgeoning, 5 = bludgeoning + piercing
  if (bOnly) return nWeapon == 2;
  else return (nWeapon == 2 || nWeapon == 5);
}

int IPGetIsSlashingWeapon(object oItem, int nItem = -1, int bOnly = TRUE){
	if (oItem != OBJECT_INVALID) nItem = GetBaseItemType(oItem);
	int nWeapon = StringToInt(Get2DAString("baseitems","WeaponType", nItem));
	// 3 = slashing, 4 = slashing + piercing
	if (bOnly) return nWeapon == 3;
	else return (nWeapon == 3 || nWeapon == 4);
}

int IPGetIsPiercingWeapon(object oItem, int nItem = -1, int bOnly = TRUE){
	if (oItem != OBJECT_INVALID) nItem = GetBaseItemType(oItem);
	int nWeapon = StringToInt(Get2DAString("baseitems","WeaponType", nItem));
	// 1 = piercing, 4 = piercing + slashing, 5 = bludgeoning + slashing
	if (bOnly) return nWeapon == 1;
	else return (nWeapon == 1 || nWeapon == 4 || nWeapon == 5);

}

// ----------------------------------------------------------------------------
// Return the IP_CONST_CASTSPELL_* ID matching to the SPELL_* constant given
// in nSPELL_ID.
// This uses Get2DAString, so it is slow. Avoid using in loops!
// returns -1 if there is no matching property for a spell

// Now returns a new IPRP_SpellIndex based on the caster level of the creator:
// will result in a caster lvl of the potion/wand/scroll equal to either minimum lvl
// for the spell, min level +5, or min level +10
// ----------------------------------------------------------------------------
int IPGetIPConstCastSpellFromSpellID(int nSpellID, int nCasterLvl = 1){

	
    // look up Spell Property Index
    string sTemp = Get2DAString("des_crft_spells","IPRP_SpellIndex",nSpellID);
    
    if (sTemp == "" || sTemp == "****"){
        PrintString("x2_inc_craft.nss::GetIPConstCastSpellFromSpellID called with invalid nSpellID" + IntToString(nSpellID));
        return -1;
    }
	
	int nSpellPrpIdx = StringToInt(sTemp);

	string sMed = Get2DAString("des_crft_spells", "IPRP_Med", nSpellID);
	string sHigh = Get2DAString("des_crft_spells", "IPRP_High", nSpellID);
	
	int nMedIPIdx = -1;
	int nHighIPIdx = -1;
	if (sMed != "" && sMed != "****") nMedIPIdx = StringToInt(sMed);
	if (sHigh != "" && sHigh != "****") nHighIPIdx = StringToInt(sHigh);
	
	int nMedCL = -1;
	int nHighCL = -1;
	if (nMedIPIdx != -1)
		nMedCL = StringToInt(Get2DAString("iprp_spells", "CasterLvl", nMedIPIdx));
		
	if (nHighIPIdx != -1)
		nHighCL = StringToInt(Get2DAString("iprp_spells", "CasterLvl", nHighIPIdx));
	
	if (nHighCL != -1){
		if (B_ALLOW_CRAFT_PLUS_10_ALL || (nCasterLvl >= nHighCL && 
			B_ALLOW_CRAFT_PLUS_10_MATCH)) return nHighIPIdx;
			
	}
	if (nMedCL != -1){
		if (B_ALLOW_CRAFT_PLUS_5_ALL || (nCasterLvl >= nMedCL && 
			B_ALLOW_CRAFT_PLUS_5_MATCH)) return nMedIPIdx;	
	}
	
    return nSpellPrpIdx;
}
// ----------------------------------------------------------------------------
// Returns TRUE if an item has ITEM_PROPERTY_ON_HIT and the specified nSubType
// possible values for nSubType can be taken from IPRP_ONHIT.2da
// popular ones:
//       5 - Daze
//      19 - ItemPoison
//      24 - Vorpal
// ----------------------------------------------------------------------------
int IPGetItemHasItemOnHitPropertySubType(object oTarget, int nSubType)
{
    if (GetItemHasItemProperty(oTarget,ITEM_PROPERTY_ON_HIT_PROPERTIES))
    {
        itemproperty ipTest = GetFirstItemProperty(oTarget);

        // loop over item properties to see if there is already a poison effect
        while (GetIsItemPropertyValid(ipTest))
        {

            if (GetItemPropertySubType(ipTest) == nSubType)   //19 == onhit poison
            {
                return TRUE;
            }

          ipTest = GetNextItemProperty(oTarget);

         }
    }
    return FALSE;
}


// ----------------------------------------------------------------------------
// Returns TRUE if an item has ITEM_PROPERTY_ABILITY_BONUS and the specified nSubType
// possible values for nSubType can be taken from ABILITY_TYPE_*
// ----------------------------------------------------------------------------
int IPGetItemHasItemAbilityBonusPropertySubType(object oTarget, int nSubType)
{
    if (GetItemHasItemProperty(oTarget,ITEM_PROPERTY_ABILITY_BONUS))
    {
        itemproperty ipTest = GetFirstItemProperty(oTarget);

        // loop over item properties to see if there is already a poison effect
        while (GetIsItemPropertyValid(ipTest))
        {

            if (GetItemPropertySubType(ipTest) == nSubType)   //2 == Constitution
            {
                return TRUE;
            }

          ipTest = GetNextItemProperty(oTarget);

         }
    }
    return FALSE;
}

// ----------------------------------------------------------------------------
// Returns the number of possible armor part variations for the specified part
// nPart - ITEM_APPR_ARMOR_MODEL_* constant
// Uses Get2DAString, so do not use in loops
// ----------------------------------------------------------------------------
int IPGetNumberOfArmorAppearances(int nPart)
{
    int nRet;
    //SpeakString(Get2DAString(X2_IP_ARMORPARTS_2DA ,"NumParts",nPart));
    nRet = StringToInt(Get2DAString(X2_IP_ARMORPARTS_2DA ,"NumParts",nPart));
    return nRet;
}

// ----------------------------------------------------------------------------
// (private)
// Returns the previous or next armor appearance type, depending on the specified
// mode (X2_IP_ARMORTYPE_NEXT || X2_IP_ARMORTYPE_PREV)
// ----------------------------------------------------------------------------
int IPGetArmorAppearanceType(object oArmor, int nPart, int nMode)
{
    string sMode;

    switch (nMode)
    {
        case        X2_IP_ARMORTYPE_NEXT : sMode ="Next";
                    break;
        case        X2_IP_ARMORTYPE_PREV : sMode ="Prev";
                    break;
    }

    int nCurrApp  = GetItemAppearance(oArmor,ITEM_APPR_TYPE_ARMOR_MODEL,nPart);
    int nRet;

    if (nPart ==ITEM_APPR_ARMOR_MODEL_TORSO)
    {
        nRet = StringToInt(Get2DAString(X2_IP_ARMORAPPEARANCE_2DA ,sMode,nCurrApp));
        return nRet;
    }
    else
    {
        int nMax =  IPGetNumberOfArmorAppearances(nPart)-1; // index from 0 .. numparts -1
        int nMin =  1; // this prevents part 0 from being chosen (naked)

        // return a random valid armor tpze
        if (nMode == X2_IP_ARMORTYPE_RANDOM)
        {
            return Random(nMax)+nMin;
        }

        else
        {
            if (nMode == X2_IP_ARMORTYPE_NEXT)
            {
                // current appearance is max, return min
                if (nCurrApp == nMax)
                {
                    return nMin;
                }
                // current appearance is min, return max  -1
                else if (nCurrApp == nMin)
                {
                    nRet = nMin+1;
                    return nRet;
                }

                //SpeakString("next");
                // next
                nRet = nCurrApp +1;
                return nRet;
            }
            else                // previous
            {
                // current appearance is max, return nMax-1
                if (nCurrApp == nMax)
                {
                    nRet = nMax--;
                    return nRet;
                }
                // current appearance is min, return max
                else if (nCurrApp == nMin)
                {
                    return nMax;
                }

                //SpeakString("prev");

                nRet = nCurrApp -1;
                return nRet;
            }
        }

     }

}

// ----------------------------------------------------------------------------
// Returns the next valid appearance type for oArmor
// Uses Get2DAString, so do not use in loops
// ----------------------------------------------------------------------------
int IPGetNextArmorAppearanceType(object oArmor, int nPart)
{
    return IPGetArmorAppearanceType(oArmor, nPart,  X2_IP_ARMORTYPE_NEXT );

}

// ----------------------------------------------------------------------------
// Returns the next valid appearance type for oArmor
// Uses Get2DAString, so do not use in loops
// ----------------------------------------------------------------------------
int IPGetPrevArmorAppearanceType(object oArmor, int nPart)
{
    return IPGetArmorAppearanceType(oArmor, nPart,  X2_IP_ARMORTYPE_PREV );
}

// ----------------------------------------------------------------------------
// Returns the next valid appearance type for oArmor
// Uses Get2DAString, so do not use in loops
// ----------------------------------------------------------------------------
int IPGetRandomArmorAppearanceType(object oArmor, int nPart)
{
    return  IPGetArmorAppearanceType(oArmor, nPart,  X2_IP_ARMORTYPE_RANDOM );
}

// ----------------------------------------------------------------------------
// Returns a new armor based of oArmor with nPartModified
// nPart - ITEM_APPR_ARMOR_MODEL_* constant of the part to be changed
// nMode -
//          X2_IP_ARMORTYPE_NEXT    - next valid appearance
//          X2_IP_ARMORTYPE_PREV    - previous valid apperance;
//          X2_IP_ARMORTYPE_RANDOM  - random valid appearance (torso is never changed);
// bDestroyOldOnSuccess - Destroy oArmor in process?
// Uses Get2DAString, so do not use in loops
// ----------------------------------------------------------------------------
object IPGetModifiedArmor(object oArmor, int nPart, int nMode, int bDestroyOldOnSuccess)
{
    int nNewApp = IPGetArmorAppearanceType(oArmor, nPart,  nMode );
    //SpeakString("old: " + IntToString(GetItemAppearance(oArmor,ITEM_APPR_TYPE_ARMOR_MODEL,nPart)));
    //SpeakString("new: " + IntToString(nNewApp));

    object oNew = CopyItemAndModify(oArmor,ITEM_APPR_TYPE_ARMOR_MODEL, nPart, nNewApp,TRUE);

    if (oNew != OBJECT_INVALID)
    {
        if( bDestroyOldOnSuccess )
        {
            DestroyObject(oArmor);
        }
        return oNew;
    }
    // Safety fallback, return old armor on failures
       return oArmor;
}

// ----------------------------------------------------------------------------
// Creates a special ring on oCreature that gives
// all weapon and armor proficiencies to the wearer
// Item is set non dropable
// ----------------------------------------------------------------------------
object IPCreateProficiencyFeatItemOnCreature(object oCreature)
{
    // create a simple golden ring
    object  oRing = CreateItemOnObject("nw_it_mring023",oCreature);

    // just in case
    SetDroppableFlag(oRing, FALSE);

    itemproperty ip = ItemPropertyBonusFeat(IP_CONST_FEAT_ARMOR_PROF_HEAVY);
    AddItemProperty(DURATION_TYPE_PERMANENT,ip,oRing);
    ip = ItemPropertyBonusFeat(IP_CONST_FEAT_ARMOR_PROF_MEDIUM);
    AddItemProperty(DURATION_TYPE_PERMANENT,ip,oRing);
    ip = ItemPropertyBonusFeat(IP_CONST_FEAT_ARMOR_PROF_LIGHT);
    AddItemProperty(DURATION_TYPE_PERMANENT,ip,oRing);
    ip = ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_EXOTIC);
    AddItemProperty(DURATION_TYPE_PERMANENT,ip,oRing);
    ip = ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_MARTIAL);
    AddItemProperty(DURATION_TYPE_PERMANENT,ip,oRing);
    ip = ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_SIMPLE);
    AddItemProperty(DURATION_TYPE_PERMANENT,ip,oRing);

    return oRing;
}

// ----------------------------------------------------------------------------
// Add an item property in a safe fashion, preventing unwanted stacking
// Parameters:
//   oItem     - the item to add the property to
//   ip        - the itemproperty to add
//   fDuration - set 0.0f to add the property permanent, anything else is temporary
//   nAddItemPropertyPolicy - How to handle existing properties. Valid values are:
//     X2_IP_ADDPROP_POLICY_REPLACE_EXISTING - remove any property of the same type, subtype, durationtype before adding;
//     X2_IP_ADDPROP_POLICY_KEEP_EXISTING - do not add if any property with same type, subtype and durationtype already exists;
//     X2_IP_ADDPROP_POLICY_IGNORE_EXISTING - add itemproperty in any case - Do not Use with OnHit or OnHitSpellCast props!
//   bIgnoreDurationType  - If set to TRUE, an item property will be considered identical even if the DurationType is different. Be careful when using this
//                          with X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, as this could lead to a temporary item property removing a permanent one
//   bIgnoreSubType       - If set to TRUE an item property will be considered identical even if the SubType is different.
//
// * WARNING: This function is used all over the game. Touch it and break it and the wrath
//            of the gods will come down on you faster than you can saz "I didn't do it"
// ----------------------------------------------------------------------------
void IPSafeAddItemProperty(object oItem, itemproperty ip, float fDuration =0.0f, int nAddItemPropertyPolicy = X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, int bIgnoreDurationType = FALSE, int bIgnoreSubType = FALSE)
{
    int nType = GetItemPropertyType(ip);
    int nSubType = GetItemPropertySubType(ip);
    int nDuration;
    // if duration is 0.0f, make the item property permanent
    if (fDuration == 0.0f)
    {

        nDuration = DURATION_TYPE_PERMANENT;
    } else
    {

        nDuration = DURATION_TYPE_TEMPORARY;
    }

    int nDurationCompare = nDuration;
    if (bIgnoreDurationType)
    {
        nDurationCompare = -1;
    }

    if (nAddItemPropertyPolicy == X2_IP_ADDPROP_POLICY_REPLACE_EXISTING)
    {

        // remove any matching properties
        if (bIgnoreSubType)
        {
            nSubType = -1;
        }
        IPRemoveMatchingItemProperties(oItem, nType, nDurationCompare, nSubType );
    }
    else if (nAddItemPropertyPolicy == X2_IP_ADDPROP_POLICY_KEEP_EXISTING )
    {
         // do not replace existing properties
        if(IPGetItemHasProperty(oItem, ip, nDurationCompare, bIgnoreSubType))
        {
          return; // item already has property, return
        }
    }
    else //X2_IP_ADDPROP_POLICY_IGNORE_EXISTING
    {

    }

    if (nDuration == DURATION_TYPE_PERMANENT)
    {
        AddItemProperty(nDuration,ip, oItem);
    }
    else
    {
        AddItemProperty(nDuration,ip, oItem,fDuration);
    }
}

// ----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
int IPGetItemHasProperty(object oItem, itemproperty ipCompareTo, int nDurationCompare, int bIgnoreSubType = FALSE)
{
    itemproperty ip = GetFirstItemProperty(oItem);

    //PrintString ("Filter - T:" + IntToString(GetItemPropertyType(ipCompareTo))+ " S: " + IntToString(GetItemPropertySubType(ipCompareTo)) + " (Ignore: " + IntToString (bIgnoreSubType) + ") D:" + IntToString(nDurationCompare));
    while (GetIsItemPropertyValid(ip))
    {
        // PrintString ("Testing - T: " + IntToString(GetItemPropertyType(ip)));
        if ((GetItemPropertyType(ip) == GetItemPropertyType(ipCompareTo)))
        {
             //PrintString ("**Testing - S: " + IntToString(GetItemPropertySubType(ip)));
             if (GetItemPropertySubType(ip) == GetItemPropertySubType(ipCompareTo) || bIgnoreSubType)
             {
               // PrintString ("***Testing - d: " + IntToString(GetItemPropertyDurationType(ip)));
                if (GetItemPropertyDurationType(ip) == nDurationCompare || nDurationCompare == -1)
                {
                    //PrintString ("***FOUND");
                      return TRUE; // if duration is not ignored and durationtypes are equal, true
                 }
            }
        }
        ip = GetNextItemProperty(oItem);
    }
    //PrintString ("Not Found");
    return FALSE;
}


object IPGetTargetedOrEquippedMeleeWeapon()
{
  object oTarget = GetSpellTargetObject();
  if(GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
  {
    if (IPGetIsMeleeWeapon(oTarget))
    {
        return oTarget;
    }
    else
    {
        return OBJECT_INVALID;
    }

  }

  object oWeapon1 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
  if (GetIsObjectValid(oWeapon1) && IPGetIsMeleeWeapon(oWeapon1))
  {
    return oWeapon1;
  }

  oWeapon1 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
  if (GetIsObjectValid(oWeapon1) && IPGetIsMeleeWeapon(oWeapon1))
  {
    return oWeapon1;
  }

  oWeapon1 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oTarget);
  if (GetIsObjectValid(oWeapon1))
  {
    return oWeapon1;
  }

  oWeapon1 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oTarget);
  if (GetIsObjectValid(oWeapon1))
  {
    return oWeapon1;
  }

  return OBJECT_INVALID;

}




object IPGetTargetedOrEquippedArmor(int bAllowShields = FALSE){

	object oTarget = GetSpellTargetObject();
	int nType;
	if(GetIsObjectValid(oTarget)){
		if (GetObjectType(oTarget) == OBJECT_TYPE_ITEM){
			nType = GetBaseItemType(oTarget);
			if (nType == BASE_ITEM_ARMOR) return oTarget;
			else if ((bAllowShields) && (nType == BASE_ITEM_LARGESHIELD ||
				nType == BASE_ITEM_SMALLSHIELD || nType == BASE_ITEM_TOWERSHIELD))
					return oTarget;
			else return OBJECT_INVALID;
		} else {
			object oArmor1 = GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget);
			if (!GetIsObjectValid(oArmor1)){
				if (bAllowShields) 
					oArmor1 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
				else return OBJECT_INVALID;
			}
			nType = GetBaseItemType(oArmor1);
			if (nType == BASE_ITEM_ARMOR || (bAllowShields && (nType == BASE_ITEM_LARGESHIELD ||
				nType == BASE_ITEM_SMALLSHIELD || nType == BASE_ITEM_TOWERSHIELD)))
					return oArmor1;
		}
	}
	return OBJECT_INVALID;
}


/* Original IPGetTargetedOrEquippedArmor()
object IPGetTargetedOrEquippedArmor(int bAllowShields = FALSE)
{
  object oTarget = GetSpellTargetObject();
  if(GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
  {
    if (GetBaseItemType(oTarget) == BASE_ITEM_ARMOR)
    {
        return oTarget;
    }
    else
    {
        if ((bAllowShields) && (GetBaseItemType(oTarget) == BASE_ITEM_LARGESHIELD ||
                               GetBaseItemType(oTarget) == BASE_ITEM_SMALLSHIELD ||
                                GetBaseItemType(oTarget) == BASE_ITEM_TOWERSHIELD))
        {
            return oTarget;
        }
        else
        {
            return OBJECT_INVALID;
        }
    }

  }

  object oArmor1 = GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget);
  if (GetIsObjectValid(oArmor1) && GetBaseItemType(oArmor1) == BASE_ITEM_ARMOR)
  {
    return oArmor1;
  }
  if (bAllowShields != FALSE)
  {
      oArmor1 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
      if (GetIsObjectValid(oArmor1) && (GetBaseItemType(oTarget) == BASE_ITEM_LARGESHIELD ||
                               GetBaseItemType(oTarget) == BASE_ITEM_SMALLSHIELD ||
                                GetBaseItemType(oTarget) == BASE_ITEM_TOWERSHIELD))
      {
        return oArmor1;
      }
    }



  return OBJECT_INVALID;

}
*/

// ----------------------------------------------------------------------------
// Returns FALSE it the item has no sequencer property
// Returns number of spells that can be stored in any other case
// ----------------------------------------------------------------------------
int IPGetItemSequencerProperty(object oItem)
{
    if (!GetItemHasItemProperty(oItem, ITEM_PROPERTY_CAST_SPELL))
    {
        return FALSE;
    }

    int nCnt;
    itemproperty ip;

    ip = GetFirstItemProperty(oItem);

    while (GetIsItemPropertyValid(ip) && nCnt ==0)
    {
        if (GetItemPropertyType(ip) ==ITEM_PROPERTY_CAST_SPELL)
        {
            if(GetItemPropertySubType(ip) == 523) // sequencer 3
            {
                nCnt =  3;
            }
            else if(GetItemPropertySubType(ip) == 522) // sequencer 2
            {
                nCnt =  2;
            }
            else if(GetItemPropertySubType(ip) == 521) // sequencer 1
            {
                nCnt =  1;
            }
        }
        ip = GetNextItemProperty(oItem);
    }

    return nCnt;
}

void IPCopyItemProperties(object oSource, object oTarget, int bIgnoreCraftProps = TRUE)
{
    itemproperty ip = GetFirstItemProperty(oSource);
    int nSub;

    while (GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyDurationType(ip) == DURATION_TYPE_PERMANENT)
        {
            if (bIgnoreCraftProps)
            {
                if (GetItemPropertyType(ip) ==ITEM_PROPERTY_CAST_SPELL)
                {
                    nSub = GetItemPropertySubType(ip);
                    // filter crafting properties
                    if (nSub != 498 && nSub != 499 && nSub  != 526 && nSub != 527)
                    {
                        AddItemProperty(DURATION_TYPE_PERMANENT,ip,oTarget);
                    }
                }
                else
                {
                    AddItemProperty(DURATION_TYPE_PERMANENT,ip,oTarget);
                }
            }
            else
            {
                AddItemProperty(DURATION_TYPE_PERMANENT,ip,oTarget);
            }
        }
        ip = GetNextItemProperty(oSource);
    }
}

int IPGetIsIntelligentWeapon(object oItem)
{
    int bRet = FALSE ;
    itemproperty ip = GetFirstItemProperty(oItem);
    while (GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyType(ip) ==  ITEM_PROPERTY_ONHITCASTSPELL)
        {
            if (GetItemPropertySubType(ip) == 135)
            {
                return TRUE;
            }
        }
        ip = GetNextItemProperty(oItem);
    }
    return bRet;
}

// ----------------------------------------------------------------------------
// (private)
// ----------------------------------------------------------------------------
int IPGetWeaponAppearanceType(object oWeapon, int nPart, int nMode)
{
    string sMode;

    switch (nMode)
    {
        case        X2_IP_WEAPONTYPE_NEXT : sMode ="Next";
                    break;
        case        X2_IP_WEAPONTYPE_PREV : sMode ="Prev";
                    break;
    }

    int nCurrApp  = GetItemAppearance(oWeapon,ITEM_APPR_TYPE_WEAPON_MODEL,nPart);
    int nRet;

    int nMax =  9;// IPGetNumberOfArmorAppearances(nPart)-1; // index from 0 .. numparts -1
    int nMin =  1;

    // return a random valid armor tpze
    if (nMode == X2_IP_WEAPONTYPE_RANDOM)
    {
        return Random(nMax)+nMin;
    }

    else
    {
        if (nMode == X2_IP_WEAPONTYPE_NEXT)
        {
            // current appearance is max, return min
            if (nCurrApp == nMax)
            {
                return nMax;
            }
            // current appearance is min, return max  -1
            else if (nCurrApp == nMin)
            {
                nRet = nMin +1;
                return nRet;
            }

            //SpeakString("next");
            // next
            nRet = nCurrApp +1;
            return nRet;
        }
        else                // previous
        {
            // current appearance is max, return nMax-1
            if (nCurrApp == nMax)
            {
                nRet = nMax--;
                return nRet;
            }
            // current appearance is min, return max
            else if (nCurrApp == nMin)
            {
                return nMin;
            }

            //SpeakString("prev");

            nRet = nCurrApp -1;
            return nRet;
        }


     }
}

// ----------------------------------------------------------------------------
// Returns a new armor based of oArmor with nPartModified
// nPart - ITEM_APPR_WEAPON_MODEL_* constant of the part to be changed
// nMode -
//          X2_IP_WEAPONTYPE_NEXT    - next valid appearance
//          X2_IP_WEAPONTYPE_PREV    - previous valid apperance;
//          X2_IP_WEAPONTYPE_RANDOM  - random valid appearance (torso is never changed);
// bDestroyOldOnSuccess - Destroy oArmor in process?
// Uses Get2DAString, so do not use in loops
// ----------------------------------------------------------------------------
object IPGetModifiedWeapon(object oWeapon, int nPart, int nMode, int bDestroyOldOnSuccess)
{
    int nNewApp = IPGetWeaponAppearanceType(oWeapon, nPart,  nMode );
    //SpeakString("old: " + IntToString(GetItemAppearance(oWeapon,ITEM_APPR_TYPE_WEAPON_MODEL,nPart)));
    //SpeakString("new: " + IntToString(nNewApp));
    object oNew = CopyItemAndModify(oWeapon,ITEM_APPR_TYPE_WEAPON_MODEL, nPart, nNewApp,TRUE);
    if (oNew != OBJECT_INVALID)
    {
        if( bDestroyOldOnSuccess )
        {
            DestroyObject(oWeapon);
        }
        return oNew;
    }
    // Safety fallback, return old weapon on failures
       return oWeapon;
}


object IPCreateAndModifyArmorRobe(object oArmor, int nRobeType)
{
    object oRet = CopyItemAndModify(oArmor,ITEM_APPR_TYPE_ARMOR_MODEL,ITEM_APPR_ARMOR_MODEL_ROBE,nRobeType+2,TRUE);
    if (GetIsObjectValid(oRet))
    {
        return oRet;
    }
    else // safety net
    {
        return oArmor;
    }
}

// ----------------------------------------------------------------------------
// Provide mapping between numbers and power constants for
// ITEM_PROPERTY_DAMAGE_BONUS
// ----------------------------------------------------------------------------
int IPGetDamagePowerConstantFromNumber(int nNumber)
{
    switch (nNumber)
    {
        case 0: return DAMAGE_POWER_NORMAL;
        case 1: return DAMAGE_POWER_PLUS_ONE;
        case 2: return  DAMAGE_POWER_PLUS_TWO;
        case 3: return DAMAGE_POWER_PLUS_THREE;
        case 4: return DAMAGE_POWER_PLUS_FOUR;
        case 5: return DAMAGE_POWER_PLUS_FIVE;
        case 6: return DAMAGE_POWER_PLUS_SIX;
        case 7: return DAMAGE_POWER_PLUS_SEVEN;
        case 8: return DAMAGE_POWER_PLUS_EIGHT;
        case 9: return DAMAGE_POWER_PLUS_NINE;
        case 10: return DAMAGE_POWER_PLUS_TEN;
        case 11: return DAMAGE_POWER_PLUS_ELEVEN;
        case 12: return DAMAGE_POWER_PLUS_TWELVE;
        case 13: return DAMAGE_POWER_PLUS_THIRTEEN;
        case 14: return DAMAGE_POWER_PLUS_FOURTEEN;
        case 15: return DAMAGE_POWER_PLUS_FIFTEEN;
        case 16: return DAMAGE_POWER_PLUS_SIXTEEN;
        case 17: return DAMAGE_POWER_PLUS_SEVENTEEN;
        case 18: return DAMAGE_POWER_PLUS_EIGHTEEN  ;
        case 19: return DAMAGE_POWER_PLUS_NINTEEN;
        case 20: return DAMAGE_POWER_PLUS_TWENTY;
    }

    if (nNumber>20)
    {
        return DAMAGE_POWER_PLUS_TWENTY;
    }
        else
    {
        return DAMAGE_POWER_NORMAL;
    }
}

// ----------------------------------------------------------------------------
// Provide mapping between numbers and bonus constants for ITEM_PROPERTY_DAMAGE_BONUS
// Note that nNumber should be > 0!
// ----------------------------------------------------------------------------
int IPGetDamageBonusConstantFromNumber(int nNumber)
{
    switch (nNumber)
    {
        case 1:  return DAMAGE_BONUS_1;
        case 2:  return DAMAGE_BONUS_2;
        case 3:  return DAMAGE_BONUS_3;
        case 4:  return DAMAGE_BONUS_4;
        case 5:  return DAMAGE_BONUS_5;
        case 6:  return DAMAGE_BONUS_6;
        case 7:  return DAMAGE_BONUS_7;
        case 8:  return DAMAGE_BONUS_8;
        case 9:  return DAMAGE_BONUS_9;
        case 10: return DAMAGE_BONUS_10;
        case 11:  return DAMAGE_BONUS_11;
        case 12:  return DAMAGE_BONUS_12;
        case 13:  return DAMAGE_BONUS_13;
        case 14:  return DAMAGE_BONUS_14;
        case 15:  return DAMAGE_BONUS_15;
        case 16:  return DAMAGE_BONUS_16;
        case 17:  return DAMAGE_BONUS_17;
        case 18:  return DAMAGE_BONUS_18;
        case 19:  return DAMAGE_BONUS_19;
        case 20: return DAMAGE_BONUS_20;
	case 21: return DAMAGE_BONUS_21;
        case 22: return DAMAGE_BONUS_22;
        case 23: return DAMAGE_BONUS_23;
        case 24: return DAMAGE_BONUS_24;
        case 25: return DAMAGE_BONUS_25;
        case 26: return DAMAGE_BONUS_26;
        case 27: return DAMAGE_BONUS_27;
        case 28: return DAMAGE_BONUS_28;
        case 29: return DAMAGE_BONUS_29;
        case 30: return DAMAGE_BONUS_30;
        case 31: return DAMAGE_BONUS_31;
        case 32: return DAMAGE_BONUS_32;
        case 33: return DAMAGE_BONUS_33;
        case 34: return DAMAGE_BONUS_34;
        case 35: return DAMAGE_BONUS_35;
        case 36: return DAMAGE_BONUS_36;
        case 37: return DAMAGE_BONUS_37;
        case 38: return DAMAGE_BONUS_38;
        case 39: return DAMAGE_BONUS_39;
        case 40: return DAMAGE_BONUS_40;
    }

    if (nNumber>40)
    {
        return DAMAGE_BONUS_40;
    }
        else
    {
        return -1;
    }
}

// ----------------------------------------------------------------------------
// GZ, Sept. 30 2003
// Special Version of Copy Item Properties for use with greater wild shape
// oOld - Item equipped before polymorphing (source for item props)
// oNew - Item equipped after polymorphing  (target for item props)
// bWeapon - Must be set TRUE when oOld is a weapon.
// ----------------------------------------------------------------------------
void IPWildShapeCopyItemProperties(object oOld, object oNew, int bWeapon = FALSE)
{
    if (GetIsObjectValid(oOld) && GetIsObjectValid(oNew))
    {
        itemproperty ip = GetFirstItemProperty(oOld);
        while (GetIsItemPropertyValid(ip))
        {
            if (bWeapon)
            {
                if (GetWeaponRanged(oOld) == GetWeaponRanged(oNew)   )
                {
                	if (GetItemPropertyType(ip) != ITEM_PROPERTY_CAST_SPELL ||
						GetItemPropertyType(ip) != ITEM_PROPERTY_ON_HIT_PROPERTIES ||
						GetItemPropertyType(ip) != ITEM_PROPERTY_ONHITCASTSPELL ||
						GetItemPropertyType(ip) != ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE ||
						GetItemPropertyType(ip) != ITEM_PROPERTY_BONUS_FEAT )
					{	AddItemProperty(DURATION_TYPE_PERMANENT,ip,oNew);	}
                }
            }
            else
            {
                    AddItemProperty(DURATION_TYPE_PERMANENT,ip,oNew);
            }
            ip = GetNextItemProperty(oOld);

        }
    }
}

// ----------------------------------------------------------------------------
// Returns the current enhancement bonus of a weapon (+1 to +20), 0 if there is
// no enhancement bonus. You can test for a specific type of enhancement bonus
// by passing the appropritate ITEM_PROPERTY_ENHANCEMENT_BONUS* constant into
// nEnhancementBonusType
// ----------------------------------------------------------------------------
int IPGetWeaponEnhancementBonus(object oWeapon, int nEnhancementBonusType = ITEM_PROPERTY_ENHANCEMENT_BONUS)
{
    itemproperty ip = GetFirstItemProperty(oWeapon);
    int nFound = 0;
    while (nFound == 0 && GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyType(ip) == nEnhancementBonusType)
        {
            nFound = GetItemPropertyCostTableValue(ip);
        }
        ip = GetNextItemProperty(oWeapon);
    }
    return nFound;
}

// -----------------------------------------------------SCOD Exclusive!--------
// Returns the enhancement bonus subtype for bonuses vs. alignment group, 
// racial group, and specific alignment
// Pass the appropriate ITEM_PROPERTY_ENHANCEMENT_BONUS* constant into 
// nAttackBonusType
// ----------------------------------------------------------------------------
int IPGetWeaponEnhancementBonusSubtype(object oWeapon, int nEnhancementBonusType)
{
	itemproperty ip = GetFirstItemProperty(oWeapon);
	int nSubtype = 0;
	while (nSubtype == 0 && GetIsItemPropertyValid(ip))
	{
		if (GetItemPropertyType(ip) == nEnhancementBonusType)
		{
			nSubtype = GetItemPropertySubType(ip);
		}
		ip = GetNextItemProperty(oWeapon);
	}
	return nSubtype;

}

// -----------------------------------------------------SCOD Exclusive!--------
// Returns the current attack bonus of a weapon (+1 to +20), 0 if there is no
// attack bonus. You can test for a specific type of attack bonus by passing
// the appropriate ITEM_PROPERTY_ATTACK_BONUS* constant into nAttackBonusType
// ----------------------------------------------------------------------------
int IPGetWeaponAttackBonus(object oWeapon, int nAttackBonusType = ITEM_PROPERTY_ATTACK_BONUS)
{
    itemproperty ip = GetFirstItemProperty(oWeapon);
    int nFound = 0;
    while (nFound == 0 && GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyType(ip) == (nAttackBonusType)) // may need to subtract 50?
        {
            nFound = GetItemPropertyCostTableValue(ip);
		}
        ip = GetNextItemProperty(oWeapon);
    }
    return nFound;
}

// -----------------------------------------------------SCOD Exclusive!--------
// Returns the attack bonus subtype for bonuses vs. alignment group, racial
// group, and specific alignment. 
// Pass the appropriate ITEM_PROPERTY_ATTACK_BONUS* constant into 
// nAttackBonusType
// ----------------------------------------------------------------------------
int IPGetWeaponAttackBonusSubtype(object oWeapon, int nAttackBonusType)
{
	itemproperty ip = GetFirstItemProperty(oWeapon);
	int nSubtype = 0;
	while (nSubtype == 0 && GetIsItemPropertyValid(ip))
	{
		if (GetItemPropertyType(ip) == nAttackBonusType) // may need to subtract 50?
		{
			nSubtype = GetItemPropertySubType(ip);
		}
		ip = GetNextItemProperty(oWeapon);
	}
	return nSubtype;
}

// ----------------------------------------------------------------------------
// Shortcut function to set the enhancement bonus of a weapon to a certain bonus
// Specifying bOnlyIfHigher as TRUE will prevent a bonus lower than the requested
// bonus from being applied. Valid values for nBonus are 1 to 20.
// ----------------------------------------------------------------------------
void IPSetWeaponEnhancementBonus(object oWeapon, int nBonus, int bOnlyIfHigher = TRUE)
{
    int nCurrent = IPGetWeaponEnhancementBonus(oWeapon);

    itemproperty ip = GetFirstItemProperty(oWeapon);

    if (bOnlyIfHigher && nCurrent > nBonus)
    {
        return;
    }

    if (nBonus <1 || nBonus > 20)
    {
        return;
    }

    while (GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyType(ip) ==ITEM_PROPERTY_ENHANCEMENT_BONUS)
        {
            RemoveItemProperty(oWeapon,ip);
        }
        ip = GetNextItemProperty(oWeapon);
    }

    ip = ItemPropertyEnhancementBonus(nBonus);
    AddItemProperty(DURATION_TYPE_PERMANENT,ip,oWeapon);
}


// ----------------------------------------------------------------------------
// Shortcut function to upgrade the enhancement bonus of a weapon by the
// number specified in nUpgradeBy. If the resulting new enhancement bonus
// would be out of bounds (>+20), it will be set to +20
// ----------------------------------------------------------------------------
void IPUpgradeWeaponEnhancementBonus(object oWeapon, int nUpgradeBy)
{
    int nCurrent = IPGetWeaponEnhancementBonus(oWeapon);

    itemproperty ip = GetFirstItemProperty(oWeapon);

    int nNew = nCurrent + nUpgradeBy;
    if (nNew <1 )
    {
        nNew = 1;
    }
    else if (nNew >20)
    {
       nNew = 20;
    }

    while (GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyType(ip) ==ITEM_PROPERTY_ENHANCEMENT_BONUS)
        {
            RemoveItemProperty(oWeapon,ip);
        }
        ip = GetNextItemProperty(oWeapon);
    }

    ip = ItemPropertyEnhancementBonus(nNew);
    AddItemProperty(DURATION_TYPE_PERMANENT,ip,oWeapon);

}

int IPGetHasItemPropertyByConst(int nItemProp, object oItem)
{
    itemproperty ip = GetFirstItemProperty(oItem);
    while (GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyType(ip) ==nItemProp)
        {
            return TRUE;
        }
        ip = GetNextItemProperty(oItem);
    }
    return FALSE;

}

// ----------------------------------------------------------------------------
// Returns TRUE if a use limitation of any kind is present on oItem
// ----------------------------------------------------------------------------
int IPGetHasUseLimitation(object oItem)
{
    itemproperty ip = GetFirstItemProperty(oItem);
    int nType;
    while (GetIsItemPropertyValid(ip))
    {
        nType = GetItemPropertyType(ip);
        if (
           nType == ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP ||
           nType == ITEM_PROPERTY_USE_LIMITATION_CLASS ||
           nType == ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE ||
           nType == ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT  )
        {
            return TRUE;
        }
        ip = GetNextItemProperty(oItem);
    }
    return FALSE;

}

//------------------------------------------------------------------------------
// GZ, Oct 2003
// Returns TRUE if a character has any item equipped that has the itemproperty
// defined in nItemPropertyConst in it (ITEM_PROPERTY_* constant)
//------------------------------------------------------------------------------
int IPGetHasItemPropertyOnCharacter(object oPC, int nItemPropertyConst)
{
    object oWeaponOld = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
    object oArmorOld  = GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
    object oRing1Old  = GetItemInSlot(INVENTORY_SLOT_LEFTRING,oPC);
    object oRing2Old  = GetItemInSlot(INVENTORY_SLOT_RIGHTRING,oPC);
    object oAmuletOld = GetItemInSlot(INVENTORY_SLOT_NECK,oPC);
    object oCloakOld  = GetItemInSlot(INVENTORY_SLOT_CLOAK,oPC);
    object oBootsOld  = GetItemInSlot(INVENTORY_SLOT_BOOTS,oPC);
    object oBeltOld   = GetItemInSlot(INVENTORY_SLOT_BELT,oPC);
    object oHelmetOld = GetItemInSlot(INVENTORY_SLOT_HEAD,oPC);
    object oLeftHand  = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);

    int bHas =  IPGetHasItemPropertyByConst(nItemPropertyConst, oWeaponOld);
     bHas = bHas ||  IPGetHasItemPropertyByConst(nItemPropertyConst, oLeftHand);
    bHas = bHas || IPGetHasItemPropertyByConst(nItemPropertyConst, oArmorOld);
    if (bHas)
        return TRUE;
    bHas = bHas || IPGetHasItemPropertyByConst(nItemPropertyConst, oRing1Old);
    bHas = bHas || IPGetHasItemPropertyByConst(nItemPropertyConst, oRing2Old);
    bHas = bHas || IPGetHasItemPropertyByConst(nItemPropertyConst, oAmuletOld);
    bHas = bHas || IPGetHasItemPropertyByConst(nItemPropertyConst, oCloakOld);
    if (bHas)
        return TRUE;
    bHas = bHas || IPGetHasItemPropertyByConst(nItemPropertyConst, oBootsOld);
    bHas = bHas || IPGetHasItemPropertyByConst(nItemPropertyConst, oBeltOld);
    bHas = bHas || IPGetHasItemPropertyByConst(nItemPropertyConst, oHelmetOld);

    return bHas;

}

//------------------------------------------------------------------------------
// GZ, Oct 24, 2003
// Returns an integer with the number of properties present oItem
//------------------------------------------------------------------------------
int IPGetNumberOfItemProperties(object oItem)
{
    itemproperty ip = GetFirstItemProperty(oItem);
    int nCount = 0;
    while (GetIsItemPropertyValid(ip))
    {
        nCount++;
        ip = GetNextItemProperty(oItem);
    }
    return nCount;
}