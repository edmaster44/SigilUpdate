//::///////////////////////////////////////////////
//:: Shout
//:: NX_s0_shout.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
 	
	Components: V
	SoE: 30ft. cone-shaped burst
	Saving Throw: Fortitude for 1/2 damage and 
	no deafness
	 
	Causes 5d6 sonic damage and Deaf status effect 
	for 2d6 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: 12.12.06
//:://////////////////////////////////////////////
//:: AFW-OEI 07/17/2007: NX1 VFX

#include "nw_i0_spells"
#include "x2_inc_spellhook"  
#include "nwn2_inc_metmag"
#include "ps_inc_onhit" 

void main() {

	int aID = GetOnHitAbilityID(OBJECT_SELF)+1751;
	object oCaster = GetOnHitAbilityCaster(OBJECT_SELF);
	string sSpellID = Get2DAString("iprp_onhit_abilities", "SpellID", aID);
	int nSpell = StringToInt(sSpellID);
	location lTarget = GetLocation(OBJECT_SELF);
	int nDC = GetOnHitAbilityDC(OBJECT_SELF);
	int nID = GetOnHitAbilityID(OBJECT_SELF);
	
	object		oTarget		=	GetFirstObjectInShape(SHAPE_SPHERE, 11.0, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	int			nDam;
	float		fDuration;
	effect		eDeaf		=	EffectDeaf();
	effect		eDam;
	effect		eImpact		=	EffectVisualEffect(VFX_HIT_SPELL_SHOUT);
	effect		eCone		=	EffectVisualEffect(VFX_DUR_CONE_SONIC);	
	effect		eLink;
	effect		eStun		=	EffectStunned();
	
	if (GetHasSpell(SPELL_GREATER_SHOUT, oCaster)) {
		while(GetIsObjectValid(oTarget))
		{
			if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
			{
				SignalEvent(oTarget, EventSpellCastAt(oCaster, 1038));
				if (oTarget != oCaster)
				{
					//determine duration and damage + metamagic
					nDam		=	d6(10);
					fDuration	=	RoundsToSeconds(d6(4));
									
					if (OnHitSavingThrow(SAVING_THROW_FORT, oTarget, GetOnHitAbilityDC(OBJECT_SELF), SAVING_THROW_TYPE_SONIC, oCaster))
					{
						nDam	=	nDam/2;
						eDam	=	EffectDamage(nDam, DAMAGE_TYPE_SONIC);
						
						eLink	=	EffectLinkEffects(eDam, eImpact);
						
						fDuration	=	fDuration/2;
						
						DelayCommand(0.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));
						ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDeaf, oTarget, fDuration);
						string sReport = "<Color="+casterColor+">"+GetName(oCaster)+"</color><Color="+reportColor+"> stuns and deafens "+GetName(oTarget)+"</color>";
						SendMessageToPC(oCaster, sReport);
						sReport = "<Color="+casterColor+">"+GetName(oCaster)+"</color><Color="+reportColor+"> damages "+GetName(oTarget)+": "+IntToString(nDam)+"</color>";
						SendMessageToPC(oCaster, sReport);
						
					}
					else
					{
						eDam	=	EffectDamage(nDam, DAMAGE_TYPE_SONIC);
						
						eLink	=	EffectLinkEffects(eDam, eImpact);
						
						DelayCommand(0.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));
						ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDeaf, oTarget, fDuration);
						ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, fDuration);
						string sReport = "<Color="+casterColor+">"+GetName(oCaster)+"</color><Color="+reportColor+"> stuns and deafens "+GetName(oTarget)+"</color>";
						SendMessageToPC(oCaster, sReport);
						sReport = "<Color="+casterColor+">"+GetName(oCaster)+"</color><Color="+reportColor+"> damages "+GetName(oTarget)+": "+IntToString(nDam)+"</color>";
						SendMessageToPC(oCaster, sReport);
					}
				}
			}
			
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, 11.0, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
		}
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCone, oCaster, 2.0);
	}
	else if (GetHasSpell(SPELL_SHOUT, oCaster)) {
		while(GetIsObjectValid(oTarget))
		{
			if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
			{
				SignalEvent(oTarget, EventSpellCastAt(oCaster, 1037));
				if (oTarget != oCaster)
				{
					//determine duration and damage + metamagic
					nDam		=	d6(5);
					fDuration	=	RoundsToSeconds(d6(2));
					
					nDam		=	ApplyMetamagicVariableMods(nDam, 30);
					fDuration	=	ApplyMetamagicDurationMods(fDuration);
					
									
					if (MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SONIC, oCaster))
					{
						nDam	=	nDam/2;
						eDam	=	EffectDamage(nDam, DAMAGE_TYPE_SONIC);
						
						eLink	=	EffectLinkEffects(eDam, eImpact);
						
						DelayCommand(0.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));
					}
					else
					{
						eDam	=	EffectDamage(nDam, DAMAGE_TYPE_SONIC);
						
						eLink	=	EffectLinkEffects(eDam, eImpact);
						
						DelayCommand(0.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));
						ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDeaf, oTarget, fDuration);
					}
				}
			}
			
			oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 11.0, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
		}
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCone, oCaster, 2.0);
	}
}