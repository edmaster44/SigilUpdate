#include "ff_safevar"

//::///////////////////////////////////////////////
//:: Example XP2 OnActivate Script Script
//:: x2_mod_def_act
//:: (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Put into: OnItemActivate Event

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-16
//:://////////////////////////////////////////////



#include "x2_inc_switches"
#include "kinc_crafting"
#include "class_mageslayer_utils"


void main()
{

    object oItem = GetItemActivated();
	object oPC = GetItemActivator();
	int nItemID = GetBaseItemType(oItem);
	int idCraftedPotion = 49;
	
	if (GetResRef(oItem) == "lvlup"){	
		int nLvl = GetHitDice(oPC);
		GiveXPToCreature(oPC, GetXP(oPC) + (nLvl * 1000));
		GiveGoldToCreature(oPC, 50000);
	}
	
	// workaround for inflict wounds potions not working in no pvp areas due to the hostile flag.
	// the craft potion feat now creates neg energy potions with UNIQUE_POWER_SELF_ONLY spell, so that they
	// register here, and the material is set so that the potion is identifiable to players even if the 
	// name and description is changed. The material also identifies what spell we want to cast.
	if (nItemID == idCraftedPotion)
	{
		// new custom materials in iprp_materials.2da are just identifiers for the spells, as explained above
		// specifically, they are inflict minor = 13, infl light = 14, infl mod = 15, infl serious = 16, 
		// infl crit = 17, harm = 18, and neg energy ray = 19
		int matMinor = 13;
		int matNeg = 19;
		int nSpellId;
		int nMaterial = GetItemBaseMaterialType(oItem);
		if (nMaterial >= matMinor && nMaterial <= matNeg)
		{
			switch (nMaterial)
			{
				case 13: nSpellId = 431; break; // inflict minor
				case 14: nSpellId = 432; break;
				case 15: nSpellId = 433; break;
				case 16: nSpellId = 434; break;
				case 17: nSpellId = 435; break; // inflict crit
				case 18: nSpellId = 77; break; // harm
				case 19: nSpellId = 371; break; // negative energy ray
				default: nSpellId = 0; break;
			}
			if (nSpellId != 0)
			{
				// if the character is a mage slayer, alert the spellhook that this is actually a potion that is bypassing the pvp settings so 
				// that an undead mage slayer can drink a potion of neg energy to heal in no pvp areas.
				// call to class_mageslayer_utils
				if (GetHasFeat(FEAT_MAGE_SLAYER_MAGICAL_ABSTINENCE, oPC)) SetMageSlayerSpecialItemBoolean(oPC);
				// character casts the designated spell on themselves, bypassing pvp settings.
				AssignCommand(oPC, ActionCastSpellAtObject(nSpellId, oPC, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
			}
		}	
	}

	string sTag = GetTag(oItem);
	
	if(nItemID == 145 && GetTag(oItem) != "sigisedition") //Recipes are itemtype 145
 	{ 
		if(TestStringAgainstPattern("**_r_g_**", sTag) ||
			TestStringAgainstPattern("**_r_poi_**", sTag) ||
			TestStringAgainstPattern("**_r_pot_**", sTag) ||
			TestStringAgainstPattern("**trap**", sTag) ||
			TestStringAgainstPattern("**_r_acid_**", sTag) ||
			TestStringAgainstPattern("**_r_alch_**", sTag) ||
			TestStringAgainstPattern("**_r_choke_**", sTag) ||
			TestStringAgainstPattern("**_r_holy_**", sTag) ||
			TestStringAgainstPattern("**_r_tangle_**", sTag) ||
			TestStringAgainstPattern("**_r_tstone_**", sTag) ||
			TestStringAgainstPattern("**_r_holy_**", sTag) ||
			TestStringAgainstPattern("**_blo**", sTag) ||
			TestStringAgainstPattern("**_aci**", sTag) ||
			TestStringAgainstPattern("**_ele**", sTag) ||
			TestStringAgainstPattern("**_fir**", sTag) ||
			TestStringAgainstPattern("**_fro**", sTag) ||
			TestStringAgainstPattern("**_gas**", sTag) ||
			TestStringAgainstPattern("**_hol**", sTag) ||
			TestStringAgainstPattern("**_neg**", sTag) ||
			TestStringAgainstPattern("**_son**", sTag) ||
			TestStringAgainstPattern("**_spi**", sTag) ||
			TestStringAgainstPattern("**_tan**", sTag)) {
		
			PS_SetLocalInt(oPC, sTag, TRUE); // ADDED FROM ACQUIRED
			int nRecipeIndex = Search2DA(NX2_CRAFTING_2DA, "RECIPE_TAG", sTag, 1);
		
			if(CheckCanCraft(nRecipeIndex, oPC, NX2_CRAFTING_2DA) )
				CraftItem(nRecipeIndex, oPC, NX2_CRAFTING_2DA);
	
		} else {
			SendMessageToPC(oPC, "This crafting system has been disabled. Please refer to the SCoD wiki for the latest crafting information.");
		}
	}
	
	if(nItemID == 146) //Incantations are itemtype 146
	{
		//object oPC = GetItemActivator();
		SendMessageToPC(oPC, "This crafting system has been disabled. Please refer to the SCoD wiki for the latest crafting information.");
		/*object oItemToEnchant = GetItemActivatedTarget();
		if(GetObjectType(oItemToEnchant) == OBJECT_TYPE_ITEM)
		{
			string sTag = GetTag(oItem);
			PS_SetLocalInt(oPC, sTag, TRUE); // ADDED FROM ACQUIRED
			
				//	SpeakString("searching 2da for: " + sTag,TALKVOLUME_SHOUT); 
			int nIncantIndex = Search2DA(NX2_ENCHANTING_2DA, "INCANTATION_TAG", sTag, 1);
			//	SpeakString(IntToString(nIncantIndex),TALKVOLUME_SHOUT); 
			
			if( CheckCanEnchant(nIncantIndex, oItemToEnchant, oPC, NX2_ENCHANTING_2DA) )
			EnchantItem(nIncantIndex, oItemToEnchant, oPC, NX2_ENCHANTING_2DA);
		}*/
	}
	
	//*********************************************************
	//Adding partial tag activation - Mimi Fearthegn
	//*********************************************************
	if (GetSubString(sTag, 0, 4) == "serv") {
		ExecuteScript("i_slave_houseservant_ac", oPC);
		return;
	} else if (GetSubString(sTag, 0, 4) == "slav") {
		ExecuteScript("i_slave_combat_ac", oPC);
		return;
	} else if (GetSubString(sTag, 0, 12) == "gemstone_vfx") {
		ExecuteScript("i_gemstone_vfx_ac", oPC);
		return;
	} 
	//*********************************************************
	
     // * Generic Item Script Execution Code
     // * If MODULE_SWITCH_EXECUTE_TAGBASED_SCRIPTS is set to TRUE on the module,
     // * it will execute a script that has the same name as the item's tag
     // * inside this script you can manage scripts for all events by checking against
     // * GetUserDefinedItemEventNumber(). See x2_it_example.nss
     if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS) == TRUE)
     {
        SetUserDefinedItemEventNumber(X2_ITEM_EVENT_ACTIVATE);
        int nRet =   ExecuteScriptAndReturnInt(GetUserDefinedItemEventScriptName(oItem),OBJECT_SELF);
        if (nRet == X2_EXECUTE_SCRIPT_END)
        {
           return;
        }

     }

}