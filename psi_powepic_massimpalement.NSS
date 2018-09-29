//::///////////////////////////////////////////////
//:: Mass Impalement (Metacreativity)
//:://////////////////////////////////////////////
/*
    Mass Impalement deals 20d6 slashing and 10d6 
	piercing damage to any caught in its AOE. 
	Reflex save for half-damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Xndar
//:: Created On: June 30, 2015
//:://////////////////////////////////////////////


// JLR - OEI 08/23/05 -- Metamagic changes
#include "nwn2_inc_spells"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
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
	object oManifester = OBJECT_SELF;
    object oTarget;
    
	int nInt = GetAbilityModifier(ABILITY_INTELLIGENCE, oManifester);
	int nDC = 20 + nInt;
    //Declare major variables
    object oCaster = OBJECT_SELF;
    
    
    int nDamage;
	
    float fDelay;
    effect eVis = EffectNWN2SpecialEffectFile("psi_crystal_hit.sef", oTarget);
    effect eDam,eDam2;
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetSpellTargetLocation();
    //Apply the ice storm VFX at the location captured above.
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_ASTRONOMIC, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oTarget != oCaster) //Additional target check to make sure that the caster cannot be harmed by this spell
        {
            fDelay = GetRandomDelay(0.15, 0.35);
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 14354));
            
			
				nDamage = d8(20);
				
				nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nDC, SAVING_THROW_TYPE_NONE);
				/*int nSave = ReflexSave(oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FIRE, OBJECT_SELF);
				
				if (nSave == 2)
				{
					return;
				}
				else if (nSave == 1)
				{
					nDamage = nDamage/2;
				}
				else
				{
					nDamage = nDamage;
				}*/
				
				 if ( nDamage > 0 )
                {
                    //Set the damage effect
                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_SLASHING);
					eDam2 = EffectDamage((nDamage/2), DAMAGE_TYPE_PIERCING);
                    // Apply effects to the currently selected target.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
					DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam2, oTarget));
                    //This visual effect is applied to the target object not the location as above.  This visual effect
                    //represents the impact that erupts on the target not on the ground.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                } 
                /*//Roll damage for each target
                nDamage = d8(nMaxLvl);
                //Resolve metamagic
                nDamage = ApplyMetamagicVariableMods(nDamage, nMaxLvl * 8);
				nDamage2 = nDamage;
                nDamage2 = GetReflexAdjustedDamage(nDamage/2, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FIRE);
				nDamage = nDamage/2 + nDamage2;
                if ( nDamage > 0 )
                {
                    //Set the damage effect
                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                    // Apply effects to the currently selected target.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    //This visual effect is applied to the target object not the location as above.  This visual effect
                    //represents the impact that erupts on the target not on the ground.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                } */
            
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_ASTRONOMIC, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}