//::///////////////////////////////////////////////
//:: Dread Seizure
//:: nx_s0_dreadseizure.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
 	Dread Seizure
	Lesser, 4th
	
	You speak a word that sends wracking pain through
	the limbs of a single target creature within
	60ft.  Though these seizures are not powerful
	enough to immobilize the creature, they do
	reduce its movement speed by 30%.  The target
	also takes a -3 penalty to all attacks it makes.
	These effects last for 3 rounds; a successful 
	Fortitude save negates the effects.
*/
//:://////////////////////////////////////////////
//:: Created By: Ryan Young
//:: Created On: 1.22.2007
//:://////////////////////////////////////////////
/*
rapsam2003 03/16/2018: Remove save against NPCs
	and Hexer feats increase the miss chance 
	of the target.
MimiFearthegn 8/11/2020: fixed some bugs with how cursemaster was handled
*/

#include "nw_i0_spells"
#include "x2_inc_spellhook" 
#include "nwn2_inc_metmag"
#include "srcalc"


void main()
{
    /*
      Spellcast Hook Code
      Added 2003-07-07 by Georg Zoeller
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more

    */
    if (!X2PreSpellCastCode())
    {
    	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

	// End of Spell Cast Hook

	effect eMissChance;
	object oCaster = OBJECT_SELF;
	int nMod = 3;
	
	if (GetHasFeat(2907, oCaster)) 
		nMod = 5;
	else if (GetHasFeat(2903, oCaster)) 
		nMod = 4;
	
	object oTarget = GetSpellTargetObject();
	effect eAttackPenalty =	EffectAttackDecrease(nMod);
	effect eMovePenalty	= EffectMovementSpeedDecrease(nMod*10);
	effect eLink = EffectLinkEffects(eAttackPenalty, eMovePenalty);
	float fDuration	= RoundsToSeconds(nMod);
	int nMissChance = 0;
	
	//metamagic
	fDuration	=	ApplyMetamagicDurationMods(fDuration);

	// rapsam2003: For Dread Seizure, these feats
	// increase the miss chance.
	if (GetHasFeat(2901, oCaster))
		nMissChance = 15;
	else if (GetHasFeat(2900, oCaster))
		nMissChance = 10;
	else if (GetHasFeat(2908, oCaster))
		nMissChance = 5;
		
	if (nMissChance > 0)
	{
		eMissChance = EffectMissChance(nMissChance);
		eLink = EffectLinkEffects(eMissChance, eLink);
	}	
	
	//Signal spell cast at event.
	SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));
	
	//Cursemaster feat makes this an AoE
	if (GetHasFeat(2907, oCaster)) {
		location locTarget = GetLocation(oTarget);
		oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, locTarget, TRUE, OBJECT_TYPE_CREATURE);
		    
		while (GetIsObjectValid(oTarget))
		{			    
			// Fortitude Save for PCs.
		    if (GetIsPC(oTarget) && !MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC())) 
		    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
			else // No save for monsters.
		        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
			
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, locTarget, TRUE, OBJECT_TYPE_CREATURE);
		}
		
	} else {
	
		if (!DoWarlockMyResistSpell(oCaster, oTarget)) {
			// Fortitude Save for PCs.
		    if (GetIsPC(oTarget) && !MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC())) 
		    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
			else // No save for monsters.
		        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
		}
		
	}
}