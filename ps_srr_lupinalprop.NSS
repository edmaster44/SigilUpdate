/* Feat created by Agony_Aunt/Loki_999 for SCoD PW
Racial feat that sets up undead state */

//#include "nw_i0_spells"
#include "x2_inc_spellhook"

const int FEAT_DR_EVIL5 = 2916;

void main()
{
	//SpeakString("Firing Aura");
    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    object oTarget = GetSpellTargetObject();
	
    if (!GetHasSpellEffect(GetSpellId(), oTarget))
	{
		int iFeat = GetSpellFeatId();
		int iAmount;
		int iType;
		int iSpecific;
		switch(iFeat)
		{
			case FEAT_DR_EVIL5: iAmount=5; iType=DR_TYPE_ALIGNMENT; iSpecific = ALIGNMENT_EVIL; break;
			default: 		SendMessageToPC(GetFirstPC(), "Problem! Feat ID is " + IntToString(iFeat)); break;
		}
	
		effect eRes = EffectDamageReduction(iAmount, iSpecific, 0, iType);
		effect eTrack = EffectSkillIncrease(SKILL_SURVIVAL, 2);
		effect eHide = EffectSkillIncrease(SKILL_HIDE, 2);
		effect eMS = EffectSkillIncrease(SKILL_MOVE_SILENTLY, 2);
		effect eDodge = EffectConcealment(20, MISS_CHANCE_TYPE_VS_RANGED);

		effect eLink = EffectLinkEffects(eTrack, eHide);
		eLink = EffectLinkEffects(eMS, eLink);
		eLink = EffectLinkEffects(eDodge, eLink);
		eLink = EffectLinkEffects(eRes, eLink);
		
		
	
		
		eLink = SupernaturalEffect(eLink);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
	}	
}