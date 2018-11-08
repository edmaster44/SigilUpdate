void main()
{
	object oChest = OBJECT_SELF;
	object oItem = GetFirstItemInInventory(oChest);
	
	if(!GetIsObjectValid(oItem))
    {
        SetPlotFlag(oChest, FALSE);
        DestroyObject(oChest);
    }
}