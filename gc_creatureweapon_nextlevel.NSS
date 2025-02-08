#include "ff_safevar"

/*
gc_creatureweapon_nextlevel by Ceremorph for the Sigil: City of Doors PW
*/

int GetNext(object oPC)
{
	object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

	if(GetIsObjectValid(oItem))
    	{
   		int iNext = PS_GetLocalInt(oItem,"NextLevel");
			return iNext;
    	}
	return 0;
}

int StartingConditional(int iRemCheck)
{
   	object oPC = GetPCSpeaker();
   	int iNextLevel = GetNext(oPC);
	int iLevel = GetTotalLevels(oPC,0);
	int iRemaining = iNextLevel - iLevel;

   	if (iRemaining > 99)
		{
		return (100 == iRemCheck);
		}
		
	if (iRemaining <= 5)
		{
		return (iRemaining == iRemCheck);
		}
		
	return (6 == iRemCheck);

}