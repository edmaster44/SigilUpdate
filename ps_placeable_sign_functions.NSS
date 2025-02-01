#include "ff_safevar"

/**********************************************************
* Function created for SCOD server by Agony_Aunt/Loki_666 *
**********************************************************/

#include "ps_inc_placeable_signs"

void main(int iFunction, int iParam)
{
	object oPC = GetPCSpeaker();
	object oPlaceable = PS_GetLocalObject(oPC, "LASTSIGNTALK");
	
	switch (iFunction)
	{
		case 1:
			DestroyObject(oPlaceable, 0.0);
			break;
		case 2:
			RotatePlaceableSign(oPC, oPlaceable, iParam);
			break;
		case 3:
			NameSpawnableSign(oPC, oPlaceable);
			break;
		case 4:
			MovePlaceableToPlayer(oPC, oPlaceable);
			break;
		case 5:
			MovePlaceableZAxis(oPC, oPlaceable, iParam);
			break;
		case 6:
			DescSpawnableSign(oPC, oPlaceable, iParam);
			break;
		case 7:
			UserPlaceableCleanContainter(oPlaceable);
			break;
		case 8:
			SetDescription(oPlaceable, "");
			break;
	}
}