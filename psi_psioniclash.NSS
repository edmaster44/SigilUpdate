//::///////////////////////////////////////////////
//:: Psionic Lash
//:: psi_psioniclash
//:://////////////////////////////////////////////
/*
    1d4 Damage per 5 levels of Pison (maximum of 5d4)
	Save vs. Confusion or PP Damage (for Psion)
*/
//:://////////////////////////////////////////////
//:: Created By: Xndar
//:: Created On: February 15, 2015
//:://////////////////////////////////////////////

#include "psi_inc_manifest"
#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "ps_inc_functions"

void main()
{
	if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

		
	object oTarget = GetSpellTargetObject();
	int nPP = GetLocalInt(oTarget, "PSI_PP");
	//Fetch the Power Point Pool of target, if any.
    int nCasterLevel = GetLevelByClass(90, OBJECT_SELF);
	if(GetLevelByClass(152, OBJECT_SELF) > 0)
	{
        nCasterLevel = nCasterLevel + GetLevelByClass(152, OBJECT_SELF);
    }
	if(GetLevelByClass(128, OBJECT_SELF) > 0)
	{
        nCasterLevel = nCasterLevel + GetLevelByClass(128, OBJECT_SELF);
    }
	
	effect ePsiConfuse = EffectConfused();
	effect eVis = EffectVisualEffect( VFX_DUR_SPELL_CONFUSION );
	effect eVis2 = EffectNWN2SpecialEffectFile("psi_psionic_lash_imp", oTarget);
	effect eLink = EffectLinkEffects(eVis, ePsiConfuse);
	//Visual effects, status effect definition.
	
	int nInt = GetAbilityModifier(ABILITY_INTELLIGENCE, OBJECT_SELF);
	int nDuration = d2(1);
	int nSaveDC = 11 + nInt;
	if (GetHasFeat(2862, OBJECT_SELF) == TRUE)
	{
		nSaveDC = nSaveDC + 1;
		//Checks for 'Psionic Heritage' feat. Gives a +1 bonus to DC if the psion has this feat.
	}
	if (GetHasFeat(1114, OBJECT_SELF) == TRUE)
	{
		nSaveDC = nSaveDC + 1;
		//Checks for 'Spellcasting Prodigy' feat. Gives +1 bonus to DC if possessed, as DC is Int based.
	}
	
	int nDice = 1;
	int nDamage = 0;
	// Calculate number of damage dice. 1 die at level 1, and 1 additional die every 3 levels afterward.
	if (nCasterLevel >= 28)
		nDice = 10;
	else if (nCasterLevel >= 25)
		nDice = 9;
	else if (nCasterLevel >= 22)
		nDice = 8;
	else if (nCasterLevel >= 19)
		nDice = 7;
	else if (nCasterLevel >= 16)
		nDice = 6;
	else if (nCasterLevel >= 13)
		nDice = 5;
	else if (nCasterLevel >= 10)
		nDice = 4;
	else if (nCasterLevel >= 7)
		nDice = 3;
	else if (nCasterLevel >= 4)
		nDice = 2;
		
	if (GetSubRace(OBJECT_SELF) == 57 || 58 || 1)
	{
		if (GetRacialType(oTarget) == 7)
		{
			nDice = nDice +1;
		}
	}
	// Calculate damage	dice.
	nDamage = d4(nDice);
	
	if (GetHasFeat(21382, OBJECT_SELF) == TRUE)
	{
		nSaveDC = nSaveDC + 1;
		nDamage = d4(nDice + 1);
		eVis2 = EffectNWN2SpecialEffectFile("psi_imppsionic_lash_imp", oTarget);
		//Boost DC by 1 and number of damage dice by 1 if psion has 'Improved Psionic Lash' feat.
	}
	
	int nPPDamage = nDamage;
	int nPPFinal = nPP - nPPDamage;	
	if (nPPFinal < 0)
	{
		nPPFinal == 0;
	}
	
	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		if(!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS))
		//Completely ineffective against creatures immune to mind-effecting spells.
		{
		 	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_LESSER_ORB_OF_ELECTRICITY));
		 
			
				
			effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL);
			//Defining the damage type and calling the damage amount for the lash.
			
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis2, OBJECT_SELF, 1.7);
			if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nSaveDC))
			{
				if(!GetLevelByClass(90, oTarget))
				{
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
					//Non-psions must save vs. being confused for 1d2 rounds.
				}
				else
				{
					SetLocalInt(oTarget, "PSI_PP", nPPFinal);
					SendMessageToPC(OBJECT_SELF, "Psionic Lash Drained  " + IntToString(nPPDamage) + " Power Points!");
					SendMessageToPC(oTarget, "Enemy Psionic Lash Drained  " + IntToString(nPPDamage) + " Power Points!");
					SetGUIObjectText(oTarget, "powerpointscreen", "PPRatioTXT", -1, IntToString(nPPFinal));
					SendMessageToPC(oTarget, "Power Points Remaining:  " + IntToString(nPPFinal));
					SetGUIObjectText(oTarget, "powerpointscreen", "PPRatioTXT", -1, IntToString(nPPFinal));
					//Psions must save vs. suffering Power Point loss equal to the magical damage dealt by the lash. Includes battle
					//log text to inform both caster and target of this power point drain if it occurs.
				}	
			}
		}
		else
		{	
			FloatingTextStringOnCreature("Psionic Lash Not Possible.",OBJECT_SELF, FALSE, 5.0);
			SendMessageToPC(oTarget, "Enemy Psionic Lash Resisted" );
		}			 
	}
	
}