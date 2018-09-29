//::///////////////////////////////////////////////
//:: Silence: Heartbeat
//:: NW_S0_SilenceC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The target is surrounded by a zone of silence
    that allows them to move without sound.  Spell
    casters caught in this area will be unable to cast
    spells.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
#include "ps_inc_onhit" 

void main()
{

    //Declare major variables
	object oCaster = GetOnHitAbilityCaster(GetAreaOfEffectCreator());
    if(GetIsDead(oCaster) || !GetIsObjectValid(oCaster))
    {
        DestroyObject(OBJECT_SELF, 0.0);
    }
}