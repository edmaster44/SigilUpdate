//::///////////////////////////////////////////////
//:: Find Traps
//:: NW_S0_FindTrap
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Finds and removes all traps within 30m.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 29, 2001
//:://////////////////////////////////////////////

// JLR - OEI 08/24/05 -- Metamagic changes
#include "nwn2_inc_spells"


#include "x2_inc_spellhook" 

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook
	int nDuration = 2 + PS_GetCasterLevel(OBJECT_SELF); 
	int nBonus = 10;
	
	int nMeta = GetMetaMagicFeat();
	if (nMeta == METAMAGIC_EMPOWER) nBonus += nBonus / 2;
	if (nMeta == METAMAGIC_EXTEND) nDuration *= 2;
	
	effect eSearch = EffectSkillIncrease(SKILL_SEARCH, nBonus);
	eSearch = SetEffectSpellId(eSearch, SPELL_FIND_TRAPS);
	SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELL_FIND_TRAPS, FALSE));
	PS_RemoveEffects(OBJECT_SELF, SPELL_FIND_TRAPS);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSearch, OBJECT_SELF, TurnsToSeconds(nDuration)); 
	
    //effect eVis = EffectVisualEffect(VFX_IMP_KNOCK);	// NWN1 VFX
    effect eVis = EffectVisualEffect( VFX_DUR_SPELL_FIND_TRAPS );	// NWN2 VFX
    int nCnt = 1;
    object oTrap = GetNearestObject(OBJECT_TYPE_TRIGGER | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, OBJECT_SELF, nCnt);
    while(GetIsObjectValid(oTrap) && (GetDistanceToObject(oTrap) <= 30.0) && GetTrapDetectable(oTrap) )	// 8/1/06 - BDF: added GetTrapDetectable check
    {
        if(GetIsTrapped(oTrap))
        {
            SetTrapDetectedBy(oTrap, OBJECT_SELF);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTrap));	// DURATION_TYPE_INSTANT will cause only the impact SEF to play, which is OK in this case
            //DelayCommand(2.0, SetTrapDisabled(oTrap));
        }
        nCnt++;
        oTrap = GetNearestObject(OBJECT_TYPE_TRIGGER | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, OBJECT_SELF, nCnt);
    }
}