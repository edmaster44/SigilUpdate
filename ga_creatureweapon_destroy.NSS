/*
ga_creatureweapon_upgrade by Ceremorph for the Sigil: City of Doors PW
	For use with "equippable" creature weapons	
		Destroys current weapon in right hand slot
*/

void main()
{
	object oPC = GetPCSpeaker();
	object oItem = GetItemInSlot(4, oPC);
	string sName = GetName(oItem);

	if (GetBaseItemType(oItem) == 160 || GetBaseItemType(oItem) == 161 || GetBaseItemType(oItem) == 162 ||
		GetBaseItemType(oItem) == 163 || GetBaseItemType(oItem) == 164 || GetBaseItemType(oItem) == 165 ||
		GetBaseItemType(oItem) == 166 || GetBaseItemType(oItem) == 167 || GetBaseItemType(oItem) == 168 ||
		GetBaseItemType(oItem) == 169 || GetBaseItemType(oItem) == 170 || GetBaseItemType(oItem) == 171 ||
		GetBaseItemType(oItem) == 172 || GetBaseItemType(oItem) == 173 || GetBaseItemType(oItem) == 174 )
		
	{	DestroyObject(oItem,0.0, TRUE);	
		SendMessageToPC(oPC, "<color=yellow>" + sName + " has been destroyed</color>");	}
}