// Mechanus Cannon feat spell for Modrons for SCoD PW by Agony_Aunt

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 
#include "x0_i0_position"

void main()
{
    if (!X2PreSpellCastCode())
    {
	    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    //Declare major variables
    object oPC = OBJECT_SELF;
    int iLevel = GetTotalLevels(oPC, TRUE);
    int iDamage;
	int iAlignLC = GetAlignmentLawChaos(oPC);
	int iAlignGE = GetAlignmentGoodEvil(oPC);
	int iEnemyAlignLC;
    float fDelay;
	
	
    /* Brock H. - OEI 03/03/06 -- Handled by the ImpactSEF column in the spells.2da
    effect eExplode = EffectVisualEffect(VFX_FNF_FIREBALL); */
    
    effect eVis = EffectVisualEffect(VFX_IMP_MAGBLUE);
    effect eDam;
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetSpellTargetLocation();
	// modify based off LC alignment
	if (iAlignLC != ALIGNMENT_LAWFUL)
	{
		int iMaxDist;
		if (iAlignLC == ALIGNMENT_CHAOTIC) iMaxDist = 200; // 1.0 in locations = 1 meter, to make random more smooth we will use scale * 10 then divide, so 100 is for 10m
		else iMaxDist = 100;
		lTarget = GenerateNewLocationFromLocation(lTarget, IntToFloat(Random(iMaxDist)) / 10, IntToFloat(Random(360)), 0.0);
	}
    
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    
	//Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{
        	SignalEvent(oTarget, EventSpellCastAt(oTarget, GetSpellId()));
            //Roll damage
			// LC alignment of caster affects accuracy. GE of caster affects damage. LC of target affects damage.
			iEnemyAlignLC = GetAlignmentLawChaos(oTarget);
			
			iDamage = d3(iLevel);
			if (iEnemyAlignLC == ALIGNMENT_CHAOTIC) iDamage *= 3;
			else if (iEnemyAlignLC == ALIGNMENT_NEUTRAL) iDamage *= 2;
			// else if target lawful, do not multiply.
			
			if (iAlignGE == ALIGNMENT_GOOD || iAlignGE == ALIGNMENT_EVIL) iDamage /= 2; // half damage if caster not neutral on good/evil scale.
			
			if(GetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER)
			{
				iDamage = iDamage * 2; // outsiders take double damage
			}
			
			
			
			eDam = EffectDamage(iDamage, DAMAGE_TYPE_MAGICAL);
            
			if(iDamage > 0)
            {
                fDelay = GetSpellEffectDelay(GetLocation(oTarget), oTarget);
                //Apply VFX impcat, damage effect and lightning effect
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eDam,oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget));
            }
		}
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}