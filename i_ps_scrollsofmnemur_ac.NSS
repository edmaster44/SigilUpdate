//
/*
   Template for an Activate item script.
   This script will run each time an item's "custom activation" is used.
   
   How to use this script:
   Item needs an item property that will cause a custom activation such as Cast Spell:Unique Power
   Replace the word "temp" (in line 1) with the tag of the item.  Rename the script with this name.  
    
   Additional Info:
   In general, all the item "tag-based" scripts will be named as follows:
   - a prefix ("i_" by defualt)
   - the tag of the item
   - a postfix indicating the item event.
   
   This script will be called automatically (by defualt) whether it exists or not.  If if does not exist, nothing happens.
   
   Note: this script runs on the module object, an important consideration for assigning actions.
      -ChazM
*/
// Name_Date

#include "x2_inc_spellhook" 

void main()
{

	int nScrollCounter = 0;
	object oPC = GetItemActivator();
	object oScroll = GetItemActivated();
	
	//ForceRest(oPC);
	effect eEffect = GetFirstEffect(oPC);
	while (GetIsEffectValid(eEffect))
	{
	    if (GetEffectSpellId(eEffect) == 1201){
	        RemoveEffect(oPC, eEffect);
	    }
	    eEffect = GetNextEffect(oPC);
	}
	
	
	object oItem = GetFirstItemInInventory(oPC);
	while(GetIsObjectValid(oItem) == TRUE)
	{
		if(GetTag(oItem) == "ps_scrollsofmnemur")
		{
			nScrollCounter = nScrollCounter + GetItemStackSize(oItem);
			DestroyObject(oItem);
		}
		oItem = GetNextItemInInventory(oPC);
	}

	effect eVis = EffectVisualEffect(SPELLABILITY_KOS_DOT);
	effect eDamage = EffectDamage(d6(nScrollCounter), DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_ENERGY, TRUE); 
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC); 
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oPC);
}