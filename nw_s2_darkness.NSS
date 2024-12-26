//::///////////////////////////////////////////////
//:: Darkness
//:: NW_S2_Darkness.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a globe of darkness around those in the area
    of effect.
*/

// JLR-OEI 03/16/06: For GDD Update
// Nov 21, 2024 - FlattedFifth: Made able to target a creature and move with them and 
// changed duration to 5 rounds + 1 round / level max 30 rounds


#include "NW_I0_SPELLS"
#include "x2_inc_spellhook" 
void main()
{
	if (!X2PreSpellCastCode()) return;

    effect eAOE = EffectAreaOfEffect(AOE_PER_DARKNESS);
	eAOE = SetEffectSpellId(eAOE, SPELL_DARKNESS);
	object oCaster = OBJECT_SELF;
	int nId = GetSpellId();
	object oTarget = GetSpellTargetObject();
	int nTargetType = GetObjectType(oTarget);
	int nRounds = PS_GetCasterLevel(oCaster);
	// racial ability CL is character lvl and duration is double.
	if (nId == 941 && GetSubRace(oCaster) == 14) nRounds = GetTotalLevels(oCaster, TRUE); // tief racial = 941
	// caster lvl for assassin feat/spells is assassin lvl + 1/2 of non-assassin lvls
	else if (GetSpellFeatId() == 469){
		nRounds = GetLevelByClass(CLASS_TYPE_ASSASSIN, OBJECT_SELF);
		nRounds += (GetTotalLevels(OBJECT_SELF, TRUE) - nRounds) / 2;
	}
   
    if (nRounds < 5) nRounds = 5;

    if (GetMetaMagicFeat() == METAMAGIC_EXTEND) nRounds *= 2;
	float fDur = RoundsToSeconds(nRounds);
    
	if (nTargetType == OBJECT_TYPE_CREATURE || nTargetType == OBJECT_TYPE_DOOR ||
		nTargetType == OBJECT_TYPE_PLACEABLE || nTargetType == OBJECT_TYPE_ITEM){
		SignalEvent(oTarget, EventSpellCastAt(oTarget, SPELL_DARKNESS));
		PS_RemoveEffects(oTarget, SPELL_DARKNESS);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, fDur);
	} else {
		ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, GetSpellTargetLocation(), fDur);
	}   
}

// original Code
/*


#include "NW_I0_SPELLS"
#include "x2_inc_spellhook" 
void main()
{



    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook



    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_DARKNESS);
    location lTarget = GetSpellTargetLocation();
    int nRounds = GetTotalLevels(OBJECT_SELF, 1); //PS_GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    //Make sure duration does no equal 0
    if (nRounds < 1)
    {
        nRounds = 1;
    }
    //Check Extend metamagic feat.
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
	   nRounds = nRounds *2;	//Duration is +100%
    }
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nRounds));
}
*/