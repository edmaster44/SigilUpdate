//::///////////////////////////////////////////////
//:: Implosion
//:: NW_S0_Implosion.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All persons within a 5ft radius of the spell must
    save at +3 DC or die.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 13, 2001
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "psi_inc_manifest"
#include "psi_inc_pwresist"
#include "psi_spellhook" 

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
	object oManifester = OBJECT_SELF;
	int nInt = GetAbilityModifier(ABILITY_INTELLIGENCE, oManifester);
	int nDC = 25 + nInt;
    object oTarget;
    effect eDeath = EffectDeath(TRUE, TRUE, TRUE);
	effect eSlow = EffectSlow();
	int nDice = d10(4);
	effect eDamage = EffectDamage(nDice, DAMAGE_TYPE_MAGICAL);
	effect eHit = EffectVisualEffect( VFX_FNF_IMPLOSION );
    float fDelay;
    //Get the first target in the shape
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, GetSpellTargetLocation());
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && !GetLocalInt(oTarget, "X2_L_IS_INCORPOREAL"))
    	{
           //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 14353));
           fDelay = GetRandomDelay(0.4, 1.2);
           //Make SR check
           
                //Make Reflex save
                if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_DEATH, OBJECT_SELF, fDelay))
                {
                    //Apply death effect and the VFX impact
					effect eParal = EffectCutsceneParalyze();
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eParal, oTarget, RoundsToSeconds(2));
                    DelayCommand(RoundsToSeconds(2), ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
					DelayCommand(RoundsToSeconds(2), ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget));
                }
				else
				{
					DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
					DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget));
					DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSlow, oTarget, RoundsToSeconds(2)));
					
				}
           
        }
       //Get next target in the shape
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, GetSpellTargetLocation());
    }
}