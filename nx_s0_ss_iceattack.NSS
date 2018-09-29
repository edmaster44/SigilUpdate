// Ice Attack Script for NX1 Silver Sword of Gith
// Adds polar-ray variant attack spell to sword.
// CGaw OEI 6/19/07

#include "NW_I0_SPELLS"    
#include "x2_inc_spellhook" 

void PlayCustomAnimationWrapper(object oObject, string sAnimationName, int nLoop, float fSpeed)
{
	PlayCustomAnimation(oObject, sAnimationName, nLoop, fSpeed);
}

void ExplodeDamage(object oTarget)
{
	location lTarget = GetLocation(oTarget);
	effect eDamage;
	int nDam;
	
	 //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
		{
			if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) == TRUE)
            {
                //Make SR check
                if(!MyResistSpell(OBJECT_SELF, oTarget))
                {
					nDam = d6(10);
			
                    //Make Will save versus fear
                    if(MySavingThrow(SAVING_THROW_REFLEX, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_SPELL))
                    {
						eDamage = EffectDamage(nDam/2, DAMAGE_TYPE_MAGICAL);
                    }	
					
					else
					{
				    	eDamage = EffectDamage(nDam, DAMAGE_TYPE_MAGICAL);	
					}
					
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);				
                }			
            }
        }

        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}

void CastSpell(float fDuration, int nEffect, int nTimesCast, int nTimesHit)
{
    if (!X2PreSpellCastCode())
    {	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    //Declare major variables
    object oTarget	 	= GetSpellTargetObject();
	int    nCasterLevel = GetCasterLevel(OBJECT_SELF);
	int nTouch = TouchAttackRanged(oTarget);
	effect eShake = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);
	effect eKnockdown = EffectKnockdown();
	
	nTimesCast = nTimesCast + 1;
	
	switch(nEffect)
	{
		case 0:
			nEffect = VFX_BEAM_ICE;
			break;
		case 1:
			nEffect = 963; //VFX_BEAM_ICE_KNEE;
			break;
		case 2:
			nEffect = 964; //VFX_BEAM_ICE_HEAD;
			break;
	}
	
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_POLAR_RAY));

		if (nTouch != TOUCH_ATTACK_RESULT_MISS)
		{	//Make SR Check
	        if(!MyResistSpell(OBJECT_SELF, oTarget))
	        {
	            //Enter Metamagic conditions
	 			int nDam = d6(10);
	    	
	            //Set damage effect
	            effect eDam = EffectDamage(nDam, DAMAGE_TYPE_COLD);
	   	 		effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ICE);
	
	            //Apply the VFX impact and damage effect
	            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
				
				nTimesHit = nTimesHit + 1;
	        }
		}
    }
	
    effect eRay = EffectBeam(nEffect, OBJECT_SELF, BODY_NODE_HAND);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, fDuration);
	
	if (nTimesCast == 1)
	{
		DelayCommand(0.40f, CastSpell(1.85, 1, nTimesCast, nTimesHit));
	}
	
	if (nTimesCast == 2)
	{
		DelayCommand(0.80f, CastSpell(1.05, 2, nTimesCast, nTimesHit));
	}
	
	if (nTimesCast == 3)
	{
		if (nTimesHit == 3)
		{
			effect eVis2 = EffectVisualEffect(VFX_HIT_AOE_HOLY);
			effect eVis3 = EffectVisualEffect(VFX_HIT_AOE_ICE);
			
			if (!MySavingThrow(SAVING_THROW_FORT, oTarget, 34))
			{
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, 6.0f);
			}

			ApplyEffectToObject(DURATION_TYPE_INSTANT, eShake, oTarget);
			DelayCommand(1.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis3, oTarget));
			DelayCommand(1.05f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
			DelayCommand(1.05f, ExplodeDamage(oTarget));
		}
	}
			
}

void main()
{
	object oPC = OBJECT_SELF;
	effect eEffect = EffectNWN2SpecialEffectFile("sp_ice_cast.sef");
	string sAttack = "1hs_multiattack0" + IntToString(Random(2) + 1);
				
	DelayCommand(0.25, PlayCustomAnimationWrapper(oPC, "1hs_multiattack01", 0, 1.0));

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oPC, 3.5f);
	DelayCommand(0.75f, CastSpell(2.25, 0, 0, 0));

}