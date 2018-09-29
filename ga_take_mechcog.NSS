void main()
{
    object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
    object oItem = GetFirstItemInInventory(oPC);
	int iFound = 0;
	
	while (oItem != OBJECT_INVALID && iFound == 0)
	{
		// using GetResRef over GetTag as hyphens are not recoginzed by it
		// Alternative method would be to change the string it is comparing with to remove the hyphen
		if (GetResRef(oItem) == "ps_miscstack_coinage-cogcoin")
		{
			iFound = 1;
			int iSize = GetItemStackSize(oItem);
			int iNew = (iSize - 1);
			if (iSize == 1) DestroyObject(oItem);
			else SetItemStackSize(oItem, iNew, TRUE);
		}
		oItem = GetNextItemInInventory(oPC);
	}

}