//::///////////////////////////////////////////////
//:: Warding of the Spirits
//:: nx_s2_wardspirits.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
    A spirit shaman can perform a special rite
    once per day to ward herself and her companions
    against hostile spirits.  The warding lasts for
    10 minutes per level and grants a +2 deflection
    bonus to AC and a +2 resistance bonus on saves
    against attacks made by spirits to all party
    members.  This effect does not stack with the
    shaman's Blessing of the Spirits.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 03/15/2007
//:://////////////////////////////////////////////

#include "nwn2_inc_spells"
#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode()) return;
    
    //Declare major variables
	int nId = GetSpellId();
	int nBless = 1096; // blessing of the spirits
    int bPCOnly     = FALSE;
    int nShamanLvl  = GetLevelByClass(CLASS_TYPE_SPIRIT_SHAMAN, OBJECT_SELF);
    float fDuration = TurnsToSeconds(10*nShamanLvl);    // 10 minutes per shaman level
    object oLeader  = GetFactionLeader(OBJECT_SELF);
	
	effect eAC = EffectACIncrease(2, AC_DODGE_BONUS, AC_VS_DAMAGE_TYPE_ALL);
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL);
    eAC = EffectLinkEffects(eSave, eAC);
	eAC = SetEffectSpellId(eAC, nId);
	
    object oTarget  = GetFirstFactionMember(oLeader, bPCOnly);
    while (GetIsObjectValid(oTarget)){
        // Does not stack with itself or with Blessing of the Spirits, skips those with Blessing,
		// removes previous applications of itself
        if (!GetHasSpellEffect(nBless, oTarget){
			PS_RemoveEffects(oTarget, nId);
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nId, FALSE));
        
            //Apply the VFX impact and effects
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
        }
        
        oTarget = GetNextFactionMember(oLeader, bPCOnly);
    }
}