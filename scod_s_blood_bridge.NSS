//::///////////////////////////////////////////////
//:: Healing Sting
//:: nx2_s0_healing_sting.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Healing Sting
	Necromancy
	Level: Druid 2
	Components: V, S
	Range: Touch
	Targets: You and one living creature
	Saving Throw: None
	Spell Resistance: Yes
	 
	Focusing the power of negative energy, you deal 1d12 points of damage +1 per caster level 
	(maximum 1d12+10) to a living creature and gain and equal amount of hit points if you make a successful melee touch attack.  
	A healing sting cannot give you more hit points than your full normal total.  
	Excess hit points are lost.
*/
//:://////////////////////////////////////////////
//:: Created By: Michael Diekmann
//:: Created On: 08/28/2007
//:://////////////////////////////////////////////
//:: RPGplayer1 11/22/2008: Added support for metamagic
//:: RPGplayer1 11/22/2008: Added SR check

#include "nwn2_inc_spells"
#include "x2_inc_spellhook"
#include "x0_i0_match"

void main()
{
    if (!X2PreSpellCastCode())
    {
	    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
	// Get necessary objects
	object oTarget			= GetSpellTargetObject();
	object oCaster			= OBJECT_SELF;
	int nMetaMagic = GetMetaMagicFeat();
	// Caster level
	int nCasterLevel		= GetCasterLevel(oCaster);
	if(nCasterLevel > 20)
		nCasterLevel = 20;
	// Effects
	int nDamage				= d4(1) + nCasterLevel;
	if (nMetaMagic == METAMAGIC_MAXIMIZE)
       {
          nDamage = 4 * nCasterLevel;
       }
    else if (nMetaMagic == METAMAGIC_EMPOWER)
       {
           nDamage = nDamage + nDamage / 2;
       }

	effect eDamage 			= EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
	int nHeal				= nDamage;
	int nMaxHP 				= GetMaxHitPoints(oTarget);
	int nCurrentHP			= GetCurrentHitPoints(oTarget);
	if(nHeal + nCurrentHP > nMaxHP)
	{
		nHeal = nMaxHP - nCurrentHP;
		nHeal = nDamage;
	}
	effect eHeal			= EffectHeal(nHeal);
	effect eVisual			= EffectVisualEffect(VFX_HIT_SPELL_HEALING_STING);
	effect eVisual2			= EffectVisualEffect(VFX_HEAL_SPELL_HEALING_STING);
	effect eLink			= EffectLinkEffects(eVisual, eDamage);
	effect eLink2			= EffectLinkEffects(eVisual2, eHeal);
	
	// Make sure spell target is valid and living
	if (GetIsObjectValid(oTarget) && !MatchNonliving(GetRacialType(oTarget)))
	{
		// check to see if hostile
		if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster)) 
		{
			
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink2, oTarget);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oCaster);
		
			//Fire cast spell at event for the specified target
  			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), TRUE));
		}
	}
}