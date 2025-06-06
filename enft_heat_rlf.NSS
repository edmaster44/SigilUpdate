

#include "enft_cnsts"

int heatRelief(object oHotPerson)
{
    int i;                                  // Counter variable
    object oNearest;                        // Near object
    string sNearest;                        // Nearest object
    object oEquipedItem;                    // Object of an equiped item

    
	if (GetLevelByClass(63, OBJECT_SELF) > 2)
		return TRUE;
	if (GetSubRace(OBJECT_SELF) == 242)
		return TRUE;
	
	// Check if endure elements class of spells is applied to cold person
    if(GetHasSpellEffect(SPELL_ENDURE_ELEMENTS, oHotPerson) ||
       GetHasSpellEffect(SPELL_PROTECTION_FROM_ENERGY, oHotPerson) ||
       GetHasSpellEffect(SPELL_RESIST_ENERGY, oHotPerson) || GetHasSpellEffect(1390, oHotPerson))
    return 1;

    // Search all objects within distance defined by coolDistance
    i = 1;
    oNearest = GetNearestObject(OBJECT_TYPE_ALL, oHotPerson, i);
    while(GetDistanceBetween(oHotPerson, oNearest) < coolDistance)
    {
        // Determine if the object is a cooling object
        if(!GetLocalInt(oNearest, "ENFT_NOT_COOLING"))
        {
            sNearest = GetTag(oNearest);
            if(sNearest == "ENFT_RELIEF_SPOT") return 1;
            sNearest = GetResRef(oNearest);
//            if(sNearest == "plc_mr_campfire1") return 1;
//            if(sNearest == "plc_mr_campfire2") return 1;
//            if(sNearest == "plc_mr_campfire3") return 1;
//            if(sNearest == "plc_mr_campfire4") return 1;
//            if(sNearest == "plc_sn_campfire3") return 1;
//            if(sNearest == "plc_nt_bonfire") return 1;
//            if(sNearest == "plc_mc_brazier01") return 1;
//            if(sNearest == "plc_mc_brazier02") return 1;
        // List sources of proximity heat relief as shown in examples above.

            // Not a cooling object.  Flag it to save time next pass
            SetLocalInt(oNearest, "ENFT_NOT_COOLING", TRUE);
        }

        // This object is not a cooling object.  Check next object.
        i++;
        oNearest = GetNearestObject(OBJECT_TYPE_ALL, oHotPerson, i);
    }

    // Search all objects the worn by the person (equiped items).
    for(i = 0; i < NUM_INVENTORY_SLOTS; i++)
    {
        oEquipedItem = GetItemInSlot(i, oHotPerson);
        if(!GetLocalInt(oEquipedItem, "ENFT_NOT_COOLING"))
        {
            if(GetResRef(oEquipedItem) == heatProtection1) return 1;
            if(GetResRef(oEquipedItem) == heatProtection2) return 1;
            if(GetResRef(oEquipedItem) == heatProtection3) return 1;
            if(GetResRef(oEquipedItem) == heatProtection4) return 1;
            if(GetResRef(oEquipedItem) == heatProtection5) return 1;
            if(GetResRef(oEquipedItem) == heatProtection6) return 1;
            if(GetResRef(oEquipedItem) == heatProtection7) return 1;
            if(GetResRef(oEquipedItem) == heatProtection8) return 1;
            if(GetResRef(oEquipedItem) == heatProtection9) return 1;
            if(GetResRef(oEquipedItem) == heatProtection10) return 1;

            // Not a cooling item.  Flag it to save time next pass
            SetLocalInt(oEquipedItem, "ENFT_NOT_COOLING", TRUE);
        }
    }

    // No warming object was found that was close enough
    return 0;
}