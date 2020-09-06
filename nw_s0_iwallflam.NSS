//:://////////////////////////////////////////////////////////////////////////
//:: Warlock Greater Invocation: 
//:: nw_s0_iwallflam.nss
//:: Created By: Brock Heinz - OEI
//:: Created On: 08/30/05
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
        Wall of Perilous Flame
        Complete Arcane, pg. 136
        Spell Level:	5
        Class: 		    Misc

        The warlock can conjure a wall of fire (4th level wizard spell). 
        It behaves identically to the wizard spell, except half of the damage 
        is considered magical energy and fire resistance won't affect it.

*/
//:://////////////////////////////////////////////////////////////////////////

#include "x2_inc_spellhook" 
#include "ps_inc_functions"

void main()
{

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
	
	object oCaster = OBJECT_SELF;
	if (GetLocalInt(oCaster, "PERILOUS_FLAME_ACTIVE") > 0) {
		SendMessageToPC(oCaster, "You have cast Wall of Perilous Flame within the last 60 seconds. Please wait before casting again.");
		return;
	}
	
	int nCasterLevel = GetWarlockCasterLevel(oCaster);

    //Declare Area of Effect object using the appropriate constant
	effect eAOE = EffectLinkEffects(EffectAreaOfEffect(AOE_PER_WALL_PERILOUS_FLAME), EffectNWN2SpecialEffectFile("SP_PERIL_FLAME_LIGHT"));
    //Get the location where the wall is to be placed.
    location lTarget = GetSpellTargetLocation();
    int nDuration = nCasterLevel;
	
	//Check fort metamagic
	if (GetMetaMagicFeat() == METAMAGIC_EXTEND)
	{
		nDuration = nDuration *2;	//Duration is +100%
	}

    //Create the Area of Effect Object declared above.
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
	
	//Make sure we only have one hungry darkness active at a time
	SetLocalInt(oCaster, "PERILOUS_FLAME_ACTIVE", 1);
	DelayCommand(60.0f, DeleteLocalInt(oCaster, "PERILOUS_FLAME_ACTIVE"));
}