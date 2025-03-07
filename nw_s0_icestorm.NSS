//::///////////////////////////////////////////////
//:: Ice Storm
//:: NW_S0_IceStorm
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Everyone in the area takes 3d6 Bludgeoning
    and 2d6 Cold damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 12, 2001
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oCaster = OBJECT_SELF;
	//Casting modifier
//	int CasterModifier = 0;
	//Determine Caster modifier
//	if (GetAbilityModifier(ABILITY_INTELLIGENCE,OBJECT_SELF) > GetAbilityModifier(ABILITY_CHARISMA,OBJECT_SELF)) {
//		CasterModifier = GetAbilityModifier(ABILITY_INTELLIGENCE,OBJECT_SELF);
//	}
//	else {
//		CasterModifier = GetAbilityModifier(ABILITY_CHARISMA,OBJECT_SELF);
//	}
	
    int nCasterLvl = GetCasterLevel(oCaster);
	int PML = GetPureMageLevels(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage, nDamage2, nDamage3;
    int nVariable = nCasterLvl;
    float fDelay;
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ICE);
    effect eDam,eDam2, eDam3;
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetSpellTargetLocation();
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    	{
            //fDelay = GetRandomDelay(0.75, 2.25);
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ICE_STORM));
            if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
    	    {
                //Roll damage for each target
                nDamage = d4(nVariable) + d4(PML/3);
				if (nCasterLvl < 20 && !GetIsObjectValid(GetSpellCastItem()) && GetIsPC(OBJECT_SELF)){
				nDamage = d4(20) + d4(PML/3);
				} 

                //Resolve metamagic
        	    if (nMetaMagic == METAMAGIC_MAXIMIZE)
                {
                    nDamage = nDamage + ((3*nDamage)/4);
                }
    	        else if (nMetaMagic == METAMAGIC_EMPOWER)
                {
                   nDamage = nDamage + (nDamage / 2);
                  
                }
                nDamage2 = nDamage2 + nDamage3;
                //Set the damage effect
                
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_COLD);
                // Apply effects to the currently selected target.
                DelayCommand(0.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                DelayCommand(0.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam2, oTarget));
                //This visual effect is applied to the target object not the location as above.  This visual effect
                //represents the impact that erupts on the target not on the ground.
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
             }
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}