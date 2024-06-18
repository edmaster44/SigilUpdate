// v1.00 (compile x2_pc_craft to get effects ingame)

//::///////////////////////////////////////////////
//:: x2_inc_craft
//:: Copyright (c) 2003 Bioare Corp.
//:://////////////////////////////////////////////
/*

    Central include for crafting feat and
    crafting skill system.

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-05-09
//:: Last Updated On: 2024-05-31
//:://////////////////////////////////////////////
// ChazM 5/10/06 - Removed XP costs.  Did anyone really like XP costs?
// ChazM 5/23/06 - added AppendSpellToName().  Updated potion and wand creation to use it.
// ChazM 5/24/06 - Updated AppendSpellToName()
// ChazM 11/6/06 - Modified CIGetSpellInnateLevel() to instead get the caster level, Added 
//				MakeItemUseableByClassesWithSpellAccess() and helper functions used in CICraftCraftWand()
// ChazM 11/7/06 - Calculate spell level based on caster class and spells.2da entries, Changed 0 level spells to 
//				cost half of first level spells, reorganized some sections, replaced string refs w/ constants, 
//				fixed SPELLS_WIZ_SORC_LEVEL_COL
// ChazM 4/27/07 - Moved constants to ginc_2da
// FlattedFifth May 31, 2024 - modified MakeItemUseableByClassesWithSpellAccess() to fix a bug that was 
//				causing some wands to not be usable by favored soul, even though FS has the same spell list and
//				and even if it was a FS that made the wand; and added spirit shaman to druid wands just in 
//				case a similar bug popped up for them. Also gave knight access to all player-made wands made 
//				with cleric spells, gave bards access to all player-made wands of wizard spells, and 
//				gave ranger access to all player-made wands of druid spells. Also added constants
//				for favored soul class and shaman class because I could not find "ginc_2da" to verify those constants.
//				Also modified MakeItemUseableByClass() to check for that property before adding it. So far this is 
//				working correctly for wands but not for scrolls. Something to do with the fact that the wand is
//				generated from scratch but scribe scroll spawns the existing in-game scroll? Possibly. Removed
//				the property add function call from scribe scroll function until I can get it working properly.
//	FlattedFifth June 4, 2024 - Fixed a previous error of mine in  MakeItemUseableByClass() that caused double-application 
//				of the same class use limitation property on some scrolls. Added option to allow players to brew cure 
//				critical and inflict critical, heal, and harm potions controlled via boolean style integer constants. 
//				Added options for player-scribed raise dead and resurrection scrolls to be usuable by anyone without UMD,
//				also controlled by a boolean style integer constant. (Special thanks to Dae for simplifying MakeItemUseableByClass())
//				Fixed spell level check in brew potions.
//	FlattedFifth June 6, 2024 - Fixed Erroneous old code that was preventing clerics from scribing their domain spells
//				because it was looking at the caster to know what spellbook to look in instead of the spell itself.
//				Edited MakeItemUseableByClassesWithSpellAccess() to properly add cleric when a spell is cast by a cleric 
//				so that wands and scrolls of cleric domain spells are useable by clerics when clerics make them, but this
//      		might need to be edited to exclude making wands and scrolls from other wands and scrolls. a GetSpellCastItem() 
//				check, maybe? -Addendum, added optional booleans to toggle and and off allowing favored soul and knight access
//				to wands and scrolls made with a cleric domain spell. Also added check that prevents a multiclass cleric with UMD 
//				from just making any wand or scroll cleric usable by using an item to create it. Also changed all my constants
//				from camelCase to SHOUTY_CAPS in keeping with standard practice for nwscript.
//	FlattedFifth June 12, 2024 - Made all crafted potions use the base item from a default Heal spell because that base Item
//				will autotarget the user with the cast spell item property. We just remove the heal spell from it and place
//				the new one in. Also crafted potions have the spell descriptions as their own descriptions. Some spells
//				that make no sense to be user-only, such as remove fear or remove paralysis, use the normal crafted potion bottle
//				that asks for a target. Also removed class use limitations from Stone To Flesh, and of course that can be toggled
//				off with a boolean.

#include "x2_inc_itemprop"
#include "x2_inc_switches"
#include "ginc_debug"
#include "ginc_2da"


const int ID_SPELL_RAISE_DEAD = 142;
const int ID_SPELL_FULL_RES = 153;
const int ID_SPELL_CURE_CRIT = 31;
const int ID_SPELL_INFLICT_CRIT = 435;
const int ID_SPELL_HEAL = 79;
const int ID_SPELL_HARM = 77;
const int ID_SPELL_STONE_TO_FLESH = 486;

// If true, then scrolls of raise dead scribed by players have no class use limitations, anyone can use them
// without UMD. Default OC behaviour is false.
const int B_RAISE_SCROLL_NO_CLASS_LIMIT = TRUE;

// As above, but with resurrection
const int B_FULL_RES_SCROLL_NO_CLASS_LIMIT = TRUE;

// As above but with Stone to Flesh
const int B_STONE_TO_FLESH_SCROLL_NO_CLASS_LIMIT = TRUE;

// If true, allows players to brew potions of cure critical wounds. I don't like that an npc is the only source
// for these. Players should give other players their money, not npcs, whenever possible. Note that we will 
// need to do some testing to make sure that the cost to brew these potions is == or > the sell price to stores.
const int B_ALLOW_CURE_CRIT_POTS = TRUE;

// As above, but for heal (and harm for undead pcs). Allowing heals automatically allows the above, but having
// both set to true doesn't hurt anything.
const int B_ALLOW_HEAL_POTS = TRUE;

//nerfs the cost for players to make raise dead scrolls to compare favourably with NPC sold items
const int B_CHEAP_RAISE_SCROLLS = TRUE;
// cost to make raise scrolls IF above is true. Based on 70% of the cost of 1 use of a pheonix feather
const int N_RAISE_COST = 250;

//as above, but for full res
const int B_CHEAP_FULL_RES_SCROLLS = TRUE;
const int N_RES_COST = 350;

// if true enables a favored soul to use a cleric wand or scroll made via a domain, without UMD.
const int B_FS_ACCESS_DOMAIN_WANDSCROLL = FALSE;

// as above, but for knights
const int B_KNIGHT_ACCESS_DOMAIN_WANDSCROLL = FALSE;

//void main(){}

//--------------------------------------------------------------------
// Structs
//--------------------------------------------------------------------

struct craft_struct
{
    int    nRow;
    string sResRef;
    int    nDC;
    int    nCost;
    string sLabel;
};

struct craft_receipe_struct
{
    int nMode;
    object oMajor;
    object oMinor;
};

//--------------------------------------------------------------------
// Constants
//--------------------------------------------------------------------
// Item Creation string refs

const int STR_REF_IC_SPELL_TO_HIGH_FOR_WAND 		= 83623;
const int STR_REF_IC_SPELL_TO_HIGH_FOR_POTION 		= 76416;
const int STR_REF_IC_SPELL_RESTRICTED_FOR_POTION	= 83450;
const int STR_REF_IC_SPELL_RESTRICTED_FOR_SCROLL	= 83451;
const int STR_REF_IC_SPELL_RESTRICTED_FOR_WAND		= 83452;
const int STR_REF_IC_MISSING_REQUIRED_FEAT			= 40487;

const int STR_REF_IC_INSUFFICIENT_GOLD				= 3786;
const int STR_REF_IC_INSUFFICIENT_XP				= 3785;

const int STR_REF_IC_SUCCESS						= 8502;
const int STR_REF_IC_FAILED							= 76417;
const int STR_REF_IC_DISABLED						= 83612;
const int STR_REF_IC_ITEM_USE_NOT_ALLOWED			= 83373;

const int FIRST_WAND_ICON                           = 2300;


const string  X2_CI_CRAFTSKILL_CONV ="x2_p_craftskills";

// Brew Potion related Constants
const int     X2_CI_BREWPOTION_FEAT_ID        = 944;                    // Brew Potion feat simulation
const int     X2_CI_BREWPOTION_MAXLEVEL       = 3;                      // Max Level for potions
const int     X2_CI_BREWPOTION_COSTMODIFIER   = 16;                     // gp Brew Potion XPCost Modifier

const string  X2_CI_BREWPOTION_NEWITEM_RESREF = "x2_it_pcpotion";       // ResRef for new potion item, if we want the potion to ask the user for a target
const string  X2_CI_DEFAULT_HEAL_POTION_RESREF = "nw_it_mpotion012";    // ResRef for new base game heal potion, if we want the potion to auto target the user

// Scribe Scroll related constants
const int     X2_CI_SCRIBESCROLL_FEAT_ID        = 945;
const int     X2_CI_SCRIBESCROLL_COSTMODIFIER   = 15;                 // Scribescroll Cost Modifier
const string  X2_CI_SCRIBESCROLL_NEWITEM_RESREF = "x2_it_pcscroll";   // ResRef for new scroll item

// Craft Wand related constants
const int     X2_CI_CRAFTWAND_FEAT_ID        = 946;
const int     X2_CI_CRAFTWAND_MAXLEVEL       = 4;
const int     X2_CI_CRAFTWAND_COSTMODIFIER   = 300;
const string  X2_CI_CRAFTWAND_NEWITEM_RESREF = "x2_it_pcwand";

// 2da for the craftskills
const string X2_CI_CRAFTING_WP_2DA 		= "des_crft_weapon" ;
const string X2_CI_CRAFTING_AR_2DA 		= "des_crft_armor" ;
const string X2_CI_CRAFTING_MAT_2DA 	= "des_crft_mat";


// spells 2da
//const string SPELLS_2DA 				= "spells";			// 2da
//const int SPELLS_ROW_COUNT				= 1008; 			// number of rows in the spells table.
//const string SPELLS_NAME_COL 			= "Name";			// str ref of spell name
//const string SPELLS_DESC_COL 			= "SpellDesc";		// str ref of spell description
//const string SPELLS_INNATE_LEVEL_COL 	= "Innate";			// Innate level of spell
//const string SPELLS_BARD_LEVEL_COL 		= "Bard";			// Bard spell level
//const string SPELLS_CLERIC_LEVEL_COL 	= "Cleric";			// Cleric spell level
//const string SPELLS_DRUID_LEVEL_COL 	= "Druid";			// Druid spell level
//const string SPELLS_PALADIN_LEVEL_COL 	= "Paladin";		// Paladin spell level
//const string SPELLS_RANGER_LEVEL_COL 	= "Ranger";			// Ranger spell level
//const string SPELLS_WIZ_SORC_LEVEL_COL 	= "Wiz_Sorc";		// Wizard and Sorceror spell level
//const string SPELLS_WARLOCK_LEVEL_COL 	= "Warlock";		// Warlock spell level

// 2da for matching spells to properties
const string X2_CI_CRAFTING_SP_2DA = "des_crft_spells" ;
// Base custom token for item modification conversations (do not change unless you want to change the conversation too)
const int     X2_CI_CRAFTINGSKILL_CTOKENBASE = 13220;

// Base custom token for DC item modification conversations (do not change unless you want to change the conversation too)
const int     X2_CI_CRAFTINGSKILL_DC_CTOKENBASE = 14220;

// Base custom token for DC item modification conversations (do not change unless you want to change the conversation too)
const int     X2_CI_CRAFTINGSKILL_GP_CTOKENBASE = 14320;

// Base custom token for DC item modification conversations (do not change unless you want to change the conversation too)
const int     X2_CI_MODIFYARMOR_GP_CTOKENBASE = 14420;

//How many items per 2da row in X2_IP_CRAFTING_2DA, do not change>4 until you want to create more conversation condition scripts as well
const int     X2_CI_CRAFTING_ITEMS_PER_ROW = 5;

// name of the scroll 2da
const string  X2_CI_2DA_SCROLLS = "des_crft_scroll";

const int X2_CI_CRAFTMODE_INVALID   = 0;
const int X2_CI_CRAFTMODE_CONTAINER = 1; // no longer used, but left in for the community to reactivate
const int X2_CI_CRAFTMODE_BASE_ITEM  = 2;
const int X2_CI_CRAFTMODE_ASSEMBLE = 3;

const int X2_CI_MAGICTYPE_INVALID = 0;
const int X2_CI_MAGICTYPE_ARCANE  = 1;
const int X2_CI_MAGICTYPE_DIVINE  = 2;

const int X2_CI_MODMODE_INVALID = 0;
const int X2_CI_MODMODE_ARMOR = 1;
const int X2_CI_MODMODE_WEAPON = 2;

//--------------------------------------------------------------------
// Prototypes
//--------------------------------------------------------------------
// *  Returns the innate level of a spell. If bDefaultZeroToOne is given
// *  Level 0 spell will be returned as level 1 spells
int   CIGetSpellInnateLevel(int nSpellId, int bDefaultZeroToOne = FALSE);

string GetClassSpellLevelColumn(int iClass);
int GetSpellLevelForClass(int iSpell, int iClass);
int IsOnSpellList(int iSpell, int iClass);
void MakeItemUseableByClass(int iClassType, object oItem);
void MakeItemUseableByClassesWithSpellAccess(int iSpell, object oItem);

// *  Returns TRUE if an item is a Craft Base Item
// *  to be used in spellscript that can be cast on items - i.e light
int   CIGetIsCraftFeatBaseItem( object oItem );

// *******************************************************
// ** Craft Checks
// *  Checks if the last spell cast was used to brew potion and will do the brewing process.
// *  Returns TRUE if the spell was indeed used to brew a potion (regardless of the actual outcome of the brewing process)
// *  Meant to be used in spellscripts only
int   CICraftCheckBrewPotion(object oSpellTarget, object oCaster);

// *  Checks if the last spell cast was used to scribe a scroll and handles the scribe scroll process
// *  Returns TRUE if the spell was indeed used to scribe a scroll (regardless of the actual outcome)
// *  Meant to be used in spellscripts only
int   CICraftCheckScribeScroll(object oSpellTarget, object oCaster);

int CICraftCheckCraftWand(object oSpellTarget, object oCaster);

// *******************************************************
// ** Craft!
// *   Create a new potion item based on the spell nSpellId  on the creator
object CICraftBrewPotion(object oCreator, int nSpellId );

// *   Create a new scroll item based on the spell nSpellId on the creator
object CICraftScribeScroll(object oCreator, int nSpellId);

// *   Create a new wand item based on the spell nSpellId on the creator
object CICraftCraftWand(object oCreator, int nSpellId );


// *  Checks if the caster intends to use his item creation feats and
// *  calls appropriate item creation subroutine if conditions are met (spell cast on correct item, etc).
// *  Returns TRUE if the spell was used for an item creation feat
int   CIGetSpellWasUsedForItemCreation(object oSpellTarget);

// * Makes oPC do a Craft check using nSkill to create the item supplied in sResRe
// * If oContainer is specified, the item will be created there.
// * Throwing weapons are created with stack sizes of 10, ammo with 20
// *  oPC       - The player crafting
// *  nSkill    - SKILL_CRAFT_WEAPON or SKILL_CRAFT_ARMOR,
// *  sResRef   - ResRef of the item to be crafted
// *  nDC       - DC to beat to succeed
// *  oContainer - if a container is specified, create item inside
object CIUseCraftItemSkill(object oPC, int nSkill, string sResRef, int nDC, object oContainer = OBJECT_INVALID);

// *  Returns TRUE if a spell is prevented from being used with one of the crafting feats
int   CIGetIsSpellRestrictedFromCraftFeat(int nSpellId, int nFeatID);

// *  Return craftitemstructdata
struct craft_struct CIGetCraftItemStructFrom2DA(string s2DA, int nRow, int nItemNo);

// Appends the spell name to the object's name
void AppendSpellToName(object oObject, int nSpellId);




//--------------------------------------------------------------------
// functrions
//--------------------------------------------------------------------

// *  Returns the innate level of a spell. If bDefaultZeroToOne is given
// *  Level 0 spell will be returned as level 1 spells
int CIGetSpellInnateLevel(int nSpellId, int bDefaultZeroToOne = FALSE)
{
    //int nRet = StringToInt(Get2DAString(X2_CI_CRAFTING_SP_2DA, "Level", nSpellId));
	// Instead of using innate level (a single level always used for a spell) we now use actual level.
		
	// The level of a spell is dependent on what class casts it.  For example
	// Dominate Person is level 5 when cast by Wizard or Sorceror, but 4th level
	// when cast by a Bard.  The spell can't be cast by any other class.
   	int nRet = GetSpellLevel(nSpellId);
	//int nClass = GetLastSpellCastClass();
   	//int nRet = GetSpellLevelForClass(nSpellId, nClass);
	
	//PrettyDebug ("CIGetSpellInnateLevel: For Spell " + IntToString(nSpellId) + " with last spell clast class of " +
	//			 IntToString(nClass) + " Level is: " + IntToString(nRet));
	
	if (bDefaultZeroToOne == TRUE)
	    if (nRet == 0)
	        nRet =1;

    return nRet;
}


string GetClassSpellLevelColumn(int iClass)
{
	string sCol;
	
	switch (iClass)
	{
		case CLASS_TYPE_BARD: 			sCol = SPELLS_BARD_LEVEL_COL;		break;
		case CLASS_TYPE_CLERIC: 		sCol = SPELLS_CLERIC_LEVEL_COL;		break;
		case CLASS_TYPE_DRUID: 			sCol = SPELLS_DRUID_LEVEL_COL;		break;
		case CLASS_TYPE_PALADIN: 		sCol = SPELLS_PALADIN_LEVEL_COL;	break;
		case CLASS_TYPE_RANGER: 		sCol = SPELLS_RANGER_LEVEL_COL;		break;
		case CLASS_TYPE_WIZARD:	// Wiz & Sorc share same list
		case CLASS_TYPE_SORCERER: 		sCol = SPELLS_WIZ_SORC_LEVEL_COL;	break;
		case CLASS_TYPE_WARLOCK: 		sCol = SPELLS_WARLOCK_LEVEL_COL;	break;
		default:						sCol = SPELLS_INNATE_LEVEL_COL;		break;
	}		
	return (sCol);
}

// spell level for this class, or -1 on error
int GetSpellLevelForClass(int iSpell, int iClass)
{
	int iSpellLevel;
	string sCol = GetClassSpellLevelColumn(iClass);
	string sSpellLevel = Get2DAString(SPELLS_2DA, sCol, iSpell);
	
	if (sSpellLevel == "")
		iSpellLevel = -1;
	else
	 	iSpellLevel = StringToInt(sSpellLevel);
		
	//PrettyDebug ("GetSpellLevelForClass: For Spell " + IntToString(iSpell) + " and class of " +
	//			 IntToString(iClass) + " Level is: " + IntToString(iSpellLevel));
		
	return (iSpellLevel);
}

int IsOnSpellList(int iSpell, int iClass)
{
	return (GetSpellLevelForClass(iSpell, iClass) >= 0);
}


void MakeItemUseableByClass(int iClassType, object oItem)
{
	itemproperty ip = GetFirstItemProperty(oItem);
	while (GetIsItemPropertyValid(ip))
	{
		if (GetItemPropertyType(ip) == ITEM_PROPERTY_USE_LIMITATION_CLASS
				&& GetItemPropertySubType(ip) == iClassType)
		{
			return;	// if the item property already exists, bail
		}
		ip = GetNextItemProperty(oItem);
	}
	AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyLimitUseByClass(iClassType), oItem);
}

void MakeItemUseableByClassesWithSpellAccess(int iSpell, object oItem)
{
	int bBard = FALSE;
	int bCleric = FALSE;
	int bDruid = FALSE;
	int bFavored = FALSE;
	int bKnight = FALSE;
	int bRanger = FALSE;
	int bShaman = FALSE;
	int bSorc = FALSE;
	int bWarlock = FALSE;
	int bWizard = FALSE;
	
		//FlattedFifth, June 6 2024 - Checks for cleric caster to account for domain spells
		//that aren't normally in the cleric spellbook and then checks to make sure the spell 
		//isn't being cast from a wand, scroll, or other item. Enabling PCs to make wands and scrolls
		//from other wands and scrolls is fine on a server with normally low-ish players, but I don't 
		//want clerics with UMD to be able to wholesale cleric-usable wands and scrolls by making them
		//from other wands and scrolls. This will limit to only spells cast via domain becoming cleric
		// useable.
	if (GetLastSpellCastClass() == CLASS_TYPE_CLERIC)
	{	
		// Getting the base item type of the item that casts the spell will return the PC
		// themself if they cast from a spellbook, and the ItemActivator is also the PC
		if (GetBaseItemType(GetSpellCastItem()) == GetBaseItemType(GetItemActivator()))
		{
			bCleric = TRUE;
			if (B_FS_ACCESS_DOMAIN_WANDSCROLL) bFavored = TRUE;
			if (B_KNIGHT_ACCESS_DOMAIN_WANDSCROLL) bKnight = TRUE;
		}
	
	}

	if (IsOnSpellList(iSpell, CLASS_TYPE_BARD))
		bBard = TRUE;
		

	if (IsOnSpellList(iSpell, CLASS_TYPE_CLERIC))
	{
		bCleric = TRUE;
		bFavored = TRUE;
		bKnight = TRUE;
	}
		
	if (IsOnSpellList(iSpell, CLASS_TYPE_DRUID))
	{
		bDruid = TRUE;
		bShaman = TRUE;
		bRanger = TRUE;
	}
		
	if (IsOnSpellList(iSpell, CLASS_TYPE_PALADIN))
		bKnight = TRUE;

	if (IsOnSpellList(iSpell, CLASS_TYPE_RANGER))
		bRanger = TRUE;
	
	if (IsOnSpellList(iSpell, CLASS_TYPE_WIZARD))
	{
		bWizard = TRUE;
		bSorc = TRUE;
		bBard = TRUE;
	}
		//Warlock invocations can't be used to make wands or scrolls afaik but this
		//contingency was here in the original so it's here still. -FlattedFifth
	if (IsOnSpellList(iSpell, CLASS_TYPE_WARLOCK))
		bWarlock = TRUE;
	
	if (bBard) MakeItemUseableByClass(CLASS_TYPE_BARD, oItem);
	if (bCleric) MakeItemUseableByClass(CLASS_TYPE_CLERIC, oItem);
	if (bDruid) MakeItemUseableByClass(CLASS_TYPE_DRUID, oItem);
	if (bFavored) MakeItemUseableByClass(CLASS_TYPE_FAVORED_SOUL, oItem);
	if (bKnight) MakeItemUseableByClass(CLASS_TYPE_PALADIN, oItem);
	if (bRanger) MakeItemUseableByClass(CLASS_TYPE_RANGER, oItem);
	if (bShaman) MakeItemUseableByClass(CLASS_TYPE_SPIRIT_SHAMAN, oItem);
	if (bSorc) MakeItemUseableByClass(CLASS_TYPE_SORCERER, oItem);
	if (bWarlock) MakeItemUseableByClass(CLASS_TYPE_WARLOCK, oItem);
	if (bWizard) MakeItemUseableByClass(CLASS_TYPE_WIZARD, oItem);
}		
	

// *  Return the type of magic as one of the following constants
// *  const int X2_CI_MAGICTYPE_INVALID = 0;
// *  const int X2_CI_MAGICTYPE_ARCANE  = 1;
// *  const int X2_CI_MAGICTYPE_DIVINE  = 2;
// *  Parameters:
// *    nClass - CLASS_TYPE_* constant
int CI_GetClassMagicType(int nClass)
{
  switch (nClass)
  {
        case CLASS_TYPE_CLERIC:
                return X2_CI_MAGICTYPE_DIVINE; break;
        case CLASS_TYPE_DRUID:
                return X2_CI_MAGICTYPE_DIVINE; break;
        case CLASS_TYPE_PALADIN:
                return X2_CI_MAGICTYPE_DIVINE; break;
        case CLASS_TYPE_BARD:
                return X2_CI_MAGICTYPE_ARCANE; break;
        case CLASS_TYPE_SORCERER:
                return X2_CI_MAGICTYPE_ARCANE; break;
        case CLASS_TYPE_WIZARD:
                return X2_CI_MAGICTYPE_ARCANE; break;
        case CLASS_TYPE_RANGER:
                return X2_CI_MAGICTYPE_DIVINE; break;
    }
    return X2_CI_MAGICTYPE_INVALID;
}

string GetMaterialComponentTag(int nPropID)
{
    string sRet = Get2DAString("des_matcomp","comp_tag",nPropID);
    return sRet;
}


// -----------------------------------------------------------------------------
// Return true if oItem is a crafting target item
// -----------------------------------------------------------------------------
int CIGetIsCraftFeatBaseItem(object oItem)
{
    int nBt = GetBaseItemType(oItem);
    // blank scroll, empty potion, wand
    if (nBt == 101 || nBt == 102 || nBt == 103)
      return TRUE;
    else
      return FALSE;
}

void AppendSpellToName(object oObject, int nSpellId)
{
	int iSpellStringRef = StringToInt(Get2DAString("spells","Name", nSpellId));
	if (iSpellStringRef == 0)
		return;

	string sSpellName = GetStringByStrRef(iSpellStringRef);
	string  sOldName = GetFirstName(oObject);
	PrettyDebug ("First Name = "  + GetFirstName(oObject));
	PrettyDebug ("Last Name = "  +  GetLastName(oObject));
	PrettyDebug ("Name = "  + GetName(oObject));
	string sName = sOldName + " - " + sSpellName;
	SetFirstName(oObject, sName);
	PrettyDebug ("sNewName = "  + sName);
}

// -----------------------------------------------------------------------------
// Wrapper for the crafting cost calculation, returns GP required
// -----------------------------------------------------------------------------
int CIGetCraftGPCost(int nLevel, int nMod)
{
    int nLvlRow =   IPGetIPConstCastSpellFromSpellID(GetSpellId());
    int nCLevel = StringToInt(Get2DAString("iprp_spells","CasterLvl",nLvlRow));

	int bZeroLevel = (nLevel == 0);
	if (bZeroLevel)
		nLevel = 1;
		
    // -------------------------------------------------------------------------
    // in case we don't get a valid CLevel, use spell level instead
    // -------------------------------------------------------------------------
    if (nCLevel ==0)
    {
        nCLevel = nLevel;
    }

	int nRet = 0;
	
	nRet = FloatToInt(((IntToFloat(nCLevel)/10.0) + IntToFloat(nLevel)) * nMod);

    return nRet;

}



// New Version of crafting a potion. In order to make player-crafted potions auto target the user like default
// potions do, in most cases we will now spawn a default potion item, remove its original properies, and rename it.
// We will still use the potion that can target others in a couple cases where doing otherwise wouldn't make 
// sense, via the function just above this comment. -FlattedFifth, June 12, 2024
object CICraftBrewPotion(object oCreator, int nSpellId )
{


	int nPropID;
	object oTarget;
	int nIcon;
	int nMaterial;
	// potions of inflict and harm cannot be used by undead pcs in no pvp areas because of the hostile flag in 
	// spells.2da, but making non-hostile versions didn't work all by itself because adding the appropriate lines
	// to iprp_spells.2da caused errors. Instead, we're going to do 2 things: 1, we change the spell id to the
	// non hostile versions for the potions (and only the potions), and 2, we make the neg energy potions cast 
	// the spell UNIQUE_POWER_SELF_ONLY so that we don't need an iprp_spells.2da entry at all. Instead, with
	// UNIQUE_POWER_SELF_ONLY, using the potion registers on the On Item Activated event (potions don't normally)
	// so that x2_mod_def_act.nss will catch the potion use and make the player using the potion cast the spell
	// on themselves even if they don't know the spell. And by using the non-hostile version I created, the drinker
	// of the potion will not have spell resistence trigger. We're also setting a custom material on these negative
	// energy potion so that, if one player makes the potion and then changes its name and desc, another player getting 
	// the potion can still plainly see what the potion is. We're also setting the icons to black ones for these potions.
	
	switch (nSpellId)
	{
		case 77: // harm
			nIcon = 237;
			nMaterial = 18;
			break;
		case 371: // negative energy ray
			nIcon = 238;
			nMaterial = 19;
			break;
		case 431: // inflict minor
			nIcon = 239;
			nMaterial = 13;
			break;
		case 432: // inflict light
			nIcon = 238;
			nMaterial = 14;
			break;
		case 433: // inflict moderate
			nIcon = 1194;
			nMaterial = 15;
			break;
		case 434: // inflict serious
			nIcon = 237;
			nMaterial = 16;
			break;
		case 435: // inflict critical
			nIcon = 237;
			nMaterial = 17;
			break;
		default:
			nIcon = 0;
			nMaterial = 0;
			break;		
	}
	
	if (nMaterial == 0)
	{
		nPropID = IPGetIPConstCastSpellFromSpellID(nSpellId);
		int nSpellLvl = StringToInt(Get2DAString("spells", "Innate", nSpellId));
		StringToInt(Get2DAString("spells", "Name", nSpellId));
		string sSpellName = GetStringByStrRef(StringToInt(Get2DAString("spells", "Name", nSpellId)));
		if (FindSubString(sSpellName, "Cure") != -1 || FindSubString(sSpellName, "Heal") != -1)
		{
			switch (nSpellLvl) // blue bottle icons
			{
				case 0: case 1: nIcon = 1669; break; 
				case 2: nIcon = 1668; break;
				default: nIcon = 1670; break;
			}
		}
		else if (IsOnSpellList(nSpellId, CLASS_TYPE_DRUID) || IsOnSpellList(nSpellId, CLASS_TYPE_RANGER))
		{
			switch (nSpellLvl) // green bottle icons
			{
				case 0: nIcon = 247; break; 
				case 1: nIcon = 246; break;
				case 2: nIcon = 1195; break;
				default: nIcon = 248; break;
			}
		}
		else if (IsOnSpellList(nSpellId, CLASS_TYPE_CLERIC) || IsOnSpellList(nSpellId, CLASS_TYPE_PALADIN))
		{
			switch (nSpellLvl) // white bottle icons
			{
				case 0: nIcon = 241; break; 
				case 1: nIcon = 240; break;
				case 2: nIcon = 1198; break;
				default: nIcon = 242; break;
			}
		}
		else if (IsOnSpellList(nSpellId, CLASS_TYPE_WIZARD) || IsOnSpellList(nSpellId, CLASS_TYPE_BARD))
		{
			switch (nSpellLvl) // purple bottle icons
			{
				case 0: nIcon = 235; break; 
				case 1: nIcon = 236; break;
				case 2: nIcon = 1197; break;
				default: nIcon = 234; break;
			}
		}
		else
		{
			switch (nSpellLvl) // orange bottle icons
			{
				case 0: nIcon = 245; break; 
				case 1: nIcon = 244; break;
				case 2: nIcon = 1196; break;
				default: nIcon = 243; break;
			}
		}
	}
	else
	{
		nPropID = IP_CONST_CASTSPELL_UNIQUE_POWER_SELF_ONLY;
	}
	


	
	if (nPropID == 0 && nSpellId != 0)
    {
		FloatingTextStrRefOnCreature(84544,oCreator);
        return OBJECT_INVALID;
    }

    if (nPropID != -1)
    {
		// create a base game heal potion and then remove all properties and rename it.
		// Why? because the potion this script normally creates asks for a target, which
		// is not only crap from an RP pov (what, we're forcing a potion down someone else's throat?)
		// but slows down the process of drinking an emergency heal or invis
		oTarget = CreateItemOnObject(X2_CI_DEFAULT_HEAL_POTION_RESREF,oCreator);
		itemproperty ip = GetFirstItemProperty(oTarget);
		while (GetIsItemPropertyValid(ip))
		{
			RemoveItemProperty(oTarget, ip);
			ip = GetFirstItemProperty(oTarget);	
		}
		SetFirstName(oTarget, "Magical Potion");

		
        itemproperty ipProp = ItemPropertyCastSpell(nPropID,IP_CONST_CASTSPELL_NUMUSES_SINGLE_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,ipProp,oTarget);
		AppendSpellToName(oTarget, nSpellId);
		string sDescRef = Get2DAString("spells", "SpellDesc", nSpellId);
		string sDesc = GetStringByStrRef(StringToInt(sDescRef));
		SetDescription(oTarget, sDesc);	
		if (nMaterial != 0)
		{ 
			SetItemBaseMaterialType(oTarget, nMaterial);
		}
		SetItemIcon(oTarget, nIcon);
		
    }
    return oTarget;
	
}

// *******************************************************
// ** Craft!

// -----------------------------------------------------------------------------
// Georg, 2003-06-12
// Create a new playermade potion object with properties matching nSpellId and return it
// -----------------------------------------------------------------------------
/*
object CICraftBrewPotion(object oCreator, int nSpellId )
{

    int nPropID = IPGetIPConstCastSpellFromSpellID(nSpellId);

    object oTarget;
    // * GZ 2003-09-11: If the current spell cast is not acid fog, and
    // *                returned property ID is 0, bail out to prevent
    // *                creation of acid fog items.
    if (nPropID == 0 && nSpellId != 0)
    {
        FloatingTextStrRefOnCreature(84544,oCreator);
        return OBJECT_INVALID;
    }

    if (nPropID != -1)
    {
		
        itemproperty ipProp = ItemPropertyCastSpell(nPropID,IP_CONST_CASTSPELL_NUMUSES_SINGLE_USE);
        oTarget = CreateItemOnObject(X2_CI_BREWPOTION_NEWITEM_RESREF,oCreator);
        AddItemProperty(DURATION_TYPE_PERMANENT,ipProp,oTarget);
		AppendSpellToName(oTarget, nSpellId);				
    }
    return oTarget;
}
*/


// -----------------------------------------------------------------------------
// Georg, 2003-06-12
// Create a new playermade wand object with properties matching nSpellId
// and return it
// -----------------------------------------------------------------------------
object CICraftCraftWand(object oCreator, int nSpellId )
{
    int nPropID = IPGetIPConstCastSpellFromSpellID(nSpellId);

    object oTarget;
    // * GZ 2003-09-11: If the current spell cast is not acid fog, and
    // *                returned property ID is 0, bail out to prevent
    // *                creation of acid fog items.
    if (nPropID == 0 && nSpellId != 0)
    {
        FloatingTextStrRefOnCreature(84544,oCreator);
        return OBJECT_INVALID;
    }


    if (nPropID != -1)
    {
        itemproperty ipProp = ItemPropertyCastSpell(nPropID,IP_CONST_CASTSPELL_NUMUSES_1_CHARGE_PER_USE);
        oTarget = CreateItemOnObject(X2_CI_CRAFTWAND_NEWITEM_RESREF,oCreator);
        AddItemProperty(DURATION_TYPE_PERMANENT,ipProp,oTarget);

		MakeItemUseableByClassesWithSpellAccess(nSpellId, oTarget);
		
		/*
        int nType = CI_GetClassMagicType(GetLastSpellCastClass());
        itemproperty ipLimit;

        if (nType == X2_CI_MAGICTYPE_DIVINE)
        {
             ipLimit = ItemPropertyLimitUseByClass(CLASS_TYPE_PALADIN);
             AddItemProperty(DURATION_TYPE_PERMANENT,ipLimit,oTarget);
             ipLimit = ItemPropertyLimitUseByClass(CLASS_TYPE_RANGER);
             AddItemProperty(DURATION_TYPE_PERMANENT,ipLimit,oTarget);
             ipLimit = ItemPropertyLimitUseByClass(CLASS_TYPE_DRUID);
             AddItemProperty(DURATION_TYPE_PERMANENT,ipLimit,oTarget);
             ipLimit = ItemPropertyLimitUseByClass(CLASS_TYPE_CLERIC);
             AddItemProperty(DURATION_TYPE_PERMANENT,ipLimit,oTarget);
        }
        else if (nType == X2_CI_MAGICTYPE_ARCANE)
        {
             ipLimit = ItemPropertyLimitUseByClass(CLASS_TYPE_WIZARD);
             AddItemProperty(DURATION_TYPE_PERMANENT,ipLimit,oTarget);
             ipLimit = ItemPropertyLimitUseByClass(CLASS_TYPE_SORCERER);
             AddItemProperty(DURATION_TYPE_PERMANENT,ipLimit,oTarget);
             ipLimit = ItemPropertyLimitUseByClass(CLASS_TYPE_BARD);
             AddItemProperty(DURATION_TYPE_PERMANENT,ipLimit,oTarget);
        }
		*/
		AppendSpellToName(oTarget, nSpellId);				

		
		// Wands are now always created w/ 50 charges 
        int nCharges = 50;
		/*		
		nCharges = GetLevelByClass(GetLastSpellCastClass(),OBJECT_SELF) + d20();

        if (nCharges == 0) // stupi cheaters
        {
            nCharges = 10+d20();
        }
        // Hard core rule mode enabled
        if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_CRAFT_WAND_50_CHARGES))
        {
            nCharges = 50;
        }
		*/
        SetItemCharges(oTarget,nCharges);
		
		// Set the wand's icon to its custom icon - Electrohydra
		string spellIcon = Get2DAString("spells", "IconResRef", nSpellId);
		string wandIcon = spellIcon + "_w";
		int iconNumber = Search2DA("nwn2_icons", "ICON", wandIcon, FIRST_WAND_ICON);
		SetItemIcon(oTarget, iconNumber);

    }
    return oTarget;
}

// -----------------------------------------------------------------------------
// Georg, 2003-06-12
// Create and Return a magic wand with an item property
// matching nSpellId. Charges are set to d20 + casterlevel
// capped at 50 max
// -----------------------------------------------------------------------------
object CICraftScribeScroll(object oCreator, int nSpellId)
{
    int nPropID = IPGetIPConstCastSpellFromSpellID(nSpellId);
    object oTarget;
    // Handle optional material components
    string sMat = GetMaterialComponentTag(nPropID);
    if (sMat != "")
    {
        object oMat = GetItemPossessedBy(oCreator,sMat);
        if (oMat== OBJECT_INVALID)
        {
            FloatingTextStrRefOnCreature(83374, oCreator); // Missing material component
            return OBJECT_INVALID;
        }
        else
        {
            DestroyObject (oMat);
        }
     }
	 

    /* 
		Erroneous code commented out, this bit breaks if it's a cleric casting a domain spell
		because it's trying to get the scroll resref based on the caster's class. -FlattedFifth, June 6, 2024
	
	int nClass = GetLastSpellCastClass();
    string sClass = "Wiz_Sorc";
    switch (nClass)
    {
       case CLASS_TYPE_WIZARD:
            sClass = "Wiz_Sorc";
            break;

       case CLASS_TYPE_SORCERER:
            sClass = "Wiz_Sorc";
            break;
       case CLASS_TYPE_CLERIC:
            sClass = "Cleric";
            break;
       case CLASS_TYPE_PALADIN:
            sClass = "Paladin";
            break;
       case CLASS_TYPE_DRUID:
            sClass = "Druid";
            break;
       case CLASS_TYPE_RANGER:
            sClass = "Ranger";
            break;
       case CLASS_TYPE_BARD:
            sClass = "Bard";
            break;
		case CLASS_TYPE_SPIRIT_SHAMAN:
            sClass = "Druid";
            break;
		case CLASS_TYPE_FAVORED_SOUL:
            sClass = "Cleric";
            break;
    }
	*/
	
	
	// The following bit of code gets the scroll blueprint id from des_crft_scroll.2da, 
	// BUT while the original code that I commented out above was only looking at the caster's class, 
	// here we're getting the spellbook the spell is in for clerics casting domain spells. Since we're 
	// changing the default "Only Useable By" properties anyway, it's ok to use the default scroll for that 
	// spell. -FlattedFifth, June 6 2024
   
	string sClass = "Wiz_Sorc";
	if (IsOnSpellList(nSpellId, CLASS_TYPE_WIZARD)) sClass = "Wiz_Sorc";
	else if (IsOnSpellList(nSpellId, CLASS_TYPE_CLERIC)) sClass = "Cleric";
	else if (IsOnSpellList(nSpellId, CLASS_TYPE_DRUID)) sClass = "Druid";
	else if (IsOnSpellList(nSpellId, CLASS_TYPE_PALADIN)) sClass = "Paladin";
	else if (IsOnSpellList(nSpellId, CLASS_TYPE_RANGER)) sClass = "Ranger";
	else if (IsOnSpellList(nSpellId, CLASS_TYPE_BARD)) sClass = "Bard";
	else 
	{
		string sSpellId = IntToString(nSpellId);
		SendMessageToPC(oCreator, "x2_inc_craft::CICraftScribeScroll(), Unable to find scroll ID number " + sSpellId);
		SendMessageToPC(oCreator, "Please screenshot the above message and contact the dev team on our Discord.");
		WriteTimestampedLogEntry("x2_inc_craft::CICraftScribeScroll failed -  Class: " + sClass + ", SpellId " + sSpellId);
	}
	


    if (sClass != "")
    {
        string sResRef = Get2DAString(X2_CI_2DA_SCROLLS,sClass,nSpellId);
        if (sResRef != "")
        {
            oTarget = CreateItemOnObject(sResRef,oCreator);
        }

        if (oTarget == OBJECT_INVALID)
        {
			int nClass = GetLastSpellCastClass();
          	WriteTimestampedLogEntry("x2_inc_craft::CICraftScribeScroll failed - Resref: " + sResRef + " Class: " + sClass + "(" +IntToString(nClass) +") " + " SpellId " + IntToString (nSpellId));
        }
    }
    return oTarget;
}


// *******************************************************
// ** Craft Checks

// -----------------------------------------------------------------------------
// Returns TRUE if the player used the last spell to brew a potion
// -----------------------------------------------------------------------------
int CICraftCheckBrewPotion(object oSpellTarget, object oCaster)
{
	// the below two are arguments we're getting, why did the oc declare them again?
    //object oSpellTarget = GetSpellTargetObject();
   // object oCaster      = OBJECT_SELF;
    int    nID          = GetSpellId();
    int    nLevel       = CIGetSpellInnateLevel(nID,FALSE);

    // -------------------------------------------------------------------------
    // check if brew potion feat is there
    // -------------------------------------------------------------------------
    if (GetHasFeat(X2_CI_BREWPOTION_FEAT_ID, oCaster) != TRUE)
    {
      FloatingTextStrRefOnCreature(STR_REF_IC_MISSING_REQUIRED_FEAT, oCaster); // Item Creation Failed - Don't know how to create that type of item
      return TRUE;
    }

    // -------------------------------------------------------------------------
    // check if spell is below maxlevel for brew potions, but allow cure and inflict crit
	// if that boolean or the heal one is set to true and allow heal and harm if that boolean is set to true.
    // -------------------------------------------------------------------------
	
	int bSkipLevelCheck = FALSE;
	if ((nID == ID_SPELL_CURE_CRIT || nID == ID_SPELL_INFLICT_CRIT) && (B_ALLOW_CURE_CRIT_POTS || B_ALLOW_HEAL_POTS))
	{
		bSkipLevelCheck = TRUE;
	}
	
	if ((nID == ID_SPELL_HEAL || nID == ID_SPELL_HARM) && B_ALLOW_HEAL_POTS)
	{
		bSkipLevelCheck = TRUE;
	}

	if (bSkipLevelCheck != TRUE)
	{
		if (nLevel > X2_CI_BREWPOTION_MAXLEVEL)
		{
			FloatingTextStrRefOnCreature(STR_REF_IC_SPELL_TO_HIGH_FOR_POTION, oCaster);
			return TRUE;
		}
	}


    // -------------------------------------------------------------------------
    // Check if the spell is allowed to be used with Brew Potions
    // -------------------------------------------------------------------------
	
	int bSkipAllowedCheck = FALSE;
	
	

    if (CIGetIsSpellRestrictedFromCraftFeat(nID, X2_CI_BREWPOTION_FEAT_ID))
    {
        FloatingTextStrRefOnCreature(STR_REF_IC_SPELL_RESTRICTED_FOR_POTION, oCaster);
        return TRUE;
    }

    // -------------------------------------------------------------------------
    // XP/GP Cost Calculation
    // -------------------------------------------------------------------------
    int nCost = CIGetCraftGPCost(nLevel, X2_CI_BREWPOTION_COSTMODIFIER);
//    float nExperienceCost = 0.04  * nCost; // xp = 1/25 of gp value
    int nGoldCost = nCost ;

    // -------------------------------------------------------------------------
    // Does Player have enough gold?
    // -------------------------------------------------------------------------
    if (GetGold(oCaster) < nGoldCost)
    {
        FloatingTextStrRefOnCreature(STR_REF_IC_INSUFFICIENT_GOLD, oCaster); // Item Creation Failed - not enough gold!
        return TRUE;
    }

//    int nHD = GetHitDice(oCaster);
//    int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
//    int nNewXP = FloatToInt(GetXP(oCaster) - nExperienceCost);


    // -------------------------------------------------------------------------
    // check for sufficient XP to cast spell
    // -------------------------------------------------------------------------
//    if (nMinXPForLevel > nNewXP || nNewXP == 0 )
//    {
//        FloatingTextStrRefOnCreature(STR_REF_IC_INSUFFICIENT_XP, oCaster); // Item Creation Failed - Not enough XP
//        return TRUE;
//    }

    // -------------------------------------------------------------------------
    // Here we brew the new potion
    // -------------------------------------------------------------------------
    object oPotion = CICraftBrewPotion(oCaster, nID);

    // -------------------------------------------------------------------------
    // Verify Results
    // -------------------------------------------------------------------------
    if (GetIsObjectValid(oPotion))
    {
        TakeGoldFromCreature(nGoldCost, oCaster, TRUE);
//        SetXP(oCaster, nNewXP);
        DestroyObject (oSpellTarget);
        FloatingTextStrRefOnCreature(STR_REF_IC_SUCCESS, oCaster); // Item Creation successful
        return TRUE;
     }
     else
     {
         FloatingTextStrRefOnCreature(STR_REF_IC_FAILED, oCaster); // Item Creation Failed
        return TRUE;
     }

}



// -----------------------------------------------------------------------------
// Returns TRUE if the player used the last spell to create a scroll
// -----------------------------------------------------------------------------
int CICraftCheckScribeScroll(object oSpellTarget, object oCaster)
{
    int  nID = GetSpellId();

    // -------------------------------------------------------------------------
    // check if scribe scroll feat is there
    // -------------------------------------------------------------------------
    if (GetHasFeat(X2_CI_SCRIBESCROLL_FEAT_ID, oCaster) != TRUE)
    {
      FloatingTextStrRefOnCreature(STR_REF_IC_MISSING_REQUIRED_FEAT, oCaster); // Item Creation Failed - Don't know how to create that type of item
      return TRUE;
    }

    // -------------------------------------------------------------------------
    // Check if the spell is allowed to be used with Scribe Scroll
    // -------------------------------------------------------------------------
    if (CIGetIsSpellRestrictedFromCraftFeat(nID, X2_CI_SCRIBESCROLL_FEAT_ID))
    {
        FloatingTextStrRefOnCreature(STR_REF_IC_SPELL_RESTRICTED_FOR_SCROLL, oCaster); // can not be used with this feat
        return TRUE;
    }

    // -------------------------------------------------------------------------
    // XP/GP Cost Calculation
    // -------------------------------------------------------------------------
    int  nLevel    = CIGetSpellInnateLevel(nID,FALSE);
    int nCost = CIGetCraftGPCost(nLevel, X2_CI_SCRIBESCROLL_COSTMODIFIER);
//    float fExperienceCost = 0.04 * nCost;
    int nGoldCost = nCost;
	
	// nerf the cost of raise deads and or full res? controlled by boolean-like integer constants at top
	if (nID == ID_SPELL_RAISE_DEAD && B_CHEAP_RAISE_SCROLLS)
	{
		nGoldCost = N_RAISE_COST;
	}
	else if (nID == ID_SPELL_FULL_RES && B_CHEAP_FULL_RES_SCROLLS)
	{
		nGoldCost = N_RES_COST;
	}


    // -------------------------------------------------------------------------
    // Does Player have enough gold?
    // -------------------------------------------------------------------------
    if (GetGold(oCaster) < nGoldCost)  //  enough gold?
    {
        FloatingTextStrRefOnCreature(STR_REF_IC_INSUFFICIENT_GOLD, oCaster); // Item Creation Failed - not enough gold!
        return TRUE;
    }

//    int nHD = GetHitDice(oCaster);
//    int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
//    int nNewXP = FloatToInt(GetXP(oCaster) - fExperienceCost);

    // -------------------------------------------------------------------------
    // check for sufficient XP to cast spell
    // -------------------------------------------------------------------------
//    if (nMinXPForLevel > nNewXP || nNewXP == 0 )
//    {
//         FloatingTextStrRefOnCreature(STR_REF_IC_INSUFFICIENT_XP, oCaster); // Item Creation Failed - Not enough XP
//         return TRUE;
//    }

    // -------------------------------------------------------------------------
    // Here we scribe the scroll
    // -------------------------------------------------------------------------
    object oScroll = CICraftScribeScroll(oCaster, nID);

    // -------------------------------------------------------------------------
    // Verify Results
    // -------------------------------------------------------------------------
    if (GetIsObjectValid(oScroll))
    {
		// Adding the proper item properties 
		if ((nID == ID_SPELL_RAISE_DEAD && B_RAISE_SCROLL_NO_CLASS_LIMIT) || 
				(nID == ID_SPELL_FULL_RES && B_FULL_RES_SCROLL_NO_CLASS_LIMIT) ||
				(nID == ID_SPELL_STONE_TO_FLESH && B_STONE_TO_FLESH_SCROLL_NO_CLASS_LIMIT))
		{
			IPRemoveMatchingItemProperties(oScroll, ITEM_PROPERTY_USE_LIMITATION_CLASS, -1, -1);
		}
		else
		{
			MakeItemUseableByClassesWithSpellAccess(nID, oScroll);
		}
		//This script spawns the default in-game spell scrolls, so since some of those descriptions have
		//changed we update the spell description with current value from tlk
		int refSpellDesc = StringToInt(Get2DAString("spells", "SpellDesc", nID));
		string sSpellDesc = GetStringByStrRef(refSpellDesc);
		SetDescription(oScroll, sSpellDesc);
		//----------------------------------------------------------------------
        // Some scrollsare ar not identified ... fix that here
        //----------------------------------------------------------------------
        SetIdentified(oScroll,TRUE);
		// if the scroll is a cheap raise dead or res, make it unsellable. I hope. Will flagging it stolen do that?
		if (nID == ID_SPELL_RAISE_DEAD && B_CHEAP_RAISE_SCROLLS)
		{
			SetStolenFlag(oScroll, TRUE);
		}
		else if (nID == ID_SPELL_FULL_RES && B_CHEAP_FULL_RES_SCROLLS)
		{
			SetStolenFlag(oScroll, TRUE);
		}
        ActionPlayAnimation (ANIMATION_FIREFORGET_READ,1.0);
        TakeGoldFromCreature(nGoldCost, oCaster, TRUE);
//        SetXP(oCaster, nNewXP);
        DestroyObject (oSpellTarget);
        FloatingTextStrRefOnCreature(STR_REF_IC_SUCCESS, oCaster); // Item Creation successful
        return TRUE;
     }
     else
     {
        FloatingTextStrRefOnCreature(STR_REF_IC_FAILED, oCaster); // Item Creation Failed
        return TRUE;
     }

    return FALSE;
}


// -----------------------------------------------------------------------------
// Returns TRUE if the player used the last spell to craft a wand
// -----------------------------------------------------------------------------
int CICraftCheckCraftWand(object oSpellTarget, object oCaster)
{

    int nID = GetSpellId();

    // -------------------------------------------------------------------------
    // check if craft wand feat is there
    // -------------------------------------------------------------------------
    if (GetHasFeat(X2_CI_CRAFTWAND_FEAT_ID, oCaster) != TRUE)
    {
      FloatingTextStrRefOnCreature(STR_REF_IC_MISSING_REQUIRED_FEAT, oCaster); // Item Creation Failed - Don't know how to create that type of item
      return TRUE; // tried item creation but do not know how to do it
    }

    // -------------------------------------------------------------------------
    // Check if the spell is allowed to be used with Craft Wand
    // -------------------------------------------------------------------------
    if (CIGetIsSpellRestrictedFromCraftFeat(nID, X2_CI_CRAFTWAND_FEAT_ID))
    {
        FloatingTextStrRefOnCreature(STR_REF_IC_SPELL_RESTRICTED_FOR_WAND, oCaster); // can not be used with this feat
        return TRUE;
    }

	// now returns the actual spell level the spell was cast with.
    int nLevel = CIGetSpellInnateLevel(nID,FALSE);

    // -------------------------------------------------------------------------
    // check if spell is below maxlevel for craft wands
    // -------------------------------------------------------------------------
    if (nLevel > X2_CI_CRAFTWAND_MAXLEVEL)
    {
        FloatingTextStrRefOnCreature(STR_REF_IC_SPELL_TO_HIGH_FOR_WAND, oCaster);
        return TRUE;
    }

    // -------------------------------------------------------------------------
    // XP/GP Cost Calculation
    // -------------------------------------------------------------------------
    int nCost = CIGetCraftGPCost( nLevel, X2_CI_CRAFTWAND_COSTMODIFIER);
//    float nExperienceCost = 0.04 * nCost;
    int nGoldCost = nCost;

    // -------------------------------------------------------------------------
    // Does Player have enough gold?
    // -------------------------------------------------------------------------
     if (GetGold(oCaster) < nGoldCost)  //  enough gold?
    {
        FloatingTextStrRefOnCreature(STR_REF_IC_INSUFFICIENT_GOLD, oCaster); // Item Creation Failed - not enough gold!
        return TRUE;
    }

    // more calculations on XP cost
//    int nHD = GetHitDice(oCaster);
//    int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
//    int nNewXP = FloatToInt(GetXP(oCaster) - nExperienceCost);

    // -------------------------------------------------------------------------
    // check for sufficient XP to cast spell
    // -------------------------------------------------------------------------
//     if (nMinXPForLevel > nNewXP || nNewXP == 0 )
//    {
//         FloatingTextStrRefOnCreature(STR_REF_IC_INSUFFICIENT_XP, oCaster); // Item Creation Failed - Not enough XP
//         return TRUE;
//    }

    // -------------------------------------------------------------------------
    // Here we craft the wand
    // -------------------------------------------------------------------------
    object oWand = CICraftCraftWand(oCaster, nID);

    // -------------------------------------------------------------------------
    // Verify Results
    // -------------------------------------------------------------------------
    if (GetIsObjectValid(oWand))
    {
        TakeGoldFromCreature(nGoldCost, oCaster, TRUE);
//        SetXP(oCaster, nNewXP);
        DestroyObject (oSpellTarget);
        FloatingTextStrRefOnCreature(STR_REF_IC_SUCCESS, oCaster); // Item Creation successful
        return TRUE;
     }
     else
     {
        FloatingTextStrRefOnCreature(STR_REF_IC_FAILED, oCaster); // Item Creation Failed
        return TRUE;
     }

    return FALSE;
}


// -----------------------------------------------------------------------------
// Georg, July 2003
// Checks if the caster intends to use his item creation feats and
// calls appropriate item creation subroutine if conditions are met
// (spell cast on correct item, etc).
// Returns TRUE if the spell was used for an item creation feat
// -----------------------------------------------------------------------------
int CIGetSpellWasUsedForItemCreation(object oSpellTarget)
{
    object oCaster = OBJECT_SELF;

    // -------------------------------------------------------------------------
    // Spell cast on crafting base item (blank scroll, etc) ?
    // -------------------------------------------------------------------------
    if (!CIGetIsCraftFeatBaseItem(oSpellTarget))
    {
       return FALSE; // not blank scroll baseitem
    }
    else
    {
        // ---------------------------------------------------------------------
        // Check Item Creation Feats were disabled through x2_inc_switches
        // ---------------------------------------------------------------------
        if (GetModuleSwitchValue(MODULE_SWITCH_DISABLE_ITEM_CREATION_FEATS) == TRUE)
        {
            FloatingTextStrRefOnCreature(STR_REF_IC_DISABLED, oCaster); // item creation disabled
            return FALSE;
        }

        // ---------------------------------------------------------------------
        // Ensure that item creation does not work one item was cast on another
        // ---------------------------------------------------------------------
		/*
        if (GetSpellCastItem() != OBJECT_INVALID)
        {
            FloatingTextStrRefOnCreature(STR_REF_IC_ITEM_USE_NOT_ALLOWED, oCaster); // can not use one item to enchant another
            return TRUE;
        }
		*/
		
        // ---------------------------------------------------------------------
        // Ok, what kind of feat the user wants to use by examining the base itm
        // ---------------------------------------------------------------------
        int nBt = GetBaseItemType(oSpellTarget);
        int nRet = FALSE;
        switch (nBt)
        {
                case 101 :
                            // -------------------------------------------------
                            // Brew Potion
                            // -------------------------------------------------
                           nRet = CICraftCheckBrewPotion(oSpellTarget,oCaster);
                           break;


                case 102 :
                            // -------------------------------------------------
                            // Scribe Scroll
                            // -------------------------------------------------
                           nRet = CICraftCheckScribeScroll(oSpellTarget,oCaster);
                           break;


                case 103 :
                            // -------------------------------------------------
                            // Craft Wand
                            // -------------------------------------------------
                           nRet = CICraftCheckCraftWand(oSpellTarget,oCaster);
                           break;

                // you could add more crafting basetypes here....
        }

        return nRet;

    }

}

// -----------------------------------------------------------------------------
// Makes oPC do a Craft check using nSkill to create the item supplied in sResRe
// If oContainer is specified, the item will be created there.
// Throwing weapons are created with stack sizes of 10, ammo with 20
// -----------------------------------------------------------------------------
object CIUseCraftItemSkill(object oPC, int nSkill, string sResRef, int nDC, object oContainer = OBJECT_INVALID)
{
    int bSuccess = GetIsSkillSuccessful(oPC, nSkill, nDC);
    object oNew;
    if (bSuccess)
    {
        // actual item creation
        // if a crafting container was specified, create inside
        int bFix;
        if (oContainer == OBJECT_INVALID)
        {
            //------------------------------------------------------------------
            // We create the item in the work container to get rid of the
            // stackable item problems that happen when we create the item
            // directly on the player
            //------------------------------------------------------------------
            oNew =CreateItemOnObject(sResRef,IPGetIPWorkContainer(oPC));
            bFix = TRUE;
        }
        else
        {
            oNew =CreateItemOnObject(sResRef,oContainer);
        }

        int nBase = GetBaseItemType(oNew);
        if (nBase ==  BASE_ITEM_BOLT || nBase ==  BASE_ITEM_ARROW || nBase ==  BASE_ITEM_BULLET)
        {
            SetItemStackSize(oNew, 20);
        }
        else if (nBase ==  BASE_ITEM_THROWINGAXE || nBase ==  BASE_ITEM_SHURIKEN || nBase ==  BASE_ITEM_DART)
        {
            SetItemStackSize(oNew, 10);
        }

        //----------------------------------------------------------------------
        // Get around the whole stackable item mess...
        //----------------------------------------------------------------------
        if (bFix)
        {
            object oRet = CopyObject(oNew,GetLocation(oPC),oPC);
            DestroyObject(oNew);
            oNew = oRet;
        }


    }
    else
    {
        oNew = OBJECT_INVALID;
    }

    return oNew;
}


// -----------------------------------------------------------------------------
// georg, 2003-06-13 (
// Craft an item. This is only to be called from the crafting conversation
// spawned by x2_s2_crafting!!!
// -----------------------------------------------------------------------------
int CIDoCraftItemFromConversation(int nNumber)
{
  string    sNumber     = IntToString(nNumber);
  object    oPC         = GetPCSpeaker();
  //object    oMaterial   = GetLocalObject(oPC,"X2_CI_CRAFT_MATERIAL");
  object    oMajor       = GetLocalObject(oPC,"X2_CI_CRAFT_MAJOR");
  object    oMinor       = GetLocalObject(oPC,"X2_CI_CRAFT_MINOR");
  int       nSkill      =  GetLocalInt(oPC,"X2_CI_CRAFT_SKILL");
  int       nMode       =  GetLocalInt(oPC,"X2_CI_CRAFT_MODE");
  string    sResult;
  string    s2DA;
  int       nDC;


    DeleteLocalObject(oPC,"X2_CI_CRAFT_MAJOR");
    DeleteLocalObject(oPC,"X2_CI_CRAFT_MINOR");

    if (!GetIsObjectValid(oMajor))
    {
          FloatingTextStrRefOnCreature(83374,oPC);    //"Invalid target"
          DeleteLocalInt(oPC,"X2_CRAFT_SUCCESS");
          return FALSE;
    }
    else
    {
          if (GetItemPossessor(oMajor) != oPC)
          {
               FloatingTextStrRefOnCreature(83354,oPC);     //"Invalid target"
               DeleteLocalInt(oPC,"X2_CRAFT_SUCCESS");
               return FALSE;
          }
    }

    // If we are in container mode,
    if (nMode == X2_CI_CRAFTMODE_CONTAINER)
    {
        if (!GetIsObjectValid(oMinor))
        {
              FloatingTextStrRefOnCreature(83374,oPC);    //"Invalid target"
              DeleteLocalInt(oPC,"X2_CRAFT_SUCCESS");
              return FALSE;
        }
        else if (GetItemPossessor(oMinor) != oPC)
         {
              FloatingTextStrRefOnCreature(83354,oPC);   //"Invalid target"
              DeleteLocalInt(oPC,"X2_CRAFT_SUCCESS");
              return FALSE;
         }
   }


  if (nSkill == 26) // craft weapon
  {
        s2DA = X2_CI_CRAFTING_WP_2DA;
  }
  else if (nSkill == 25)
  {
        s2DA = X2_CI_CRAFTING_AR_2DA;
  }

  int nRow = GetLocalInt(oPC,"X2_CI_CRAFT_RESULTROW");
  struct craft_struct stItem =  CIGetCraftItemStructFrom2DA(s2DA,nRow,nNumber);
  object oContainer = OBJECT_INVALID;

  // ---------------------------------------------------------------------------
  // We once used a crafting container, but found it too complicated. Code is still
  // left in here for the community
  // ---------------------------------------------------------------------------
  if (nMode == X2_CI_CRAFTMODE_CONTAINER)
  {
        oContainer = GetItemPossessedBy(oPC,"x2_it_craftcont");
  }

  // Do the crafting...
  object oRet = CIUseCraftItemSkill( oPC, nSkill, stItem.sResRef, stItem.nDC, oContainer) ;

  // * If you made an item, it should always be identified;
  SetIdentified(oRet,TRUE);

  if (GetIsObjectValid(oRet))
  {
      // -----------------------------------------------------------------------
      // Copy all item properties from the major object on the resulting item
      // Through we problably won't use this, its a neat thing to have for the
      // community
      // to enable magic item creation from the crafting system
      // -----------------------------------------------------------------------
       if (GetGold(oPC)<stItem.nCost)
       {
          DeleteLocalInt(oPC,"X2_CRAFT_SUCCESS");
          FloatingTextStrRefOnCreature(86675,oPC);
          DestroyObject(oRet);
          return FALSE;
       }
       else
       {
          TakeGoldFromCreature(stItem.nCost, oPC,TRUE);
          IPCopyItemProperties(oMajor,oRet);
        }
      // set success variable for conversation
      SetLocalInt(oPC,"X2_CRAFT_SUCCESS",TRUE);
  }
  else
  {
      TakeGoldFromCreature(stItem.nCost / 4, oPC,TRUE);
      // make sure there is no success
      DeleteLocalInt(oPC,"X2_CRAFT_SUCCESS");
  }

  // Destroy first material component
  DestroyObject (oMajor);

  // if we are running in a container, destroy the second material component as well
  if (nMode == X2_CI_CRAFTMODE_CONTAINER || nMode == X2_CI_CRAFTMODE_ASSEMBLE)
  {
      DestroyObject (oMinor);
  }
  int nRet = (oRet != OBJECT_INVALID);
  return nRet;
}

// -----------------------------------------------------------------------------
// Retrieve craft information on a certain item
// -----------------------------------------------------------------------------
struct craft_struct CIGetCraftItemStructFrom2DA(string s2DA, int nRow, int nItemNo)
{
   struct craft_struct stRet;
   string sNumber = IntToString(nItemNo);

   stRet.nRow    =  nRow;
   string sLabel = Get2DAString(s2DA,"Label"+ sNumber, nRow);
   if (sLabel == "")
   {
      return stRet;  // empty, no need to read further
   }
   int nStrRef = StringToInt(sLabel);
   if (nStrRef != 0)  // Handle bioware StrRefs
   {
      sLabel = GetStringByStrRef(nStrRef);
   }
   stRet.sLabel  = sLabel;
   stRet.nDC     =  StringToInt(Get2DAString(s2DA,"DC"+ sNumber, nRow));
   stRet.nCost   =  StringToInt(Get2DAString(s2DA,"CostGP"+ sNumber, nRow));
   stRet.sResRef =  Get2DAString(s2DA,"ResRef"+ sNumber, nRow);

   return stRet;
}

// -----------------------------------------------------------------------------
// Return the cost
// -----------------------------------------------------------------------------
int CIGetItemPartModificationCost(object oOldItem, int nPart)
{
    int nRet = StringToInt(Get2DAString(X2_IP_ARMORPARTS_2DA,"CraftCost",nPart));
    nRet = (GetGoldPieceValue(oOldItem) / 100 * nRet);

    // minimum cost for modification is 1 gp
    if (nRet == 0)
    {
        nRet =1;
    }
    return nRet;
}

// -----------------------------------------------------------------------------
// Return the DC for modifying a certain armor part on oOldItem
// -----------------------------------------------------------------------------
int CIGetItemPartModificationDC(object oOldItem, int nPart)
{
    int nRet = StringToInt(Get2DAString(X2_IP_ARMORPARTS_2DA,"CraftDC",nPart));
    // minimum cost for modification is 1 gp
    return nRet;
}

// -----------------------------------------------------------------------------
// returns the dc
// dc to modify oOlditem to look like oNewItem
// -----------------------------------------------------------------------------
int CIGetArmorModificationCost(object oOldItem, object oNewItem)
{
   int nTotal = 0;
   int nPart;
   for (nPart = 0; nPart<ITEM_APPR_ARMOR_NUM_MODELS; nPart++)
   {

        if (GetItemAppearance(oOldItem,ITEM_APPR_TYPE_ARMOR_MODEL, nPart) !=GetItemAppearance(oNewItem,ITEM_APPR_TYPE_ARMOR_MODEL, nPart))
        {
            nTotal+= CIGetItemPartModificationCost(oOldItem,nPart);
        }
   }

   // Modification Cost should not exceed value of old item +1 GP
   if (nTotal > GetGoldPieceValue(oOldItem))
   {
        nTotal = GetGoldPieceValue(oOldItem)+1;
   }
   return nTotal;
}

// -----------------------------------------------------------------------------
// returns the cost in gold piece that it would
// cost to modify oOlditem to look like oNewItem
// -----------------------------------------------------------------------------
int CIGetArmorModificationDC(object oOldItem, object oNewItem)
{
   int nTotal = 0;
   int nPart;
   int nDC =0;
   for (nPart = 0; nPart<ITEM_APPR_ARMOR_NUM_MODELS; nPart++)
   {

        if (GetItemAppearance(oOldItem,ITEM_APPR_TYPE_ARMOR_MODEL, nPart) !=GetItemAppearance(oNewItem,ITEM_APPR_TYPE_ARMOR_MODEL, nPart))
        {
            nDC = CIGetItemPartModificationDC(oOldItem,nPart);
            if (nDC>nTotal)
            {
                nTotal = nDC;
            }
        }
   }

   nTotal = GetItemACValue(oOldItem) + nTotal + 5;

   return nTotal;
}

// -----------------------------------------------------------------------------
// returns TRUE if the spell matching nSpellId is prevented from being used
// with the CraftFeat matching nFeatID
// This is controlled in des_crft_spells.2da
// -----------------------------------------------------------------------------
int CIGetIsSpellRestrictedFromCraftFeat(int nSpellId, int nFeatID)
{
    string sCol;
    if (nFeatID == X2_CI_BREWPOTION_FEAT_ID)
    {
        sCol ="NoPotion";
    }
    else if (nFeatID == X2_CI_SCRIBESCROLL_FEAT_ID)
    {
        sCol = "NoScroll";
    }
    else if (nFeatID == X2_CI_CRAFTWAND_FEAT_ID)
    {
         sCol = "NoWand";
    }

    string sRet = Get2DAString(X2_CI_CRAFTING_SP_2DA,sCol,nSpellId);
    int nRet = (sRet == "1") ;

    return nRet;
}

// -----------------------------------------------------------------------------
// Retrieve the row in des_crft_bmat too look up receipe
// -----------------------------------------------------------------------------
int CIGetCraftingReceipeRow(int nMode, object oMajor, object oMinor, int nSkill)
{
    if (nMode == X2_CI_CRAFTMODE_CONTAINER || nMode == X2_CI_CRAFTMODE_ASSEMBLE )
    {
        int nMinorId = StringToInt(Get2DAString("des_crft_amat",GetTag(oMinor),1));
        int nMajorId = StringToInt(Get2DAString("des_crft_bmat",GetTag(oMajor),nMinorId));
        return nMajorId;
    }
    else if (nMode == X2_CI_CRAFTMODE_BASE_ITEM)
    {
       int nLookUpRow;
       string sTag = GetTag(oMajor);
       switch (nSkill)
       {
            case 26: nLookUpRow =1 ; break;
            case 25: nLookUpRow= 2 ; break;
       }
       int nRet = StringToInt(Get2DAString(X2_CI_CRAFTING_MAT_2DA,sTag,nLookUpRow));
       return nRet;
    }
    else
    {
        return 0; // error
    }
}

// -----------------------------------------------------------------------------
// used to set all variable required for the crafting conversation
// (Used materials, number of choises, 2da row, skill and mode)
// -----------------------------------------------------------------------------
void CISetupCraftingConversation(object oPC, int nNumber, int nSkill, int nReceipe, object oMajor, object oMinor, int nMode)
{

  SetLocalObject(oPC,"X2_CI_CRAFT_MAJOR",oMajor);
  if (nMode == X2_CI_CRAFTMODE_CONTAINER ||  nMode == X2_CI_CRAFTMODE_ASSEMBLE )
  {
      SetLocalObject(oPC,"X2_CI_CRAFT_MINOR", oMinor);
  }
  SetLocalInt(oPC,"X2_CI_CRAFT_NOOFITEMS",nNumber);    // number of crafting choises for this material
  SetLocalInt(oPC,"X2_CI_CRAFT_SKILL",nSkill);          // skill used (craft armor or craft weapon)
  SetLocalInt(oPC,"X2_CI_CRAFT_RESULTROW",nReceipe);    // number of crafting choises for this material
  SetLocalInt(oPC,"X2_CI_CRAFT_MODE",nMode);
}

// -----------------------------------------------------------------------------
// oItem - The item used for crafting
// -----------------------------------------------------------------------------
struct craft_receipe_struct CIGetCraftingModeFromTarget(object oPC,object oTarget, object oItem = OBJECT_INVALID)
{
  struct craft_receipe_struct stStruct;


  if (GetBaseItemType(oItem) == 112 ) // small
  {
       stStruct.oMajor = oItem;
       stStruct.nMode = X2_CI_CRAFTMODE_BASE_ITEM;
       return stStruct;
  }

  if (!GetIsObjectValid(oTarget))
  {
     stStruct.nMode = X2_CI_CRAFTMODE_INVALID;
     return stStruct;
  }


  // A small craftitem was used on a large one
  if (GetBaseItemType(oItem) == 110 ) // small
  {
        if (GetBaseItemType(oTarget) == 109)  // large
        {
            stStruct.nMode = X2_CI_CRAFTMODE_ASSEMBLE; // Mode is ASSEMBLE
            stStruct.oMajor = oTarget;
            stStruct.oMinor = oItem;
            return stStruct;
        }
        else
        {
            FloatingTextStrRefOnCreature(84201,oPC);
        }

  }

  // -----------------------------------------------------------------------------
  // *** CONTAINER IS NO LONGER USED IN OFFICIAL CAMPAIGN
  //     BUT CODE LEFT IN FOR COMMUNITY.
  //     THE FOLLOWING CONDITION IS NEVER TRUE FOR THE OC (no crafting container)
  //     To reactivate, create a container with tag x2_it_craftcont
  int bCraftCont = (GetTag(oTarget) == "x2_it_craftcont");


  if (bCraftCont == TRUE)
  {
    // First item in container is baseitem  .. mode = baseitem
    if ( GetBaseItemType(GetFirstItemInInventory(oTarget)) == 112)
    {
        stStruct.nMode = X2_CI_CRAFTMODE_BASE_ITEM;
        stStruct.oMajor = GetFirstItemInInventory(oTarget);
        return stStruct;
    }
    else
    {
        object oTest = GetFirstItemInInventory(oTarget);
        int nCount =1;
        int bMajor = FALSE;
        int bMinor = FALSE;
        // No item in inventory ... mode = fail
        if (!GetIsObjectValid(oTest))
        {
            FloatingTextStrRefOnCreature(84200,oPC);
            stStruct.nMode = X2_CI_CRAFTMODE_INVALID;
            return stStruct;
        }
        else
        {
            while (GetIsObjectValid(oTest) && nCount <3)
            {
                if (GetBaseItemType(oTest) == 109)
                {
                    stStruct.oMajor = oTest;
                    bMajor = TRUE;
                }
                else if (GetBaseItemType(oTest) == 110)
                {
                    stStruct.oMinor = oTest;
                    bMinor = TRUE;
                }
                else if ( GetBaseItemType(oTest) == 112)
                {
                    stStruct.nMode = X2_CI_CRAFTMODE_BASE_ITEM;
                    stStruct.oMajor = oTest;
                    return stStruct;
                }
                oTest = GetNextItemInInventory(oTarget);
                if (GetIsObjectValid(oTest))
                {
                    nCount ++;
                }
            }

            if (nCount >2)
            {
                FloatingTextStrRefOnCreature(84356,oPC);
                stStruct.nMode = X2_CI_CRAFTMODE_INVALID;
                return stStruct;
            }
            else if (nCount <2)
            {
                FloatingTextStrRefOnCreature(84356,oPC);
                stStruct.nMode = X2_CI_CRAFTMODE_INVALID;
                return stStruct;
            }

            if (bMajor && bMinor)
            {
                stStruct.nMode =  X2_CI_CRAFTMODE_CONTAINER;
                return stStruct;
            }
            else
            {
                FloatingTextStrRefOnCreature(84356,oPC);
                //FloatingTextStringOnCreature("Temp: Wrong combination of items in the crafting container",oPC);
                stStruct.nMode = X2_CI_CRAFTMODE_INVALID;
                return stStruct;
            }

        }
    }
  }
  else
  {
    // not a container but a baseitem
    if (GetBaseItemType(oTarget) == 112)
    {
       stStruct.nMode = X2_CI_CRAFTMODE_BASE_ITEM;
       stStruct.oMajor = oTarget;
       return stStruct;

    }
    else
    {
          if (GetBaseItemType(oTarget) == 109 || GetBaseItemType(oTarget) == 110)
          {
              FloatingTextStrRefOnCreature(84357,oPC);
              stStruct.nMode = X2_CI_CRAFTMODE_INVALID;
              return stStruct;
          }
          else
          {
              FloatingTextStrRefOnCreature(84357,oPC);
              // not a valid item
              stStruct.nMode = X2_CI_CRAFTMODE_INVALID;
              return stStruct;

          }
    }
  }
}

// -----------------------------------------------------------------------------
//                 *** Crafting Conversation Functions ***
// -----------------------------------------------------------------------------
int CIGetInModWeaponOrArmorConv(object oPC)
{
    return GetLocalInt(oPC,"X2_L_CRAFT_MODIFY_CONVERSATION");
}


void CISetCurrentModMode(object oPC, int nMode)
{
    if (nMode == X2_CI_MODMODE_INVALID)
    {
        DeleteLocalInt(oPC,"X2_L_CRAFT_MODIFY_MODE");
    }
    else
    {
        SetLocalInt(oPC,"X2_L_CRAFT_MODIFY_MODE",nMode);
    }
}

int CIGetCurrentModMode(object oPC)
{
  return GetLocalInt(oPC,"X2_L_CRAFT_MODIFY_MODE");
}


object CIGetCurrentModBackup(object oPC)
{
    return GetLocalObject(GetPCSpeaker(),"X2_O_CRAFT_MODIFY_BACKUP");
}

object CIGetCurrentModItem(object oPC)
{
    return GetLocalObject(GetPCSpeaker(),"X2_O_CRAFT_MODIFY_ITEM");
}


void CISetCurrentModBackup(object oPC, object oBackup)
{
    SetLocalObject(GetPCSpeaker(),"X2_O_CRAFT_MODIFY_BACKUP",oBackup);
}

void CISetCurrentModItem(object oPC, object oItem)
{
    SetLocalObject(GetPCSpeaker(),"X2_O_CRAFT_MODIFY_ITEM",oItem);
}


// -----------------------------------------------------------------------------
// * This does multiple things:
//   -  store the part currently modified
//   -  setup the custom token for the conversation
//   -  zoom the camera to that part
// -----------------------------------------------------------------------------
void CISetCurrentModPart(object oPC, int nPart, int nStrRef)
{
    SetLocalInt(oPC,"X2_TAILOR_CURRENT_PART",nPart);

    if (CIGetCurrentModMode(oPC) == X2_CI_MODMODE_ARMOR)
    {

        // * Make the camera float near the PC
        float fFacing  = GetFacing(oPC) + 180.0;

        if (nPart == ITEM_APPR_ARMOR_MODEL_LSHOULDER || nPart == ITEM_APPR_ARMOR_MODEL_LFOREARM ||
            nPart == ITEM_APPR_ARMOR_MODEL_LHAND || nPart == ITEM_APPR_ARMOR_MODEL_LBICEP)
        {
            fFacing += 80.0;
        }

        if (nPart == ITEM_APPR_ARMOR_MODEL_RSHOULDER || nPart == ITEM_APPR_ARMOR_MODEL_RFOREARM ||
            nPart == ITEM_APPR_ARMOR_MODEL_RHAND || nPart == ITEM_APPR_ARMOR_MODEL_RBICEP)
        {
            fFacing -= 80.0;
        }

        float fPitch = 75.0;
        if (fFacing > 359.0)
        {
            fFacing -=359.0;
        }

        float  fDistance = 3.5f;
        if (nPart == ITEM_APPR_ARMOR_MODEL_PELVIS || nPart == ITEM_APPR_ARMOR_MODEL_BELT )
        {
            fDistance = 2.0f;
        }

        if (nPart == ITEM_APPR_ARMOR_MODEL_LSHOULDER || nPart == ITEM_APPR_ARMOR_MODEL_RSHOULDER )
        {
            fPitch = 50.0f;
            fDistance = 3.0f;
        }
        else  if (nPart == ITEM_APPR_ARMOR_MODEL_LFOREARM || nPart == ITEM_APPR_ARMOR_MODEL_LHAND)
        {
            fDistance = 2.0f;
            fPitch = 60.0f;
        }
        else if (nPart == ITEM_APPR_ARMOR_MODEL_NECK)
        {
            fPitch = 90.0f;
        }
        else if (nPart == ITEM_APPR_ARMOR_MODEL_RFOOT || nPart == ITEM_APPR_ARMOR_MODEL_LFOOT  )
        {
            fDistance = 3.5f;
            fPitch = 47.0f;
        }
         else if (nPart == ITEM_APPR_ARMOR_MODEL_LTHIGH || nPart == ITEM_APPR_ARMOR_MODEL_RTHIGH )
        {
            fDistance = 2.5f;
            fPitch = 65.0f;
        }
        else if (        nPart == ITEM_APPR_ARMOR_MODEL_RSHIN || nPart == ITEM_APPR_ARMOR_MODEL_LSHIN    )
        {
            fDistance = 3.5f;
            fPitch = 95.0f;
        }

        if (GetRacialType(oPC)  == RACIAL_TYPE_HALFORC)
        {
            fDistance += 1.0f;
        }

        SetCameraFacing(fFacing, fDistance, fPitch,CAMERA_TRANSITION_TYPE_VERY_FAST) ;
    }

    int nCost = GetLocalInt(oPC,"X2_TAILOR_CURRENT_COST");
    int nDC = GetLocalInt(oPC,"X2_TAILOR_CURRENT_DC");

    SetCustomToken(X2_CI_MODIFYARMOR_GP_CTOKENBASE,IntToString(nCost));
    SetCustomToken(X2_CI_MODIFYARMOR_GP_CTOKENBASE+1,IntToString(nDC));


    SetCustomToken(XP_IP_ITEMMODCONVERSATION_CTOKENBASE,GetStringByStrRef(nStrRef));
}

int CIGetCurrentModPart(object oPC)
{
    return GetLocalInt(oPC,"X2_TAILOR_CURRENT_PART");
}


void CISetDefaultModItemCamera(object oPC)
{
    float fDistance = 3.5f;
    float fPitch =  75.0f;
    float fFacing;

    if (CIGetCurrentModMode(oPC) == X2_CI_MODMODE_ARMOR)
    {
        fFacing  = GetFacing(oPC) + 180.0;
        if (fFacing > 359.0)
        {
            fFacing -=359.0;
        }
    }
    else if (CIGetCurrentModMode(oPC) == X2_CI_MODMODE_WEAPON)
    {
        fFacing  = GetFacing(oPC) + 180.0;
        fFacing -= 90.0;
        if (fFacing > 359.0)
        {
            fFacing -=359.0;
        }
    }

    SetCameraFacing(fFacing, fDistance, fPitch,CAMERA_TRANSITION_TYPE_VERY_FAST) ;
}

void CIUpdateModItemCostDC(object oPC, int nDC, int nCost)
{
        SetLocalInt(oPC,"X2_TAILOR_CURRENT_COST", nCost);
        SetLocalInt(oPC,"X2_TAILOR_CURRENT_DC",nDC);
        SetCustomToken(X2_CI_MODIFYARMOR_GP_CTOKENBASE,IntToString(nCost));
        SetCustomToken(X2_CI_MODIFYARMOR_GP_CTOKENBASE+1,IntToString(nDC));
}


// dc to modify oOlditem to look like oNewItem
int CIGetWeaponModificationCost(object oOldItem, object oNewItem)
{
   int nTotal = 0;
   int nPart;
   for (nPart = 0; nPart<=2; nPart++)
   {
        if (GetItemAppearance(oOldItem,ITEM_APPR_TYPE_WEAPON_MODEL, nPart) !=GetItemAppearance(oNewItem,ITEM_APPR_TYPE_WEAPON_MODEL, nPart))
        {
            nTotal+= (GetGoldPieceValue(oOldItem)/4)+1;
        }
   }

   // Modification Cost should not exceed value of old item +1 GP
   if (nTotal > GetGoldPieceValue(oOldItem))
   {
        nTotal = GetGoldPieceValue(oOldItem)+1;
   }
   return nTotal;
}