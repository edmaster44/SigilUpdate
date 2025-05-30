//::///////////////////////////////////////////////
//:: Scorching Ray
//:: [NX1_S0_scorchingraysingle.nss]
//:: Copyright (c) 2007 Obsidian Ent.
//:://////////////////////////////////////////////
//:: Targets a single enemy and shoots up to 3
//:: rays of fire at them, each ray doing 4d6
//:: damage.  
//:: 1 ray at level 3, 2 rays at level 7, 3 rays at level 11.
//:://////////////////////////////////////////////
//:: Created By: Ryan Young
//:: Created On: 1.17.2007
//:://////////////////////////////////////////////

// Note: There is some tricky delay timing going on
// (see var fDelay).  All that's happening is that
// I'm delaying the all the special effects to coincide
// with the character's animation (arm extends, etc).
//::PKM-OEI: 05.29.07: Touch attacks now do critical hit damage
//:: -modernized metamagic behaviors

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "nwn2_inc_spells"
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
    object oTarget = GetSpellTargetObject();
    int nCasterLvl = GetTotalLevels(OBJECT_SELF, TRUE);
	effect eRay;
	
	int nNumRays = nCasterLvl/3;
	
	if (nNumRays < 1) nNumRays = 1;

	
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
		int ni=0;
		//float fDelay = 2.5;
		float fDelay = 0.75;
		
		effect eFire = EffectNWN2SpecialEffectFile("fx_ignition");
		//ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFire, oTarget, fDelay+(nNumRays-1));
		
		effect eMantle = GetFirstEffect(oTarget);
		while (GetIsEffectValid(eMantle) &&
			(GetEffectSpellId(eMantle) != SPELL_LEAST_SPELL_MANTLE) &&
			(GetEffectSpellId(eMantle) != SPELL_LESSER_SPELL_MANTLE) &&
			(GetEffectSpellId(eMantle) != SPELL_SPELL_MANTLE) &&
			(GetEffectSpellId(eMantle) != SPELL_GREATER_SPELL_MANTLE))
		{
			eMantle = GetNextEffect(oTarget);
		}
		if (GetIsEffectValid(eMantle)) //has Spell Mantle, do MyResistSpell just once, plus visuals
		{
			int bResisted = FALSE;
			eRay = EffectBeam(VFX_BEAM_FIRE, OBJECT_SELF, BODY_NODE_HAND);
			while (ni<nNumRays)
			{
			        //Fire cast spell at event for the specified target
			        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
				int nTouch      = TouchAttackRanged(oTarget);

				// Ray spells require a ranged touch attack
				if (nTouch != TOUCH_ATTACK_RESULT_MISS && bResisted == FALSE)
				{
				    MyResistSpell(OBJECT_SELF, oTarget);
				    bResisted = TRUE;
				}
			   	DelayCommand((fDelay-0.5), ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 0.5));

				ni++;
				fDelay = fDelay + 1.6f;
			}
		}
		else
		{
		while (ni<nNumRays) {
			
	        //Fire cast spell at event for the specified target
	        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
			int nTouch      = TouchAttackRanged(oTarget);
	 
			// Ray spells require a ranged touch attack
			if (nTouch != TOUCH_ATTACK_RESULT_MISS)
			//if (FALSE)
			{	//Make SR check
	        	if (!MyResistSpell(OBJECT_SELF, oTarget))
	        	{	
					int nDamage = d6(4);
					nDamage = ApplyMetamagicVariableMods(nDamage, 24);
					if (nTouch == TOUCH_ATTACK_RESULT_CRITICAL && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
					{
						nDamage = d6(8);
						nDamage = ApplyMetamagicVariableMods(nDamage, 48);
					}
				
					 
					// sneak can only apply to first ray.
					if (ni == 0)
					{
						// If applicable adds any sneak damage to total to be inflicted and reports the damage.
						nDamage += PS_AddSneakDmgToSpell(OBJECT_SELF, oTarget, DAMAGE_TYPE_FIRE);
					}	
	                //Set ability damage effect
	                effect eFireDamage = EffectDamage(nDamage, DAMAGE_TYPE_FIRE, DAMAGE_POWER_NORMAL, FALSE);
	  			    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_FIRE);
	                effect eLink = EffectLinkEffects(eFireDamage, eVis);
					eRay = EffectBeam(VFX_BEAM_FIRE, OBJECT_SELF, BODY_NODE_HAND);
	
	                //Apply the ability damage effect and VFX impact
	                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));
				}
				eRay = EffectBeam(VFX_BEAM_FIRE, OBJECT_SELF, BODY_NODE_HAND); //FIX: show when spell is resisted too
	        }
			else {
				eRay = EffectBeam(VFX_BEAM_FIRE, OBJECT_SELF, BODY_NODE_HAND);		// ,FALSE for miss ray (that doesn't work)
				
				
			}
			DelayCommand((fDelay-0.5), ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 0.5));
				
			ni++;
			//if (ni == 1)
				fDelay = fDelay + 1.6f;
			//else
			//	fDelay = fDelay + 1.0f;
		}
		}
    }
}