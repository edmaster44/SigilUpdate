//::///////////////////////////////////////////////
//:: Great Thunderclap
//:: X2_S0_GrtThdclp
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// You create a loud noise equivalent to a peal of
// thunder and its acommpanying shock wave. The
// spell has three effects. First, all creatures
// in the area must make Will saves to avoid being
// stunned for 1 round. Second, the creatures must
// make Fortitude saves or be deafened for 1 minute.
// Third, they must make Reflex saves or fall prone.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 20, 2002
//:: Updated On: Oct 20, 2003 - some nice Vfx:)
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"
#include "x0_i0_spells"
#include "ps_inc_functions"
#include "x2_inc_spellhook"
#include "nwn2_inc_metmag"

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

    
    int nDC = GetSpellSaveDC();
	int nCL = PS_GetCasterLevel(OBJECT_SELF);
	int PML = GetPureMageLevels(OBJECT_SELF);
	object		oCaster		=	OBJECT_SELF;

	int	nMetaMagic = GetMetaMagicFeat();
    float fDelay;
    effect eExplode = EffectVisualEffect(VFX_HIT_AOE_LIGHTNING);
    effect eVis  = EffectVisualEffect(VFX_IMP_SONIC);
    effect eVis2 = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
    effect eVis3 = EffectVisualEffect(VFX_IMP_STUN);
    effect eDeaf = EffectDeaf();
    effect eKnock = EffectKnockdown();
    effect eStun = EffectStunned();
    effect eShake = EffectVisualEffect(356);
	effect eDam;

    location lTarget = GetSpellTargetLocation();
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, OBJECT_SELF, 2.0f);
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

            //Get the distance between the explosion and the target to calculate delay
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;

            if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SONIC))
            {
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDeaf, oTarget, RoundsToSeconds(10)));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
            }
            if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_SONIC))
            {
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, RoundsToSeconds(1)));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            }
            if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_SONIC))
            {
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnock, oTarget, 6.0f));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis3, oTarget,4.0f));
            }
			
			int nDam = d6(nCL) + d6(PML/3);
				eDam = EffectDamage(nDam, DAMAGE_TYPE_SONIC);
			
				
		    if (nMetaMagic == METAMAGIC_MAXIMIZE)
                    {
                        nDam = nDam + ((3*nDam)/4);
						eDam = EffectDamage(nDam, DAMAGE_TYPE_SONIC);

                    }
        	else if (nMetaMagic == METAMAGIC_EMPOWER)
                    {
                        nDam = nDam + nDam / 2;
						eDam = EffectDamage(nDam, DAMAGE_TYPE_SONIC);

                    }
				
				
								
			if (MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_SONIC))
				{
					nDam	=	nDam/2;
					eDam	=	EffectDamage(nDam, DAMAGE_TYPE_SONIC);
				}
			else
				{
					eDam	=	EffectDamage(nDam, DAMAGE_TYPE_SONIC);
				}
	
					
        

       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
 			}
	     }
}