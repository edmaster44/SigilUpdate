//::///////////////////////////////////////////////
//:: Mestil's Acid Breath
//:: X2_S0_AcidBrth
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// You breathe forth a cone of acidic droplets. The
// cone inflicts 1d6 points of acid damage per caster
// level (maximum 10d6).
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov, 22 2002
//:://////////////////////////////////////////////
//::Mymothersmeatloaf 6/20/2020 - Upped scaling to 20'th caster level

//float SpellDelay (object oTarget, int nShape);

#include "NW_I0_SPELLS"
#include "x0_i0_spells"
#include "x2_inc_spellhook" 
#include "ps_inc_functions"

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-07-07 by Georg Zoeller
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
    int nCasterLevel = PS_GetCasterLevel(OBJECT_SELF);
	int PML = GetPureMageLevels(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    float fDelay;
	effect eCone = EffectVisualEffect(VFX_DUR_CONE_ACID);
	float fMaxDelay = 0.0f; // used to determine duration of eCone effect
    location lTargetLocation = GetSpellTargetLocation();
    object oTarget;
    //Limit Caster level for the purposes of damage.

    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while(GetIsObjectValid(oTarget))
    {
    	if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    	{
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            //Get the distance between the target and caster to delay the application of effects
            fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20.0;
			if (fDelay > fMaxDelay)
			{
				fMaxDelay = fDelay;
			}
            //Make SR check, and appropriate saving throw(s).
            //if(!MyResistSpell(OBJECT_SELF, oTarget, fDelay) && (oTarget != OBJECT_SELF))
            if(oTarget != OBJECT_SELF && !MyResistSpell(OBJECT_SELF, oTarget, fDelay)) //FIX: prevents caster from getting SR check against himself
            {
                //Detemine damage
                nDamage = d4(nCasterLevel) + d4(PML/3);
                //Enter Metamagic conditions
                if (nMetaMagic == METAMAGIC_MAXIMIZE)
                {
                    nDamage = nDamage + ((3*nDamage)/4);//Damage is at max
                }
                else if (nMetaMagic == METAMAGIC_EMPOWER)
                {
                    nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
                }
                //Adjust damage according to Reflex Save, Evasion or Improved Evasion
                nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_ACID);

                // Apply effects to the currently selected target.
                effect eAcid = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
                effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ACID);
                if(nDamage > 0)
                {
                    //Apply delayed effects
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eAcid, oTarget));
                }
            }
        }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 8.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
	fMaxDelay += 0.5f;
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCone, OBJECT_SELF, fMaxDelay);
}