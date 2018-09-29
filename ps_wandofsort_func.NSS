// script called from sort convo that defines what goes where.

#include "ps_wandofsort_inc"

void main(string sStore)
{
	object oPC = GetPCSpeaker();
	
	object oSelected = GetLocalObject(oPC, VAR_TEMP_OBJECT);
	
	if (GetBaseItemType(oSelected) == BASE_ITEM_LARGEBOX && GetItemPossessor(oSelected) == oPC) // apparently a container
	{
		if (sStore == VAR_RESET)
		{
			/*//string sTemp = GetLocalString(oSelected, VAR_TYPE_CONT);
			if (sTemp != "")
			{
				DeleteLocalObject(oPC, sTemp);
				DeleteLocalString(oSelected, VAR_TYPE_CONT);
				if (GetStringRight(GetFirstName(oSelected), 13) == " (AUTO_STORE)")
					SetFirstName(oSelected, GetStringLeft(GetFirstName(oSelected), GetStringLength(GetFirstName(oSelected)) - 13));
			}*/
			string sTemp = GetLocalString(oSelected, VAR_CONT_ORIG_NAME);
			if (sTemp != "") SetFirstName(oSelected, sTemp);
			
			sTemp = GetLocalString(oSelected, VAR_CONT_ORIG_TAG);
			if (sTemp != "") SetTag(oSelected, sTemp);
			
			DeleteLocalObject(oPC, VAR_TYPE_GEMS);
			DeleteLocalObject(oPC, VAR_TYPE_BOOKS);
			DeleteLocalObject(oPC, VAR_TYPE_SCROLLS);
			DeleteLocalObject(oPC, VAR_TYPE_AMMO);
			DeleteLocalObject(oPC, VAR_TYPE_WEAPONS);
			DeleteLocalObject(oPC, VAR_TYPE_ARMOUR);
			DeleteLocalObject(oPC, VAR_TYPE_OTHER);
			DeleteLocalInt(oSelected, VAR_TYPE_GEMS);
			DeleteLocalInt(oSelected, VAR_TYPE_BOOKS);
			DeleteLocalInt(oSelected, VAR_TYPE_SCROLLS);
			DeleteLocalInt(oSelected, VAR_TYPE_AMMO);
			DeleteLocalInt(oSelected, VAR_TYPE_WEAPONS);
			DeleteLocalInt(oSelected, VAR_TYPE_ARMOUR);
			DeleteLocalInt(oSelected, VAR_TYPE_OTHER);
		}
		else
		{
			SetLocalInt(oSelected, sStore, 1);
			SetLocalObject(oPC, sStore, oSelected);
			
			if (GetTag(oSelected) != VAR_NEWTAG)
			{
				SetLocalString(oSelected, VAR_CONT_ORIG_TAG, GetTag(oSelected));
				SetTag(oSelected, VAR_NEWTAG);
			}
			
			string sName = GetFirstName(oSelected);
			if (GetStringLeft(sName, GetStringLength(VAR_NEW_NAME)) != VAR_NEW_NAME)
			{
				SetLocalString(oSelected, VAR_CONT_ORIG_NAME, sName);
				SetFirstName(oSelected, VAR_NEW_NAME);
			}
			else
			{
				SetFirstName(oSelected, sName + STRING_SEPERATOR); // since it already has the auto name, we just need to add a separator before we do the next bit.
			}
			
			string sTemp;
			
			if (sStore == VAR_TYPE_GEMS) sTemp = STRING_GEMS;
			else if (sStore == VAR_TYPE_BOOKS) sTemp = STRING_BOOKS;
			else if (sStore == VAR_TYPE_AMMO) sTemp = STRING_AMMO;
			else if (sStore == VAR_TYPE_SCROLLS) sTemp = STRING_SCROLLS;
			else if (sStore == VAR_TYPE_WEAPONS) sTemp = STRING_WEAPONS;
			else if (sStore == VAR_TYPE_ARMOUR) sTemp = STRING_ARMOUR;
			else sTemp = STRING_OTHER;
			
			sName = GetFirstName(oSelected) + sTemp;
			
			SetFirstName(oSelected, sName);
		}
	}
	else
	{
		SendMessageToPC(oPC, "<color=lime>You must target a container in your inventory for this to work.");
	}
}