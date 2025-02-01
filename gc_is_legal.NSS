#include "ff_safevar"

// gc_is_legal v1.02

//#include "ps_wandofsort_inc"
//#include "x2_inc_itemprop"
	
int iCheckitem(object oItem)
{
int oImmun = 0;

   if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_FREEDOM_OF_MOVEMENT))
   {
    //SpeakString("freedom " + GetTag(oItem),TALKVOLUME_SHOUT);
    oImmun = 1;
   }
   else if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_HASTE))
   {
    //SpeakString("permahaste " + GetTag(oItem),TALKVOLUME_SHOUT);
    oImmun = 1;
   }
   else if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE))
   {
    //SpeakString("immunity damage " + GetTag(oItem),TALKVOLUME_SHOUT);
    oImmun = 1;
   }
   else if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS))
   {
    //SpeakString("immunity misc " + GetTag(oItem),TALKVOLUME_SHOUT);
    oImmun = 1;
   }
   else if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMMUNITY_SPELL_SCHOOL))
   {
    //SpeakString("immunity spell " + GetTag(oItem),TALKVOLUME_SHOUT);
    oImmun = 1;
   }
   else if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL))
   {
    //SpeakString("immunity spells by level " + GetTag(oItem),TALKVOLUME_SHOUT);
    oImmun = 1;
   }
   else if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMPROVED_EVASION))
   {
    //SpeakString("item with improved evasion " + GetTag(oItem),TALKVOLUME_SHOUT);
    oImmun = 1;
   }
   
   	//Blocks shard items
	string sTag = GetTag(oItem);
	if (FindSubString(sTag, "nwn2_it_shard", 0) != -1)
		oImmun = 1;

return oImmun;
}

// Function added by Agony_Aunt to strip Merkhant Belt from characters due to nature of
// Merchant's Friend feat causing lots of problems with store prices and exploits.
// Function should remove item, reimburse gold, send message, save character.
/*void StripMerkhantBelt(object oPC, object oItem)
{
	DestroyObject(oItem, 0.0, TRUE);
	GiveGoldToCreature(oPC, 62500, TRUE);
	SendMessageToPC(oPC, "<COLOR=red>Due to major issues and exploits with the Merkhant's Belt we have had to remove it from the game.  The base cost of the item has been refunded. - The DM Team");
	ExportSingleCharacter(oPC);
}
*/
// Removing now, as guess a majority of these are gone.
/*
void ScanMerkBelt(object oPC)
{
	object oItem = GetFirstItemInInventory(oPC);
   	while(GetIsObjectValid(oItem))
   	{
		// Check each item scanned to see if it is a Merkhant Belt
		if (GetTag(oItem) == "ps_it_merkh_mrcbelt")
			StripMerkhantBelt(oPC, oItem);		
 		oItem = GetNextItemInInventory(oPC);
   	}

	// Check direct on belt slot to see if Merkhant Belt
	oItem = GetItemInSlot(INVENTORY_SLOT_BELT, oPC);
	if (GetTag(oItem) == "ps_it_merkh_mrcbelt")
		StripMerkhantBelt(oPC, oItem);
}
*/

int oScan1(object oPC)
{
	int problem = 0;
	string sTag;
	
   	object oItem = GetFirstItemInInventory(oPC);
   	while(GetIsObjectValid(oItem))
   	{
		sTag = GetTag(oItem);
		// Check each item scanned to see if it is a Merkhant Belt
		/*if (sTag == "ps_it_merkh_mrcbelt")
			StripMerkhantBelt(oPC, oItem);
		*/
		
	
		
		if (sTag == "itemondisplay")
		{
			DestroyObject(oItem, 0.01);
			SendMessageToPC(oPC, "Naughty boy had an item stolen from a display container. Stolen item has gone bye bye!");
		}
			
 		if(iCheckitem(oItem)==1)
 		{
  			problem += 1;
 		}
		oItem = GetNextItemInInventory(oPC);
   	}

	/*
	// Check direct on belt slot to see if Merkhant Belt
	oItem = GetItemInSlot(INVENTORY_SLOT_BELT, oPC);
	if (GetTag(oItem) == "ps_it_merkh_mrcbelt")
		StripMerkhantBelt(oPC, oItem);
	*/
	
   int nSlot = 0;
   for (nSlot=0; nSlot<NUM_INVENTORY_SLOTS; nSlot++)
   {
	   oItem=GetItemInSlot(nSlot, oPC);
	
	   if (GetIsObjectValid(oItem))
	   {
		 if(iCheckitem(oItem)==1)
		 {
          SendMessageToPC(oPC,"Following item is illegal on server (you cannot enter while carrying it): " + GetName(oItem));
		  problem += 1;
		 }
	   }
   }

   
return problem;
}


int CheckELC(object oPC)
{
ForceRest(oPC);

int wow =0;

   if(GetImmortal(oPC))
   {
    //SpeakString("immortal",TALKVOLUME_SHOUT);
    wow = 1;
   }
   //else if(GetCreatureSize(oPC) > 3)
   //{
    //SpeakString("size > 3",TALKVOLUME_SHOUT);
   // wow = 1;
   //}
   else if(GetMaxHitPoints(oPC) > 1500)
   {
    //SpeakString("hp > 1000",TALKVOLUME_SHOUT);
    wow = 1;
   }
   else if(GetAC(oPC) > 80)
   {
    //SpeakString("AC > 79",TALKVOLUME_SHOUT);
    wow = 1;
   }
   else if(GetAbilityScore(oPC,ABILITY_STRENGTH) > 50 ||
   GetAbilityScore(oPC,ABILITY_DEXTERITY) > 50 ||
   GetAbilityScore(oPC,ABILITY_CONSTITUTION) > 50 ||
   GetAbilityScore(oPC,ABILITY_WISDOM) > 50 ||
   GetAbilityScore(oPC,ABILITY_INTELLIGENCE) > 50 ||
   GetAbilityScore(oPC,ABILITY_CHARISMA) > 50)
   {
   	//SpeakString("too high ab score(s)",TALKVOLUME_SHOUT);
    wow = 1;
   }
   if(GetFortitudeSavingThrow(oPC) > 80 ||
   GetWillSavingThrow(oPC) > 80 ||
   GetReflexSavingThrow(oPC) > 80)
   {
    //SpeakString("too high saves",TALKVOLUME_SHOUT);
    wow = 1;
   }
   string oNa = GetName(oPC);
   if(GetStringLength(oNa) < 2)
   {
   	 SendMessageToPC(oPC,"Please select a character name that is longer than a single letter.");
    //SpeakString("char name too short",TALKVOLUME_SHOUT);
    wow = 1;
   }
if(oScan1(oPC)>0)
{
 wow = 1;
}

return wow;
}

int StartingConditional()
{
	//SpeakString("start",TALKVOLUME_SHOUT);

    object oPC = GetPCSpeaker();

	int iEssence = 0;
	
	object oItem = GetItemPossessedBy(oPC,"ps_essence");
    if(GetIsObjectValid(oItem))
    {
	 	string sLegal = PS_GetLocalString(oItem,"LEGAL");
		if(sLegal == "TRUE")
		{
			//ScanMerkBelt(oPC);
			return TRUE;
		}
		iEssence += 1;
    }

	if ( iEssence != 1 ) // 1 essence exactly needed otherwise bugged
	{
		//SpeakString("no essence or too many essences",TALKVOLUME_SHOUT);
		return FALSE;
	}
	
    if ( CheckELC(oPC) == 0 ) return TRUE;

    return FALSE;

}