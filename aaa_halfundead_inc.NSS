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
		if (nLevel >= 5 ) 
		{	nAmount 	= 10;	}
		effect eVul1   =  EffectDamageImmunityDecrease(DAMAGE_TYPE_DIVINE,nAmount);
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

void GhedenBoniFeat(object oPC, object oItem, int nSpell)
{
	if (!GetHasFeat(FEAT_STEADFAST_DETERMINATION, oPC, TRUE))
	{	FeatAdd(oPC, FEAT_STEADFAST_DETERMINATION, FALSE, TRUE, FALSE);	}
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
		
		eLink = SupernaturalEffect(eLink);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC,fDur);
}

void main()
{
	if (!X2PreSpellCastCode())
    {	return;	}

    object oPC 		= OBJECT_SELF;
	object oTarget	= GetSpellTargetObject();
	object 	oItem	= GetItemPossessedBy(oPC,"ps_essence");
	int nSpell 		= GetSpellId();

	
	switch (nSpell)
	{
////////////////////////////////////////////////////////////////////////////////////
		case 1519 :		//Half-Undead Undead Immunity Power
		{	HalfUndeadPower(oPC, nSpell);	}		
		break; 
		
		case 1514: //Gheden Bonus Feat
		{ GhedenBoniFeat(oPC, oItem, nSpell); }
		break;
		
		case 1516: //Half Undead Immunity and Vulnerability
		{ GhedenBoniFeat(oPC, oItem, nSpell); }
		break;
	}
	}