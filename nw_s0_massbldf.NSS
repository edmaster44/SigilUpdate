//::///////////////////////////////////////////////
//:: Mass Blindness and Deafness
//:: [NW_S0_BlindDead.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Causes the target creature to make a Fort
//:: save or be blinded and deafened.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 12, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 10, 2001
//:: Update Pass By: Preston W, On: Aug 2, 2001
//:: RPGplayer1 01/07/2009: Should affect only enemies

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
	int bImmuneBlind = FALSE;
	int bImmuneDeaf = FALSE;
    int nMetaMagic = GetMetaMagicFeat();
    int nDuration = GetCasterLevel(OBJECT_SELF);
    effect eBlind =  EffectNewBlindness();
    effect eDeaf = EffectDeaf();
    //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);	// NWN1 VFX
    effect eDur = EffectVisualEffect( VFX_DUR_SPELL_BLIND_DEAF );	// NWN2 VFX

    //effect eVis = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);	// NWN1 VFX
    //effect eXpl = EffectVisualEffect(VFX_FNF_BLINDDEAF);	// NWN1 VFX
    //Check for metamagic extend
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
         nDuration = nDuration * 2;
    }
    //Play area impact VFX
    //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eXpl, GetSpellTargetLocation());	// NWN1 VFX
    //Get the first target in the spell area
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, GetSpellTargetLocation());
    while (GetIsObjectValid(oTarget))
    {
        //if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
    	{
			bImmuneBlind = GetIsImmune(oTarget, IMMUNITY_TYPE_BLINDNESS, OBJECT_SELF);
			bImmuneDeaf = GetIsImmune(oTarget, IMMUNITY_TYPE_DEAFNESS, OBJECT_SELF);
			if (bImmuneBlind && bImmuneDeaf){
				FloatingTextStringOnCreature("Target Immune", oTarget);
			} else {
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MASS_BLINDNESS_AND_DEAFNESS));
				//Make SR check
				if (!MyResistSpell(OBJECT_SELF, oTarget))
				{
					//Make Fort save
					if (!/*Fort Save*/ MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC()))
					{
						//Apply the effects and the VFX impact
						ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, RoundsToSeconds(nDuration));
						if (!bImmuneBlind)
							ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlind, oTarget, RoundsToSeconds(nDuration));
						if (!bImmuneDeaf)
							ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDeaf, oTarget, RoundsToSeconds(nDuration));
						//ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);	// NWN1 VFX
					}
				}
			}
		}
        //Get next object in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, GetSpellTargetLocation());
    }
}