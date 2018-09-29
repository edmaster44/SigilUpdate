/* Feat created by Agony_Aunt/Loki_999 for SCoD PW
Racial feat that sets up undead state */

//#include "nw_i0_spells"
#include "x2_inc_spellhook"
#include "nwn2_inc_spells"

#include "psi_inc_manifest"
#include "psi_inc_metapsi"
#include "psi_inc_fillin"
#include "psi_spellhook"

void main()
{
	//SpeakString("Firing Aura");
    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    object oTarget = GetSpellTargetObject();
	effect eMind = EffectDamageShield(1,DAMAGE_BONUS_1, DAMAGE_TYPE_MAGICAL);
	effect eConcen = EffectSkillDecrease(SKILL_CONCENTRATION, 2);
	effect eLink = EffectLinkEffects(eMind, eConcen);
    if (!GetHasSpellEffect(GetSpellId(), oTarget))
	{
			
			DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget));
			SendMessageToPC(OBJECT_SELF, "Kinetic Defense: Activated");
		
			
	}
	else
	{
		RemoveEffectsFromSpell(oTarget, GetSpellId());
		SendMessageToPC(OBJECT_SELF, "Kinetic Defense: Deactivated");
	}	
}