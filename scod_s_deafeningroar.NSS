//::///////////////////////////////////////////////
//:: Deafening Roar - Dragon Magic
//:://////////////////////////////////////////////
/*
// You blast the target with loud and high-pitched
// sounds. 
// The Victim must make a Will save or be deafened for 1d4
// rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Xndar
//:: Created On: July 3rd, 2014
//:://////////////////////////////////////////////
//:: Mimi Fearthegn 7/26/20 - Buffed this spell. . a lot

#include "srcalc"
#include "NW_I0_SPELLS"
#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "nw_i0_invocatns"

void main() {

	/*
	  Spellcast Hook Code
	  Added 2003-07-07 by Georg Zoeller
	  If you want to make changes to all spells,
	  check x2_inc_spellhook.nss to find out more
	
	*/
    if (!X2PreSpellCastCode()) {
    	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

	object oCaster = OBJECT_SELF;
    int nCasterLvl = GetWarlockCasterLevel(oCaster);
	
    int nRounds = (nCasterLvl/2) + 1;
    int nMetaMagic = GetMetaMagicFeat();
	
	location lTargetLocation = GetSpellTargetLocation();
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_SHOUT);
    effect eDeaf = EffectDeaf();
	float fDelay = 0.2f;
	
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 11.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE);
	while(GetIsObjectValid(oTarget)) {
	
	    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	    {
	        if(!DoWarlockMyResistSpell(OBJECT_SELF, oTarget))
	        {
	            //Fire cast spell at event for the specified target
	            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
	            
				//visual effect
	            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				
				int nDamage = GetEldritchBlastDmg(oCaster, oTarget, FALSE, FALSE, TRUE, 1);
				effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_SONIC);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
	
	            if(!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_SONIC)) {
				
					//Standard effect - Deafness
	                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDeaf, oTarget, RoundsToSeconds(nRounds));
					
					//Secondary higher level effect - might knockdown
					if (nCasterLvl > 15) {
						effect eTrip = EffectKnockdown();
		                // * DO a strength check vs. Strength 20
		                if (d20() + GetAbilityScore(oTarget, ABILITY_STRENGTH) <= 20 + d20() ) {
							//Knockdown!
							effect eKnockVis = EffectVisualEffect( VFX_HIT_SPELL_BALAGARN_IRON_HORN );
		                    DelayCommand(0.2f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTrip, oTarget, 6.0));
                    		DelayCommand(0.2f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
		                }
		                else {
							//Failure message
		                    FloatingTextStrRefOnCreature(2750, OBJECT_SELF, FALSE);
						}
					}
					
	            }
	        }
	    }
		
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, 11.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE);
	}
	
	effect eVis2 = EffectVisualEffect(VFX_IMP_SONIC);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis2, OBJECT_SELF, 3.0);
}