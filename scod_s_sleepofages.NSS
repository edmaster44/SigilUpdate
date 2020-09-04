#include "nw_i0_spells" 
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "nwn2_inc_metmag"
#include "ps_inc_functions"

void DoMagicDamageOnWaking(object oTarget);

void CheckAndDoMagicDamage(object oTarget);

void main() {

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

	//Declare major variables
    location 	lTarget 	= 	GetSpellTargetLocation();
	object 		oCaster 	=	OBJECT_SELF;
    object 		oTarget 	= 	GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE,OBJECT_TYPE_CREATURE);
    effect 		eDur 		= 	EffectNWN2SpecialEffectFile("sp_sleep_hit");
	effect		eSleep		=	EffectSleep();
	effect		eLink		=	EffectLinkEffects(eSleep, eDur);
	float		fDuration	=	RoundsToSeconds(GetWarlockCasterLevel(oCaster));
	
	fDuration		=	ApplyMetamagicDurationMods(fDuration);
	
	effect eFX = EffectNWN2SpecialEffectFile("sp_abjuration_aoe");
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFX, lTarget);

    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
        {
			if (!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS, oCaster)) {
			
            	SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), TRUE));
				eLink = EffectLinkEffects(eLink, EffectOnDispel(0.1f, DoMagicDamageOnWaking(oTarget))); //if dispelled, do magic damage
				if (GetIsPC(oTarget)) {
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
					DelayCommand((fDuration-0.1f), CheckAndDoMagicDamage(oTarget)); //for PCs, just check when the duration runs out
				} else {
					ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget, fDuration);
					SetLocalString(oTarget, "DamagedScript", "scod_s_creature_awaken"); //do the damage when we are woken up
				}
				
			}
        }
		
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}

void DoMagicDamageOnWaking(object oTarget) {
	effect eDamage = EffectDamage(d6(2));
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
	SetLocalString(oTarget, "DamagedScript", "");
}

void CheckAndDoMagicDamage(object oTarget) {

	effect eEffect = GetFirstEffect(OBJECT_SELF);
	while (GetIsEffectValid(eEffect)) {
		if (GetEffectType(eEffect) == EFFECT_TYPE_SLEEP && 
		GetEffectSpellId(eEffect) == SPELL_SLEEP_OF_AGES) {
			RemoveEffect(OBJECT_SELF, eEffect);
			DoMagicDamageOnWaking(oTarget);
			return;
		}
			
		eEffect = GetNextEffect(OBJECT_SELF);
	}

}