#include "nwn2_inc_spells"

/* //Obsolete system not in use.
#include "nwnx_craft"
#include "nwnx_craft_system"

void CopyItemDoppelganger(object oTarget, int nItemSlot)
{
	object oItemCreature = GetItemInSlot(nItemSlot, oTarget);
	object oItemSelf = GetItemInSlot(nItemSlot, OBJECT_SELF);
	if (GetTag(oItemCreature) != "" & GetTag(oItemSelf) != "")
	{
		XPCraft_StoreItemToCraft(OBJECT_SELF,oItemCreature,FALSE);
		object oItemNew = XPCraft_RetrieveCraftedItem(OBJECT_SELF, GetLocation(OBJECT_SELF));

		int nNewItemRules = GetArmorRulesType(oItemSelf);
		SetArmorRulesType(oItemNew, nNewItemRules);
		int nNewMaterialType = GetItemBaseMaterialType(oItemSelf);
		SetItemBaseMaterialType(oItemNew, nNewMaterialType);
		object oItemNewInv = CopyItem(oItemNew, OBJECT_SELF, 0);
	
		itemproperty ipItemPropertyOld = GetFirstItemProperty(oItemNewInv);
		while(GetIsItemPropertyValid(ipItemPropertyOld))
		{
			RemoveItemProperty(oItemNewInv,ipItemPropertyOld);
			ipItemPropertyOld = GetNextItemProperty(oItemNewInv);
		}
	
		IPCopyItemProperties(oItemSelf,oItemNewInv,FALSE);
		DestroyObject(oItemSelf);
		DestroyObject(oItemNew);
		SetIdentified(oItemNewInv, TRUE);
		ActionEquipItem(oItemNewInv, nItemSlot);
	}
}