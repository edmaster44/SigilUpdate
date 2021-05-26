#include "nw_i0_spells" 
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "nwn2_inc_metmag"
#include "ps_inc_functions"
#include "srcalc"

void DoMagicDamageOnWaking(object oTarget, int nAwake = 2);

void CheckAndDoMagicDamage(object oTarget, int nAwake = 2);

void main() {

    if (!X2PreSpellCastCode()) {
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
	int	 		nAwakeDice 	= 	2;
	int 		nDC			= 	GetSpellSaveDC();
	
	fDuration		=	ApplyMetamagicDurationMods(fDuration);
	
	effect eFX = EffectNWN2SpecialEffectFile("sp_abjuration_aoe");
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFX, lTarget);
	
	if (GetHasFeat(FEAT_HEXEN_CURSEMASTER, oCaster)) {	
		nAwakeDice = 6;
		nDC += 4;
	} else if (GetHasFeat(FEAT_HEXEN_HEXER_3, oCaster)) {
		nAwakeDice = 5;
		nDC += 3;
	} else if (GetHasFeat(FEAT_HEXEN_HEXER_2, oCaster)) {
		nAwakeDice = 4;
		nDC += 2;
	} else if (GetHasFeat(FEAT_HEXEN_HEXER_1, oCaster)) {
		nAwakeDice = 3;
		nDC += 1;
	}

    while (GetIsObjectValid(oTarget)) {
	
		if (GetHasFeat(FEAT_HEXEN_CURSEMASTER, oCaster) || !DoWarlockMyResistSpell(oCaster, oTarget)) {	
		
			if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS, oCaster)) {
				
	            SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), TRUE));
				eLink = EffectLinkEffects(eLink, EffectOnDispel(0.1f, DoMagicDamageOnWaking(oTarget))); //if dispelled, do magic damage
				if (GetIsPC(oTarget)) {
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
					DelayCommand((fDuration-0.1f), CheckAndDoMagicDamage(oTarget, nAwakeDice)); //for PCs, just check when the duration runs out
				} else {
					ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
					SetLocalInt(OBJECT_SELF, "AWAKEN_DICE", nAwakeDice);
					SetLocalString(oTarget, "DamagedScript", "scod_s_creature_awaken"); //do the damage when we are woken up
				}
					
			} else if (GetHasFeat(FEAT_HEXEN_HEXER_1, oCaster) || GetHasFeat(FEAT_HEXEN_HEXER_2, oCaster) || GetHasFeat(FEAT_HEXEN_HEXER_3, oCaster)) {
			
				DoMagicDamageOnWaking(oTarget, nAwakeDice);
				
				//Dread Seizure effects
				if (GetHasFeat(FEAT_HEXEN_PAINFUL_SLEEP, oCaster)) {
				
					int nMod = 3;
					int nMissChance = 5;
					
					if (GetHasFeat(FEAT_HEXEN_CURSEMASTER, oCaster)) {		
						nMissChance = 20;
						nMod = 5;
					} else if (GetHasFeat(FEAT_HEXEN_HEXER_3, oCaster)) {		
						nMissChance = 15;
						nMod = 5;
					} else if (GetHasFeat(FEAT_HEXEN_HEXER_2, oCaster)) {
						nMissChance = 10;
						nMod = 4;
					} else if (GetHasFeat(FEAT_HEXEN_HEXER_1, oCaster)) {
						nMissChance = 5;
					}
					
					effect eAttackPenalty =	EffectAttackDecrease(nMod);
					effect eMovePenalty	= EffectMovementSpeedDecrease(nMod*10);
					effect eLink = EffectLinkEffects(eAttackPenalty, eMovePenalty);
					
					effect eMissChance = EffectMissChance(nMissChance);
					eLink = EffectLinkEffects(eMissChance, eLink);
					
					if (GetIsPC(oTarget)) {
						if (!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC)) {
				    		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
						}
					}
					else { // No save for monsters.
				        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
					}
				
				}
			
	        }
			
		}
		
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}

void DoMagicDamageOnWaking(object oTarget, int nAwake = 2) {
	effect eDamage = EffectDamage(d6(nAwake));
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
	SetLocalString(oTarget, "DamagedScript", "");
}

void CheckAndDoMagicDamage(object oTarget, int nAwake = 2) {

	effect eEffect = GetFirstEffect(OBJECT_SELF);
	while (GetIsEffectValid(eEffect)) {
		if (GetEffectType(eEffect) == EFFECT_TYPE_SLEEP && 
		GetEffectSpellId(eEffect) == SPELL_SLEEP_OF_AGES) {
			RemoveEffect(OBJECT_SELF, eEffect);
			DoMagicDamageOnWaking(oTarget, nAwake);
			return;
		}
			
		eEffect = GetNextEffect(OBJECT_SELF);
	}

}