//:://///////////////////////////////////////////////
//:: Warlock Lesser Invocation: Charm
//:: nw_s0_icharm.nss
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//::////////////////////////////////////////////////
//:: Created By: Brock Heinz
//:: Created On: 08/12/05
//::////////////////////////////////////////////////
//:: Mimi Fearthegn 8/11/20 - Turned this into Hungry Darkness

#include "NW_I0_SPELLS"    
#include "x2_inc_spellhook" 

void main()
{

    if (!X2PreSpellCastCode())
    {
		// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
	
    //Declare major variables
	object oCaster = OBJECT_SELF;
	int nCasterLevel = GetWarlockCasterLevel(oCaster);
	float fDur = RoundsToSeconds(nCasterLevel);
	
	if (PS_GetLocalInt(oCaster, "HUNGRY_DARKNESS_ACTIVE") > 0) {
		SendMessageToPC(oCaster, "You have cast Hungry Darkness within the last 60 seconds. Please wait before casting again.");
		return;
	}
	
	location lLoc = GetSpellTargetLocation();
    effect eAOE = EffectAreaOfEffect(96); //Hungry Darkness VFX + details, swap out for better darkness vfx later
	
    object oTarget = GetSpellTargetObject();
	if (GetIsObjectValid(oTarget))
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
	
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lLoc, fDur);
	
	//Make sure we only have one hungry darkness active at a time
	PS_SetLocalInt(oCaster, "HUNGRY_DARKNESS_ACTIVE", 1);
	DelayCommand(60.0f, PS_DeleteLocalInt(oCaster, "HUNGRY_DARKNESS_ACTIVE"));

}