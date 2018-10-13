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
	int deathlessMasteryId = 2617;
	
    if (!GetHasSpellEffect(deathlessMasteryId, oTarget))
	{
		effect eCritImmune = EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);
		effect eSneakImmune = EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK);
		effect eLink = EffectLinkEffects(eSneakImmune, eCritImmune);
		eLink = SupernaturalEffect(eLink);
		
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
	}
}