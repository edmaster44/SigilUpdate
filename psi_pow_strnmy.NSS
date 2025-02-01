/*
   ----------------
   Strength of my Enemy

   psi_pow_strnmy
   ----------------

   14/12/05 by Stratovarius
*/ /** @file

    Strength of My Enemy

    Psychometabolism
    Level: Psychic warrior 2
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 round/level
    Power Points: 3
    Metapsionics: Extend

    You gain the ability to siphon away your enemy’s strength for your own use.
    One of your natural or manufactured weapons becomes the instrument of your
    desire, and deals 1 point of Strength damage on each successful hit. You
    gain that point of Strength as an enhancement bonus to your Strength score.
    Strength you siphon from different foes is tracked separately - the total
    siphoned from each individual foe is considered a separate enhancement bonus
    to your Strength (maximum +6), and you gain only the highest total.

    Augment: For every 3 additional power points you spend, the maximum
             enhancement bonus you can add to your Strength increases by 2.
*/


    // Determine whether this script call is about manifesting the power or an OnHit
#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
//#include "prc_sp_func"
int DoPower(object oManifester, object oTarget, struct manifestation manif)
{
    int nPen = GetPsiPenetration(oManifester);
    int nDamage, nTouchAttack;
    int bHit = 0;
	int nStr = 6;
	if (manif.bAugment)
	nStr = 8;
    effect eVis  = EffectVisualEffect(VFX_COM_HIT_NEGATIVE);
    effect eLink =                          EffectAbilityIncrease(ABILITY_STRENGTH,     nStr);
           eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MAJOR));

    //SPRaiseSpellCastAt(oTarget, TRUE, manif.nSpellID, oManifester);

    int nRepeats = manif.bTwin ? 2 : 1;
    for(; nRepeats > 0; nRepeats--)
    {
        nTouchAttack = TouchAttackMelee(oTarget);
        if(nTouchAttack > 0)
        {
            bHit = 1;
            if(PRCMyResistPower(oManifester, oTarget, nPen) == POWER_RESIST_FAIL)
            {
                // Determine damage
                int nNumberOfDice = 20;
                int nDieSize      = 6;
                int nDamage       = d6(nNumberOfDice);
                // Fort save for half
                if(MySavingThrow(SAVING_THROW_FORT, oTarget, GetManifesterDC(oManifester), SAVING_THROW_TYPE_NONE))
                {
                    nDamage /= 2;
				//if (GetHasMettle(oTarget, SAVING_THROW_FORT))
				// This script does nothing if it has Mettle, bail
				//	nDamage = 0;                       
				}
                nDamage = GetTargetSpecificChangesToDamage(oTarget, manif.oManifester, nDamage);
                // Apply damage and the accompanying VFX
                //ApplyTouchAttackDamage(manif.oManifester, oTarget, nTouchAttack, nDamage, DAMAGE_TYPE_MAGICAL);
				
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                // Give the temp HP, and if the target was dead, the stat boosts
                effect eTempHP;
                if(GetIsDead(oTarget))
                {
                    eTempHP = EffectTemporaryHitpoints(nDamage);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, manif.oManifester, HoursToSeconds(1));
                }
                else
                    eTempHP = EffectTemporaryHitpoints(nDamage / 2);

                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTempHP, manif.oManifester, HoursToSeconds(1));
            }
        }
    }

    return bHit;    //Held charge is used if at least 1 touch from twinned power hits
}

void main()
{
    if (!PsiPrePowerCastCode())
    {
    // If code within the PrePowerCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook
	
    object oManifester = OBJECT_SELF;
    object oTarget     = GetSpellTargetObject();
	int nPP = PS_GetLocalInt(oManifester, "PSI_PP");
	int nPPt = PS_GetLocalInt(oTarget, "PSI_PP");
	effect eVis  = EffectVisualEffect(VFX_COM_HIT_NEGATIVE);
    struct manifestation manif =
        EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE | METAPSIONIC_TWIN
                              );
	if(manif.bCanManifest)
    {						  
		int nPen = GetPsiPenetration(oManifester);
	    int nDamage, nTouchAttack;
		int nPPAbsorb = nPPt;
		int nPPFinal = nPP + nPPAbsorb;
			int nStr = 6;
	if (manif.bAugment)
	nStr = 8;
	    int bHit = 0;
	if (manif.bAugment)
	       effect eVis  = EffectVisualEffect(VFX_COM_HIT_NEGATIVE);
    effect eLink =                          EffectAbilityIncrease(ABILITY_STRENGTH,     nStr);
           eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MAJOR));
	
	    int nRepeats = manif.bTwin ? 2 : 1;
	    for(; nRepeats > 0; nRepeats--)
	    {
	        nTouchAttack = TouchAttackMelee(oTarget);
	        if(nTouchAttack > 0)
	        {
	            bHit = 1;
	            if(PRCMyResistPower(oManifester, oTarget, nPen) == POWER_RESIST_FAIL)
	            {
	                // Determine damage
	                float nDamage       = IntToFloat(d6(20));
					if (manif.bEmpower)
						nDamage *= 1.5f;
					else if (manif.bMaximize)
						nDamage = 20.0f*6.0f;
						
	                // Fort save for half
	                if(MySavingThrow(SAVING_THROW_FORT, oTarget, GetManifesterDC(oManifester), SAVING_THROW_TYPE_NONE))
	                {
	                    nDamage /= 2;                      
					}
					
					if(GetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT || GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
					{
						nDamage = 0.0f;
						SendMessageToPC(oManifester, "You can only Sap the Strength of Living Creatures!");
						return;
					}
					
	                effect eDamage = EffectDamage(FloatToInt(nDamage));
					
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
	                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
					
	                // Give the temp HP, and if the target was dead, the stat boosts
	                effect eTempHP;
	                if(GetIsDead(oTarget))
	                {
						eTempHP = EffectHeal(FloatToInt(nDamage));
	                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, manif.oManifester, HoursToSeconds(1));
	                }
	                else
	                    eTempHP = EffectHeal(FloatToInt(nDamage) / 2);
						
					if (!GetHasSpellEffect(GetSpellId(), manif.oManifester))
					{
						ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTempHP, manif.oManifester, HoursToSeconds(1));
					}
	            }
	        }
	    }
	}
}