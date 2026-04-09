//::///////////////////////////////////////////////
//:: Tortoise Shell
//:: nw_s0_tortshell.nss
//:: Copyright (c) 2006 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	Tortoise Shell grants a +6 enhancement bonus to the subject's
	existing natural armor bonus.  This enhancement bonus increases
	by 1 for every three caster levels beyond 11th, to a maximum
	of +9 at 20th level.  Tortoise Shell slows a creature's 
	movement to half its normal rate for the duration.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: Oct 12, 2006
//:://////////////////////////////////////////////


// Dec 19, 2024 - FlattedFifth.
// Removing Freedom of MOvement and then reapplying isn't balanced because doing
// so strips all Metamagic duration from the initial casting. Instead, we will allow FoM
// prevent negative effects but ALSO have them prevent some of the positive effects.
// If FoM is on, the AC provided by this spell is reduced by 2. Otherwise the spell is unchanged.

// MDiekmann 7/27/07 - Added signal event.
#include "nw_i0_spells"
#include "x2_inc_spellhook" 
#include "x2_i0_spells"

#include "nwn2_inc_spells"


void main()
{
	if (!X2PreSpellCastCode()) return;


	object	oTarget		=	GetSpellTargetObject();
	object	oCaster		=	OBJECT_SELF;
	effect	eAC;
	effect	eDur		=	EffectVisualEffect(VFX_SPELL_DUR_TORT_SHELL); 
	effect 	eSpeed		=	EffectMovementSpeedDecrease(50);
	int 	nMeta		=	GetMetaMagicFeat();
	int		nCLevel		=	PS_GetCasterLevel(oCaster);
	int bHasFoM = FALSE;
	if (GetHasSpellEffect(SPELL_FREEDOM_OF_MOVEMENT, oTarget)) bHasFoM = TRUE;

	int	nAC	= 6 + ((nCLevel - 11)/3);
	if (nAC > 9) nAC = 9;
	if (bHasFoM) nAC -= 2;
		
	float	fDuration	=	TurnsToSeconds(10*nCLevel);




	//Prevent this spell from stacking, the AC won't stack anyway, but the slowing will
	if (GetHasSpellEffect(1005, oTarget))
	{
		RemoveSpellEffects( 1005, oCaster, oTarget);
	}


	eAC	= EffectACIncrease(nAC, AC_NATURAL_BONUS);
			

	fDuration = ApplyMetamagicDurationMods(fDuration);

	effect eLink = EffectLinkEffects(eAC, eDur);
	eLink = EffectLinkEffects(eLink, eSpeed);

	//Apply effects
	if (GetIsObjectValid(oTarget)){
		if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster)){
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
		}
	}
}