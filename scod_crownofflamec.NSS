//::///////////////////////////////////////////////

// FlattedFifth - June 17, 2024. Reworked logic to have no affect on allies, changed damage 
//			to do 1d8 vs good, 2d8 vs neutral, and 3d8 vs evil with an additional 1d8 vs
//			enemy outsiders, undead, and fey
// FlattedFifth - June 26, 2024. Updated to use spellIsTarget() function in nw_io_spells. That's
// 		 	a more thorough check than just GetReactionTypeHostile().

#include "NW_I0_SPELLS"
#include "aaa_constants"


void main()
{
	object oTarget;
	object oCaster		= GetAreaOfEffectCreator();
	effect eImpact		= EffectVisualEffect(VFX_HIT_SPELL_FIRE);
	eImpact				= EffectLinkEffects(eImpact, EffectVisualEffect(VFX_HIT_SPELL_HOLY));
	effect eBlind 		= EffectBlindness();
	effect eDam;
	effect eLink;
	
	// Not really sure why this is here, a fix for some kind of bug I don't know about?
	// Or removes the effect if the caster dies? Not sure.  Leaving it in just in case. 
	// -FlattedFifth, June 17 2024
	if (!GetIsObjectValid(oCaster))
    {	DestroyObject(OBJECT_SELF);
        return;		}
	
	// Get the first target in the AoE
	oTarget = GetFirstInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {	
		// Only process anything at all if the target is hostile
		if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster))
		{
			int nNumDice = 1;
			int bIsBlinded = FALSE;
			int nRace = GetRacialType(oTarget);
			if (GetAlignmentGoodEvil(oTarget) == ALIGNMENT_NEUTRAL)
			{
				nNumDice += 1;
				bIsBlinded = TRUE;
			}
			else if (GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
			{
				nNumDice += 2;
				bIsBlinded = TRUE;
			}
			if (nRace == RACIAL_TYPE_OUTSIDER || nRace == RACIAL_TYPE_UNDEAD || nRace == RACIAL_TYPE_FEY)
			{
				nNumDice += 1;
			}
			
			eDam = EffectDamage(d8(nNumDice), DAMAGE_TYPE_DIVINE, DAMAGE_POWER_NORMAL, TRUE);
			eLink = EffectLinkEffects(eImpact, eDam);
			if (bIsBlinded) eLink = EffectLinkEffects(eLink, eBlind);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);		
		}
		// get the next target in the AoE
        oTarget = GetNextInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE);
	}
}