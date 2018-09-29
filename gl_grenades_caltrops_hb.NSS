/*
	On heartbeat script for caltrops bomb AoE.
	Slow effect plus possible damage on all objects inside it.
*/

#include "gl_grenades_inc"
#include "x2_I0_SPELLS"
#include "NW_I0_SPELLS"

void main()
{
	object oTarget;
    //Start cycling through the AOE Object for viable targets including doors and placable objects.
    oTarget = GetFirstInPersistentObject(OBJECT_SELF);
    while(GetIsObjectValid(oTarget))
    {
     	DoCaltropsEffects(oTarget);
        //Get next target.
    	oTarget = GetNextInPersistentObject(OBJECT_SELF);
    }
}