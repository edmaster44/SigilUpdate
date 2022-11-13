#include "x2_inc_spellhook"
#include "X0_I0_SPELLS"
#include "ps_inc_functions"
#include "ps_inc_advscript"
#include "aaa_constants"
#include "nw_i0_spells"
#include "aaa_changeself_inc"
#include "x0_i0_match"


void HalfUndeadImmunity(object oPC, int nSpell)	
{
	if (!GetHasSpellEffect(nSpell, oPC))
	{	int nLevel	= GetLevelByClass(CLASS_TYPE_HALF_UNDEAD, oPC);
		int nAmount		= 5;
		int nVulD 		= 15;
		if (nLevel >= 5 ) 
		{	nVulD 	= 25;	}
		
		if (nLevel >= 5 ) 
		{	nAmount 	= 10;	}
		effect eVul1   =  EffectDamageImmunityDecrease(DAMAGE_TYPE_DIVINE,nVulD);
		effect eNeg		=EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE,nAmount);
		effect eDR		= EffectDamageReduction(nAmount,GMATERIAL_METAL_ALCHEMICAL_SILVER, 0, DR_TYPE_GMATERIAL);
		
			eDR			= ExtraordinaryEffect(eDR);
			eNeg		= ExtraordinaryEffect(eNeg);
			eVul1		= ExtraordinaryEffect(eVul1);
			eVul1		= SetEffectSpellId(eVul1, nSpell);
			eDR			= SetEffectSpellId(eDR, nSpell);
		effect	eLink    =EffectLinkEffects(eDR,eVul1);
		
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
		//SendMessageToPC(oPC, "Damage Reduction of " + IntToString(nAmount) + "/silver applied.");
	}
}

void GhedeanDeadNerves(object oPC, object oItem, int nSpell)
{
if (!GetHasSpellEffect(nSpell, oPC))
{
int nLevel	= GetLevelByClass(CLASS_TYPE_HALF_UNDEAD, oPC);
		int nAmount		= 5;
		if (nLevel >= 5 ) 
		{	nAmount 	= 10;	}
	int nSkill = 8;
		
effect eNegHand =EffectSkillDecrease(SKILL_SLEIGHT_OF_HAND,nSkill);
effect eNegLock =EffectSkillDecrease(SKILL_OPEN_LOCK,nSkill);
effect eDR = EffectDamageReduction(nAmount, DAMAGE_TYPE_ALL, 0, DR_TYPE_NONE);
effect eLink = EffectLinkEffects(eNegHand,eNegLock);
eLink = EffectLinkEffects(eDR,eLink);
eLink = SupernaturalEffect(eLink);

ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
}

}

void HalfUndeadSkills(object oPC, int nSpell)
{
if (!X2PreSpellCastCode())
    {	return;	}
	int nFeat;
	if (GetHasSpellEffect(nSpell,oPC))	
	{	RemoveSpellEffects(nSpell, oPC, oPC);	}
	 nFeat = GetHasFeat(nFeat,oPC);
	
	int iSkill1 = SKILL_HIDE;
	int iSkill2 = SKILL_MOVE_SILENTLY;
	int iSkill3;
	int iSkill4;
	
	switch (nFeat)
	{	case 0://Debug
		SendMessageToPC(oPC, "Something is wrong.");	
		break;
		case 3049://Half Vampire
		iSkill3 = SKILL_BLUFF;
		iSkill4 = SKILL_LISTEN;
		break;
		
	}
	effect eSk1		=	EffectSkillIncrease(iSkill1, 4);
	effect eSk2 	=	EffectSkillIncrease(iSkill2, 4);
	effect eSk3 	=	EffectSkillIncrease(iSkill3, 4);
	effect eSk4 	=	EffectSkillIncrease(iSkill4, 4);
	effect eLink1	=	EffectLinkEffects(eSk1,eSk2);
	effect eLink2	=	EffectLinkEffects(eSk3,eSk4);
	effect eSkill	=	EffectLinkEffects(eLink1,eLink2);
	eSkill	=	ExtraordinaryEffect(eSkill);
				if (!GetHasSpellEffect(nSpell, oPC))
	{			
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSkill, oPC);			
	}
		
}

void HalfUndeadPower(object oPC, int nSpell)
{		float fDur = 150.00;
		effect eMind = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
		effect eCharm = EffectImmunity(IMMUNITY_TYPE_CHARM);
		effect ePoison = EffectImmunity(IMMUNITY_TYPE_POISON);
		effect eSleep = EffectImmunity(IMMUNITY_TYPE_SLEEP);
		effect ePara = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
		effect eDeath = EffectImmunity(IMMUNITY_TYPE_DEATH);
		effect eCritical = EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);
		effect eSneak = EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK);
		effect eLevel = EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL);
		effect eAbility = EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE);
		effect eDisease = EffectImmunity(IMMUNITY_TYPE_DISEASE);

		effect eLink = EffectLinkEffects(eMind, eCharm);
		eLink = EffectLinkEffects(ePoison, eLink);
		eLink = EffectLinkEffects(eSleep, eLink);
		eLink = EffectLinkEffects(ePara, eLink);
		eLink = EffectLinkEffects(eDeath, eLink);
		eLink = EffectLinkEffects(eCritical, eLink);
		eLink = EffectLinkEffects(eSneak, eLink);
		eLink = EffectLinkEffects(eLevel, eLink);
		eLink = EffectLinkEffects(eAbility, eLink);
		eLink = EffectLinkEffects(eDisease, eLink);
		
		
		eLink = EffectLinkEffects(eLink, EffectNWN2SpecialEffectFile("fx_wraith_aura.sef"));
		eLink = SupernaturalEffect(eLink);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC,fDur);
}