//:://////////////////////////////////////////////////////////////////////////
//:: Warlock Greater Invocation: Chilling Tentacles
//:: nw_s0_chilltent.nss
//:: Created By: Brock Heinz - OEI
//:: Created On: 08/30/05
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
        Chilling Tentacles
        Complete Arcane, pg. 132
        Spell Level:	5
        Class: 		    Misc

        This functions identically to the Evard's black tentacles spell 
        (4th level wizard) except that each creature in the area of effect
        takes an additional 2d6 of cold damage per round regardless 
        if tentacles hit them or not.
	
		Upon entering the mass of "soul-chilling" rubbery tentacles the
		target is struck by 1d4 tentacles.  Each has a chance to hit of 5 + 1d20. 
		If it succeeds then it does 2d6 damage and the target must make
		a Fortitude Save versus paralysis or be paralyzed for 1 round.

*/
//:://////////////////////////////////////////////////////////////////////////


#include "x2_inc_spellhook" 
#include "ps_inc_functions"
#include "ps_inc_areaofeffect"

void main()
{


    if (!X2PreSpellCastCode())
    {
	    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
	
	object oCaster = OBJECT_SELF;
	/*SendMessageToPC(oCaster, "You have "+IntToString(GetAOESInLedger(oCaster))+" AoE's active.");
    if (GetAOESInLedger(oCaster) > 2) {
        SendMessageToPC(oCaster, "You have 3 other AoE's active right now. That is the maximum number.");
        return;
    }*/
	
	if (GetLocalInt(oCaster, "CHILLING_TENTACLES_ACTIVE") > 0) {
		SendMessageToPC(oCaster, "You have cast Chilling Tentacles within the last 60 seconds. Please wait before casting again.");
		return;
	}

	//SpawnScriptDebugger();

    //Declare major variables including Area of Effect Object
    effect      eAOE        = EffectAreaOfEffect(AOE_PER_CHILLING_TENTACLES);
    location    lTarget     = GetSpellTargetLocation();
    int         nDuration   = GetWarlockCasterLevel(OBJECT_SELF);
    int         nMetaMagic  = GetMetaMagicFeat();

    //Make sure duration does no equal 0
    if (nDuration < 1) {
        nDuration = 1;
    }

    //Check Extend metamagic feat.
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
	   nDuration = nDuration * 2;	//Duration is +100%
    }

    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
	
	//Make sure we only have one chiling tentacles active at a time
	SetLocalInt(oCaster, "CHILLING_TENTACLES_ACTIVE", 1);
	DelayCommand(60.0f, DeleteLocalInt(oCaster, "CHILLING_TENTACLES_ACTIVE"));

}