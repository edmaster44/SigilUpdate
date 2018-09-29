/* Feat created by Agony_Aunt/Loki_999 for SCoD PW
Racial feat that sets up undead state */

//#include "nw_i0_spells"
#include "x2_inc_spellhook"

void main()
{
	//SpeakString("Firing Aura");
    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    object oTarget = GetSpellTargetObject();
	int nHD = GetHitDice(oTarget);
	
    if (!GetHasSpellEffect(GetSpellId(), oTarget))
	{
		effect eMagicMissile = EffectSpellImmunity(107);
		effect eKineticBlades = EffectSpellImmunity(14332);
		effect eKineticDefense = EffectSpellImmunity(14352);
		effect ePush = EffectSpellImmunity(1392);
		effect eBreath = EffectSpellImmunity(2660);
		//Lvl 4
		effect eConcussionBlast = EffectSpellImmunity(14414);
		effect eInterposingHand = EffectSpellImmunity(459);
		
		//Lvl 8
		effect eTeleMan = EffectSpellImmunity(14519);
		effect eForcefulHand = EffectSpellImmunity(460);
		
		//Lvl 12
		effect eLesserIsaac = EffectSpellImmunity(447);
		effect eGraspingHand = EffectSpellImmunity(461);

		//Lvl 16
		effect eForceBeam = EffectSpellImmunity(14672);
		effect eClenchedFist = EffectSpellImmunity(462);
		
		//Lvl 20
		effect eGreaterIsaac = EffectSpellImmunity(448);
		effect eCrushingHand = EffectSpellImmunity(463);
		

		effect eLink = EffectLinkEffects(eMagicMissile, eKineticBlades);
		eLink = EffectLinkEffects(eKineticDefense, eLink);
		eLink = EffectLinkEffects(ePush, eLink);
		eLink = EffectLinkEffects(eBreath, eLink);
		eLink = EffectLinkEffects(eConcussionBlast, eLink);
		eLink = EffectLinkEffects(eInterposingHand, eLink);
		eLink = EffectLinkEffects(eTeleMan, eLink);
		eLink = EffectLinkEffects(eForcefulHand, eLink);
		eLink = EffectLinkEffects(eLesserIsaac, eLink);
		eLink = EffectLinkEffects(eGraspingHand, eLink);
		eLink = EffectLinkEffects(eForceBeam, eLink);
		eLink = EffectLinkEffects(eClenchedFist, eLink);
		eLink = EffectLinkEffects(eCrushingHand, eLink);
		eLink = EffectLinkEffects(eGreaterIsaac, eLink);
		
	
		
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nHD));
	}	
}