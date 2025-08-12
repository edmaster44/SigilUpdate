//::///////////////////////////////////////////////
//:: Blade Barrier, Wall
//:: NW_S0_BladeBarWall.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a wall 10m long and 2m thick of whirling
    blades that hack and slice anything moving into
    them.  Anything caught in the blades takes
    2d6 per caster level.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 20, 2001
//:://////////////////////////////////////////////
//:: PKM-OEI 08.10.06 - Adapted to new functionality
//:: PKM-OEI 08.31.06 - Stacking rules

#include "x2_inc_spellhook" 

void main()
{

    if (!X2PreSpellCastCode()) return;


	//We need to make sure that this AOE isn't stackable, because it is super powerful
	//First we need to generate the string that serves as the object ID for this AOE object
	object oCaster = OBJECT_SELF;
	int nId = GetSpellId();
	string sWall = ObjectToString(oCaster) + IntToString(nId);
	//Now we need to see if anything with this tag already exists
	object oWall = GetNearestObjectByTag(sWall);
	//If it exists, kill it.
	if (GetIsObjectValid(oWall))
	{
		DestroyObject(oWall);
	}


    //Declare major variables including Area of Effect Object
	int nCL = PS_GetCasterLevel(oCaster);
	StoreSpellDataForAoE("BladeBarrier", nId, nCL);
    effect eAOE = EffectAreaOfEffect(AOE_PER_WALLBLADE, "", "", "", sWall );
    location lTarget = GetSpellTargetLocation();
    int nDuration = nCL;
    int nMetaMagic = GetMetaMagicFeat();

    //Check Extend metamagic feat.
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;	

    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}