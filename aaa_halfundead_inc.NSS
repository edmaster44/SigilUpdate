#include "x2_inc_spellhook"
#include "X0_I0_SPELLS"
#include "ps_inc_advscript"
#include "aaa_constants"
#include "nw_i0_spells"
#include "aaa_changeself_inc"
#include "x0_i0_match"
// tlk 16781639

void HalfUndeadImmunity(object oPC, int nSpell){

	int nLevel	= GetLevelByClass(CLASS_TYPE_HALF_UNDEAD, oPC);
	int nAmount = (nLevel >= 5) ? 10 : 5;
	int nVull 	= (nLevel >= 5) ? 25 : 15;

	effect eVull =	EffectDamageImmunityDecrease(DAMAGE_TYPE_DIVINE,nVull);
	effect eNeg	 = 	EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE,nVull);
	effect eDR	 = 	EffectDamageReduction(nAmount,GMATERIAL_METAL_ALCHEMICAL_SILVER, 0, DR_TYPE_GMATERIAL);
	effect eLink =	EffectLinkEffects(eVull, eNeg);
	eLink    	 =	EffectLinkEffects(eDR, eLink);
	eLink 		 = 	SupernaturalEffect(eLink);
	eLink 		 = 	SetEffectSpellId(eLink, nSpell);
	RemoveEffectsFromSpell(oPC, nSpell);	

	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
	if (GetLocalInt(oPC, "halfUndeadDR") != nAmount){
		SendMessageToPC(oPC, "Damage Reduction of " + IntToString(nAmount) + "/silver applied.");
		SetLocalInt(oPC, "halfUndeadDR", nAmount);
	}	
}

void GhedeanDeadNerves(object oPC, object oItem, int nSpell){
	int nLevel	= GetLevelByClass(CLASS_TYPE_HALF_UNDEAD, oPC);
	int nAmount	= (nLevel >= 5) ? 10 : 5;
	
	effect eNegTrap =	EffectSkillDecrease(SKILL_DISABLE_TRAP, nAmount);
	effect eNegTrap2=	EffectSkillDecrease(SKILL_SET_TRAP, nAmount);
	effect eNegHand = 	EffectSkillDecrease(SKILL_SLEIGHT_OF_HAND, nAmount);
	effect eNegLock = 	EffectSkillDecrease(SKILL_OPEN_LOCK, nAmount);
	effect eDR 		= 	EffectDamageReduction(nAmount, DAMAGE_TYPE_ALL, 0, DR_TYPE_NONE);
	effect eLink 	= 	EffectLinkEffects(eNegHand,eNegLock);
	eLink 			=	EffectLinkEffects(eNegTrap, eLink);
	eLink			=	EffectLinkEffects(eNegTrap2, eLink);
	eLink 			= 	EffectLinkEffects(eDR, eLink);
	eLink 			= 	SupernaturalEffect(eLink);
	eLink 			= 	SetEffectSpellId(eLink, nSpell);
	RemoveEffectsFromSpell(oPC, nSpell);

	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
}



void HalfUndeadSkills(object oPC, int nSpell){
	
	int nBonus = 3;
	int iSkill3, iSkill4;

	if (GetHasFeat(FEAT_HALFVAMPIRE, oPC)){
		iSkill3 = SKILL_BLUFF;
		iSkill4 = SKILL_LISTEN;
	} else if (GetHasFeat(FEAT_FETCH,oPC)){	
		iSkill3 = SKILL_SPELLCRAFT;
		iSkill4 = SKILL_CONCENTRATION;
	} else if (GetHasFeat(FEAT_GHUL,oPC)){
		iSkill3 = SKILL_SURVIVAL;
		iSkill4 = SKILL_CRAFT_TRAP;
	} else if (GetHasFeat(FEAT_GHAEDEN, oPC)){
		iSkill3 = SKILL_SURVIVAL;
		iSkill4 = SKILL_LISTEN;
	}
	
	effect eSk1		=	EffectSkillIncrease(SKILL_HIDE, nBonus);
	effect eSk2 	=	EffectSkillIncrease(SKILL_MOVE_SILENTLY, nBonus);
	effect eSk3 	=	EffectSkillIncrease(iSkill3, nBonus);
	effect eSk4 	=	EffectSkillIncrease(iSkill4, nBonus);
	effect eLink	= 	EffectLinkEffects(eSk1,eSk2);
		   eLink	=	EffectLinkEffects(eSk3, eLink);
		   eLink	=	EffectLinkEffects(eSk4, eLink);
		   eLink	=	SupernaturalEffect(eLink);	
		   eLink 	= 	SetEffectSpellId(eLink, nSpell);
	RemoveEffectsFromSpell(oPC, nSpell);
	
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);			
}

void HalfUndeadPower(object oPC, int nSpell){		
		int nCon = GetAbilityModifier(ABILITY_CONSTITUTION, oPC);
		if (nCon < 1) nCon = 0;
		nCon += 1; // duration is 1 minute + 1 min per con
		if (nCon > 10) nCon = 10; //max 10 minutes
		float fDur = IntToFloat(nCon * 60);
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
		
		
		eLink = EffectLinkEffects(eLink, EffectNWN2SpecialEffectFile("fx_wraith_aura.sef",oPC));
		eLink = SupernaturalEffect(eLink);
		
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC,fDur);
}

/*
int ed_checkhalfvampirestats(object oPC)
{
	string name = SQLEncodeSpecialChars(GetName(oPC));
   	string act = SQLEncodeSpecialChars(GetPCPlayerName(oPC));	
	SQLExecDirect("SELECT `bonus` FROM `generalability_tracking` WHERE `name`='" + name + "' AND `act`='" + act + "';");
	SQLFetch();
	return StringToInt(SQLGetData(1));

}

void ed_updatehalfvampirestat(object oPC, int delete = 0)
{

	string name = SQLEncodeSpecialChars(GetName(oPC));
	string act = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
	if(delete == 1) SQLExecDirect("DELETE `bonus` FROM `generalability_tracking` WHERE `name`='" + name + "' AND `act`='" + act + "';");
	SQLExecDirect("INSERT INTO `generalability_tracking` VALUES('" + name + "','" + act + "','1') ON DUPLICATE KEY UPDATE `bonus`=`bonus`+1;");
}


void ed_halfvampirestats(object oPC, int nSpell)
{
//Bonuses to Strength, Dex and Charima at Level 3 and 5
int iLevel = GetLevelByClass(114,oPC);
int iVal = ed_checkhalfvampirestats(oPC);
if (iVal >2)
return;

if (iVal == 0 && iLevel >= 3 )
	
{	SetBaseAbilityScore(oPC,ABILITY_STRENGTH,GetAbilityScore(oPC,ABILITY_STRENGTH,TRUE)+1+GetRacialBonus(oPC,ABILITY_STRENGTH));
	SetBaseAbilityScore(oPC,ABILITY_DEXTERITY,GetAbilityScore(oPC,ABILITY_DEXTERITY,TRUE)+1+GetRacialBonus(oPC,ABILITY_DEXTERITY));
	SetBaseAbilityScore(oPC,ABILITY_CHARISMA,GetAbilityScore(oPC,ABILITY_CHARISMA,TRUE)+1+GetRacialBonus(oPC,ABILITY_CHARISMA));
	SendMessageToPC(oPC,"<I>Your Undead Heritage makes you stronger . . .</I>");
	SendMessageToPC(oPC,"<I>Strength, Dexterity and Charisma increased by +1.</I>");
	ed_updatehalfvampirestat(oPC);
	}
	
	
if (iVal == 1 && iLevel >=5 )
	
{	SetBaseAbilityScore(oPC,ABILITY_STRENGTH,GetAbilityScore(oPC,ABILITY_STRENGTH,TRUE)+1+GetRacialBonus(oPC,ABILITY_STRENGTH));
	SetBaseAbilityScore(oPC,ABILITY_DEXTERITY,GetAbilityScore(oPC,ABILITY_DEXTERITY,TRUE)+1+GetRacialBonus(oPC,ABILITY_DEXTERITY));
	SetBaseAbilityScore(oPC,ABILITY_CHARISMA,GetAbilityScore(oPC,ABILITY_CHARISMA,TRUE)+1+GetRacialBonus(oPC,ABILITY_CHARISMA));
	SendMessageToPC(oPC,"<I>Your Undead Heritage makes you stronger . . .</I>");
	SendMessageToPC(oPC,"<I>Strength, Dexterity and Charisma increased by +1.</I>");
	ed_updatehalfvampirestat(oPC);
	}
	
	
	ExportSingleCharacter(oPC);
	
}

int ed_checkghulstats(object oPC)
{
	string name = SQLEncodeSpecialChars(GetName(oPC));
   	string act = SQLEncodeSpecialChars(GetPCPlayerName(oPC));	
	SQLExecDirect("SELECT `bonus` FROM `generalability_tracking` WHERE `name`='" + name + "' AND `act`='" + act + "';");
	SQLFetch();
	return StringToInt(SQLGetData(1));

}

void ed_updateghul(object oPC, int delete = 0)
{

	string name = SQLEncodeSpecialChars(GetName(oPC));
	string act = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
	if(delete == 1) SQLExecDirect("DELETE `bonus` FROM `generalability_tracking` WHERE `name`='" + name + "' AND `act`='" + act + "';");
	SQLExecDirect("INSERT INTO `generalability_tracking` VALUES('" + name + "','" + act + "','1') ON DUPLICATE KEY UPDATE `bonus`=`bonus`+1;");
}


void ed_ghulstats(object oPC, int nSpell)
{
//Bonuses to Strength, Dex and Charima at Level 3 and 5
int iLevel = GetLevelByClass(114,oPC);
int iVal = ed_checkghulstats(oPC);
if (iVal >2)
return;

if (iVal == 0 && iLevel >= 3 )
	
{	
	SetBaseAbilityScore(oPC,ABILITY_DEXTERITY,GetAbilityScore(oPC,ABILITY_DEXTERITY,TRUE)+2+GetRacialBonus(oPC,ABILITY_DEXTERITY));	
	SendMessageToPC(oPC,"<I>Your Undead Heritage makes you stronger . . .</I>");
	SendMessageToPC(oPC,"<I>Dexterity increased by +2.</I>");
	ed_updateghul(oPC);
	}
	
	
if (iVal == 1 && iLevel >=5 )
	
{	
	SetBaseAbilityScore(oPC,ABILITY_DEXTERITY,GetAbilityScore(oPC,ABILITY_DEXTERITY,TRUE)+2+GetRacialBonus(oPC,ABILITY_DEXTERITY));
	SetBaseAbilityScore(oPC,ABILITY_CHARISMA,GetAbilityScore(oPC,ABILITY_CHARISMA,TRUE)+2+GetRacialBonus(oPC,ABILITY_CHARISMA));
	SendMessageToPC(oPC,"<I>Your Undead Heritage makes you stronger . . .</I>");
	SendMessageToPC(oPC,"<I>Dexterity and Charisma  by +2.</I>");
	ed_updateghul(oPC);
	}
	
	
	ExportSingleCharacter(oPC);
	
}

int ed_checkfetchstats(object oPC)
{
	string name = SQLEncodeSpecialChars(GetName(oPC));
   	string act = SQLEncodeSpecialChars(GetPCPlayerName(oPC));	
	SQLExecDirect("SELECT `bonus` FROM `generalability_tracking` WHERE `name`='" + name + "' AND `act`='" + act + "';");
	SQLFetch();
	return StringToInt(SQLGetData(1));
}

void ed_updatefetch(object oPC, int delete = 0)
{
	string name = SQLEncodeSpecialChars(GetName(oPC));
	string act = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
	if(delete == 1) SQLExecDirect("DELETE `generalability_tracking` WHERE `name`='"+name+"' AND `act`='"+act+"';");
	SQLExecDirect("INSERT INTO `generalability_tracking` VALUES('" + name + "','" + act + "','1') ON DUPLICATE KEY UPDATE `bonus`=`bonus`+1;");
	
	}


void ed_fetchstats(object oPC, int nSpell)
{
//Bonuses to Strength, Dex and Charima at Level 3 and 5
int iLevel = GetLevelByClass(114,oPC);
int iVal = ed_checkfetchstats(oPC);



if (iVal == 0 && iLevel >= 3 )
	
{	
	SetBaseAbilityScore(oPC,ABILITY_CHARISMA,GetAbilityScore(oPC,ABILITY_CHARISMA,TRUE)+2+GetRacialBonus(oPC,ABILITY_CHARISMA));	
	SendMessageToPC(oPC,"<I>Your Undead Heritage Makes your more Charismatic  . . .</I>");
	SendMessageToPC(oPC,"<I>Charisma  by +2</I>");
	ed_updatefetch(oPC);
	}
	
	
if (iVal == 1 && iLevel >=5 )
	
{	
	SetBaseAbilityScore(oPC,ABILITY_CHARISMA,GetAbilityScore(oPC,ABILITY_CHARISMA,TRUE)+2+GetRacialBonus(oPC,ABILITY_CHARISMA));
	SetBaseAbilityScore(oPC,ABILITY_WISDOM,GetAbilityScore(oPC,ABILITY_WISDOM,TRUE)+2+GetRacialBonus(oPC,ABILITY_WISDOM));
	SendMessageToPC(oPC,"<I>Your Undead Heritage makes you wiser and charismatic . . .</I>");
	SendMessageToPC(oPC,"<I>Charismia and Wisdom  by +2.</I>");
	ed_updatefetch(oPC);
	}
	
	
	ExportSingleCharacter(oPC);
}

int ed_checkghedenstats(object oPC)
{
	string name = SQLEncodeSpecialChars(GetName(oPC));
   	string act = SQLEncodeSpecialChars(GetPCPlayerName(oPC));	
	SQLExecDirect("SELECT `bonus` FROM `generalability_tracking` WHERE `name`='" + name + "' AND `act`='" + act + "';");
	SQLFetch();
	return StringToInt(SQLGetData(1));
}

void ed_updategheden(object oPC, int delete = 0)
{

	string name = SQLEncodeSpecialChars(GetName(oPC));
	string act = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
	if(delete == 1) SQLExecDirect("DELETE `generalability_tracking` WHERE `name`='"+name+"' AND `act`='"+act+"';");
	SQLExecDirect("INSERT INTO `generalability_tracking` VALUES('" + name + "','" + act + "','1') ON DUPLICATE KEY UPDATE `bonus`=`bonus`+1;");
}


void ed_ghedenstats(object oPC, int nSpell)
{
int iLevel = GetLevelByClass(114,oPC);
int iVal = ed_checkghedenstats(oPC);

if (iVal == 0 && iLevel >= 3 )
	
{	
	SetBaseAbilityScore(oPC,ABILITY_STRENGTH,GetAbilityScore(oPC,ABILITY_STRENGTH,TRUE)+2+GetRacialBonus(oPC,ABILITY_STRENGTH));	
	SendMessageToPC(oPC,"<I>Your Undead Heritage Increases your Muscle mass  . . .</I>");
	SendMessageToPC(oPC,"<I>Strength  increases by +2.</I>");
	ed_updategheden(oPC);
	}
	
	
if (iVal == 1 && iLevel >=5 )
	
{	
	SetBaseAbilityScore(oPC,ABILITY_STRENGTH,GetAbilityScore(oPC,ABILITY_STRENGTH,TRUE)+2+GetRacialBonus(oPC,ABILITY_STRENGTH));
	SetBaseAbilityScore(oPC,ABILITY_CONSTITUTION,GetAbilityScore(oPC,ABILITY_CONSTITUTION,TRUE)+2+GetRacialBonus(oPC,ABILITY_CONSTITUTION));
	SendMessageToPC(oPC,"<I>Your Undead Heritage makes you stronger . . .</I>");
	SendMessageToPC(oPC,"<I>Strength and Contitution increased  by +2.</I>");
	ed_updategheden(oPC);
	}
	
	
	ExportSingleCharacter(oPC);
}
*/