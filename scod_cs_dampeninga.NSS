//::///////////////////////////////////////////////
//:: Magic Cirle Against Good
//:: NW_S0_CircGoodA
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Add basic protection from good effects to
    entering allies.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 20, 2001
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"
#include "x0_i0_spells"
#include "x2_inc_spellhook"

void main()
{




    object oTarget = GetEnteringObject();
	object oMaster = GetMaster(oTarget);
	effect eSummWink = EffectEthereal();
	effect eSummVfx = EffectVisualEffect(VFX_DUR_SPELL_ETHEREAL_VISAGE);
	effect eWinkLink = EffectLinkEffects(eSummVfx, eSummWink);
	effect eSummStun = EffectPetrify();
	effect eSummGhost = EffectCutsceneGhost();
	effect eLink2 = EffectLinkEffects(eSummStun, eWinkLink);
	effect eLink3 = EffectLinkEffects(eSummGhost, eLink2);
	effect eSummonWinking = ExtraordinaryEffect(eLink3);
	effect   eVis         = EffectVisualEffect( VFX_HIT_SPELL_ABJURATION );
	effect   eImpact; // Now handled by spells.2da, the ImpactSEF column, but effect required for spellsDispelMagic
    

//    if(GetIsFriend(oTarget, GetAreaOfEffectCreator()))
    if(GetIsObjectValid(oTarget))
    {
		if (oMaster == OBJECT_INVALID)
        {
            oMaster = OBJECT_SELF;
        //Declare major variables
        	int nDuration = GetCasterLevel(OBJECT_SELF);
        //effect eVis = EffectVisualEffect( VFX_DUR_SPELL_GOOD_CIRCLE );	// handled by CreateProtectionFromAlignmentLink()
       
        //Fire cast spell at event for the specified target
        	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 1383, FALSE));

        //Apply the VFX impact and effects
        //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);	// handled by CreateProtectionFromAlignmentLink()
        	
			
			
		}
		if((GetAssociate(ASSOCIATE_TYPE_SUMMONED, oMaster) == oTarget || GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oMaster) == oTarget || GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oMaster) == oTarget || GetCreatureFlag(oTarget, CREATURE_VAR_IS_INCORPOREAL) == TRUE ))
		{
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 1383, FALSE));
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSummonWinking, oTarget);
			
			
			
		}
		
     }
}