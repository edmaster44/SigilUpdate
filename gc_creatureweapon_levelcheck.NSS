#include "ff_safevar"

/*
gc_creatureweapon_levelcheck by Ceremorph for the Sigil: City of Doors PW


*/
int StartingConditional()
{
   object oPC = GetPCSpeaker();
   object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
   int iLevels = GetTotalLevels(oPC,TRUE);
   int iNext = PS_GetLocalInt(oItem,"NextLevel");

   	if (iLevels >= iNext)

   {
		return TRUE;
   }

    return FALSE;

}