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
#include "ps_inc_functions"

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
    int nCasterLvl = PS_GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage, nDamage2, nDamage3;
    int nVariable = nCasterLvl;
	int PML = GetPureMageLevels(OBJECT_SELF);
	int nDuration = nCasterLvl;
    float fDelay;
    effect eVis = EffectNWN2SpecialEffectFile("sp_stygian_ice_storm_hit.sef");
	effect eConfuse = EffectConfused();
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
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 1219));
            if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
    	    {
                //Roll damage for each target
                nDamage = d6(nVariable) + d6(PML/3);
				if (nVariable < 20 && !GetIsObjectValid(GetSpellCastItem())){
				nDamage = d6(20) + d6(PML/3);
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
				//Make Will Save
                if (!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, fDelay))
                {
                   //Apply linked effect and VFX Impact
                   nDuration = GetScaledDuration(GetCasterLevel(OBJECT_SELF), oTarget);

                   //Perform metamagic checks
                   if (nMetaMagic == METAMAGIC_EXTEND)
                   {
                       nDuration = nDuration * 2;
                   }

                   DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eConfuse, oTarget, RoundsToSeconds(nDuration)));
                   //DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));	// NWN1 VFX
                }
             }
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}