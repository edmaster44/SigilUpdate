//:://////////////////////////////////////////////////////////////////////////
//:: Warlock Greater Invocation: Chilling Tentacles  ON ENTER
//:: nw_s0_chilltent.nss
//:: Created By: Brock Heinz - OEI
//:: Created On: 08/30/05
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
        Chilling Tentacles
        Complete Arcane, pg. 132
        Spell Level:	5
        Class: 		    Misc

        This functions identically to the Evard's black tentacles spell 
        (4th level wizard) except that each creature in the area of effect
        takes an additional 2d6 of cold damage per round regardless 
        if tentacles hit them or not.
	
		Upon entering the mass of "soul-chilling" rubbery tentacles the
		target is struck by 1d4 tentacles.  Each has a chance to hit of 5 + 1d20. 
		If it succeeds then it does 2d6 damage and the target must make
		a Fortitude Save versus paralysis or be paralyzed for 1 round.

*/
//:://////////////////////////////////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "nwn2_inc_spells"


void main()
{
	//SpawnScriptDebugger();
	

    object oCaster = GetAreaOfEffectCreator();
	
	int nCasterLevel = GetWarlockCasterLevel(oCaster);
	int nCHAMod = GetAbilityModifier(ABILITY_CHARISMA, oCaster);
    object oTarget = GetEnteringObject();
	int nSaveDC = GetSpellSaveDC();
    effect eParal = EffectParalyze(nSaveDC, SAVING_THROW_FORT);
    effect eDur = EffectVisualEffect(VFX_DUR_PARALYZED);
    effect eLink = EffectLinkEffects(eDur, eParal);
    effect eDam;

    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    int nAC = GetAC(oTarget);
    int nHits = d4();
    int nRoll;
    float fDelay;
    if (GetIsEnemy(oTarget, oCaster)) {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt( oCaster, SPELL_I_CHILLING_TENTACLES));
		nHits = d4();
		float fDelta = RoundsToSeconds( 1 ) / IntToFloat( nHits );
		int nCounter;
			
        for (nCounter = 1; nCounter <= nHits; nCounter++)
        {
            fDelay = GetRandomDelay(1.0, 2.2);
			
			int n20 = d20();
            nRoll = nCasterLevel + nCHAMod + n20; //AB is Caster Level + CHA
			
            if( ((nRoll >= nAC) || (n20 == 20)) && (n20 != 1) ) //auto-success on 20, failure on 1
            {
                nDamage = d6() + nCHAMod; //Add charisma to damage
                //Enter Metamagic conditions
                if (nMetaMagic == METAMAGIC_MAXIMIZE)
                {
                    nDamage = 6 + nCHAMod;//Damage is at max
                }
                else if (nMetaMagic == METAMAGIC_EMPOWER)
                {
                    nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
                }
				
				eDam = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_PLUS_TWO);
	            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
				
	            if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC, SAVING_THROW_TYPE_NONE, oCaster, fDelay))
	            {
	                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1)));
	            }
            }
        }

        // Apply Cold Damage regardless of whether or not any tentacles struck the target.... 
        fDelay  = GetRandomDelay(0.4, 0.8);
        nDamage = d6(2);
		if (nCasterLevel >= 28) {
			nDamage = d6(4);
        	nDamage = ApplyMetamagicVariableMods( nDamage, 4*6 );
		} else if (nCasterLevel >= 21) {
			nDamage = d6(3);
        	nDamage = ApplyMetamagicVariableMods( nDamage, 3*6 );
		} else {
        	nDamage = ApplyMetamagicVariableMods( nDamage, 2*6 );
		}
        eDam = EffectDamage(nDamage, DAMAGE_TYPE_COLD);
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
    }
}