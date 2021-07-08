//////////////////////////////////////////////
// Heartbeat script for Freezing Fog AOE	//
// Ceremorph 4/26/16						//
//////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "ps_inc_functions"

void main()
{
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage, nSave;
	int PML = GetPureMageLevels(OBJECT_SELF);
	int nCL = PS_GetCasterLevel(OBJECT_SELF);
    effect eDam, eHalfDam, eSlow, eLink, eLink2;
    object oTarget;
    effect eVis = EffectNWN2SpecialEffectFile("sp_rayfrost_hit", oTarget);
    float fDelay;
	
    effect eFall = EffectKnockdown();

    if (!GetIsObjectValid(GetAreaOfEffectCreator()))
    {	DestroyObject(OBJECT_SELF);
        return;		}

    oTarget = GetFirstInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
        {	fDelay = GetRandomDelay(0.5, 2.0);
            SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELL_INCENDIARY_CLOUD));
            nDamage = d3(nCL/3) + d3(PML/9);
            if (nMetaMagic == METAMAGIC_MAXIMIZE)
            {	nDamage = nDamage + ((3*nDamage)/4);	}
            if (nMetaMagic == METAMAGIC_EMPOWER)
            {	nDamage = nDamage + (nDamage/2);	}
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
			
			if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
            {
            	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFall, oTarget, 4.0));
            }
        }
        oTarget = GetNextInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}