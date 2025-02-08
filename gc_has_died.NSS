#include "ff_safevar"

//v 1.00

int StartingConditional()
{
    object oPC = GetPCSpeaker();

    if(GetAreaFromLocation(PS_GetLocalLocation(oPC, "DEATH_LOCATION")) != OBJECT_INVALID) return TRUE;

    return FALSE;
}