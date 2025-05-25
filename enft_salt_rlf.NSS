

#include "enft_cnsts"

int saltRelief(object oSaltPerson)
{
    int i;                                  // Counter variable
    object oNearest;                        // Near object
    string sNearest;                        // Nearest object
    object oEquipedItem;                    // Object of an equiped item
	int nRace = GetRacialType(oSaltPerson);

    // Check if endure elements class of spells is applied to cold person
    if(GetHasSpellEffect(1390, oSaltPerson) || GetHasFeat(2381, oSaltPerson, TRUE) || GetRacialType(oSaltPerson) == RACIAL_TYPE_OUTSIDER || GetRacialType(oSaltPerson) == RACIAL_TYPE_CONSTRUCT || GetRacialType(oSaltPerson) == RACIAL_TYPE_UNDEAD || GetRacialType(oSaltPerson) == RACIAL_TYPE_ELEMENTAL)
    return 1;
	
    // Search all objects within distance defined by coolDistance
    i = 1;
    oNearest = GetNearestObject(OBJECT_TYPE_ALL, oSaltPerson, i);
    while(GetDistanceBetween(oSaltPerson, oNearest) < hydrateDistance)
    {
        // Determine if the object is a cooling object
        if(!GetLocalInt(oNearest, "ENFT_NOT_HYDRATING"))
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
            SetLocalInt(oNearest, "ENFT_NOT_HYDRATING", TRUE);
        }

        // This object is not a cooling object.  Check next object.
        i++;
        oNearest = GetNearestObject(OBJECT_TYPE_ALL, oSaltPerson, i);
    }

    // Search all objects the worn by the person (equiped items).
    for(i = 0; i < NUM_INVENTORY_SLOTS; i++)
    {
        oEquipedItem = GetItemInSlot(i, oSaltPerson);
        if(!GetLocalInt(oEquipedItem, "ENFT_NOT_COOLING"))
        {
            if(GetResRef(oEquipedItem) == saltProtection1)
			{
				return 1;
			}

            // Not a cooling item.  Flag it to save time next pass
            SetLocalInt(oEquipedItem, "ENFT_NOT_COOLING", TRUE);
        }
    }

    // No warming object was found that was close enough
    return 0;
}