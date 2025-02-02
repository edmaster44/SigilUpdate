/*
ps_hb_nighttorch_multiuse
by Dedic8ed, 3/2/11
based on torch script by Sean Bradbury, found on nwn2 wikia

Place on an NPC's OnHeartbeat script.
This will cause them to check the time, and if it is nighttime they will put away the item in
their off-hand and equip an item specified in the "nighttorch" variable; if it is dawn or day 
and they are holding a torch, they will put the torch away and re-equip the previous item in 
their left.

Note: the value for an actual torch is nw_it_torch001
*/

void main()
{

	object oItem;
	object oTorch;
	object oOld;
	string sOld;
	int iTorchOn		= GetLocalInt(OBJECT_SELF,"torchon");
	string sTorch 		= GetLocalString(OBJECT_SELF, "nighttorch");


	if(GetIsDay() || GetIsDawn())
	{
		// Put torch away if holding one
		oItem = GetItemInSlot (INVENTORY_SLOT_LEFTHAND);
		sOld = GetLocalString(OBJECT_SELF, "oldobject");
		oOld = GetItemPossessedBy(OBJECT_SELF, sOld);
		if (iTorchOn == 1)
		{
			ActionUnequipItem (oItem);
			SetLocalInt (OBJECT_SELF, "torchon", 0);
			// Get the item held in left hand and equip it.
			ActionEquipItem (oOld, INVENTORY_SLOT_LEFTHAND);
		}
	}

	else
	{
		// check to see if torch equipped
		int iTorchOn = GetLocalInt (OBJECT_SELF, "torchon");
		if (iTorchOn == 0)
		{
			oTorch = CreateItemOnObject("nighttorch");
			if (oItem != OBJECT_INVALID)
			{
				// Get the current item in the left hand and store it for later use
				oOld = GetItemInSlot (INVENTORY_SLOT_LEFTHAND);
				sOld = GetTag(oOld);
				SetLocalString(OBJECT_SELF, "oldobject", sOld);
				ActionEquipItem (oTorch, INVENTORY_SLOT_LEFTHAND);
				SetLocalInt (OBJECT_SELF, "torchon", 1);
			}
		}
		else
		{
		//Run the rest of the default heartbeat script	
		ExecuteScript("nw_c2_default1", OBJECT_SELF);
		}
	} // END TORCH routine
//Run the rest of the default heartbeat script	
ExecuteScript("nw_c2_default1", OBJECT_SELF);
}