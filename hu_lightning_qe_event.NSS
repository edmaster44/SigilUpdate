// hu_lightning_qe_event
/*
    Determines the course of action to be taken
    on a user defined event.
*/
// 30nov19 RJHall

void main()
{
    // enter desired behaviour here
	int nEvent = GetUserDefinedEventNumber();
	
	switch( nEvent ) {
		case EVENT_DAMAGED:
			// Apply electrical damage if bare-handed or wielding a metal(?) weapon
			int bShock = FALSE;
			object oDamager = GetLastDamager();
			if (GetIsObjectValid(oDamager)) {
				object oInvItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oDamager);
				if (GetIsObjectValid(oInvItem)) {
					int itemType = GetBaseItemType(oInvItem);
					switch(itemType) {
						case BASE_ITEM_BASTARDSWORD:
						case BASE_ITEM_CGIANT_SWORD:
						case BASE_ITEM_DAGGER:
						case BASE_ITEM_FALCHION:
						case BASE_ITEM_FLAIL:
						case BASE_ITEM_GREATSWORD:
						case BASE_ITEM_HEAVYFLAIL:
						case BASE_ITEM_KUKRI:
						case BASE_ITEM_LONGSWORD:
						case BASE_ITEM_RAPIER:
						case BASE_ITEM_SCIMITAR:
						case BASE_ITEM_SHORTSWORD:
						case BASE_ITEM_SICKLE:
						case BASE_ITEM_TWOBLADEDSWORD:
							bShock = TRUE;
							break;
					}
				} else {
					// Bare-handed
					bShock = TRUE;
				}
			}
			
			if (bShock) {
				effect eVis = EffectVisualEffect(VFX_IMP_LIGHTNING_S);
				effect eDmg = EffectDamage(d6(1), DAMAGE_TYPE_ELECTRICAL, DAMAGE_POWER_NORMAL);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oDamager);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oDamager);
			}
			break;
	}
	
    return;
}