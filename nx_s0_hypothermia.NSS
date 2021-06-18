//::///////////////////////////////////////////////
//:: Hypothermia
//:: nx_s0_hypothermia.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	 	
	Hypothermia
	Evocation [Cold]
	Level: Cleric 4, druid 3
	Components: V, S
	Range: Close
	Target: One creature
	Saving Throw: Fortitude partial
	Spell Resistance: Yes
	 
	The subject takes 1d6 points of cold damage per 
	caster level (maximum 10d6) and becomes fatigued.  
	A successful Fortitude save halves the damage and 
	negates the fatigue.
	 
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: 12.06.2006
//:://////////////////////////////////////////////
// MDiekmann 5/21/07 - Modified code to use fatigue effect
// AFW-OEI 07/06/2007: Fatigue must be applied as a permanent effect.
// RPGplayer1 02/04/2009: Made SpellCastAt event hostile, so that caster drops invisibility properly

#include "nw_i0_spells"
#include "x2_inc_spellhook" 
#include "nwn2_inc_metmag"
#include "nwn2_inc_spells"
#include "ps_inc_functions"


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

//Major variables
	object 	oTarget 	= 	GetSpellTargetObject();
	object 	oCaster 	= 	OBJECT_SELF;
	int		nCasterLvl	=	PS_GetCasterLevel(OBJECT_SELF);
	int		nDam;
	int 	nMetaMagic = GetMetaMagicFeat();
	effect	eFatigue    =   EffectFatigue();  
	effect	eDam;
	//effect 	eVis		=	EffectVisualEffect(VFX_HIT_SPELL_ICE);
	//effect	eLink;	
	
	
//Cap caster level for purposes of limiting damage


//Determine damage
			nDam		=	d3(nCasterLvl);
			eDam		=	EffectDamage(nDam, DAMAGE_TYPE_COLD);
			
			if (nMetaMagic == METAMAGIC_MAXIMIZE)
			{
			nDam = (nDam*2);
			}
			else if (nMetaMagic == METAMAGIC_EMPOWER)
			{
			nDam = nDam + nDam / 2;
			}
			
			
//Link up effects
			//eLink		=	EffectLinkEffects(eDam, eVis);

//Validate target and apply effects
//Target Discrimination

	if (GetIsObjectValid(oTarget))
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
		{	
			//Target is valid, cast spell and then run spell resistance and saving throw before applying effect
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 1031, TRUE));
			
			if (!MyResistSpell(oCaster, oTarget))
			{
				if (MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_COLD, oCaster))
				{
					//Apply half damage, linked effects must be re-linked.
					eDam	=	EffectDamage(nDam/2, DAMAGE_TYPE_COLD);
					//eLink	=	EffectLinkEffects(eDam, eVis);
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
				}
				else
				{
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
					ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFatigue, oTarget);
				}
			}
		}
	}
}
					