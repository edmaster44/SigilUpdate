//::///////////////////////////////////////////////
//:: Summon Gale
//:: [nx_s2_summongale.nss]
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Mostly copied from x0_s0_gustwind.  A little
	cleanup & force the spell to be cast as a 5th
	level sorcerer.

    This spell creates a gust of wind in all directions
    around the target. All targets in a medium area will be
    affected:
    - Target must make a For save vs. spell DC or be
      knocked down for 3 rounds
    - if an area of effect object is within the area
      it is dispelled
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 01/11/2007
//:://////////////////////////////////////////////
//:: RPGplayer1 01/08/2009: Won't remove auras anymore

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 

void main()
{
    if (!X2PreSpellCastCode())
    {	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    //Declare major variables
    object oCaster   = OBJECT_SELF;
    int iCasterLevel = GetTotalLevels(oCaster, TRUE);
    if (iCasterLevel < 5) iCasterLevel = 5;
	int nMetaMagic   = GetMetaMagicFeat();
    location lTarget = GetSpellTargetLocation();		    	//Get the spell target location as opposed to the spell target.
    effect eVis      = EffectVisualEffect(VFX_HIT_SPELL_SONIC);

	int nDamage;
    float fDelay;
	int nDC;
	int iAppearanceType;
	
	effect eKnockdown = EffectKnockdown();

    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_AREA_OF_EFFECT);

    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if (GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT)
        {
            if (GetAreaOfEffectDuration(oTarget) != DURATION_TYPE_PERMANENT) //auras have permanent AOE object
            {
                DestroyObject(oTarget);
            }
        }
        else if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oTarget != oCaster)
    	{
	         //Fire cast spell at event for the specified target
	         SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
			 
	         //Get the distance between the explosion and the target to calculate delay
	         fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
	
	         // * unlocked doors will reverse their open state
	         if (GetObjectType(oTarget) == OBJECT_TYPE_DOOR)
	         {
	             if (GetLocked(oTarget) == FALSE)
	             {
	                 if (GetIsOpen(oTarget) == FALSE)
	                 {
	                     AssignCommand(oTarget, ActionOpenDoor(oTarget));
	                 }
	                 else
					 {
	                     AssignCommand(oTarget, ActionCloseDoor(oTarget));
					 }
	             }
	         }
			 
			 // using CHA as a modifier on a race with a neg CHA modifier is silly.
			 // Let's use the Genasi's level for the DC modifier.  Should create a high DC at high levels then
			 // int nDC = 10 + GetSpellLevel(SPELLABILITY_SUMMON_GALE) + GetAbilityModifier(ABILITY_CHARISMA, oCaster);
	         nDC = 10 + GetSpellLevel(SPELLABILITY_SUMMON_GALE) + iCasterLevel;
			 
			 // If race (or appearance) is Air Elemental or Air Genasi then DC is low
			 // I guess air elementals are actually immune to knockdown anyway.
			 // Probably should expand these changes to include other relevant creatures (mephits)
			 
			 iAppearanceType = GetAppearanceType(oTarget);
			 if (iAppearanceType == APPEARANCE_TYPE_ELEMENTAL_AIR || 
			 	iAppearanceType == APPEARANCE_TYPE_ELEMENTAL_AIR_ELDER || 
				iAppearanceType == 554 || 
				iAppearanceType == 555 || 
				GetSubRace(oTarget) == RACIAL_SUBTYPE_AIR_GENASI ||
				GetLevelByClass(CLASS_TYPE_BRALANI_PRC, oTarget) > 0)
					nDC = 10;
					
			 if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC))
	 	     {
				 // Duration set to 3 (original) + Random value between 1 and the caster's HD / 5.
	             ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, RoundsToSeconds(3 + Random(FloatToInt(IntToFloat(iCasterLevel)/5))) + 1);
	             DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
	          }
        }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE |OBJECT_TYPE_AREA_OF_EFFECT);
    }
}