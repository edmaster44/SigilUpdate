//::///////////////////////////////////////////////
//:: Deafening Roar - Dragon Magic
//:://////////////////////////////////////////////
/*
// You blast the target with loud and high-pitched
// sounds. 
// The Victim must make a Will save or be deafened for 1d4
// rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Xndar
//:: Created On: July 3rd, 2014
//:://////////////////////////////////////////////


#include "NW_I0_SPELLS"
#include "x0_i0_spells"
#include "x2_inc_spellhook"

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


    //Declare major variables  ( fDist / (3.0f * log( fDist ) + 2.0f) )
    object oTarget;
    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
    int nRounds = (nCasterLvl/2) + 1;
    int nMetaMagic = GetMetaMagicFeat();
	location lTargetLocation = GetSpellTargetLocation();
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_SHOUT);
    effect eDeaf = EffectDeaf();
    //Minimum caster level of 1, maximum of 15.
    if(nCasterLvl == 0)
    {
        nCasterLvl = 1;
    }
    else
	oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE);
	while(GetIsObjectValid(oTarget))
	{
	    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	    {
	        if(!MyResistSpell(OBJECT_SELF, oTarget))
	        {
	            //Fire cast spell at event for the specified target
	            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
	            //Roll damage
	            
	            //Set damage effect
	            
	            //Apply the MIRV and damage effect
	            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	
	            if(!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_SONIC))
	            {
	                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDeaf, oTarget, RoundsToSeconds(nRounds));
	            }
	        }
	    }
		oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE);
	}
	effect eVis2 = EffectVisualEffect(VFX_DUR_CONE_SONIC);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis2, OBJECT_SELF, 3.0);
}