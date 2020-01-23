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
void main()
{
    object oItem = GetItemActivated();
	object oPC = GetItemActivator();

	string sTag = GetTag(oItem);
	if(GetBaseItemType(oItem) == 145 && GetTag(oItem) != "sigisedition") //Recipes are itemtype 145
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
		
			SetLocalInt(oPC, sTag, TRUE); // ADDED FROM ACQUIRED
			int nRecipeIndex = Search2DA(NX2_CRAFTING_2DA, "RECIPE_TAG", sTag, 1);
		
			if(CheckCanCraft(nRecipeIndex, oPC, NX2_CRAFTING_2DA) )
				CraftItem(nRecipeIndex, oPC, NX2_CRAFTING_2DA);
	
		} else {
			SendMessageToPC(oPC, "This crafting system has been disabled. Please refer to the SCoD wiki for the latest crafting information.");
		}
	}
	
	if(GetBaseItemType(oItem) == 146) //Incantations are itemtype 146
	{
		//object oPC = GetItemActivator();
		SendMessageToPC(oPC, "This crafting system has been disabled. Please refer to the SCoD wiki for the latest crafting information.");
		/*object oItemToEnchant = GetItemActivatedTarget();
		if(GetObjectType(oItemToEnchant) == OBJECT_TYPE_ITEM)
		{
			string sTag = GetTag(oItem);
			SetLocalInt(oPC, sTag, TRUE); // ADDED FROM ACQUIRED
			
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