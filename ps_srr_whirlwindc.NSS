/* Feat created by Agony_Aunt/Loki_999 for SCoD PW
Racial feat spell that gives djinn whirlwind effect */

//heartbeat script

#include "nw_i0_spells"
#include "x2_inc_spellhook" 
#include "nwn2_inc_metmag"

void main()
{
    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }


	object	oTarget;
	object	oCreator		=	GetAreaOfEffectCreator();
	int		nCasterLevel	=	GetTotalLevels(oCreator, TRUE);
	effect	eVis			=	EffectVisualEffect(VFX_COM_HIT_ELECTRICAL);
	effect 	eKnockdown		=	EffectKnockdown();

	if (!GetIsObjectValid(oCreator))
	{
		DestroyObject(OBJECT_SELF);
	}
	
//Find our first target
	oTarget = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
	
//This loop validates target, makes it save, burns it, then finds the next target and repeats
	while(GetIsObjectValid(oTarget))
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && oTarget != oCreator)
		{
			// strength of whirlwind increases with level of caster
			int iResist = GetAbilityScore(oTarget, ABILITY_STRENGTH) + d20();
			int iPush = nCasterLevel + d20();
			if (iPush > iResist)
			{
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, 6.0);
			}		
			
			if (ReflexSave(oTarget, 10 + nCasterLevel/3, SAVING_THROW_TYPE_ELECTRICITY, GetAreaOfEffectCreator()) == 0)
			{
				int nDice = nCasterLevel/5;
				if (nDice < 1) nDice = 1;
				int nDam = d6(nDice);
				if (GetHasFeat(FEAT_EVASION, oTarget)) nDam = nDam/2;
				if (GetHasFeat(FEAT_IMPROVED_EVASION, oTarget)) nDam = nDam/2;
				
				if (nDam > 0)
				{
					effect eDam = EffectDamage(nDam, DAMAGE_TYPE_ELECTRICAL);
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 3.0);
				}
			}
		}
		
		oTarget = GetNextInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
	}
}
	
	
