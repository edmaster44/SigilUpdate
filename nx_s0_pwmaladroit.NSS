//::///////////////////////////////////////////////
//:: Power Word: Weaken
//:: NX_s0_pwweaken.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	Power Word Maladroit
	Divination (Changed from Enchantment)
	Level: Sorceror/wizard 3
	Components: V
	Range: Close
	Target: One living creature with 75 hp or less
	Duration: See text
	Saving Throw: None
	Spell Resistance: Yes
	 
	You utter a single word of power that instantly 
	causes one creature of your choice to become 
	clumbsier, dealing 2 points of damage to its 
	Dexterity, whether the creature can hear the word or 
	not.  The specific effect and duration of the spell 
	depend on the target's current hit point total, as 
	shown below.  Any creature that currently has 75 or 
	more hit points is unaffected by power word maladroit.
	 
	 
	Hit Points        Effect/Duration
	25 or less       The Dexterity damage is ability drain instead
	26-50             Dexterity damage lasts until 1d4+1 minutes
	51-75             Dexterity damage lasts until 1d4+1 rounds
	 
	NOTE: Because this was changed from enchantment
	to Divination, creatures previously immune to
	mind-affecting spells are vulnurable.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: 11.28.06
//:://////////////////////////////////////////////
//:: Updates to scripts go here.
//:: MDiekmann 6/13/07 - Added SignalEvent
//:: AFW-OEI 07/10/2007: NX1 VFX

#include "nw_i0_spells" 
#include "x2_inc_spellhook"
#include "nwn2_inc_metmag"
#include "nwn2_inc_spells"

void main()
{

/* 
  Spellcast Hook Code 
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


//Declare Major variables

	object 	oCaster		=	OBJECT_SELF;
	object	oTarget		=	GetSpellTargetObject();
	int	nTargetHP	=	GetCurrentHitPoints(oTarget);
	effect	eStrDrain	=	EffectAbilityDecrease(ABILITY_DEXTERITY, 4 + d4());
	effect	eVis	=	EffectVisualEffect(VFX_DUR_SPELL_POWER_WORD_MALADROIT);
	float	fDuration;
	
//Link vfx with strength drain
	effect	eLink		=	EffectLinkEffects(eStrDrain, eVis);
	
//Spell Resistance Check & Target Discrimination

	if (GetIsObjectValid(oTarget))
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			if (!MyResistSpell(oCaster, oTarget))
			{
			
				// Set up values based on whether PC or NPC and their HPs.
				// Decision was taken to leave values as default if PC so not affecting PvP
				
				int iTargetMaxHP = GetMaxHitPoints(oTarget);
				int iTargetHPHigh = 75;
				int iTargetHPMed = 50;
				int iTargetHPLow = 25;
	
				if (GetIsPC(oTarget) == FALSE)
				{
					// 75% of max or original value, whichever is higher.
					int iPercentOfMaxHigh = FloatToInt(IntToFloat(iTargetMaxHP) * 0.75);
					if (iPercentOfMaxHigh > iTargetHPHigh)
						iTargetHPHigh = iPercentOfMaxHigh;
			
					// 50% of max or original value, whichever is higher.
					int iPercentOfMaxMed = FloatToInt(IntToFloat(iTargetMaxHP) * 0.5);
					if (iPercentOfMaxMed > iTargetHPMed)
						iTargetHPHigh = iPercentOfMaxHigh;
						
					// 25% of max or original value, whichever is higher.
					int iPercentOfMaxLow = FloatToInt(IntToFloat(iTargetMaxHP) * 0.25);
					if (iPercentOfMaxLow > iTargetHPLow)
						iTargetHPLow = iPercentOfMaxLow;
				}
			
//Determine the nature of the effect
				if	(nTargetHP > iTargetHPHigh)
				{
					SendMessageToPC(oCaster, "<COLOR=red>Target has too many HPs to be affected.");
				}
				else if (nTargetHP > iTargetHPMed)
				{
					fDuration	=	ApplyMetamagicDurationMods(RoundsToSeconds(d4()));
					
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
					SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));
				}
				else if (nTargetHP > iTargetHPLow)
				{
					fDuration	=	ApplyMetamagicDurationMods(TurnsToSeconds(d4()));
					
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
					SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));
				}
				else
				{
					ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
					SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));
				}
			}
		}
	}
}
					
						
	