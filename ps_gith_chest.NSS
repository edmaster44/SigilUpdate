void main()
{
	// Really redundant as additional code for this wrapper moved directly into ps_chest to avoid exploit
	// Just would need to edit chests in Gith Interior to make their on_open change to ps_chest instead of ps_gith_chest
	object oChest = OBJECT_SELF;
	ExecuteScript("ps_chest", oChest);	
}