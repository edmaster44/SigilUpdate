#include "x2_inc_spellhook"
#include "aaa_constants"
#include "X0_I0_SPELLS"
#include "nw_i0_spells"
#include "ps_inc_functions"
#include "nwn2_inc_spells"
#include "ps_inc_faction"
#include "x2_inc_itemprop"
#include "x2_inc_toollib"
#include "nwn2_inc_metmag"
#include "ps_inc_advscript"

/*	This is the include file for custom feats which are not tied to any specific class.

	//////////////////////////////////////////////////////////////////////////////////////////
	//////////					Let The Magic Begin!								//////////
	//////////////////////////////////////////////////////////////////////////////////////////	*/

const int FEAT_BACKGROUND_SACRED_VOW 			= 2627;
const int FEAT_BACKGROUND_UNHALLOWED 			= 2628;
const int FEAT_PSIONICALLY_GIFTED				= 2862;
const int FEAT_PSIONIC_THRUST					= 2863;
const int FEAT_PSIONIC_DOMINATION				= 2864;
const int FEAT_PSIONIC_BODY_ADJUSTMENT			= 2865;
const int FEAT_PSIONIC_OVERCHARGE				= 2866;
const int FEAT_BACKGROUND_STERN                 = 3100;
const int FEAT_BACKGROUND_MISDIRECTOR           = 3101;
const int FEAT_BACKGROUND_TINKER                = 3102;
const int FEAT_BACKGROUND_NATURALIST             = 3103;
const int FEAT_BACKGROUND_AMICABLE              = 3104;


void PS_Feat_Counterspell(object oPC, object oTarget)
{
	if (!X2PreSpellCastCode())
	{	return;		}

	PS_ActivateCounterSpell(oTarget);
	return;
}

// Helper feat for PS_Feat_ControlUndead
void PrintControlMaxLevel(int nControlMaxLevel)
{
	string sControlMaxLevel 			= IntToString( nControlMaxLevel );
	string sControlMaxLevelFeedbackMsg 	= "<c=tomato>" + "Highest Level of Creature Affected" + " : </c>" +  sControlMaxLevel;

	SendMessageToPC( OBJECT_SELF, sControlMaxLevelFeedbackMsg );
}

// Helper feat for PS_Feat_ControlUndead
void PrintCreatureLevel(int nCreatureLevel)
{
	string sCreatureLevel 				= IntToString( nCreatureLevel );
	string sCreatureLevelFeedbackMsg 	= "<c=tomato>" + "Hit Dice of Creature Affected" + " : </c>" +  sCreatureLevel;

	SendMessageToPC( OBJECT_SELF, sCreatureLevelFeedbackMsg );
}

void PS_Feat_ControlUndead(object oPC, object oTarget, int nSpell)
{
    effect eControl 		= EffectCutsceneDominated(); //EffectDominated is bugged
    effect eVis 			= EffectVisualEffect( VFX_DUR_SPELL_CONTROL_UNDEAD );
	eControl 				= EffectLinkEffects( eControl, eVis );
    int nCasterLevel 		= GetCasterLevel(oPC);
    int nDuration 			= nCasterLevel;
	int nClericLevel 		= GetLevelByClass(CLASS_TYPE_CLERIC, oPC);
	
	if (GetHasFeat(2684, oPC) && GetHasFeat(2099, oPC)) //Divine Lich with Undeath Domain
	{	int nDivineLich 	= GetLevelByClass(CLASS_TYPE_LICH_D_PRC, oPC);
			nClericLevel 	= nClericLevel + nDivineLich;	}
	
	int nControlMaxLevel 	= nClericLevel;
	int nCreatureLevel 		= GetHitDice(oTarget);
	
	object oAssoc			= GetAssociate(ASSOCIATE_TYPE_DOMINATED, oPC);
	
	if (oAssoc != OBJECT_INVALID)
	{	SendMessageToPC(oPC, "You may not control more than one undead minion at a time.");
		return;	}
		
	if (GetIsPC(oTarget) == TRUE)
	{	SendMessageToPC(oPC, "You may not use this ability on another PC.");
		return;	}
	
	if (!GetHasFeat(FEAT_TURN_UNDEAD, oPC))
	{	SpeakStringByStrRef(STR_REF_FEEDBACK_NO_MORE_TURN_ATTEMPTS);	}
	else
   	{	int nImpT 			= GetHasFeat(FEAT_EMPOWER_TURNING, oPC);
    	int nChrMod 		= GetAbilityModifier(ABILITY_CHARISMA);
    	int nTurnCheck 		= d20();     
	    if(nImpT == TRUE)
    	{	nControlMaxLevel += 1;	}
		nTurnCheck += nChrMod;
	    if(nTurnCheck <= 0)
    	{	nControlMaxLevel -= 4;	}
    	else if(nTurnCheck >= 1 && nTurnCheck <= 3)
    	{	nControlMaxLevel -= 3;	}
    	else if(nTurnCheck >= 4 && nTurnCheck <= 6)
    	{	nControlMaxLevel -= 2;	}
    	else if(nTurnCheck >= 7 && nTurnCheck <= 9)
    	{	nControlMaxLevel -= 1;	}
    	else if(nTurnCheck >= 10 && nTurnCheck <= 12)
    	{	/*Stays the same*/		}
    	else if(nTurnCheck >= 13 && nTurnCheck <= 15)
    	{	nControlMaxLevel += 1;	}
    	else if(nTurnCheck >= 16 && nTurnCheck <= 18)
    	{	nControlMaxLevel += 2;	}
    	else if(nTurnCheck >= 19 && nTurnCheck <= 21)
    	{	nControlMaxLevel += 3;	}
    	else if(nTurnCheck >= 22)
    	{	nControlMaxLevel += 4;	}
	
		//**DEBUG START**
		string sName 		= GetName(oPC);
		string sDice 		= IntToString( nTurnCheck );
		string sDiceMsg 	= "<c=tomato>" + "1d20+CHA MOD Summ" + " : </c>" +  sDice;
		//**DEBUG END**
	
		DecrementRemainingFeatUses(oPC, FEAT_TURN_UNDEAD);
    	if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD && GetHitDice(oTarget) <= nControlMaxLevel)
    	{	if (GetIsPC(oTarget) == 0)
			{	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC))
        		{	SignalEvent(oTarget, EventSpellCastAt(oPC, nSpell));
           			//if (!MyResistSpell(oPC, oTarget))		{	
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eControl, oTarget, HoursToSeconds(nDuration));	//}
        		}
    		}
		}
	}
	PrintControlMaxLevel(nControlMaxLevel);
	PrintCreatureLevel(nCreatureLevel);
}

void PS_Feat_BolsterUndead(object oPC, object oTarget, int nSpell)
{
	int nHD 		= GetHitDice(oPC);
	int nHDT 		= nHD / 4;
	if (nHDT < 1)
	{	nHDT = 1;	}
	int nBonus 		= nHD / 6;
	if (nBonus < 1)
	{	nBonus = 1;	}
	int nHP 		= nBonus * 12;
	effect eAC		= EffectACIncrease(nBonus, AC_DODGE_BONUS);
	effect eHP		= EffectTemporaryHitpoints(nHP);
	effect eAtt		= EffectAttackIncrease(nBonus);
	effect eTurn 	= EffectTurnResistanceIncrease(nHDT);
	effect eLink	= EffectLinkEffects(eAC, eHP);
			eLink	= EffectLinkEffects(eLink, eAtt);
			eLink	= EffectLinkEffects(eLink, eTurn);
	effect eImpact 	= EffectNWN2SpecialEffectFile("sp_necromancy_hit");
	float fDelay;
	object oTarget	= GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oPC));

	while(GetIsObjectValid(oTarget))
	{	if(GetIsFriend(oTarget) && !GetIsPC(oTarget) && GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
		{	fDelay = GetRandomDelay();
			SignalEvent(oTarget, EventSpellCastAt(oPC, nSpell, FALSE));
			DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(10)));
			DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget));	}
		oTarget 	= GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oPC));
	}
	DecrementRemainingFeatUses(oPC, FEAT_TURN_UNDEAD);
}

void PS_Feat_PsionicThrust(object oPC, object oTarget, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}

    int nDuration = 2;
    
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC))
    {   effect eImpact 				= EffectVisualEffect(VFX_IMP_BIGBYS_FORCEFUL_HAND);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);
        SignalEvent(oTarget, EventSpellCastAt(oPC, nSpell, TRUE));
        if(!MyResistSpell(oPC, oTarget))
        {	int nCasterRoll 		= GetAbilityModifier(ABILITY_INTELLIGENCE, oPC) + 12;
            int nTargetRoll 		= d20(1) + GetAbilityModifier(ABILITY_STRENGTH, oTarget) + GetSizeModifier(oTarget);
            if (HasSizeIncreasingSpellEffect(oTarget) || GetHasSpellEffect(803, oTarget))
                nTargetRoll 		= nTargetRoll + 4;
            if (nCasterRoll >= nTargetRoll)
            {	effect eVis 		= EffectVisualEffect( VFX_DUR_SPELL_DAZE );
                effect eKnockdown 	= EffectDazed();
                effect eKnockdown2 	= EffectKnockdown();
                effect eLink 		= EffectLinkEffects(eKnockdown, eVis);
                	eLink 			= EffectLinkEffects(eLink, eKnockdown2);

                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
                FloatingTextStrRefOnCreature(8966,oPC, FALSE);	}
            else
            {	FloatingTextStrRefOnCreature(8967, oPC, FALSE);	}
			int nDamage = d6(2) + GetTotalLevels(oPC, 1);
			effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL, FALSE);
			
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);	}
    }
}

void PS_Feat_PsionicDominate(object oPC, object oTarget, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}

    object oTarget 		= GetSpellTargetObject();
    effect eDom 		= EffectDominated();
    	eDom 			= GetScaledEffect(eDom, oTarget);
    effect eDur 		= EffectVisualEffect(VFX_DUR_SPELL_DOM_MONSTER);
    effect eLink 		= EffectLinkEffects(eDur, eDom);

    int nMetaMagic 		= GetMetaMagicFeat();
    int nCasterLevel 	= GetTotalLevels(oPC, 1);
    int nDuration 		= 3 + nCasterLevel/2;
	int nDC;
	int nInt = GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);
	int nCha = GetAbilityModifier(ABILITY_CHARISMA, oPC);
	
	if(nCha > nInt)
	{
		nDC = 13 + nCha;
	}
	else
	{
		nDC = 13 + nInt;
	}

    nDuration 			= GetScaledDuration(nDuration, oTarget);
    int nRacial 		= GetRacialType(oTarget);

	SignalEvent(oTarget, EventSpellCastAt(oPC, nSpell, FALSE));
	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC))
	{	if (!MyResistSpell(oPC, oTarget))
    	{	if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
    		{	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));	}
        }
	}
}


void PS_Feat_PsionicBodyAdjustment(object oPC, int nSpell)
{
    int nLevel 			= GetTotalLevels(oPC, 1) * 2;
    effect eHeal 		= EffectHeal(d10(1) + nLevel);
    effect eVis 		= EffectVisualEffect(VFX_IMP_HEALING_M);
    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);
}

void PS_Feat_PsionicallyGifted(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}

	if (!GetHasSpellEffect(nSpell, oPC))
	{	effect eRes 	= EffectSavingThrowIncrease(SAVING_THROW_WILL, 4, SAVING_THROW_TYPE_MIND_SPELLS, FALSE);
			eRes		= ExtraordinaryEffect(eRes);
		if (GetSubRace(oPC) == RACIAL_SUBTYPE_GRAY_DWARF || GetSubRace(oPC) == 146 || GetSubRace(oPC) == 173 || GetSubRace(oPC) == 175)
		{	effect eRes = EffectSavingThrowIncrease(SAVING_THROW_WILL, 8, SAVING_THROW_TYPE_MIND_SPELLS, FALSE);
				eRes 	= ExtraordinaryEffect(eRes);	}
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRes, oPC);
	}	
}

void PS_Feat_PsionicOvercharge(object oPC, int nSpell)
{
    int nLevel = GetTotalLevels(oPC, 1);
	int nDamage = d6(1) + nLevel;
    effect eDamage 		= EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL, FALSE);
    effect eVis 		= EffectVisualEffect(VFX_HIT_AOE_MAGIC);
    SignalEvent(oPC, EventSpellCastAt(oPC, nSpell, FALSE));

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oPC);
	IncrementRemainingFeatUses(oPC, 2863);
	IncrementRemainingFeatUses(oPC, 2864);
	IncrementRemainingFeatUses(oPC, 2865);
	IncrementRemainingFeatUses(oPC, 1073);
	IncrementRemainingFeatUses(oPC, 1074);
	ResetFeatUses(oPC, 2336, FALSE, TRUE);
	ResetFeatUses(oPC, 2356, FALSE, TRUE);
	if (GetHasFeat(20998, oPC))
	{	int nPP 		= GetLocalInt(oPC, "PSI_PP");
		int nPPFinal 	= nPP + nDamage;
		SetLocalInt(oPC, "PSI_PP", nPPFinal);
		SendMessageToPC(oPC, "Psionic Overcharge Restored  " + IntToString(nDamage) + " Power Points!");
		SendMessageToPC(oPC, "Current Power Points:  " + IntToString(nPPFinal));
		SetGUIObjectText(oPC, "powerpointscreen", "PPRatioTXT", -1, IntToString(nPPFinal));	}
}

void PS_Feat_ServantOfTheHeavens(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}

    if (!GetHasSpellEffect(nSpell, oPC))
   	{
        int nCharLevel 		= GetTotalLevels(oPC, 0);
		int iSub 			= GetSubRace(oPC);
		object oItem		= GetItemPossessedBy(oPC,"ps_essence");
		string sECL			= GetLocalString(oItem, "ECL");
		int nLevelAdj		= StringToInt(sECL);
		int nEffLevel 		= (nCharLevel + nLevelAdj);
   		int nAmount 		= nEffLevel/5;
		int nAlign 			= GetGoodEvilValue(OBJECT_SELF);

		if (nAmount <0)
    	{	nAmount =1;	}
		else if (nAmount>5)
    	{	nAmount =5;	}
        effect eACBonus 	= EffectACIncrease(nAmount,AC_DODGE_BONUS,AC_VS_DAMAGE_TYPE_ALL);
        effect eACvsBonus	= VersusAlignmentEffect(eACBonus,ALIGNMENT_ALL,ALIGNMENT_EVIL);
        	eACvsBonus 		= SupernaturalEffect(eACvsBonus);
        if (nAlign >69)
		{	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eACvsBonus, oPC);	}
		else 
		{	string sError = "You are no longer Good. Until you have redeemed yourself, your Servant of Heaven ability will not be available to you.";
			SendMessageToPC(oPC,sError);	}
    }
}	

void PS_Feat_DiscipleOfDarkness(object oPC, int nSpell)
{
    if (!X2PreSpellCastCode())
    {	return;		}
    
    if (!GetHasSpellEffect(GetSpellId(), oPC))
   	{	int nCharLevel 		= GetTotalLevels(oPC, 0);
		int iSub 			= GetSubRace(OBJECT_SELF);
		object oItem		= GetItemPossessedBy(oPC,"ps_essence");
		string sECL			= GetLocalString(oItem, "ECL");
		int nLevelAdj		= StringToInt(sECL);
		int nEffLevel 		= (nCharLevel + nLevelAdj);
   		int nAmount 		= nEffLevel/5;
		int nAlign 			= GetGoodEvilValue(OBJECT_SELF);

		if (nAmount <0)
    	{	nAmount =1;		}
		else if (nAmount>5)
    	{	nAmount =5;		}

        effect eACBonus 	= EffectACIncrease(nAmount,AC_DODGE_BONUS,AC_VS_DAMAGE_TYPE_ALL);
        effect eACvsBonus 	= VersusAlignmentEffect(eACBonus,ALIGNMENT_ALL,ALIGNMENT_GOOD);
        	eACvsBonus 		= SupernaturalEffect(eACvsBonus);

        if (nAlign <31)
		{	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eACvsBonus, oPC);	}
		else 
		{	string sError = "You are no longer Evil. Until you have properly debased yourself, your Disciple of Darkness ability will not be available to you.";
			SendMessageToPC(oPC,sError);	}
    }
}

void PS_Feat_SacredVow(object oPC, int nSpell)
{
	if(GetHasFeat(FEAT_BACKGROUND_SACRED_VOW, oPC) && (GetLocalInt(oPC,"FEAT_BACKGROUND_SACRED_VOW") <1))
    	SetLocalInt(oPC,"FEAT_BACKGROUND_SACRED_VOW",1);
   
	effect eEff = EffectLinkEffects(
        EffectSkillIncrease(SKILL_DIPLOMACY, 2),
		EffectSavingThrowIncrease(SAVING_THROW_WILL, 1));

		eEff = SupernaturalEffect(eEff);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oPC);
}

void PS_Feat_Unhallowed(object oPC, int nSpell)
{
   	if(GetHasFeat(FEAT_BACKGROUND_UNHALLOWED, oPC) && (GetLocalInt(oPC,"FEAT_BACKGROUND_UNHALLOWED") <1))
      	SetLocalInt(oPC,"FEAT_BACKGROUND_UNHALLOWED",1);
   
   	effect eEff = EffectLinkEffects(
        EffectSkillIncrease(SKILL_INTIMIDATE, 2),
		EffectSavingThrowIncrease(SAVING_THROW_FORT, 1));

   	eEff = SupernaturalEffect(eEff);
   	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oPC);
}

void PS_Feat_Amicable(object oPC, int nSpell)
{
   	if(GetHasFeat(FEAT_BACKGROUND_AMICABLE, oPC) && (GetLocalInt(oPC,"FEAT_BACKGROUND_AMICABLE") <1))
      	SetLocalInt(oPC,"FEAT_BACKGROUND_AMICABLE",1);
   
   	
        effect Stat1 = EffectSkillDecrease(SKILL_INTIMIDATE, 3);
		effect Stat2 = EffectSkillDecrease(SKILL_BLUFF, 3);
		effect Stat3 = EffectSkillIncrease(SKILL_DIPLOMACY, 4);
		effect eEff = EffectLinkEffects(Stat1, Stat2);
		eEff = EffectLinkEffects (eEff, Stat3);

   	eEff = SupernaturalEffect(eEff);
   	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oPC);
}

void PS_Feat_Stern(object oPC, int nSpell)
{
   	if(GetHasFeat(FEAT_BACKGROUND_STERN, oPC) && (GetLocalInt(oPC,"FEAT_BACKGROUND_STERN") <1))
      	SetLocalInt(oPC,"FEAT_BACKGROUND_STERN",1);
   
        effect Stat1 = EffectSkillIncrease(SKILL_INTIMIDATE, 4);
		effect Stat2 = EffectSkillDecrease(SKILL_BLUFF, 3);
		effect Stat3 = EffectSkillDecrease(SKILL_DIPLOMACY, 3);
		effect eEff = EffectLinkEffects(Stat1, Stat2);
		eEff = EffectLinkEffects (eEff, Stat3);

   	eEff = SupernaturalEffect(eEff);
   	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oPC);
}

void PS_Feat_Misdirector(object oPC, int nSpell)
{
   	if(GetHasFeat(FEAT_BACKGROUND_MISDIRECTOR, oPC) && (GetLocalInt(oPC,"FEAT_BACKGROUND_MISDIRECTOR") <1))
      	SetLocalInt(oPC,"FEAT_BACKGROUND_MISDIRECTOR",1);
   
        effect Stat1 = EffectSkillDecrease(SKILL_INTIMIDATE, 3);
		effect Stat2 = EffectSkillIncrease(SKILL_BLUFF, 4);
		effect Stat3 = EffectSkillDecrease(SKILL_DIPLOMACY, 3);
		effect eEff = EffectLinkEffects(Stat1, Stat2);
		eEff = EffectLinkEffects (eEff, Stat3);

   	eEff = SupernaturalEffect(eEff);
   	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oPC);
}

void PS_Feat_Tinker(object oPC, int nSpell)
{
   	if(GetHasFeat(FEAT_BACKGROUND_TINKER, oPC) && (GetLocalInt(oPC,"FEAT_BACKGROUND_TINKER") <1))
      	SetLocalInt(oPC,"FEAT_BACKGROUND_TINKER",1);
   

        effect Stat1 = EffectSkillDecrease(SKILL_INTIMIDATE, 3);
		effect Stat2 = EffectSkillDecrease(SKILL_BLUFF, 3);
		effect Stat3 = EffectSkillDecrease(SKILL_DIPLOMACY, 3);
		effect Stat4 = EffectSkillDecrease(SKILL_SURVIVAL, 3);
		effect Stat5 = EffectSkillIncrease(SKILL_DISABLE_TRAP, 3);
		effect Stat6 = EffectSkillIncrease(SKILL_OPEN_LOCK, 3);
		effect Stat7 = EffectSkillIncrease(SKILL_SET_TRAP, 3);
		effect Stat8 = EffectSkillIncrease(SKILL_CRAFT_TRAP, 3);
		effect eEff = EffectLinkEffects(Stat1, Stat2);
		 eEff = EffectLinkEffects(eEff, Stat3);
		 eEff = EffectLinkEffects(eEff, Stat4);
		 eEff = EffectLinkEffects(eEff, Stat5);
		 eEff = EffectLinkEffects(eEff, Stat6);
		 eEff = EffectLinkEffects(eEff, Stat7);
		 eEff = EffectLinkEffects(eEff, Stat8);

   	eEff = SupernaturalEffect(eEff);
   	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oPC);
}

void PS_Feat_Naturalist(object oPC, int nSpell)
{
   	if(GetHasFeat(FEAT_BACKGROUND_NATURALIST, oPC) && (GetLocalInt(oPC,"FEAT_BACKGROUND_NATURALIST") <1))
      	SetLocalInt(oPC,"FEAT_BACKGROUND_NATURALIST",1);
   
        effect Stat1 = EffectSkillDecrease(SKILL_LORE, 3);
		effect Stat2 = EffectSkillDecrease(SKILL_APPRAISE, 3);
		effect Stat3 = EffectSkillIncrease(SKILL_SURVIVAL, 4);
		effect eEff = EffectLinkEffects(Stat1, Stat2);
		eEff = EffectLinkEffects (eEff, Stat3);

   	eEff = SupernaturalEffect(eEff);
   	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEff, oPC);
}