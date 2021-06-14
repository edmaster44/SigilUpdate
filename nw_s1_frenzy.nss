//::///////////////////////////////////////////////
//:: Frenzy
//:: NW_S1_Frenzy
//:://////////////////////////////////////////////
/*
    Similar to Barbarian Rage
    Gives +6 Str, -4 AC, extra attack at highest
    Base Attack Bonus (BAB), doesn't stack with Haste/etc.,
    receives 2 points of non-lethal dmg a round.
    Lasts 3+ Con Mod rounds.
    Greater Frenzy starts at level 8.
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: July 22, 2005
//:://////////////////////////////////////////////
//:: AFW-OEI 08/07/2006: Now inflicts 12 points of
//::	damage per round.
//:: AFW-OEI 10/30/2006: Changed to 6 pts./rnd.

#include "x2_i0_spells"
#include "nwn2_inc_spells"

void main()
{
    if(!GetHasFeatEffect(FEAT_FRENZY_1))
    {
        //Declare major variables
        int nLevel = GetLevelByClass(CLASS_TYPE_FRENZIEDBERSERKER) ;
        int nIncrease;
        int nSave;

       nIncrease = 6 + (nLevel / 2);

        PlayVoiceChat(VOICE_CHAT_BATTLECRY1);
        //Determine the duration by getting the con modifier after being modified
        int nCon = 3 + GetAbilityModifier(ABILITY_CONSTITUTION);

		// JLR - OEI 06/03/05 NWN2 3.5
        if (GetHasFeat(FEAT_EXTEND_RAGE))
        {
            nCon += 5;
        }
	

        effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, nIncrease);
        effect eDur = EffectVisualEffect( VFX_DUR_SPELL_RAGE );
        effect eAttackMod = EffectModifyAttacks(1);
		effect eHaste = EffectHaste();
		effect eCritImm = EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);
		effect eMove = EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE);
        effect eLink = EffectLinkEffects(eStr, eDur);
       	eLink = EffectLinkEffects(eLink, eAttackMod);
		
			if (GetLevelByClass(CLASS_TYPE_FRENZIEDBERSERKER) > 7)
			{
				eLink = EffectLinkEffects(eLink, eHaste);
			}
			
 ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eMove, OBJECT_SELF, RoundsToSeconds(nCon + 1));
 eMove = ExtraordinaryEffect(eMove);
			
        SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
        //Make effect extraordinary
        eLink = ExtraordinaryEffect(eLink);

        if (nCon > 0)
        {
			float fDuration = RoundsToSeconds(nCon);
			fDuration		=	fDuration + 2.0;
		
            //Apply the VFX impact and effects
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, fDuration);
			
			if (GetLevelByClass(CLASS_TYPE_FRENZIEDBERSERKER) >= 6) {
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCritImm, OBJECT_SELF, RoundsToSeconds(4));
  eCritImm = ExtraordinaryEffect(eCritImm);
}
			
			if (GetHasFeat(FEAT_DEATHLESS_FRENZY) && !GetIsImmune(OBJECT_SELF, IMMUNITY_TYPE_DEATH)) //Deathless frenzy check
			{
				effect eDeath = EffectImmunity(IMMUNITY_TYPE_DEATH);
				effect eNeg = EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE, 100);
    			effect eLevel = EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL);
    			effect eAbil = EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE);
				
				effect eDeathless = EffectLinkEffects(eDeath, eDur);
			 	eDeathless = EffectLinkEffects(eDeathless, eNeg);
    			eDeathless = EffectLinkEffects(eDeathless, eLevel);
    			eDeathless = EffectLinkEffects(eDeathless, eAbil);
				
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDeathless, OBJECT_SELF, fDuration);
			}
			
			// Start the fatigue logic half a second before the frenzy ends
			if (GetLevelByClass(CLASS_TYPE_FRENZIEDBERSERKER) <= 7)
			{	DelayCommand(fDuration - 0.5f, ApplyFatigue(OBJECT_SELF, 5, 0.6f));	// Fatigue duration fixed to 5 rounds
			}
			        }
    }
}