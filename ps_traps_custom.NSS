#include "x0_i0_spells"
#include "NW_I0_SPELLS"

void main()
{
	// Initial stuff
	object oTarget = GetEnteringObject();
	int iBaseTrap = GetTrapBaseType(OBJECT_SELF);
	int iTrapDC; 
	int iTrapDiceNumber;
	int iTrapDuration;
	float fTrapRadius;
	// any other vars needed can be declared within the below statements.
	
	if (iBaseTrap >= 65 && iBaseTrap <= 69)
	{
		if (iBaseTrap == 65)
		{
			iTrapDiceNumber = 2;
		}
		else if (iBaseTrap == 66)
		{
			iTrapDiceNumber = 5;
		}
		else if (iBaseTrap == 67)
		{
			iTrapDiceNumber = 10;
		}
		else if (iBaseTrap == 68)
		{
			iTrapDiceNumber = 20;
		}
		else if (iBaseTrap == 69)
		{
			iTrapDiceNumber = 35;
		}
		else
		{
		// nothing... shouldn't happen.
		}
		DoTrapSpike(d6(iTrapDiceNumber));
	}
	else if (iBaseTrap >= 70 && iBaseTrap <= 74)
	{
		effect eDam;
		
		if (iBaseTrap == 70)
		{
			iTrapDiceNumber = 2;
		}
		else if (iBaseTrap == 71)
		{
			iTrapDiceNumber = 4;
		}
		else if (iBaseTrap == 72)
		{
			iTrapDiceNumber = 6;
		}
		else if (iBaseTrap == 73)
		{
			iTrapDiceNumber = 8;
		}
		else if (iBaseTrap == 74)
		{
			iTrapDiceNumber = 10;
		}
		else
		{
		// nothing... shouldn't happen.
		}
		if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
		{
			eDam = EffectDamage(d12(iTrapDiceNumber*2), DAMAGE_TYPE_DIVINE);
		}
		else
		{
			eDam = EffectDamage(d6(iTrapDiceNumber), DAMAGE_TYPE_DIVINE);
		}
		effect eVis = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	}
	else if (iBaseTrap >= 75 && iBaseTrap <= 79)
	{
		if (iBaseTrap == 75)
		{
			iTrapDuration = 3;
			iTrapDC = 20;
			fTrapRadius = RADIUS_SIZE_MEDIUM;
		}
		else if (iBaseTrap == 76)
		{
			iTrapDuration = 5;
			iTrapDC = 25;
			fTrapRadius = RADIUS_SIZE_MEDIUM;
		}
		else if (iBaseTrap == 77)
		{
			iTrapDuration = 8;
			iTrapDC = 30;
			fTrapRadius = RADIUS_SIZE_LARGE;
		}
		else if (iBaseTrap == 78)
		{
			iTrapDuration = 12;
			iTrapDC = 35;
			fTrapRadius = RADIUS_SIZE_LARGE;
		}
		else if (iBaseTrap == 79)
		{
			iTrapDuration = 17;
			iTrapDC = 40;
			fTrapRadius = RADIUS_SIZE_HUGE;
		}
		else
		{
		// nothing... shouldn't happen.
		}
		location lTarget = GetLocation(oTarget);
    	effect eSlow = EffectSlow();
    	effect eVis = EffectVisualEffect( VFX_DUR_SPELL_SLOW );
		
		oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fTrapRadius, lTarget);
    
    	while (GetIsObjectValid(oTarget))
	    {
        	if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, iTrapDC, SAVING_THROW_TYPE_TRAP))
        	{
            	//Apply slow effect and slow effect
            	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSlow, oTarget, RoundsToSeconds(iTrapDuration));
        	}
        	//Get next target in the shape.
        	oTarget = GetNextObjectInShape(SHAPE_SPHERE, fTrapRadius, lTarget);
    	}
	}
	else if (iBaseTrap >= 80 && iBaseTrap <= 84)
	{
		if (iBaseTrap == 80)
		{
			iTrapDuration = 2;
			iTrapDC = 15;
			iTrapDiceNumber = 3;
		}
		else if (iBaseTrap == 81)
		{
			iTrapDuration = 3;
			iTrapDC = 20;
			iTrapDiceNumber = 5;
		}
		else if (iBaseTrap == 82)
		{
			iTrapDuration = 4;
			iTrapDC = 25;
			iTrapDiceNumber = 12;
		}
		else if (iBaseTrap == 83)
		{
			iTrapDuration = 5;
			iTrapDC = 30;
			iTrapDiceNumber = 18;
		}
		else if (iBaseTrap == 84)
		{
			iTrapDuration = 6;
			iTrapDC = 35;
			iTrapDiceNumber = 25;
		}
		else
		{
		// nothing... shouldn't happen.
		}
		
		effect eDam = EffectDamage(d6(iTrapDiceNumber), DAMAGE_TYPE_ACID);
    	effect eHold = EffectParalyze(iTrapDC, SAVING_THROW_FORT);
    	effect eVis = EffectVisualEffect(VFX_IMP_ACID_L);
    	effect eDur = EffectVisualEffect(VFX_DUR_PARALYZED);
    	effect eLink = EffectLinkEffects(eHold, eDur);
		
		if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, iTrapDC, SAVING_THROW_TYPE_TRAP))
    	{
        	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(iTrapDuration));
    	}
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
    	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	}
	else if (iBaseTrap >= 85 && iBaseTrap <= 89)
	{
		if (iBaseTrap == 85)
		{
			iTrapDC = 18;
			iTrapDiceNumber = 5;
			fTrapRadius = RADIUS_SIZE_MEDIUM;
		}
		else if (iBaseTrap == 86)
		{
			iTrapDC = 20;
			iTrapDiceNumber = 8;
			fTrapRadius = RADIUS_SIZE_MEDIUM;
		}
		else if (iBaseTrap == 87)
		{
			iTrapDC = 23;
			iTrapDiceNumber = 15;
			fTrapRadius = RADIUS_SIZE_LARGE;
		}
		else if (iBaseTrap == 88)
		{
			iTrapDC = 26;
			iTrapDiceNumber = 25;
			fTrapRadius = RADIUS_SIZE_LARGE;
		}
		else if (iBaseTrap == 89)
		{
			iTrapDC = 30;
			iTrapDiceNumber = 37;
			fTrapRadius = RADIUS_SIZE_HUGE;
		}
		else
		{
		// nothing... shouldn't happen.
		}	
    	location lTarget = GetLocation(oTarget);
    	int nDamage;
    	
    	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fTrapRadius, lTarget);
		
    	while(GetIsObjectValid(oTarget))
	    {
			nDamage = d6(iTrapDiceNumber);
            //Adjust the trap damage based on the feats of the target
            if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, iTrapDC, SAVING_THROW_TYPE_TRAP))
            {
                if (GetHasFeat(FEAT_IMPROVED_EVASION, oTarget))
                {
                    nDamage /= 2;
                }
            }
            else if (GetHasFeat(FEAT_EVASION, oTarget) || GetHasFeat(FEAT_IMPROVED_EVASION, oTarget))
            {
                nDamage = 0;
            }
            else
            {
                nDamage /= 2;
            }
            if (nDamage > 0)
            {
				effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
				effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                DelayCommand(0.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
			}
			//Get next target in shape
        	oTarget = GetNextObjectInShape(SHAPE_SPHERE, fTrapRadius, lTarget);
        }
	}
	else if (iBaseTrap >= 90 && iBaseTrap <= 94)
	{
		int iAdditionalTargets;
		
		if (iBaseTrap == 90)
		{
			iTrapDC = 19;
			iTrapDiceNumber = 8;
			iAdditionalTargets = 3;
		}
		else if (iBaseTrap == 91)
		{
			iTrapDC = 22;
			iTrapDiceNumber = 15;
			iAdditionalTargets = 4;
		}
		else if (iBaseTrap == 92)
		{
			iTrapDC = 26;
			iTrapDiceNumber = 20;
			iAdditionalTargets = 5;
		}
		else if (iBaseTrap == 93)
		{
			iTrapDC = 28;
			iTrapDiceNumber = 30;
			iAdditionalTargets = 6;
		}
		else if (iBaseTrap == 94)
		{
			iTrapDC = 32;
			iTrapDiceNumber = 40;
			iAdditionalTargets = 8;
		}
		else
		{
		// nothing... shouldn't happen.
		}
		TrapDoElectricalDamage(d6(iTrapDiceNumber),iTrapDC,iAdditionalTargets);
	}
	else if (iBaseTrap >= 95 && iBaseTrap <= 99)
	{
		effect ePoison;
		
		if (iBaseTrap == 95)
		{
			ePoison = EffectPoison(POISON_GIANT_WASP_POISON);
			fTrapRadius = RADIUS_SIZE_MEDIUM;
		}
		else if (iBaseTrap == 96)
		{
			ePoison = EffectPoison(POISON_DEATHBLADE);
			fTrapRadius = RADIUS_SIZE_MEDIUM;
		}
		else if (iBaseTrap == 97)
		{
			ePoison = EffectPoison(POISON_DARK_REAVER_POWDER);
			fTrapRadius = RADIUS_SIZE_LARGE;
		}
		else if (iBaseTrap == 98)
		{
			ePoison = EffectPoison(POISON_BLACK_LOTUS_EXTRACT);
			fTrapRadius = RADIUS_SIZE_LARGE;
		}
		else if (iBaseTrap == 99)
		{
			ePoison = EffectPoison(POISON_COLOSSAL_SPIDER_VENOM);
			fTrapRadius = RADIUS_SIZE_HUGE;
		}
		else
		{
		// nothing... shouldn't happen.
		}
		location lTarget = GetLocation(oTarget);
    	int nDuration = 2;
		effect eAOE = EffectAreaOfEffect(AOE_PER_FOGACID, "****", "****", "****");
    	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
    
		oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fTrapRadius, lTarget);
		while(GetIsObjectValid(oTarget))
    	{
	        ApplyEffectToObject(DURATION_TYPE_INSTANT, ePoison, oTarget);
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, fTrapRadius, lTarget);
     	}
	}
	else if (iBaseTrap >= 100 && iBaseTrap <= 104)
	{
		if (iBaseTrap == 100)
		{
			iTrapDC = 14;
			iTrapDiceNumber = 2;
			iTrapDuration = 1;
		}
		else if (iBaseTrap == 101)
		{
			iTrapDC = 18;
			iTrapDiceNumber = 4;
			iTrapDuration = 2;
		}
		else if (iBaseTrap == 102)
		{
			iTrapDC = 22;
			iTrapDiceNumber = 6;
			iTrapDuration = 3;
		}
		else if (iBaseTrap == 103)
		{
			iTrapDC = 26;
			iTrapDiceNumber = 8;
			iTrapDuration = 4;
		}
		else if (iBaseTrap == 104)
		{
			iTrapDC = 30;
			iTrapDiceNumber = 10;
			iTrapDuration = 5;
		}
		else
		{
		// nothing... shouldn't happen.
		}
    	effect eDam = EffectDamage(d4(iTrapDiceNumber), DAMAGE_TYPE_COLD);
    	effect eParal = EffectParalyze(iTrapDC, SAVING_THROW_FORT);
    	effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
    	effect eFreeze = EffectVisualEffect(VFX_DUR_PARALYZED);
    	effect eLink = EffectLinkEffects(eParal, eFreeze);
    
    	if(!MySavingThrow(SAVING_THROW_FORT, oTarget, iTrapDC, SAVING_THROW_TYPE_TRAP))
    	{
        	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(iTrapDuration));
    	} 
    	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
    	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	}
	else if (iBaseTrap >= 105 && iBaseTrap <= 109)
	{
		if (iBaseTrap == 105)
		{
			iTrapDC = 10;
			iTrapDiceNumber = 10;
			fTrapRadius = RADIUS_SIZE_MEDIUM;
		}
		else if (iBaseTrap == 106)
		{
			iTrapDC = 14;
			iTrapDiceNumber = 13;
			fTrapRadius = RADIUS_SIZE_MEDIUM;
		}
		else if (iBaseTrap == 107)
		{
			iTrapDC = 18;
			iTrapDiceNumber = 16;
			fTrapRadius = RADIUS_SIZE_LARGE;
		}
		else if (iBaseTrap == 108)
		{
			iTrapDC = 22;
			iTrapDiceNumber = 19;
			fTrapRadius = RADIUS_SIZE_LARGE;
		}
		else if (iBaseTrap == 109)
		{
			iTrapDC = 26;
			iTrapDiceNumber = 22;
			fTrapRadius = RADIUS_SIZE_HUGE;
		}
		else
		{
		// nothing... shouldn't happen.
		}
		location lTarget = GetLocation(oTarget);
    	int nDamage;
    	effect eDam;
    	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fTrapRadius, lTarget);
		effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);
		
    	while(GetIsObjectValid(oTarget))
	    {
			nDamage = GetReflexAdjustedDamage(d8(iTrapDiceNumber), oTarget, iTrapDC, SAVING_THROW_TYPE_TRAP);
    		eDam = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
    		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
    		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        
        	oTarget = GetNextObjectInShape(SHAPE_SPHERE, fTrapRadius, lTarget);
		}
	}
	else if (iBaseTrap >= 110 && iBaseTrap <= 114)
	{
		if (iBaseTrap == 110)
		{
			iTrapDuration = 1;
			iTrapDC = 12;
			iTrapDiceNumber = 2;
			fTrapRadius = RADIUS_SIZE_MEDIUM;
		}
		else if (iBaseTrap == 111)
		{
			iTrapDuration = 2;
			iTrapDC = 14;
			iTrapDiceNumber = 3;
			fTrapRadius = RADIUS_SIZE_MEDIUM;
		}
		else if (iBaseTrap == 112)
		{
			iTrapDuration = 3;
			iTrapDC = 17;
			iTrapDiceNumber = 5;
			fTrapRadius = RADIUS_SIZE_LARGE;
		}
		else if (iBaseTrap == 113)
		{
			iTrapDuration = 4;
			iTrapDC = 20;
			iTrapDiceNumber = 8;
			fTrapRadius = RADIUS_SIZE_LARGE;
		}
		else if (iBaseTrap == 114)
		{
			iTrapDuration = 5;
			iTrapDC = 25;
			iTrapDiceNumber = 12;
			fTrapRadius = RADIUS_SIZE_HUGE;
		}
		else
		{
		// nothing... shouldn't happen.
		}
    	effect eStun = EffectStunned();
    	effect eFNF = EffectVisualEffect( VFX_HIT_SPELL_SONIC );
    	effect eMind = EffectVisualEffect( VFX_DUR_SPELL_DAZE );
    	effect eLink = EffectLinkEffects(eStun, eMind);
    	effect eDam;
		location lTarget = GetLocation(oTarget);
		
    	ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eFNF, lTarget);
    
		oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fTrapRadius, lTarget);
    	while (GetIsObjectValid(oTarget))
    	{
			eDam = EffectDamage(d4(iTrapDiceNumber), DAMAGE_TYPE_SONIC);
        	DelayCommand(0.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
        
        	if(!MySavingThrow(SAVING_THROW_WILL, oTarget, iTrapDC, SAVING_THROW_TYPE_TRAP))
        	{
            	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(iTrapDuration));
        	}
        	oTarget = GetNextObjectInShape(SHAPE_SPHERE, fTrapRadius, lTarget);
		}
        
    }
	else if (iBaseTrap >= 115 && iBaseTrap <= 119)
	{
		int iStatDmg;	
	
		if (iBaseTrap == 115)
		{
			iStatDmg = 2;
			iTrapDC = 12;
			iTrapDiceNumber = 2;
		}
		else if (iBaseTrap == 116)
		{
			iStatDmg = 4;
			iTrapDC = 15;
			iTrapDiceNumber = 4;
		}
		else if (iBaseTrap == 117)
		{
			iStatDmg = 6;
			iTrapDC = 18;
			iTrapDiceNumber = 6;
		}
		else if (iBaseTrap == 118)
		{
			iStatDmg = 8;
			iTrapDC = 21;
			iTrapDiceNumber = 8;
		}
		else if (iBaseTrap == 119)
		{
			iStatDmg = 10;
			iTrapDC = 25;
			iTrapDiceNumber = 12;
		}
		else
		{
		// nothing... shouldn't happen.
		}
    	effect eNeg = EffectAbilityDecrease(ABILITY_STRENGTH, iStatDmg);
    	effect eDam = EffectDamage(d6(iTrapDiceNumber), DAMAGE_TYPE_NEGATIVE);
    	eNeg = SupernaturalEffect(eNeg);
    	effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
		
    	if(!MySavingThrow(SAVING_THROW_FORT, oTarget, iTrapDC, SAVING_THROW_TYPE_TRAP))
    	{
        	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eNeg, oTarget);
    	}
    	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
    	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		
	}
	else
	{
		SpeakString("Not a known trap type!", TALKVOLUME_TALK);
	}
}