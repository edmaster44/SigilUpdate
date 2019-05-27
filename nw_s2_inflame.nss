//::///////////////////////////////////////////////
//:: Inflame
//:: NW_S2_Inflame
//:: Copyright (c) 2006 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
// 
// Inflame is a Warpriest ability that grants all
// allies within 30' bonuses to saves vs. fear and
// mind effects for 5 rounds.
//
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 05/20/2006
//:://////////////////////////////////////////////

void main()
{
    //Declare major variables
    object oPC = OBJECT_SELF;
	location lPC = GetLocation(oPC);
	float fDUR = RoundsToSeconds(5);
	
	//Determine bonus:
	int nCLASS = GetLevelByClass(CLASS_TYPE_WARPRIEST, oPC);
	int nBONUS = 2;
	if (nCLASS >= 10) nBONUS = 8;
	else if (nCLASS >= 6) nBONUS = 6;
	else if (nCLASS >= 4) nBONUS = 4;
	
	effect eFX = EffectSavingThrowIncrease(SAVING_THROW_ALL, nBONUS, SAVING_THROW_TYPE_FEAR);
	eFX = EffectLinkEffects(eFX, EffectSavingThrowIncrease(SAVING_THROW_ALL, nBONUS, SAVING_THROW_TYPE_MIND_SPELLS));
	eFX = EffectLinkEffects(eFX, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
	eFX = ExtraordinaryEffect(eFX);
	
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_AOE_ENCHANTMENT), lPC);
	
	object oTARGET = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_TREMENDOUS, lPC);
	while (oTARGET != OBJECT_INVALID)
	{
		if (GetIsEnemy(oTARGET, oPC) == FALSE)
		{
			SignalEvent(oTARGET, EventSpellCastAt(oPC, SPELLABILITY_INFLAME, FALSE));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFX, oTARGET, fDUR);
		}
		oTARGET = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_TREMENDOUS, lPC);
	}
}