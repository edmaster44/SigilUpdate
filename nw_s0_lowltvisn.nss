//::///////////////////////////////////////////////
//:: [Low Light Vision]
//:: [NW_S0_LowLtVisn.nss]
//:://////////////////////////////////////////////
/*
    All "party-members" gain Low-Light Vision (as
    the Elf Racial ability).
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: July 12, 2005
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001
//:: Modified March 2003 to give -2 attack and damage penalties


// JLR - OEI 08/23/05 -- Metamagic changes
#include "nwn2_inc_spells"
#include "NW_I0_SPELLS"
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
	int nFeatLowLightVision = 354;
    location lLoc = GetSpellTargetLocation();
    int nMetaMagic = GetMetaMagicFeat();
    int nCasterLvl = PS_GetCasterLevel(OBJECT_SELF);
    float fDuration = HoursToSeconds(nCasterLvl);

    //Enter Metamagic conditions
    fDuration = ApplyMetamagicDurationMods(fDuration);
	// removed because this will always return DURATION_TYPE_TEMPORARY, we don't have any Metamagic that changes
	// the duration type.
    //int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	effect eDur = EffectVisualEffect( VFX_DUR_SPELL_LOWLIGHT_VISION );

	object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLoc, TRUE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oTarget))
		{
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
			PS_GrantFeatBySpellWithEffect(nFeatLowLightVision, oTarget, eDur, fDuration);
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLoc, TRUE, OBJECT_TYPE_CREATURE);
       
    }
}