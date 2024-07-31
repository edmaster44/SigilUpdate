// FlattedFifth - June 17, 2024. Created central file for functions related to mage slayer abilities.
// 			This file should be included in ps_onpcloaded, x2_inc_spellhook, ga_cast_spell_at_object,
//			x2_mod_def_aqu, and x2_mod_def_act

// uses a couple utility functions from the x2_inc_craft and from x2_inc_itemprop (included in x2_inc_craft)
#include "x2_inc_craft"
#include "ps_inc_functions"
#include "nw_i0_spells"

const int FEAT_MAGE_SLAYER_NORMAL = 21923;
const int FEAT_MAGE_SLAYER_ANTI_ARCANE = 21925;
const int FEAT_MAGE_SLAYER_ANTI_DIVINE = 21926;
const int FEAT_MAGE_SLAYER_MAGICAL_ABSTINENCE = 2950;
const int CLASS_TYPE_MAGE_SLAYER = 70;
const int SPELL_ID_MAGE_SLAYER_TYPE = 14717;

const int MAGE_SLAYER_SKIPS_UMD_FOR_ALLOWED_SCROLLS = TRUE;

// a string that is used as the variable for when an item that uses the UNIQUE_POWER type causes the mage slayer to cast
// a spell. The mechanical reality is that the mage slayer is casting the spell, usually on themself, but ICly it's actually 
// the item that is doing it. At the time of this writing the ONLY items that do this are the self-only potions of negative
// energy that an undead PC can use to heal themselves and use UNIQUE_POWER_SELF_ONLY to bypass pvp restrictions on hostile
// spells so that they can drink a negative energy heal in no pvp areas. But there might be others in the future, who knows?
// If we add other items that are IC supposed to be mundane but mechanically the OnItemActivated event is making the mage
// slayer cast it we should add other identifier constants. This is not a constant so that we can change it easily, This
// is a constant to make sure it is the same across all functions that use it.
const string S_ACTIVATED_POTION_IDENTIFIER = "ActivatedPotion";

//Integers to control the potions, scrolls, wands, and buffs from others that the 4 types can have.
// These are not constants so that we can change them easily, they're just to make the code more readable 
// than having 0 - 5 in the main body of the code.
const int N_NONE = 0;
const int N_HEALING_ONLY = 1;
const int N_DIVINE = 2;
const int N_ARCANE = 3;
const int N_ARCANE_AND_HEALING = 4;
const int N_ANY = 5;

// THESE constants ARE for admin adjustment.
// Change the following to control what potions, wands, scrolls, and buffs for the diff kind of mageslayers.
// Regardless of these settings, though, all mage slayers can use items that raise dead companions and 
// stone to flesh, and be the target of raise and un-petrify, because their beliefs won't stop them
// from saving a companion or from being saved.
const int N_NORMAL_MS_POTION_USE = N_ANY;
const int N_NORMAL_MS_SCROLL_USE = N_NONE;
const int N_NORMAL_MS_WAND_USE = N_NONE;
const int N_NORMAL_MS_BUFFS = N_ANY;

const int N_ANTI_ARCANE_MS_POTION_USE = N_ANY;
const int N_ANTI_ARCANE_MS_SCROLL_USE = N_DIVINE;
const int N_ANTI_ARCANE_MS_WAND_USE = N_DIVINE;
const int N_ANTI_ARCANE_MS_BUFFS = N_DIVINE;

const int N_ANTI_DIVINE_MS_POTION_USE = N_ANY;
const int N_ANTI_DIVINE_MS_SCROLL_USE = N_ARCANE;
const int N_ANTI_DIVINE_MS_WAND_USE = N_ARCANE;
const int N_ANTI_DIVINE_MS_BUFFS = N_ARCANE;

// if true then when a spell fails to pass the mage slayer spellhook check only because of the target, 
// the caster casts a fake spell and then the mage slayer target gets the spell resist vfx
const int B_USE_VFX_FOR_MS_FAIL = TRUE;


struct ItemUsage
{
    int nPotionUse;
    int nScrollUse;
    int nWandUse;
    int nBuffs;
};

// function declarations
struct ItemUsage GetMageSlayerUsageData(object oPC);
int GetSpellIsHostile(int nSpellId, object oTarget);
void MageSlayerLevels(object oPC);
int GetSpellIsDivine(int nSpellId);
int GetSpellIsArcane(int nSpellId);
int GetSpellIsHealing(int nSpellId, object oPC);
int GetMageSlayerAllowedSpecificItems(object oItem);
int GetMageSlayerType(object oPC);
int GetMageSlayerItemOrSpell(object oPC, int nItem, int nSpellId);
int GetBypassMageSlayerRestriction(object oTarget, object oPC, object oItem, int nSpellId, int nFeatId);
void SetMageSlayerSpecialItemBoolean(object oPC);
void CheckMakeItemUseableForMageSlayer(object oItem, object oPC);
int GetItemUseableByClass(int iClassType, object oItem);
int GetItemUsuableByDivine(object oItem);
int GetItemUsuableByArcane(object oItem);




/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

			Called from ps_onpcloaded and ps_pclevelup, check for pre-change mage slayer and make 
			sure that mage slayer combat bonuses are applied correctly for class level, in case of de-leveling

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
void MageSlayerLevels(object oPC)
{
	if (GetHasFeat(FEAT_MAGE_SLAYER_MAGICAL_ABSTINENCE, oPC))
	{
		if (!GetHasFeat(FEAT_MAGE_SLAYER_ANTI_ARCANE, oPC) && !GetHasFeat(FEAT_MAGE_SLAYER_ANTI_DIVINE, oPC) && 
				  !GetHasFeat(FEAT_MAGE_SLAYER_NORMAL, oPC))
		{
			SendMessageToPC(oPC, "Mage Slayer class pre-requisites and abilites have changed. Please see a DM/EM for assistance with a rebuild");
			return;
		}
	}
	
	int nSlayerLevel = GetLevelByClass(CLASS_TYPE_MAGE_SLAYER, oPC);
	
	// if they have just gotten their first level of mage slayer for the first time, then
	// cycle through their inventory and check to see if any of their scrolls and wands
	// are now useable by them
	object oEss = PS_GetEssence(oPC);
	if (nSlayerLevel == 1 && GetLocalInt(oEss, "MageSlayerInvCheckDone"))
	{
		 // Iterate through all items in the inventory
		int i = 0;
		object oItem = GetFirstItemInInventory(oPC);
		while (GetIsObjectValid(oItem))
		{
			i++;
			// num of items a pc could have if inv full of full bags, including the bags
			if (i > 27072) break;
			CheckMakeItemUseableForMageSlayer(oItem, oPC);
			oItem = GetNextItemInInventory(oPC);
		}
		SetLocalInt(oEss, "MageSlayerInvCheckDone", TRUE);
	}
	// Setting the boolean back to false at level 2 so that if the player re-levels the same check will 
	// happen again at slayer level 1
	if (nSlayerLevel >= 2 || nSlayerLevel == 0) SetLocalInt(oEss, "MageSlayerInvCheckDone", FALSE);
	
	RemoveEffectsFromSpell(oPC, SPELL_ID_MAGE_SLAYER_TYPE);
	int nDamageType = DAMAGE_TYPE_POSITIVE;
	// set the bonus damage type for the type of mage slayer. If they don't have any of
	// these feats, exit. 
	if (GetHasFeat(FEAT_MAGE_SLAYER_ANTI_ARCANE, oPC)) nDamageType = DAMAGE_TYPE_DIVINE;
		else if (GetHasFeat(FEAT_MAGE_SLAYER_ANTI_DIVINE, oPC)) nDamageType = DAMAGE_TYPE_MAGICAL;
		else if (GetHasFeat(FEAT_MAGE_SLAYER_NORMAL, oPC)) nDamageType = DAMAGE_TYPE_POSITIVE;
		else return;

	int nDamageBonus = (GetLevelByClass(CLASS_TYPE_MAGE_SLAYER, oPC) + 1) / 3;
	if (nDamageBonus > 0)
	{
		effect eDam	= EffectDamageIncrease(nDamageBonus, nDamageType);
		eDam = SupernaturalEffect(eDam);
		eDam = SetEffectSpellId(eDam, SPELL_ID_MAGE_SLAYER_TYPE);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDam, oPC);
	}
}

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

					Called from x2_inc_spellhook and ga_cast_spell_at_object, 
					check if the mage slayer can use the item/ability
					or be the target of the spell/item/ability

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
int GetBypassMageSlayerRestriction(object oTarget, object oCaster, object oItem, int nSpellId, int nFeatId)
{
	// Electrohydra's original code completely disallowed all spells from any source, including healing potions 
	// and even the item editor and lots of basic stuff. I felt that was too crippling for the class so I added 
	// functionality to allow mageslayers to use some potions and abilities, which ones are controlled by 
	// integers at the top of this file, and added ability to control what sort of non-hostile spell other
	// players can cast on mage slayer. -FlattedFifth
	
	// I don't think a mage-slayer's principles should stand in the way of saving a companion's 
	// life, or from being saved, so we will allow raise dead, resurrection, and stone to flesh
	// regardless of whether the mage slayer is caster or target
	if (nSpellId == 142 || nSpellId == 153 || nSpellId == 486) return TRUE;
	
	

	if (oItem != OBJECT_INVALID)
	{	
		//Some items are automatically allowed, such as the Coin of Life, Item Editor, and any mundane items
		//so we'll check for those first with a function in this file and skip the rest of the checks if it's 
		//one of those. Currently there aren't any items in that function that a MS shouldn't be able to use or
		// be the targetof, they're either mundane, hostile, or both, but if this changes we can move this check
		//into the specific conditions for caster and target. For now I'd prefer to skip a lot of checks when possible.
		if (GetMageSlayerAllowedSpecificItems(oItem)) return TRUE;
		
		// allow all on hit properties on all weapons and armor. Sadly this will also allow all other cast
		// spell properties on any weapons and armor that also have on hit properties but it's 3am and I can't
		// think of a way around that.
		itemproperty ip = GetFirstItemProperty(oItem);
		while (GetIsItemPropertyValid(ip))
		{
			// Check if the item property type is OnHitCastSpell
			if (GetItemPropertyType(ip) == ITEM_PROPERTY_ON_HIT_PROPERTIES)
			{
				return TRUE;
			}
        ip = GetNextItemProperty(oItem);
		}
	}
	
	
	// let's set up the variables we need. We won't be setting these 5 to false in the rest of this function. The
	// rest of the code will either set them to true or leave them alone.
	int bCasterIsSlayer = GetHasFeat(FEAT_MAGE_SLAYER_MAGICAL_ABSTINENCE, oCaster);
	int bTargetIsSlayer = GetHasFeat(FEAT_MAGE_SLAYER_MAGICAL_ABSTINENCE, oTarget);
	int bCasterCanCast = !bCasterIsSlayer;
	int bTargetCanReceive = !bTargetIsSlayer;
	int bCanCastSpell = FALSE;

	// if the mage slayer is using a feat ability then it's allowed for the caster but not necessarily for the target.
	// At some point we should probably make exceptions and disallow class-based feat spells, such as from Assassin,
	// but for now we'll let it slide so that we don't disallow any racial abilities. Testing with feats such as barb 
	// aura of courage showed that disallowing feat spells as a target but not as the caster resulting in an endless 
	// loop of attempting to cast and failing. To be really accurate we need to make a function that grants or refuses 
	// feat spells on a case by case basis. For now we'll make sure that the mage slayer can use the feat ability on
	// themselves to avoid the aforementioned auro of courage loop. After Dae decides what classes are getting spellbooks
	// instead of feats we can revisit this.
	if (nFeatId > 0 && bCasterIsSlayer) bCasterCanCast = TRUE;

	
	// note that a spell can be both arcane and divine, like stoneskin, energy immunity, and prot from alignment,
	// so we do two checks. One or both of these will be TRUE, but it's unlikely that both will be FALSE other than 
	// maybe some feat abilities.
	int bDivineSpell = GetSpellIsDivine(nSpellId);
	int bArcaneSpell = GetSpellIsArcane(nSpellId);

	
	string sCasterMessage = "";
	string sTargetMessage = "You cannot be the target of spells or items of this type.";
	int nItem = GetBaseItemType(oItem);

	
	// If the caster/item user is the mage slayer, also if the mage slayer is targeting themself.
	if (bCasterIsSlayer)
	{
		// The spell is not being cast from an item and therefore the mage slayer is casting it directly.
		// This is only allowed if the "casting" is from a UNIQUE_POWER_SELF_ONLY item or is a feat-based spell
		// such as a racial spell like ability.
		if (oItem == OBJECT_INVALID)
		{
			sCasterMessage = "You cannot cast spells.";
			// if the mage slayer is using a special "unique power self only" item activated in the on item activated
			// event, then that registers first and then spellhook thinks they're casting the spell themselves,
			// which technically they are. So that script sets a local int on the character to let the spellhook
			// know to let it pass. Here we'll set it to false and allow it past if the right conditions are met.
			if (GetLocalInt(oCaster, S_ACTIVATED_POTION_IDENTIFIER))
			{
				SetLocalInt(oCaster, S_ACTIVATED_POTION_IDENTIFIER, FALSE);
				// in this case we'll pretend the item is a potion because at the time of this writing that's the ONLY
				// thing the this could be. If that changes, we will have to adjust this. Probably by changing the 
				// identifier to have a diff variable string for each type of item that uses the On Item Activated event.
				// Since at this time the only thing that uses this local int is a self-only potion, we'll set TRUE
				// for both the caster and the target.
				if (GetMageSlayerItemOrSpell(oCaster, 49, nSpellId))
				{
					bCasterCanCast = TRUE;
				}
			}

		}
		else // the mage slayer is using a spell ability from an item
		{	
				sCasterMessage = "You cannot use items of this type.";

				// The mage-slayer is using a potion, wand, or scroll. Any other spellcasting item should either be
				// caught by GetMageSlayerAllowedSpecificItems() or not allowed.
				if (nItem == 49 || nItem == 104 || nItem == 101 || nItem == 103 || nItem == 106 ||
						nItem == 46 || nItem == 75 || nItem == 102 || nItem == 105)
				{
					if (GetMageSlayerItemOrSpell(oCaster, nItem, nSpellId)) bCasterCanCast = TRUE;
				}
		}
	}
	
	// if the mage slayer is targeting themself then whatever we decided applies to the caster also applies to them as
	// the target.
	if (oCaster == oTarget) bTargetCanReceive = bCasterCanCast;
	
	// Separate check for if the target is a mage slayer but isn't the same as the caster. we'll let the 1st condition
	// catch all instances of a self-targeting mage slayer, but there ARE cases where a mage slayer could use something 
	// that targets another mage slayer but that other can't be the target of, if they are diff mage slayer paths.
	if (bTargetIsSlayer && oTarget != oCaster)
	{
		if (sCasterMessage != "") sCasterMessage = sCasterMessage + " ";
		sCasterMessage = sCasterMessage + "Spells or items of this type cannot affect your target.";
		
		// If it's a hostile spell let it through and let the SR handle it. 
		if (GetSpellIsHostile(nSpellId, oTarget))
		{
			bTargetCanReceive = TRUE;
		}
		else
		{
			if (GetMageSlayerItemOrSpell(oTarget, -1, nSpellId)) bTargetCanReceive = TRUE;
		}	
	}
	
	if (bCasterCanCast && bTargetCanReceive) bCanCastSpell = TRUE;
	
	if (bCanCastSpell == FALSE)
	{
		// If the caster can cast the spell but the target cannot recieve it use some VFX to give them a show of
		// the target mage-slayer resisting the spell. Not necessary to add !bTargetCanReceive because if 
		// bTargetCanReceive was true and so was bCasterCanCast we wouldn't get to this point due to the above 
		/// two conditions. Also we'll disable the vfx feedback if it's been done once already this session.
		//	Turn off this vfx with a boolean at the top of this file if you don't like it.
		if (bCasterCanCast && B_USE_VFX_FOR_MS_FAIL && nFeatId < 1) 
		{
			string sAlreadyCast = GetFirstName(oCaster) + "_Cast_" + IntToString(nSpellId);
			if (GetLocalInt(oTarget, sAlreadyCast) != TRUE)
			{
				AssignCommand(oCaster, ActionCastFakeSpellAtObject(nSpellId, oTarget, PROJECTILE_PATH_TYPE_DEFAULT));
				effect eVis = EffectVisualEffect(VFX_DUR_SPELL_SPELL_RESISTANCE);
				DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				SetLocalInt(oTarget, sAlreadyCast, TRUE);
			}
		}

		if (GetIsPC(oCaster)) SendMessageToPC(oCaster, sCasterMessage);
		if (GetIsPC(oTarget) && oTarget != oCaster) SendMessageToPC(oTarget, sTargetMessage);
	}
	return bCanCastSpell;
}

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

					Called from x2_mod_def_act. Silly to just have one line of code in a function but
					I wanted all the mage slayer code in one file.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
void SetMageSlayerSpecialItemBoolean(object oPC)
{
	// a little silly to have a function in this file just for this, but I wanted this to be
	// here in case the method of identifying to the spellhook that the special potion is being
	// used needs to change for any reason, then everything that would need changed would be in one
	// file
	 SetLocalInt(oPC, S_ACTIVATED_POTION_IDENTIFIER, TRUE);
}

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

					Called by x2_mod_def_aqu

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

// Add "usuable by Mage Slayer" item property to wands and scrolls IF the proper conditions are met
// Note that even if one type of mage slayer handles a scroll or wand and it gets the property, then
// gives that item to another mage slayer, that 2nd mage slayer would still have to pass the 
// GetBypassMageSlayerRestriction() check called from the spellhook to use it. 
void CheckMakeItemUseableForMageSlayer(object oItem, object oPC)
{
	// go ahead and bail if no type of mage slayer can use any wands or scrolls
	if (N_NORMAL_MS_SCROLL_USE == N_NONE && N_NORMAL_MS_WAND_USE == N_NONE && 
		N_ANTI_ARCANE_MS_SCROLL_USE == N_NONE && N_ANTI_ARCANE_MS_WAND_USE == N_NONE &&
		N_ANTI_DIVINE_MS_SCROLL_USE == N_NONE && N_ANTI_DIVINE_MS_WAND_USE == N_NONE)
	{
		return;
	}
	else 
	{
		int nItem = GetBaseItemType(oItem);
		// only concerned with wands and scrolls
		if (nItem == 103 || nItem == 106 || nItem == 46 ||
			 nItem == 75 || nItem == 102 || nItem == 105)
		{

			int bHasUsageLimitations = FALSE;
			int bUseableByMageSlayer = FALSE;
			int nSpellId = -1;

			itemproperty ip = GetFirstItemProperty(oItem);
			while (GetIsItemPropertyValid(ip))
			{
				int nIpType = GetItemPropertyType(ip);
				if (nIpType == ITEM_PROPERTY_USE_LIMITATION_CLASS)
				{
					bHasUsageLimitations = TRUE;
					int nClassType = GetItemPropertySubType(ip);
					if (nClassType == CLASS_TYPE_MAGE_SLAYER)
					{
						bUseableByMageSlayer = TRUE;
					}
				}
				else if (nIpType == ITEM_PROPERTY_CAST_SPELL)
				{
					// it would be unusual for a scroll or wand to cast multiple spells and against best practice
					// but just in case we will only catch the first valid spell we come to.
					if (nSpellId == -1)
					{
						int nIprpSpellId = GetItemPropertySubType(ip);
						nSpellId = StringToInt(Get2DAString("iprp_spells", "SpellIndex", nIprpSpellId));
					}
				}
				// if we have all the data we need go ahead and exit the loop. Otherwise keep looking
				// until we run out of item properties.
				if (nSpellId != -1 && bHasUsageLimitations == TRUE && bUseableByMageSlayer == TRUE) break;
				ip = GetNextItemProperty(oItem);
			}
			// bail if there are not use limitation or mage slayer can already use it
			if (bHasUsageLimitations == FALSE || bUseableByMageSlayer == TRUE) return;
			
			int bAddMageSlayerUseProperty = FALSE;
			
			// by this point we SHOULD either have a valid spellid or have bailed on this function.
			if (nSpellId != -1)
			{
				if (GetMageSlayerItemOrSpell(oPC, nItem, nSpellId)) bAddMageSlayerUseProperty = TRUE;
			}
			// we SHOULD have been able to find a valid spell id by now, but just in case we didn't we'll check for 
			// usuable by properties for other classes.
			else 
			{
				struct ItemUsage dItemUsage = GetMageSlayerUsageData(oPC);
				int nThis;
				// wand
				if (nItem == 103 || nItem == 106 || nItem == 46){ nThis = dItemUsage.nWandUse;
				}
				// scroll
				else if (nItem == 75 || nItem == 102 || nItem == 105){ nThis = dItemUsage.nScrollUse;
				}
				if (nThis == N_ANY) bAddMageSlayerUseProperty = TRUE;
				else if (nThis == N_ARCANE || nThis == N_ARCANE_AND_HEALING) bAddMageSlayerUseProperty = GetItemUsuableByArcane(oItem);
				else if (nThis == N_DIVINE) bAddMageSlayerUseProperty = GetItemUsuableByDivine(oItem);
				else bAddMageSlayerUseProperty = FALSE;
			}
			
			if (bAddMageSlayerUseProperty) MakeItemUseableByClass(CLASS_TYPE_MAGE_SLAYER, oItem);
		}
	}	
}



/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

			Helper functions called from within this file
			
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/


// These are items, usually store-bought, that any mage slayer should be able to use. If there are other items
// we want mage slayer to use, add their resref strings here.
int GetMageSlayerAllowedSpecificItems(object oItem)
{
	string sRes = GetResRef(oItem);
	int bCanUse;
	
	if (sRes == "nx2_misc_lifecoin"){ bCanUse = TRUE;}
	else if (sRes == "ps_miscthin_bludimndwhetstone"){ bCanUse = TRUE;}
	else if (FindSubString(sRes, "i_ps_itemeditor") != -1){ bCanUse = TRUE;}
	else if (FindSubString(sRes, "ps_grenade") != -1){ bCanUse = TRUE;}
	else if (FindSubString(sRes, "it_herb") != -1){ bCanUse = TRUE;}
	else if (FindSubString(sRes, "ps_food") != -1){ bCanUse = TRUE;}
	else if (FindSubString(sRes, "nx2_r_") != -1){ bCanUse = TRUE;}
	else bCanUse = FALSE;
	return bCanUse;
}

struct ItemUsage GetMageSlayerUsageData(object oPC)
{
	int nSlayerType = GetMageSlayerType(oPC);
	struct ItemUsage dItemUsage;
	if (nSlayerType == FEAT_MAGE_SLAYER_ANTI_ARCANE)
	{
		dItemUsage.nPotionUse = N_ANTI_ARCANE_MS_POTION_USE;
		dItemUsage.nWandUse = N_ANTI_ARCANE_MS_WAND_USE;
		dItemUsage.nScrollUse = N_ANTI_ARCANE_MS_SCROLL_USE;
		dItemUsage.nBuffs = N_ANTI_ARCANE_MS_BUFFS;
	}
	else if (nSlayerType == FEAT_MAGE_SLAYER_ANTI_DIVINE)
	{
		dItemUsage.nPotionUse = N_ANTI_DIVINE_MS_POTION_USE;
		dItemUsage.nWandUse = N_ANTI_DIVINE_MS_WAND_USE;
		dItemUsage.nScrollUse = N_ANTI_DIVINE_MS_SCROLL_USE;	
		dItemUsage.nBuffs = N_ANTI_DIVINE_MS_BUFFS;
	}
	else
	{
		dItemUsage.nPotionUse = N_NORMAL_MS_POTION_USE;
		dItemUsage.nWandUse = N_NORMAL_MS_WAND_USE;
		dItemUsage.nScrollUse = N_NORMAL_MS_SCROLL_USE;
		dItemUsage.nBuffs = N_NORMAL_MS_BUFFS;
	}
	return dItemUsage;	
}

int GetMageSlayerItemOrSpell(object oPC, int nItem, int nSpellId)
{
	int bDivineSpell = GetSpellIsDivine(nSpellId);
	int bArcaneSpell = GetSpellIsArcane(nSpellId);
	int bHealingSpell = GetSpellIsHealing(nSpellId, oPC);
	int nThis;
	int bAllowed = FALSE;
	
	struct ItemUsage dItemUsage = GetMageSlayerUsageData(oPC);
	
	// item is a potion
	if (nItem == 49 || nItem == 104 || nItem == 101){ nThis = dItemUsage.nPotionUse;
	}
	// wand
	else if (nItem == 103 || nItem == 106 || nItem == 46){ nThis = dItemUsage.nWandUse;
	}
	// scroll
	else if (nItem == 75 || nItem == 102 || nItem == 105){ nThis = dItemUsage.nScrollUse;
	}
	else { nThis = dItemUsage.nBuffs;
	}
	
	switch (nThis)
	{
		case N_ANY: bAllowed = TRUE; break;
		case N_HEALING_ONLY: bAllowed = GetSpellIsHealing(nSpellId, oPC); break;
		case N_ARCANE: bAllowed = GetSpellIsArcane(nSpellId); break;
		case N_DIVINE: bAllowed = GetSpellIsDivine(nSpellId); break;
		case N_ARCANE_AND_HEALING: if (GetSpellIsArcane(nSpellId) || GetSpellIsHealing(nSpellId, oPC))
									{
									bAllowed = TRUE; break;
									}
									else 
									{
									bAllowed = FALSE; break;
									}
		default: bAllowed = FALSE; break;
	}
	return bAllowed;
}

int GetSpellIsHealing(int nSpellId, object oPC)
{
	int bIsHealing = FALSE;
	string sSpellName = GetStringByStrRef(StringToInt(Get2DAString("spells", "Name", nSpellId)));
	if (GetRacialType(oPC) == RACIAL_TYPE_UNDEAD)
	{
		switch (nSpellId)
		{
			case 77: bIsHealing = TRUE; break;//harm
			case 287: bIsHealing = TRUE; break;// neg energy pulse
			case 370: bIsHealing = TRUE; break;// neg energy burst
			case 371: bIsHealing = TRUE; break;// neg energy ray
			default: bIsHealing = FALSE; break;
		}
		if (FindSubString(sSpellName, "Inflict") != -1) bIsHealing = TRUE;	
	}
	else 
	{
		switch (nSpellId)
		{
			case 79: bIsHealing = TRUE; break;//heal
			case 114: bIsHealing = TRUE; break;// mass heal
			default: bIsHealing = FALSE; break;
		}
		if (FindSubString(sSpellName, "Cure") != -1) bIsHealing = TRUE;	
	}
	if (bIsHealing == FALSE)
	{
		if (FindSubString(sSpellName, "Remove") != -1) bIsHealing = TRUE;
		if (FindSubString(sSpellName, "Neutralize") != -1) bIsHealing = TRUE;
		if (FindSubString(sSpellName, "Restoration") != -1) bIsHealing = TRUE;	
	}
	return bIsHealing;
}

int GetSpellIsHostile(int nSpellId, object oPC)
{
	int bSpellIsHostile = Get2DAString("spells", "HostileSetting", nSpellId) == "1";
	string sSpellName = GetStringByStrRef(StringToInt(Get2DAString("spells", "Name", nSpellId)));
	if (GetRacialType(oPC) == RACIAL_TYPE_UNDEAD)
	{
		switch (nSpellId)
		{
			case 77: bSpellIsHostile = FALSE; break;//harm
			case 287: bSpellIsHostile = FALSE; break;// neg energy pulse
			case 370: bSpellIsHostile = FALSE; break;// neg energy burst
			case 371: bSpellIsHostile = FALSE; break;// neg energy ray
			case 79: bSpellIsHostile = TRUE; break;//heal
			case 114: bSpellIsHostile = TRUE; break;// mass heal
			default: 	if (FindSubString(sSpellName, "Inflict") != -1){ bSpellIsHostile = FALSE; break;
						}
						else if (FindSubString(sSpellName, "Cure") != -1){ bSpellIsHostile = TRUE; break;
						}
						else { bSpellIsHostile = Get2DAString("spells", "HostileSetting", nSpellId) == "1"; break;
						}
		}
	}

	return bSpellIsHostile;
}


int GetItemUsuableByDivine(object oItem)
{
	if (GetItemUseableByClass(CLASS_TYPE_CLERIC, oItem)) return TRUE;
	else if (GetItemUseableByClass(CLASS_TYPE_FAVORED_SOUL, oItem)) return TRUE;
	else if (GetItemUseableByClass(CLASS_TYPE_DRUID, oItem)) return TRUE;
	else if (GetItemUseableByClass(CLASS_TYPE_SPIRIT_SHAMAN, oItem)) return TRUE;
	else if (GetItemUseableByClass(CLASS_TYPE_RANGER, oItem)) return TRUE;
	else if (GetItemUseableByClass(CLASS_TYPE_PALADIN, oItem)) return TRUE;
	else return FALSE;
}


int GetItemUsuableByArcane(object oItem)
{
	if (GetItemUseableByClass(CLASS_TYPE_BARD, oItem)) return TRUE;
	else if (GetItemUseableByClass(CLASS_TYPE_WIZARD, oItem)) return TRUE;
	else if (GetItemUseableByClass(CLASS_TYPE_SORCERER, oItem)) return TRUE;
	else if (GetItemUseableByClass(CLASS_TYPE_WARLOCK, oItem)) return TRUE;
	else return FALSE;
}

int GetItemUseableByClass(int iClassType, object oItem)
{
	itemproperty ip = GetFirstItemProperty(oItem);
	while (GetIsItemPropertyValid(ip))
	{
		if (GetItemPropertyType(ip) == ITEM_PROPERTY_USE_LIMITATION_CLASS
				&& GetItemPropertySubType(ip) == iClassType)
		{
			return TRUE;
		}
		ip = GetNextItemProperty(oItem);
	}
	return FALSE;
}

int GetMageSlayerType(object oPC)
{
	if (GetHasFeat(FEAT_MAGE_SLAYER_ANTI_ARCANE, oPC)) return FEAT_MAGE_SLAYER_ANTI_ARCANE;
	else if (GetHasFeat(FEAT_MAGE_SLAYER_ANTI_DIVINE, oPC)) return FEAT_MAGE_SLAYER_ANTI_DIVINE;
	else return FEAT_MAGE_SLAYER_NORMAL;
}

int GetSpellIsDivine(int nSpellId)
{
	int bRet = FALSE;
	if (IsOnSpellList(nSpellId, CLASS_TYPE_CLERIC) ||
		IsOnSpellList(nSpellId, CLASS_TYPE_DRUID) ||
		IsOnSpellList(nSpellId, CLASS_TYPE_PALADIN) ||
		IsOnSpellList(nSpellId, CLASS_TYPE_RANGER))
		{
		bRet = TRUE;
		}
	return bRet;
}

int GetSpellIsArcane(int nSpellId)
{
	int bRet = FALSE;
	if (IsOnSpellList(nSpellId, CLASS_TYPE_WIZARD) ||
		IsOnSpellList(nSpellId, CLASS_TYPE_WARLOCK) ||
		(IsOnSpellList(nSpellId, CLASS_TYPE_BARD) && !GetSpellIsDivine(nSpellId)))
		{
		bRet = TRUE;
		}
	return bRet;
}