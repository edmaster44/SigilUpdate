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

#include "x0_i0_spells"
#include "x2_inc_spellhook"

void main(){
	object oCaster = GetAreaOfEffectCreator();
	int bAbyssalDark = FALSE;
	int nRounds = PS_GetCasterLevel(oCaster);
	
	// if this is the tiefling racial variant, then the creator is immune to the blindness
	// and the duration is based on 2x the total character level, not caster level. Note that
	// a tiefling would still be blinded by a different tiefling's darkness. 
	int nRace = GetSubRace(oCaster);
	if (GetSpellId() == SPELL_RACIAL_DARKNESS){
		nRounds = GetTotalLevels(oCaster, TRUE);
		if (nRace == 14 || nRace == 194) bAbyssalDark = TRUE;
	}
	
	// at least 1
	if (nRounds < 1) nRounds = 1;
	int nMetaMagic = GetMetaMagicFeat();
    if (nMetaMagic == METAMAGIC_EXTEND || bAbyssalDark ) nRounds *= 2;
    float fDur = RoundsToSeconds(nRounds);
	int nBonus = 10;
	if (nMetaMagic == METAMAGIC_EMPOWER || bAbyssalDark) nBonus += nBonus / 2;
	
    effect eConceal = EffectConcealment(50, MISS_CHANCE_TYPE_VS_RANGED);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	effect eHide = EffectSkillIncrease(SKILL_HIDE, nBonus);
	eConceal = EffectLinkEffects(eDur, eConceal);
	eConceal = EffectLinkEffects(eHide, eConceal);
	SetEffectSpellId(eConceal, SPELL_DARKNESS); 
	
	effect eHit = EffectVisualEffect(VFX_HIT_SPELL_EVIL);
    effect eBlindness = EffectMissChance(50);
	eBlindness = EffectLinkEffects(EffectSkillDecrease(SKILL_SEARCH, nBonus), eBlindness);
	eBlindness = EffectLinkEffects(EffectSkillDecrease(SKILL_SPOT, nBonus), eBlindness);
	SetEffectSpellId(eBlindness, SPELL_DARKNESS); 

	
    object oTarget = GetEnteringObject();
	int nCreatorRace;
	int bImmuneNeg = FALSE;
	int bDivineLight = TRUE;
	int nLightId = -1;
    if (GetIsObjectValid(oTarget)){
		if ((oTarget == oCaster && bAbyssalDark)|| 
				GetIsImmune(oTarget, IMMUNITY_TYPE_BLINDNESS, oCaster)) 
					bImmuneNeg = TRUE;
	
		effect eLight = GetFirstEffect(oTarget);
		while (GetIsEffectValid(eLight)){
			nLightId = GetEffectSpellId(eLight);
			if (nLightId == SPELL_RACIAL_LIGHT){
				nCreatorRace = GetSubRace(GetEffectCreator(eLight));
				if (nCreatorRace == 203 || nCreatorRace == 13){
					if (bAbyssalDark){
						if (GetHitDice(oCaster) > GetHitDice(GetEffectCreator(eLight))){
							RemoveEffect(oTarget, eLight);
							eLight = GetFirstEffect(oTarget);
						} else {
							bImmuneNeg = TRUE;
							bDivineLight = TRUE;
							eLight = GetNextEffect(oTarget);
						}
					} else {
						bImmuneNeg = TRUE;
						eLight = GetNextEffect(oTarget);
					}
				} else { // racial light but not divine
					if (bAbyssalDark){
						RemoveEffect(oTarget, eLight);
						eLight = GetFirstEffect(oTarget);
					} else {
						bImmuneNeg = TRUE;
						eLight = GetNextEffect(oTarget);
					}
				}	
			} else if (nLightId == SPELL_LIGHT){
				if (bAbyssalDark){
					RemoveEffect(oTarget, eLight);
					eLight = GetFirstEffect(oTarget);
				} else eLight = GetNextEffect(oTarget);
		
			} else eLight = GetNextEffect(oTarget);	
		}	
		// apply the harmless conceal to everyone in the cloud unless they have Aasimar Light
		if (!bDivineLight){
			SignalEvent(oTarget, EventSpellCastAt(oTarget, SPELL_DARKNESS, FALSE));
			PS_RemoveEffects(oTarget, SPELL_LIGHT);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eConceal, oTarget, fDur);

			
			if (!bImmuneNeg){
				SignalEvent(oTarget, EventSpellCastAt(oTarget, SPELL_DARKNESS, FALSE));
				// only turn the target hostile if the target can see the caster. Pretty meta otherwise
				if (GetObjectSeen(oCaster, oTarget) && oCaster != oTarget)
					SignalEvent(oTarget, EventSpellCastAt(oTarget, SPELL_DARKNESS, TRUE));
				else SignalEvent(oTarget, EventSpellCastAt(oTarget, SPELL_DARKNESS, FALSE));
				
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlindness, oTarget, fDur);
			}
		}
    }
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
	SetEffectSpellId(eLink2, SPELL_DARKNESS); 
	
    effect eBlindness = EffectBlindness();
	SetEffectSpellId(eBlindness, SPELL_DARKNESS); 

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