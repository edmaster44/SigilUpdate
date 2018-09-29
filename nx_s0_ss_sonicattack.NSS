// Sonic Attack Script for NX1 Silver Sword of Gith
// Adds AOE-variant sonic attack to sword.
// CGaw OEI 6/19/07

#include "nw_i0_spells"
#include "x2_inc_spellhook"  
#include "nwn2_inc_metmag"

void PlayCustomOneShotAnimation(object oObject, string sAnimationName, float fSpeed)
{
	PlayCustomAnimation(oObject, sAnimationName, 0, fSpeed);
}

void CastSpell()
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

	location lTarget = GetSpellTargetLocation();
	object oCaster = OBJECT_SELF;
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_VAST, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	int nDam;
	float fDuration;
	float fDuration2;
	float fStun = RoundsToSeconds(2);
	effect eDeaf = EffectDeaf();
	effect eDam;
	effect eImpact = EffectVisualEffect(VFX_COM_HIT_SONIC);
	effect eCone = EffectVisualEffect(VFX_DUR_CONE_SONIC);	
	effect eStun = EffectStunned();
	effect eLink;
	effect eShake = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);
	effect eKnockdown = EffectKnockdown();
	
	while(GetIsObjectValid(oTarget))
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 1038));
			if (oTarget != oCaster)
			{
				//determine duration and damage
				nDam = d6(25);
				fDuration =	RoundsToSeconds(d6(4));		
				fDuration2 = RoundsToSeconds(d3(1));
								
				if (MySavingThrow(SAVING_THROW_FORT, oTarget, 32, SAVING_THROW_TYPE_SONIC, oCaster))
				{
					nDam = nDam/2;
					eDam = EffectDamage(nDam, DAMAGE_TYPE_SONIC);
					
					eLink = EffectLinkEffects(eDam, eImpact);
					
					fDuration = fDuration/2;
					
					DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));
					DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDeaf, oTarget, fDuration));
					
				}
				else
				{
					eDam	=	EffectDamage(nDam, DAMAGE_TYPE_SONIC);
					
					eLink	=	EffectLinkEffects(eDam, eImpact);
					
					DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));
					DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDeaf, oTarget, fDuration));
					DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, fDuration2));
				}
			}
		}
		
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_VAST, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	}
	
	DelayCommand(0.25f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, oCaster, 0.25f));
}



void main()
{
	object oPC = OBJECT_SELF;
	effect eEffect = EffectNWN2SpecialEffectFile("sp_sonic_cast_silent.sef");
	effect eCone = EffectNWN2SpecialEffectFile("sp_sonic_cone_mouth.sef");	
	effect eWave = EffectNWN2SpecialEffectFile("sp_sonic_aoe_2.sef");
				
	PlayCustomOneShotAnimation(oPC, "1hS_whirlwind", 0.75);

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oPC, 2.0f);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCone, oPC, 2.0);	
	DelayCommand(1.0f, PlaySound("cb_whirlwind"));
	DelayCommand(1.5f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWave, oPC, 4.0));	
	DelayCommand(1.0f, CastSpell());
}
			