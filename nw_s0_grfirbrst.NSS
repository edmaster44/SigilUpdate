//::///////////////////////////////////////////////
//:: Greater Fireburst
//:: NW_S0_GrFirbrst
//:://////////////////////////////////////////////
/*
    Burst of Fire from caster damaging everyone within
    5 feet.  Does 1d8/lvl (max 5d8) to everyone in
    range except for the caster.
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: August 01, 2005
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update Pass By: Preston W, On: Aug 1, 2001

// JLR - OEI 08/23/05 -- Metamagic changes
// MDiekmann 7/25/07 - Modified to pass GetSpellId() for CastAtEvent.
// Mymothersmeatloaf 6/21/2020 - Increased spellcaster level scaling
#include "nwn2_inc_spells"

#include "ps_inc_functions"
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
    int nCasterLvl = PS_GetCasterLevel(OBJECT_SELF);
	int nMetaMagic = GetMetaMagicFeat();
    int nMaxLvl = nCasterLvl;
	int PML = GetPureMageLevels(OBJECT_SELF);
   /* if ( nCasterLvl > 15 )
    {
        nMaxLvl = 15;
    }
    else
    {
        nMaxLvl = nCasterLvl;
    }*/
	
    int nDamage;
    float fDelay;
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_FIRE);
    effect eDam,eDam2, eDam3;
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetSpellTargetLocation();
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
        {
            fDelay = GetRandomDelay(0.15, 0.35);
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
            {
                //Roll damage for each target
                nDamage = d2(2*nMaxLvl) +  d2((2*PML)/3);
				if (nCasterLvl < 20 && !GetIsObjectValid(GetSpellCastItem()) && GetIsPC(OBJECT_SELF)){
				nDamage = d2(40) + d2((2*PML)/3);
				} 
               //Resolve metamagic
				if (nMetaMagic == METAMAGIC_MAXIMIZE)
				{
				nDamage = nDamage + ((3*nDamage)/4);
				}
				else if (nMetaMagic == METAMAGIC_EMPOWER)
				{
				nDamage = nDamage + nDamage / 2;
				}
                {
                    //Set the damage effect
                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                    // Apply effects to the currently selected target.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    //This visual effect is applied to the target object not the location as above.  This visual effect
                    //represents the impact that erupts on the target not on the ground.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
            }
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}