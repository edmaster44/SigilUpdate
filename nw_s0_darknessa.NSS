//::///////////////////////////////////////////////
//:: Darkness: On Enter
//:: NW_S0_DarknessA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a globe of darkness around those in the area
    of effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 28, 2002
//:://////////////////////////////////////////////
// ChazM 1/18/07 - EvenFlw modifications -  evenflw edited to stop AI lockups
// Nov 21, 2024- FlattedFifth: Darkness changed to be a cloud that can move with a target
// that provides concealment versus ranged and blinds anyone who does not have
// a light spell, true seeing, or immunity to blindness (as granted by blindsight spell and now
// also by aasimar light spell). Also the tiefling version is now a self-only effect and doesn'target
// impose the miss chance on the creator. The tief version the darkness is drawn from within, 
// not cast as a spell, though it can still be dispelled, ofc. In other words, everyone in the cloud will
// now have 50% conceal vs ranged, and those who are not immune become blind, thereby having a 50% miss chance

#include "nw_s0_darkness_inc"

void main(){

	object oCaster = GetAreaOfEffectCreator();
	object oTarget = GetEnteringObject();
	
	int nId = GetSpellId();
	int bAbyssalDark = FALSE;
	int nRace = GetSubRace(oCaster);
	int nRounds = PS_GetCasterLevel(oCaster);
	
	if (nId == SPELL_RACIAL_DARKNESS){
		nRounds = GetTotalLevels(oCaster, TRUE);
		if (nRace == 14 || nRace == 194)
			bAbyssalDark = TRUE;
	
	} else if (nId == SPELLABILITY_AS_DARKNESS){
		nRounds = GetLevelByClass(CLASS_TYPE_ASSASSIN, OBJECT_SELF);
		nRounds += (GetTotalLevels(OBJECT_SELF, TRUE) - nRounds) / 2;
	}
	
    if (nRounds < 5) nRounds = 5;

    if (GetMetaMagicFeat() == METAMAGIC_EXTEND || bAbyssalDark) nRounds *= 2;
	float fDur = RoundsToSeconds(nRounds);


    if (GetIsObjectValid(oTarget))
		ApplyDarkness(oCaster, oTarget, nId, fDur, bAbyssalDark);
}
// previous code
/*
void main()
{

    int nMetaMagic = GetMetaMagicFeat();
    effect eInvis = EffectConcealment(20, MISS_CHANCE_TYPE_NORMAL);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	effect eHit = EffectVisualEffect(VFX_HIT_SPELL_EVIL);

    effect eLink2 =  EffectLinkEffects(eInvis, eDur);
	SetEffectSpellId(eLink2, nId); 
	
    effect eBlindness = EffectBlindness();
	SetEffectSpellId(eBlindness, nId); 

    int nDuration = PS_GetCasterLevel(OBJECT_SELF);
    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND) {
        nDuration = nDuration *2; //Duration is +100%
    }
	
    object oTarget = GetEnteringObject();

    if(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
        }
        else
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
        }
		
        // Creatures immune to the darkness spell are not affected.
		if (GetIsEnemy(oTarget, OBJECT_SELF)) {
	        if ( ResistSpell(OBJECT_SELF,oTarget) != 2 )
	        {
	            //Fire cast spell at event for the specified target
	            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlindness, oTarget, RoundsToSeconds(20));
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
	        }
		} else {
	     	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, RoundsToSeconds(20));
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
		}
    }
}
*/