//////////////////////////////////////////
// On Enter script for Freezing Fog AOE	//
// Ceremorph 4/26/16					//
//////////////////////////////////////////
#include "X0_I0_SPELLS"
#include "ps_inc_functions"

void main()
{
	int nMetaMagic = GetMetaMagicFeat();
    int nDamage, nSave;
	int nCL = PS_GetCasterLevel(OBJECT_SELF);
    effect eDam, eHalfDam, eSlow, eLink, eLink2;
    object oTarget;
    effect eVis 	= EffectNWN2SpecialEffectFile("sp_rayfrost_hit", oTarget);
    float fDelay;
    oTarget 		= GetEnteringObject();

    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
    {   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 1229));
            fDelay = GetRandomDelay(0.5, 2.0);
            nDamage = d4(nCL/3);
        if (nMetaMagic == METAMAGIC_MAXIMIZE)
        {	nDamage = nDamage*2;	}
        if (nMetaMagic == METAMAGIC_EMPOWER)
       	{	nDamage = nDamage + (nDamage/2);	}
        //Adjust damage for Reflex Save, Evasion and Improved Evasion
        eDam 		= EffectDamage(nDamage, DAMAGE_TYPE_COLD);
		eHalfDam	= EffectDamage(nDamage / 2, DAMAGE_TYPE_COLD);
		eLink 		= EffectLinkEffects(eDam, eVis);
		eLink2		= EffectLinkEffects(eHalfDam, eVis);
		eSlow 		= EffectSlow();
		nSave		= ReflexSave(oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_COLD, GetAreaOfEffectCreator() );
		
		if (oTarget == GetAreaOfEffectCreator())
		{	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));	}
		else
		{	if (nSave == 2)
			{	return;	}
			else if (nSave == 1)
			{	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink2, oTarget));	}
			else
        	{	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));
            	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSlow, oTarget, TurnsToSeconds(1)));	}
		}
    }
}