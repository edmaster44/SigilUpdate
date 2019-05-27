//::///////////////////////////////////////////////
//:: Implacable Foe
//:: NW_S2_ImpFoe
//:: Copyright (c) 2006 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Modified for Sigil Server (Clangeddin 2019)
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo
//:: Created On: 05/20/2006
//:://////////////////////////////////////////////
//:: AFW-OEI 05/22/2006:
//:: Does not use Turn Undead attempts anymore.
//:: RPGplayer1 03/19/2008: EventSpellCastAt not Harmful anymore
 
void main()
{
	object oPC = OBJECT_SELF;
	location lPC = GetLocation(oPC);
	effect eFX = EffectTemporaryHitpoints(30);
	eFX = EffectLinkEffects(eFX, EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_DIVINE));
	eFX = EffectLinkEffects(eFX, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
	eFX = ExtraordinaryEffect(eFX);
	effect eVFX	= EffectVisualEffect(VFX_HIT_SPELL_ENCHANTMENT);
	float fDEL;
	float fDUR = RoundsToSeconds(10);
	
	object oTARGET = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_TREMENDOUS, lPC);
	while (oTARGET != OBJECT_INVALID)
	{
		if (oTARGET != oPC)
		{
			if (GetIsEnemy(oTARGET, oPC) == FALSE)
			{
				fDEL = GetDistanceToObject(oTARGET) / 10.0;
				
				//Fire cast spell at event for the specified target
				SignalEvent(oTARGET, EventSpellCastAt(oPC, SPELLABILITY_IMPLACABLE_FOE, FALSE));
				
				//Apply the VFX impact and effects and extra damage
				DelayCommand(fDEL, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFX, oTARGET, fDUR));
				DelayCommand(fDEL, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oTARGET));
			}
		}
		oTARGET = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_TREMENDOUS, lPC);
	}
}