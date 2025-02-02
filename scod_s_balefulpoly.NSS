//:://////////////////////////////////////////////
/*
   Baleful Polymorph - Warlock Spell
   scod_s_balefulpoly.NSS
*/
//:://////////////////////////////////////////////
//:: Created By: Mimi Fearthegn
//:: Created On: Februrary 2nd, 2015
//:://////////////////////////////////////////////
/*
rapsam2003 03/26/2018: Remove save against NPCs and
	Hexer feats decrease the BAB of the target.
*/

#include "x0_I0_SPELLS"    
#include "x2_inc_spellhook" 
#include "srcalc"
#include "ps_inc_onhit"
 
void main() {

    if (!X2PreSpellCastCode()) {
		// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    //Declare major variables
    int nSpell = GetSpellId();
	
	// constrain to allowed values
	if(nSpell<1680 || nSpell>1685)
		nSpell=1680 + Random(5); // set default as random (instead of cow)
	
	object 		oCaster 	= 	OBJECT_SELF;
    object 		oTarget 	= 	GetSpellTargetObject();
    effect 		eVis 		= 	EffectVisualEffect( VFX_DUR_POLYMORPH );
    int 		nPoly 		= 	POLYMORPH_TYPE_CHICKEN;
    int 		nMetaMagic 	= 	GetMetaMagicFeat();
	effect 		eConfuse 	= 	EffectConfused();
	int 		nDC			= 	GetSpellSaveDC();
		
    int nDuration = PS_GetCasterLevel(oCaster);
	
	if (GetHasFeat(FEAT_HEXEN_BALEFUL_POLYMORPH, oCaster)) {
		nDuration = nDuration *2;
	}
	
    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND) {
        nDuration = nDuration *2; //Duration is +100%
    }
	
	if (GetHasFeat(FEAT_HEXEN_CURSEMASTER, oCaster)) {
		nDC += 4;
	} else if (GetHasFeat(FEAT_HEXEN_HEXER_3, oCaster)) {
		nDC += 3;
	} else if (GetHasFeat(FEAT_HEXEN_HEXER_2, oCaster)) {
		nDC += 2;
	} else if (GetHasFeat(FEAT_HEXEN_HEXER_1, oCaster)) {
		nDC += 1;
	}

    //Determine Polymorph subradial type
    if(nSpell == 1681) {
        nPoly = 168; //Pig
    } else if (nSpell == 1682) {
        nPoly = 40; //Chicken
    } else if (nSpell == 1683) {
        nPoly = 177; //Weasel
    } else if (nSpell == 1684) {
        nPoly = 403; //Rabbit
    } else if (nSpell == 1685) {
        nPoly = 171; //Bat
    }
	
	effect ePoly = EffectPolymorph(nPoly, TRUE);
		
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 1680, TRUE));

    //Apply the VFX impact and effects
    AssignCommand(oTarget, ClearAllActions()); // Prevents an exploit
	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
        // Make SR Check
        if (GetHasFeat(FEAT_HEXEN_CURSEMASTER, OBJECT_SELF) || !DoWarlockMyResistSpell(OBJECT_SELF, oTarget))
        {
		 	// Make a Fort Save
            if (!GetIsPC(oTarget) && !MySavingThrow(SAVING_THROW_FORT, oTarget, nDC)) {
			
    			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, oTarget, TurnsToSeconds(nDuration));
				
				if (GetHasFeat(FEAT_HEXEN_BALEFUL_POLYMORPH, oCaster)) {
					ChangeToStandardFaction(oTarget, STANDARD_FACTION_DEFENDER);
					SetLocalObject(oTarget, abilityCaster, oCaster);
					SetLocalObject(oTarget, "FOLLOW_MASTER", oCaster);
					SetLocalInt(oTarget, "IS_SUMMONED", 1);
				} else {
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eConfuse, oTarget, TurnsToSeconds(nDuration));
				}
				
				if (GetHasFeat(FEAT_HEXEN_CURSEMASTER, oCaster)) {
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectHaste(), oTarget, TurnsToSeconds(nDuration));
				}
				
				if (GetHasFeat(FEAT_HEXEN_HEXER_3, oCaster)) {
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityIncrease(ABILITY_DEXTERITY, 6), oTarget, TurnsToSeconds(nDuration));
				} else if (GetHasFeat(FEAT_HEXEN_HEXER_2, oCaster)) {
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityIncrease(ABILITY_DEXTERITY, 4), oTarget, TurnsToSeconds(nDuration));
				} else if (GetHasFeat(FEAT_HEXEN_HEXER_1, oCaster)) {
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityIncrease(ABILITY_DEXTERITY, 2), oTarget, TurnsToSeconds(nDuration));
				}
				
			}
		}
	}
}