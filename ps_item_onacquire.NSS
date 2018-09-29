// v1.01

//Set the module's "onacquire" to this or include it.
//Will announce to every party member when someone acquires an item.
//It ignores whether the item is IDed or not, but does not ID it by doing so.
//It ignores whether the party members are in the same area or not
//Both the above would be simple changes if desired.
//Written August 12 2007, by Lusitania


#include "nwnx_sql"
#include "ps_wandofsort_inc"
#include "ps_inc_advscript"
#include "ps_inc_functions"

void CheckAndPlaceItemInContainer(object oItem, object oPC, object oFrom)
{
	int iType = GetBaseItemType(oItem);
	object oTo;
	string sTo;

	//SendMessageToPC(oPC, "Taken from : " + IntToString(GetBaseItemType(oFrom)) + " Name is: " + GetName(oFrom) + " Type is: " + IntToString(GetObjectType(oFrom)));
	// switching to use same method as main() uses.
	if (GetTag(oFrom) == "BodyBag" || TestStringAgainstPattern("**chest**",GetTag(oFrom)))
	{
		// we can see if it should be stored somewhere.
		switch (iType)
		{
			case BASE_ITEM_GEM: sTo = VAR_TYPE_GEMS; break;
			case BASE_ITEM_BOOK: sTo = VAR_TYPE_BOOKS; break;
			case BASE_ITEM_ENCHANTED_SCROLL: 
			case BASE_ITEM_SPELLSCROLL: sTo = VAR_TYPE_SCROLLS; break;
			case BASE_ITEM_ARROW:
			case BASE_ITEM_BOLT:
			case BASE_ITEM_BULLET: sTo = VAR_TYPE_AMMO; break;
			case BASE_ITEM_ARMOR: sTo = VAR_TYPE_ARMOUR; break;
			default: sTo = VAR_TYPE_OTHER; break;
		}
		
		if (GetWeaponType(oItem) != WEAPON_TYPE_NONE) sTo = VAR_TYPE_WEAPONS;
		
		oTo = GetLocalObject(oPC, sTo);
		
		// extra check to make sure container belongs to PC and that it is a container - at least hopefully stop items disappearing to god knows where...
		if (GetIsObjectValid(oTo) && GetItemPossessor(oTo) == oPC && GetBaseItemType(oTo) == BASE_ITEM_LARGEBOX) 
		{
			//SendMessageToPC(oPC, "Giving item to inventory object " + GetName(oTo));
			AssignCommand(oPC, ActionGiveItem(oItem, oTo, TRUE));
			AssignCommand(oPC, ActionDoCommand(PS_MergeContainerStacks(oTo)));
		}
	}
}


void main() {

	//SpeakString("ITEM AQUIRED",TALKVOLUME_SILENT_SHOUT);

	object acquirer = GetModuleItemAcquiredBy();
	if (!GetIsPC(acquirer)) return;

	object item = GetModuleItemAcquired();		
	object oPartyMember = GetFirstFactionMember(acquirer, TRUE);
	string textToSpeak;
	object aFrom = GetModuleItemAcquiredFrom();
	string previousOwner;
	string AcquiredItemTag;
		
	
    if(aFrom == OBJECT_INVALID)
	{
		//do not speak picking up stuff
	}
	else
	{	
		if ( GetTag(aFrom) == "BodyBag" || TestStringAgainstPattern("**chest**",GetTag(aFrom)))
		{
			if(GetBaseItemType(item) == 255)
				textToSpeak = GetName(acquirer) + " picked up some gold"; //Gold.  Apparently the defined global value for BASE_ITEM_GOLD being 76 is a lie, it's 255.
			else if(GetItemStackSize(item)>1)
				textToSpeak = GetName(acquirer) + " picked up " + IntToString(GetItemStackSize(item)) + " " + GetName(item) + "s";
			else if(GetBaseItemType(item) == BASE_ITEM_SPELLSCROLL && GetIdentified(item))
				textToSpeak = GetName(acquirer) + " picked up a Scroll of " + GetName(item);
			else
				textToSpeak = GetName(acquirer) + " picked up a " + GetName(item);
		}
	}

	previousOwner = GetLocalString(item, "A1");
	
	//Anti cheat logging
	if(GetLocalString(item,"A2") == GetPCPlayerName(acquirer) && GetLocalString(item,"N2") != GetName(acquirer) || 
		(previousOwner == GetPCPlayerName(acquirer) && GetLocalString(item,"N1") != GetName(acquirer)))
	{
		SQLExecDirect("INSERT INTO logging (account,name,event,type) VALUES ('" + GetPCPlayerName(acquirer) + "','" + GetName(acquirer) + "','" + GetName(item) + " (" + GetTag(item) + ") given from " + GetLocalString(item,"A1") + "/" + GetLocalString(item,"N1") + " and original owner: " + GetLocalString(item,"A2") + "/" + GetLocalString(item,"N2") + " (" + GetTag(aFrom) + ")',105)");
		//SpeakString("Possible muling",TALKVOLUME_SILENT_SHOUT);
		SpeakString("<C=TOMATO>[POSSIBLE MULING] " + GetLocalString(item,"A1") + "/" + GetLocalString(item,"N1") + " just gave " + GetPCPlayerName(acquirer) + "/" + GetName(acquirer) + " following: " + GetName(item) + "/" + GetTag(item) + ", which was last owned by: " + GetLocalString(item,"A2") + "/" + GetLocalString(item,"N2"),TALKVOLUME_SILENT_SHOUT);

		SetLocalString(item,"A2","");
		SetLocalString(item,"N2","");
		SetLocalString(item,"A1",GetPCPlayerName(acquirer));
		SetLocalString(item,"N1",GetName(acquirer));
		SetLocalString(item,"M","Muling logged");		
	}
	
	//SpeakString(GetLocalString(item,"N1"),TALKVOLUME_SILENT_SHOUT);
	//SpeakString(GetName(acquirer),TALKVOLUME_SILENT_SHOUT);
	
	if(GetLocalString(item,"N1") != GetName(acquirer))
	{
		//SpeakString("SETTING VARS",TALKVOLUME_SILENT_SHOUT);
		SetLocalString(item,"A2",GetLocalString(item,"A1"));
		SetLocalString(item,"N2",GetLocalString(item,"N1"));
		SetLocalString(item,"A1",GetPCPlayerName(acquirer));
		SetLocalString(item,"N1",GetName(acquirer));
	}	
		
	while (GetIsObjectValid(oPartyMember) == TRUE) {
		if(oPartyMember == acquirer)
			FloatingTextStringOnCreature(textToSpeak,acquirer,FALSE,5.0);
		else if (GetArea(oPartyMember) == GetArea(acquirer))
			SendMessageToPC(oPartyMember, textToSpeak);
		oPartyMember = GetNextFactionMember(acquirer, TRUE);
	}

	if (previousOwner == "")
	{
		CheckAndPlaceItemInContainer(item, acquirer, aFrom);
	}

	AcquiredItemTag = GetTag(item);
	
	// for persistence of auto-sort containers.
	// discovered, when character logs in, on-aquire event triggers for all items in inventory of PCs (and monsters on spawn!!! Remember this!)
	if (AcquiredItemTag == VAR_NEWTAG)
	{
		ResetSortValuesOnPC(acquirer, item);
	}
	else if (AcquiredItemTag == "ps_essence")
	{
		PS_LoadEssenceState(acquirer, item);
	}
}