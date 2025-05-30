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
//Mymothersmeatloaf 6/20/2020: Increased damage based on casting stat, increased deafened rounds based on half casting stat
#include "nw_i0_spells"
#include "x2_inc_spellhook"  
#include "nwn2_inc_metmag"
#include "ps_inc_functions"

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

//Declare major variables

	location	lTarget		=	GetSpellTargetLocation();
	object		oCaster		=	OBJECT_SELF;
	object		oTarget		=	GetFirstObjectInShape(SHAPE_SPELLCONE, 11.0, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	int			nDam;
	int 		nCasterLvl = PS_GetCasterLevel(OBJECT_SELF);
	int			nMetaMagic = GetMetaMagicFeat();
	int		    PML = GetPureMageLevels(OBJECT_SELF);
	float		fDuration;
	effect		eDeaf		=	EffectDeaf();
	effect		eDam;
	effect		eImpact		=	EffectVisualEffect(VFX_HIT_SPELL_SHOUT);
	effect		eCone		=	EffectVisualEffect(VFX_DUR_CONE_SONIC);	
	effect		eLink;
	

	
	while(GetIsObjectValid(oTarget))
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 1037));
			if (oTarget != oCaster)
			{
				//determine duration and damage + metamagic
				nDam		=	d4(nCasterLvl) + d4(PML/3);
				if (nCasterLvl < 20 && !GetIsObjectValid(GetSpellCastItem()) && GetIsPC(OBJECT_SELF)){
				nDam = d4(20) + d4(PML/3);
				} 
				fDuration	=	RoundsToSeconds(d6(2));
				
				    if (nMetaMagic == METAMAGIC_MAXIMIZE)
                    {
                        nDam = nDam + ((3*nDam)/4);
                    }
        	        else if (nMetaMagic == METAMAGIC_EMPOWER)
                    {
                       nDam = nDam + nDam / 2;
                    }
				
				fDuration	=	ApplyMetamagicDurationMods(fDuration);
				
								
				if (MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_SONIC, oCaster))
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
			