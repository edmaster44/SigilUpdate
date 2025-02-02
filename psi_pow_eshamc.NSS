/*
   ----------------
   Ectoplasmic Shambler, Heartbeat

   psi_pow_eshamc
   ----------------

   23/2/04 by Stratovarius
*/ /** @file

    Ectoplasmic Shambler, OnHeartbeat

    Metacreativity (Creation)
    Level: Psion/wilder 5
    Manifesting Time: 1 round
    Range: Long (400 ft. + 40 ft./level)
    Effect: One ectoplasmic manifestation of 10m radius
    Duration: 1 min./level
    Saving Throw: None
    Power Resistance: No
    Power Points: 9
    Metapsionics: Extend, Twin, Widen

    You fashion an ephemeral mass of pseudo-living ectoplasm called an
    ectoplasmic shambler. As the consistency of the ectoplasmic shambler is
    that of thick mist, those within the shambler are blinded. In addition,
    manifesting powers (or casting spells) within the shambler is difficult
    due to the constant turbulence felt by those caught in the shambler�s form.

    Creatures enveloped by the shambler, regardless of Armor Class, take 1 point
    of damage for every two manifester levels you have in each round they become
    or remain within the roiling turbulence of the shambler. Anyone trying to
    manifest a power must make a Concentration check (DC 15 + power�s or spell�s
    level) to successfully manifest a power or cast a spell inside the shambler.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
//#include "spinc_common"

void main()
{
    object oAoE     = OBJECT_SELF;
    object oCreator = GetAreaOfEffectCreator();
    int nDamage     = GetLocalInt(oAoE, "PRC_EctoShambler_Damage");
    effect eDamage  =                            EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
           eDamage  = EffectLinkEffects(eDamage, EffectVisualEffect(VFX_IMP_HEAD_MIND));

    // Loop over creatures inside the AoE
    object oTarget = GetFirstInPersistentObject(oAoE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {

				//If The Targets are Friendly, it will not do nothing
		if (GetIsReactionTypeFriendly(oTarget,oCreator))
			{
				return;
				}
    	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
    	{
			// Let the AI know
        	//SPRaiseSpellCastAt(oTarget, TRUE, POWER_ECTOSHAMBLER, oCreator);
        	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
        }

        //Select the next target within the spell shape.
        oTarget = GetNextInPersistentObject(oAoE, OBJECT_TYPE_CREATURE);
    }
}