

//v 1.00

int StartingConditional()
{
    object oPC = GetPCSpeaker();

    if(GetAreaFromLocation(GetLocalLocation(oPC, "DEATH_LOCATION")) != OBJECT_INVALID) return TRUE;

    return FALSE;
}