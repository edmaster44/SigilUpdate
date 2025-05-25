

#include "enft_cnsts"

int freezeRelief(object oColdPerson)
{
    int i;                                  // Counter variable
    object oNearest;                        // Near object
    string sNearest;                        // Nearest object
    object oEquipedItem;                    // Object of an equiped item

    // Check if endure elements class of spells is applied to cold person
    if(GetHasSpellEffect(1390, oColdPerson) || GetHasFeat(2381, oColdPerson, TRUE))
        return 1;
	if (GetSubRace(OBJECT_SELF) == 242)
		return 1;

    // Search all objects within distance defined by warmDistance
    i = 1;
    oNearest = GetNearestObject(OBJECT_TYPE_ALL, oColdPerson, i);
    while(GetDistanceBetween(oColdPerson, oNearest) < warmDistance)
    {
        // Determine if the object is a warming object
        if(!GetLocalInt(oNearest, "ENFT_NOT_WARMING"))
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
		// The above placables are not used as freeze relief placables because
		// the fire effect is a seperate placed effect and these placeables may
		// be used without a fire on them, and thus, won't provide relief.
        // List sources of proximity heat relief as shown in examples above.

            // Not a warming object.  Flag it to save time next pass
            SetLocalInt(oNearest, "ENFT_NOT_WARMING", TRUE);
        }

        // This object is not a warming object.  Check next object.
        i++;
        oNearest = GetNearestObject(OBJECT_TYPE_ALL, oColdPerson, i);
    }

    // Search all objects the worn by the person (equiped items).
    for(i = 0; i < NUM_INVENTORY_SLOTS; i++)
    {
        oEquipedItem = GetItemInSlot(i, oColdPerson);
        if(!GetLocalInt(oEquipedItem, "ENFT_NOT_WARMING"))
        {
            if(GetResRef(oEquipedItem) == coldProtection1) return 1;
            if(GetResRef(oEquipedItem) == coldProtection2) return 1;
            if(GetResRef(oEquipedItem) == coldProtection3) return 1;
            if(GetResRef(oEquipedItem) == coldProtection4) return 1;
            if(GetResRef(oEquipedItem) == coldProtection5) return 1;
            if(GetResRef(oEquipedItem) == coldProtection6) return 1;
            if(GetResRef(oEquipedItem) == coldProtection7) return 1;
            if(GetResRef(oEquipedItem) == coldProtection8) return 1;
            if(GetResRef(oEquipedItem) == coldProtection9) return 1;
            if(GetResRef(oEquipedItem) == coldProtection10) return 1;

            // Not a warming object.  Flag it to save time next pass
            SetLocalInt(oEquipedItem, "ENFT_NOT_WARMING", TRUE);
        }
    }

    // No warming object was found that was close enough
    return 0;
}