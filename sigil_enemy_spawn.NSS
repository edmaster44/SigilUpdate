

#include "sigil_enemy_inc"

effect EffectDifficulty(int nLVL, int nDIFF, int nRANK, int nHP, int nSLOW, int nDESTR, int nBOSS)
{
	int nLIFE = nDIFF * (nHP + nRANK * nLVL);
	if (nBOSS == TRUE) nLIFE = nLIFE * 10;
	int nDMG = nDIFF * nRANK;
	if (nDESTR == TRUE) nDMG = 50;
	else if (nDMG > 50) nDMG = 50;
	else if (nDMG > 5) nDMG = nDMG + 10;
	effect eFX;
	if (nLIFE > 0) eFX = EffectLinkEffects(eFX, EffectBonusHitpoints(nLIFE));
	eFX = EffectLinkEffects(eFX, EffectSkillIncrease(SKILL_ALL_SKILLS, nDIFF));
	eFX = EffectLinkEffects(eFX, EffectAttackIncrease(nDIFF));
	eFX = EffectLinkEffects(eFX, EffectACIncrease(nDIFF));
	eFX = EffectLinkEffects(eFX, EffectDamageIncrease(nDMG));
	if (nDIFF > 1)
	{
		int nATTR = 4 * (nDIFF - 1);
		eFX = EffectLinkEffects(eFX, EffectAbilityIncrease(ABILITY_CHARISMA, nATTR));
		eFX = EffectLinkEffects(eFX, EffectAbilityIncrease(ABILITY_CONSTITUTION, nATTR));
		eFX = EffectLinkEffects(eFX, EffectAbilityIncrease(ABILITY_DEXTERITY, nATTR));
		eFX = EffectLinkEffects(eFX, EffectAbilityIncrease(ABILITY_INTELLIGENCE, nATTR));
		eFX = EffectLinkEffects(eFX, EffectAbilityIncrease(ABILITY_STRENGTH, nATTR));
		eFX = EffectLinkEffects(eFX, EffectAbilityIncrease(ABILITY_WISDOM, nATTR));
	}
	if (nSLOW == TRUE) eFX = EffectLinkEffects(eFX, EffectSlow());
	if (nDESTR == TRUE)
	{
		int nCOUNT;
		while (nCOUNT < nDIFF)
		{
			eFX = EffectLinkEffects(eFX, EffectDamageIncrease(nDMG));
			nCOUNT = nCOUNT + 1;
		}
		eFX = EffectLinkEffects(eFX, EffectBABMinimum(100));
	}
	if (nBOSS == TRUE)
	{
		eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_BLINDNESS));
		eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_CHARM));
		eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS));
		eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_DEATH));
		eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_PARALYSIS));
		eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_SILENCE));
		eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_DEAFNESS));
		eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_DOMINATE));
		eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_FEAR));
		eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN));
		eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_STUN));
		eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE));
		eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_SLOW));
		eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_CONFUSED));
		eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_DAZED));
		eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_ENTANGLE));
		eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_SLEEP));
	}
	eFX = SupernaturalEffect(eFX);
	return eFX;
}

void BossStartup(object oBOSS)
{
	object oHELPER;
	int nENEMY = GetLocalInt(oBOSS, "ENEMY_HEART");
	switch (nENEMY)
	{
		case 101:
			break;
		case 102:
			EnemyCutscene(oBOSS, 30.0);
			oHELPER = GetObjectByTag("OlympiaBoss1");
			SpeakString("Olympia... how long has it been since you last paid me a visit?");
			DelayCommand(6.0, AssignCommand(oHELPER, SpeakString("Spare the pleasantries, Gorshtak. I'm not going to take any chances with you anymore. I have come to end you once and for all.")));
			DelayCommand(12.0, SpeakString("Hahahahaha! Is that why you brought along these weaklings? Are they your bodyguards? How low have you fallen."));
			DelayCommand(18.0, AssignCommand(oHELPER, SpeakString("Underestimating them will be your downfall, prepare to die.")));
			DelayCommand(24.0, SpeakString("This is a stupid mistake you will regret for all eternity."));
			break;
		case 103: 
			break;
	}
}

void LoopTheKO(object oNPC)
{
	PlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0, 10.0);
	DelayCommand(10.0, LoopTheKO(oNPC));
}

void main()
{
	object oENEMY = OBJECT_SELF;
	if (GetLocalInt(oENEMY, "KO") == TRUE)
	{
		DelayCommand(0.0f, LoopTheKO(oENEMY));
		return;
	}
	object oAREA = GetArea(oENEMY);
	int nDIFF = GetLocalInt(oAREA, "ENEMY_DIFF");
	if (nDIFF < 1)
	{
		object oMOB = GetNearestObjectByTag("sigil_mobs", oENEMY);
		nDIFF = GetLocalInt(oMOB, "ENEMY_DIFF");
	}
	
	if (nDIFF < 1) nDIFF = 1;
	else if (nDIFF > 4) nDIFF = 4;
	SetLocalInt(oENEMY, "ENEMY_DIFF", nDIFF);
	int nLVL = GetHitDice(oENEMY);
	int nRANK = GetLocalInt(oENEMY, "ENEMY_RANK");
	if (nRANK < 1) nRANK = 1;
	int nHP = GetLocalInt(oENEMY, "ENEMY_HP");
	int nSLOW = GetLocalInt(oENEMY, "ENEMY_SLOW");
	int nDESTR = GetLocalInt(oENEMY, "ENEMY_DEST");
	int nBOSS = GetLocalInt(oENEMY, "ENEMY_BOSS");
	string sCOLOR = "<c=Aquamarine>";
	switch (nDIFF)
	{
		case 2: sCOLOR = "<c=SteelBlue>"; break;
		case 3: sCOLOR = "<c=DarkOrange>"; break;
		case 4: sCOLOR = "<c=Crimson>"; break;
	}
	SetFirstName(oENEMY, sCOLOR + GetFirstName(oENEMY) + "</c>");
	SetLastName(oENEMY, sCOLOR + GetLastName(oENEMY) + "</c>");
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDifficulty(nLVL, nDIFF, nRANK, nHP, nSLOW, nDESTR, nBOSS), oENEMY);
	DelayCommand(0.0f, ForceRest(oENEMY));
	DelayCommand(0.5, BossStartup(oENEMY));
}