#include "x2_inc_itemprop"

// I noticed some erroneous behaviour in stacking crafted potions with the ServerExts
// #stacks command, so I wrote my own. Setting this to FALSE uses mine, TRUE uses ServerExts
// -FlattedFifth
const int USE_SERVEREXTS_STACK = FALSE;
const int SHOW_STACKS_DEBUG = TRUE;

int GetItemsIdentical(object oItem1, object oItem2);

void ff_MergeStacksInContainer(object oContainer){
	
	//debug
	if (SHOW_STACKS_DEBUG){
		object oOwner = GetItemPossessor(oContainer);
		if (GetIsObjectValid(oOwner) && (GetIsPC(oOwner) || GetIsDM(oOwner))){
			SendMessageToPC(oOwner, "Merging items (new function)");
		}
	}
	//end debug

    object oItem = GetFirstItemInInventory(oContainer);
	object oOther;
	int nMaxStack;
	int nOtherStack;
	int nFreeSpace;
	int nNumToTransfer;
	
    while (GetIsObjectValid(oItem)){
        
		nMaxStack = IPGetMaxStackSize(oItem);
		// Only items not already a full stack
        if (nMaxStack > 1 && GetItemStackSize(oItem) < nMaxStack){
            
			oOther = GetNextItemInInventory(oContainer);
			
            while (GetIsObjectValid(oOther)){
                
                if (oOther != oItem){
					if (GetItemsIdentical(oItem, oOther)){
						nOtherStack = GetItemStackSize(oOther);
						nFreeSpace = nMaxStack - GetItemStackSize(oItem);
						nNumToTransfer = nOtherStack;
						if (nNumToTransfer > nFreeSpace) nNumToTransfer = nFreeSpace;
						nOtherStack -= nNumToTransfer;
						
						if (nNumToTransfer > 0){
							// Add to this stack
							SetItemStackSize(oItem, GetItemStackSize(oItem) + nNumToTransfer);
							if (nOtherStack > 0)
								SetItemStackSize(oOther, nOtherStack);
							else DestroyObject(oOther);
						}
						
						// If this stack is now full, move on
						if (GetItemStackSize(oItem) >= nMaxStack)
							break;
					}
                }
                oOther = GetNextItemInInventory(oContainer);
            }
        }
        oItem = GetNextItemInInventory(oContainer);
    }
}

int GetItemsIdentical(object oItem1, object oItem2){
    // Compare resref, tag, and base material
    if (GetResRef(oItem1) != GetResRef(oItem2)) return FALSE;
    if (GetTag(oItem1) != GetTag(oItem2)) return FALSE;
	if (GetItemBaseMaterialType(oItem1) != GetItemBaseMaterialType(oItem2)) return FALSE;

    // Compare charges
    if (GetItemCharges(oItem1) != GetItemCharges(oItem2)) return FALSE;

    // Compare all item properties
    itemproperty ip1 = GetFirstItemProperty(oItem1);
    itemproperty ip2 = GetFirstItemProperty(oItem2);

    // Count properties
    int nCount1 = 0, nCount2 = 0;
    while (GetIsItemPropertyValid(ip1)) { nCount1++; ip1 = GetNextItemProperty(oItem1); }
    while (GetIsItemPropertyValid(ip2)) { nCount2++; ip2 = GetNextItemProperty(oItem2); }

    if (nCount1 != nCount2) return FALSE;

    // Now compare properties themselves
	int bFound = FALSE;
    ip1 = GetFirstItemProperty(oItem1);
    while (GetIsItemPropertyValid(ip1)){
        bFound = FALSE;
        ip2 = GetFirstItemProperty(oItem2);
        while (GetIsItemPropertyValid(ip2)){
            if (IPGetItemPropertiesIdentical(ip1, ip2, TRUE)){
                bFound = TRUE;
                break;
            }
            ip2 = GetNextItemProperty(oItem2);
        }
        if (!bFound) return FALSE;
        ip1 = GetNextItemProperty(oItem1);
    }

    return TRUE;
}
