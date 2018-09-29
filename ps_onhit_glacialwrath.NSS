//::///////////////////////////////////////////////
//:: Burst of Glacial Wrath
//:: NX_s0_glacial.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/* 	
	Burst of Glacial Wrath 
	Evocation Level: Sorceror/Wizard 9 
	Components: V, S 
	Range: Medium 
	Area: Cone Shaped Burst 
	Duration: See Text 
	Saving Throw: Fortitude half Spell 
	Resistance: Yes 
	
	You create a burst of icy energy that flash-
	freezes any creatures within the spell's area. 
	The spell deals 1d6 points of cold damager per 
	caster level (maximum 25d6 points). Any living 
	creature reduced to 10 hit points or lower is 
	encased in ice for 1 round/ two caster levels 
	(max 10 rounds). Creatures turned to ice in 
	this fashion gain DR 10/fire and immunity to 
	cold and electricity. 
	
	NOTE: Numerous changes were made to this spell. 
	This spell is now evocation only, rather than 
	evocation/transmutation. Creatures turned to 
	ice eventually thaw out. vulnurability to fire 
	and hardness 10 is replaced with DR 10/fire. 
	Negative hitpoints rules are ignored and reversed.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: 12.14.06
//:: Modified Extensively By: Ryan Young
//:: Date: 1.25.07
//:://////////////////////////////////////////////
//:: AFW-OEI 07/10/2007: NX1 VFX

#include "nw_i0_spells" 
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "ps_inc_onhit" 


void FreezeDamage(int nDam, effect eFreeze, object oTarget, float fDuration);

void main()
{
	
	location	lLocation	=	GetLocation(OBJECT_SELF);
	object		oCaster		=	GetOnHitAbilityCaster(OBJECT_SELF);
	int			nDam;
	int			nHP;
	int			nCasterLvl	=	GetCasterLevel(oCaster);
	int			nFreezeLvl	=	GetCasterLevel(oCaster)/2;
	effect		eFreeze		=	EffectPetrify();
	effect		eVis		=	EffectVisualEffect(VFX_HIT_SPELL_ICE);
	effect 		eDur		=	EffectVisualEffect(VFX_DUR_SPELL_GLACIAL_WRATH);
	effect		eDam;
	effect		eCold		=	EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 100);
	effect		eElec		=	EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, 100);
	effect		eFire		=	EffectDamageImmunityDecrease(DAMAGE_TYPE_FIRE, 100);
	effect		eDR			=	EffectDamageReduction(10, 0, 0, DR_TYPE_NONE);
	effect		eLink;
	effect		eCone		=	EffectVisualEffect(VFX_HIT_AOE_ICE);
	float		fDuration;
	float 		fDist;
	
	//determine duration of freeze + metmagic
	if (nCasterLvl > 25)
	{
		nCasterLvl	=	25;
	}
	if (nFreezeLvl > 10)
	{
		nFreezeLvl	=	10;
	}
	
	fDuration	=	RoundsToSeconds(nFreezeLvl);
	
	//link freeze effects
	eLink	=	EffectLinkEffects(eFreeze, eDur);
	eLink	=	EffectLinkEffects(eLink, eCold);
	eLink	=	EffectLinkEffects(eLink, eElec);
	eLink	=	EffectLinkEffects(eLink, eDR);
	eLink	=	EffectLinkEffects(eLink, eFire);
	eLink	=	EffectLinkEffects(eLink, eVis);


	object		oTarget		=	GetFirstObjectInShape(SHAPE_SPHERE, 15.0, lLocation, FALSE);
	//begin cycling targets + basic discrimination
	while (GetIsObjectValid(oTarget))
	{	//FoF discrimination
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster) && oTarget != oCaster)
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, 1045, TRUE));
			fDist = GetDistanceBetween(OBJECT_SELF, oTarget)/10;
			if (!OnHitResistSpell(oCaster, oTarget))
			{
				//determine damage + metamagic
				nDam	=	d6(nCasterLvl);
				if (OnHitSavingThrow(SAVING_THROW_FORT, oTarget, GetOnHitAbilityDC(OBJECT_SELF), SAVING_THROW_TYPE_COLD, oCaster))
					nDam	=	nDam / 2;
					
				DelayCommand(fDist, FreezeDamage(nDam, eLink, oTarget, fDuration)); //FIX: damage needs to be delayed, otherwise bad things happen
				string sReport = "<Color="+casterColor+">"+GetName(oCaster)+"</color><Color="+reportColor+"> damages "+GetName(oTarget)+": "+IntToString(nDam)+"</color>";
				DelayCommand(fDist, SendMessageToPC(oCaster, sReport));
			}
			
		}
		//cycle back to the next target
		oTarget		=	GetNextObjectInShape(SHAPE_SPHERE, 15.0, lLocation, FALSE);
	}
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCone, OBJECT_SELF, 3.0);
}

void FreezeDamage(int nDam, effect eFreeze, object oTarget, float fDuration)
{
    int bPlotImmortal = GetImmortal(oTarget);
    effect eDam = EffectDamage(nDam, DAMAGE_TYPE_COLD);
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ICE);

    SetImmortal(oTarget, TRUE); //spell should never kill creatures

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, fDuration);

    if (!bPlotImmortal) //remove immortality only from targets that were not immortal before spell is cast
    {
        SetImmortal(oTarget, FALSE);
    }

    //check HP of target, if HP < 10 deal freeze(link) effect	
    int nHP = GetCurrentHitPoints(oTarget);
    if (nHP <= 10)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFreeze, oTarget, fDuration);
    }
}