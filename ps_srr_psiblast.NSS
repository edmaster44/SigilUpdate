//::///////////////////////////////////////////////
//:: Cone: Mindflayer Mind Blast
//:: x2_m1_mindblast
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Anyone caught in the cone must make a
    Will save (DC 17) or be stunned for 3d4 rounds.
	
	Update: Now does 3d6 magic damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Dec 5/02
//:: Modified By: Jeff Husges
//:://////////////////////////////////////////////

// Edited by Agony_Aunt for SCoD PW

#include "x2_i0_spells"

void main()
{
	int nSaveDC			= 15 + GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF);
	int nIntMod			= GetAbilityModifier(ABILITY_INTELLIGENCE, OBJECT_SELF);
	int nMentalLevel	= GetLevelByClass(100, OBJECT_SELF);
	
	if (GetHasFeat(21420, OBJECT_SELF))
	{
		nSaveDC = nSaveDC + nIntMod;
	}
	object oTarget		= GetSpellTargetObject();
	effect eConeBlast	= EffectNWN2SpecialEffectFile("fx_mindflayer_cone");
	
	int nStunDuration;	
	int nDamageAmount;
	float fDelay;
	
	location lTargetLocation = GetSpellTargetLocation();
	effect eStun		= EffectStunned();
	effect eHit			= EffectNWN2SpecialEffectFile("sp_sonic_hit");
	effect eDamageHit	= EffectNWN2SpecialEffectFile("sp_magic_hit");
	effect eVis			= EffectNWN2SpecialEffectFile("fx_stun");
	effect eMindblast	= EffectLinkEffects(eStun, eVis);
	effect eDamage;

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eConeBlast, OBJECT_SELF, 1.0f);
	
	oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 20.0f, lTargetLocation, TRUE);

    while(GetIsObjectValid(oTarget))
    {
        int nApp = GetAppearanceType(oTarget);
        int bImmune = FALSE;
        //----------------------------------------------------------------------
        // Hack to make mind flayers immune to their psionic attacks...
        //----------------------------------------------------------------------
        if (GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, OBJECT_SELF))
        {
            bImmune = TRUE;
        }
		if (GetHasFeat(21422, OBJECT_SELF) && GetIsFriend(oTarget, OBJECT_SELF))
		{
			bImmune = TRUE;
		}

        if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF && !bImmune )
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
			
			nStunDuration	= d4(3);
			nDamageAmount;
			
			switch (nMentalLevel)
			{
				case 1: case 2:
				{
					nDamageAmount	= d6(1);
					break;
				}
				case 3: case 4:
				{
					nDamageAmount	= d6(2);
					break;
				}
				case 5: case 6:
				{
					nDamageAmount	= d6(3);
					break;
				}
				case 7: case 8:
				{
					nDamageAmount	= d6(4);
					break;
				}
				case 9: case 10:
				{
					nDamageAmount	= d6(5);
					break;
				}
			}
			
			eDamage			= EffectDamage(nDamageAmount);
			eDamage			= EffectLinkEffects(eDamage, eDamageHit);
			
			
			
            // already stunned
            if (WillSave(oTarget, nSaveDC)==SAVING_THROW_CHECK_FAILED)
            {
				if (GetHasFeat(21420, OBJECT_SELF))
				{
					DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
				}
				if (!GetHasSpellEffect(GetSpellId(), oTarget))
				{
					DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget));
					DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eMindblast, oTarget, RoundsToSeconds(nStunDuration)));
				}
			}
			else
			{
				if (GetHasFeat(21421, OBJECT_SELF))
				{
					effect eDamage2 = EffectDamage(nDamageAmount/2);
					eDamage2	= EffectLinkEffects(eDamage2, eDamageHit);
					DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage2, oTarget));
				}
			}
			
		}
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 20.0f, lTargetLocation, TRUE);
    }
}