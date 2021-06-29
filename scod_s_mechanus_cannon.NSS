//::///////////////////////////////////////////////
//:: Fireball
//:: NW_S0_Fireball
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// A fireball is a burst of flame that detonates with
// a low roar and inflicts 1d6 points of damage per
// caster level (maximum of 10d6) to all creatures
// within the area. Unattended objects also take
// damage. The explosion creates almost no pressure.
*/
//:://////////////////////////////////////////////
//:: Created By: Noel Borstad
//:: Created On: Oct 18 , 2000
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 6, 2001
//:: Last Updated By: AidanScanlan, On: April 11, 2001
//:: Last Updated By: Preston Watamaniuk, On: May 25, 2001

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 
#include "ps_inc_functions"


void main()
{


    if (!X2PreSpellCastCode())
    {
	    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }



    //Declare major variables
    object oCaster = OBJECT_SELF;
    int nCasterLvl = PS_GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
	int nAlign = GetAlignmentLawChaos(OBJECT_SELF);
    float fDelay;
    
    /* Brock H. - OEI 03/03/06 -- Handled by the ImpactSEF column in the spells.2da
    effect eExplode = EffectVisualEffect(VFX_FNF_FIREBALL); */
    
    effect eVis = EffectVisualEffect(VFX_IMP_MAGBLUE);
    effect eDam;
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetSpellTargetLocation();

    
    //Apply the fireball explosion at the location captured above.
    /* Brock H. - OEI 03/03/06 -- Handled by the ImpactSEF column in the spells.2da
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);*/

    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    
	//Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
            	{
                   //Fire cast spell at event for the specified target
					//PrettyDebug("Signaling Lightning Bolt on " + GetName(oTarget));
                   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 1218));
                   //Make an SR check
                   if (!MyResistSpell(OBJECT_SELF, oTarget))
        	       {
                        //Roll damage
                        
        		        //Enter Metamagic conditions
        		        if (nAlign == ALIGNMENT_LAWFUL)
						{
							nDamage = d3(nCasterLvl) + (nCasterLvl);
						}
						if (nAlign == ALIGNMENT_NEUTRAL)
						{
							nDamage = ((d3(nCasterLvl))/2);
						}
						if (nAlign == ALIGNMENT_CHAOTIC)
						{
							nDamage = ((d3(nCasterLvl))/2);
							nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(),SAVING_THROW_TYPE_LAW);
							
						//Resolve metamagic
						if (nMetaMagic == METAMAGIC_MAXIMIZE)
						{
						nDamage = (nDamage*2);
						}
						else if (nMetaMagic == METAMAGIC_EMPOWER)
						{
						nDamage = nDamage + nDamage / 2;
						}
							
							//if (GetRacialType(oCaster) == RACIAL_TYPE_OUTSIDER)
							//{
						//		oTarget = oCaster;
						//	}
					//	}
					//	if(GetAlignmentLawChaos(oTarget) == ALIGNMENT_CHAOTIC)
					//	{
					//		nDamage = nDamage;
							
					//		if(GetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER)
					//		{
					//			nDamage = nDamage * 2;
					//		}
						}
                        //Adjust damage based on Reflex Save, Evasion and Improved Evasion
                       
                        //Set damage effect
                        eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
                        if(nDamage > 0)
                        {
                            fDelay = GetSpellEffectDelay(GetLocation(oTarget), oTarget);
                            //Apply VFX impcat, damage effect and lightning effect
                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eDam,oTarget));
                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget));
                        }
                    }
                   
                }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}