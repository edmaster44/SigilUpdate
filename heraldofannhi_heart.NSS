#include "ff_safevar"


#include "aaa_constants"

effect BossFX(int nBHP)
{
	effect eFX = EffectBonusHitpoints(nBHP);
	eFX = EffectLinkEffects(eFX, EffectRegenerate(10, 1.0));
	eFX = EffectLinkEffects(eFX, EffectTrueSeeing());
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_BLINDNESS));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_CHARM));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_CONFUSED));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_DAZED));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_DEAFNESS));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_DEATH));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_DOMINATE));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_ENTANGLE));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_FEAR));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_PARALYSIS));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_SILENCE));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_SLEEP));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_STUN));
	eFX = SupernaturalEffect(eFX);
	eFX = SetEffectSpellId(eFX, BOSS_EFFECTS);
	return eFX;
}

effect OmegaChampion(int nPHASE)
{
	effect eFX = EffectSlow();
	eFX = EffectLinkEffects(eFX, EffectMovementSpeedIncrease(50));
	eFX = EffectLinkEffects(eFX, EffectAttackIncrease(20));
	eFX = EffectLinkEffects(eFX, EffectDamageIncrease(DAMAGE_BONUS_40, DAMAGE_TYPE_MAGICAL));
	eFX = EffectLinkEffects(eFX, EffectDamageIncrease(DAMAGE_BONUS_40, DAMAGE_TYPE_MAGICAL));
	eFX = EffectLinkEffects(eFX, EffectDamageIncrease(DAMAGE_BONUS_20, DAMAGE_TYPE_MAGICAL));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_DEATH));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_FEAR));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_DOMINATE));
	eFX = EffectLinkEffects(eFX, EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL));
	if (nPHASE == 3)
	{
		
		eFX = EffectLinkEffects(eFX, EffectDamageIncrease(DAMAGE_BONUS_40, DAMAGE_TYPE_MAGICAL));
		eFX = EffectLinkEffects(eFX, EffectDamageIncrease(DAMAGE_BONUS_40, DAMAGE_TYPE_MAGICAL));
		eFX = EffectLinkEffects(eFX, EffectDamageIncrease(DAMAGE_BONUS_20, DAMAGE_TYPE_MAGICAL));
		eFX = EffectLinkEffects(eFX, EffectSetScale(1.5));
	}
	eFX = SupernaturalEffect(eFX);
	return eFX;
}

void ResetFight(object oBOSS, int nCUTSCENE)
{
	effect eFX = EffectCutsceneParalyze();
	string sADD;
	location lBOSS = GetLocation(oBOSS);
	object oENTRANCE = GetObjectByTag("wp_herald_annhi_entrance");
	object oPC = GetFirstObjectInShape(SHAPE_SPHERE, 100.0, lBOSS, TRUE);
	while (oPC != OBJECT_INVALID)
	{
		sADD = GetTag(oPC);
		if ((sADD == "heraldannhi_add") || (sADD == "heraldannhi_font")) DestroyObject(oPC);
		else 
		{
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFX, oPC, 5.0);
			if (nCUTSCENE == FALSE)
			{
				if (GetIsOwnedByPlayer(oPC) == TRUE)
				{
					AssignCommand(oPC, JumpToObject(oENTRANCE));
					if (GetIsDead(oPC) == TRUE) ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPC);
				}
			}
		}
		oPC = GetNextObjectInShape(SHAPE_SPHERE, 100.0, lBOSS, TRUE);
	}
}

void FinalChampions(object oBOSS)
{
	object oPORTAL;
	object oCHAMP;
	object oCENTER = GetObjectByTag("wp_herald_center");
	int nCOUNT;
	while (nCOUNT < 4)
	{
		if (nCOUNT < 3) oPORTAL = GetObjectByTag("wp_herald_annhi", nCOUNT);
		else oPORTAL = GetObjectByTag("wp_herald_annhi_start");
		oCHAMP = CreateObject(OBJECT_TYPE_CREATURE, "heraldannhi_add", GetLocation(oPORTAL), TRUE);
		SetFirstName(oCHAMP, "Eternal Reaver");
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, OmegaChampion(3), oCHAMP);
		AssignCommand(oCHAMP, ActionMoveToObject(oCENTER));
		nCOUNT = nCOUNT + 1;
	}
}

void CallChampions(object oBOSS)
{
	if (PS_GetLocalInt(oBOSS, "BOSS_PHASE_CUTSCENE") == 1) return;
	int nRANDOM = Random(3);
	object oPORTAL = GetObjectByTag("wp_herald_annhi", nRANDOM);
	object oCHAMP = CreateObject(OBJECT_TYPE_CREATURE, "heraldannhi_add", GetLocation(oPORTAL), TRUE);
	object oCENTER = GetObjectByTag("wp_herald_center");
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, OmegaChampion(0), oCHAMP);
	AssignCommand(oCHAMP, ActionMoveToObject(oCENTER));
	DestroyObject(oCHAMP, RoundsToSeconds(10)); //failsafe
}

void ShockWave(object oBOSS)
{
	if (PS_GetLocalInt(oBOSS, "BOSS_PHASE_CUTSCENE") == 1) return;
	if (PS_GetLocalInt(oBOSS, "BOSS_DEFEATED") == 1) return;
	location lBOSS = GetLocation(oBOSS);
	object oTARGET = GetFirstObjectInShape(SHAPE_SPHERE, 100.0, lBOSS, TRUE);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_AOE_ETHEREAL_PURGE), oBOSS);
	effect eKNOCK = EffectKnockdown();
	effect eHIT = EffectVisualEffect(VFX_COM_HIT_SONIC);
	effect eDMG;
	int nDMG;
	while (oTARGET != OBJECT_INVALID)
	{
		if ((GetIsEnemy(oTARGET, oBOSS) == TRUE)&&(GetIsDead(oTARGET) == FALSE))
		{
			nDMG = GetReflexAdjustedDamage(d2(20), oTARGET, 40, SAVING_THROW_TYPE_SONIC);
			if (nDMG > 0)
			{
				eDMG = EffectLinkEffects(eHIT, EffectDamage(nDMG, DAMAGE_TYPE_SONIC, DAMAGE_POWER_NORMAL, TRUE));
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eDMG, oTARGET);
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKNOCK, oTARGET, 3.0);
			}
		}
		oTARGET = GetNextObjectInShape(SHAPE_SPHERE, 100.0, lBOSS, TRUE);
	}
}

void SharePain(object oBOSS)
{
	if (PS_GetLocalInt(oBOSS, "BOSS_PHASE_CUTSCENE") == 1) return;
	if (PS_GetLocalInt(oBOSS, "BOSS_DEFEATED") == 1) return;
	float fDUR = RoundsToSeconds(1);
	location lBOSS = GetLocation(oBOSS);
	object oTARGET = GetFirstObjectInShape(SHAPE_SPHERE, 100.0, lBOSS, TRUE);
	effect eFX;
	while (oTARGET != OBJECT_INVALID)
	{
		if ((GetIsEnemy(oTARGET, oBOSS) == TRUE)&&(GetIsDead(oTARGET) == FALSE))
		{
			eFX = EffectShareDamage(oTARGET, 1, 99);
			eFX = SupernaturalEffect(eFX);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFX, oBOSS, fDUR);
			eFX = EffectBeam(VFX_BEAM_EVIL, oBOSS, BODY_NODE_MONSTER_9);
			eFX = SupernaturalEffect(eFX);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFX, oTARGET, fDUR);
		}
		oTARGET = GetNextObjectInShape(SHAPE_SPHERE, 100.0, lBOSS, TRUE);
	}
}

void SoulFire(object oBOSS, int nPHASE)
{
	if (PS_GetLocalInt(oBOSS, "BOSS_PHASE_CUTSCENE") == 1) return;
	location lBOSS = GetLocation(oBOSS);
	object oTARGET = GetFirstObjectInShape(SHAPE_SPHERE, 100.0, lBOSS, TRUE);
	int nDMG;
	effect eVFX = EffectVisualEffect(VFX_HIT_SPELL_FLAMESTRIKE);
	effect eSOUL = EffectDamageOverTime(2, 1.0, DAMAGE_TYPE_FIRE, TRUE);
	eSOUL = EffectLinkEffects(eSOUL, EffectVisualEffect(VFX_DUR_FIRE));
	eSOUL = ExtraordinaryEffect(eSOUL);
	while (oTARGET != OBJECT_INVALID)
	{
		if ((GetIsEnemy(oTARGET, oBOSS) == TRUE)&&(GetIsDead(oTARGET) == FALSE))
		{
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oTARGET);
			if (nPHASE == 3)
			{
				ForceRest(oTARGET);
				nDMG = GetCurrentHitPoints(oTARGET) / 2;
				if (WillSave(oTARGET, 40, SAVING_THROW_TYPE_FIRE) == SAVING_THROW_CHECK_FAILED) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSOUL, oTARGET);
				else nDMG = nDMG / 2;
			}
			else
			{
				ResetFeatUses(oTARGET, FEAT_INVALID, TRUE, TRUE);
				nDMG = GetCurrentHitPoints(oTARGET) / 4;
				if (WillSave(oTARGET, 40, SAVING_THROW_TYPE_FIRE) == SAVING_THROW_CHECK_FAILED) ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSOUL, oTARGET, RoundsToSeconds(1));
				else nDMG = nDMG / 2;
			}
			ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDMG, DAMAGE_TYPE_FIRE, DAMAGE_POWER_NORMAL, TRUE), oTARGET);
		}
		oTARGET = GetNextObjectInShape(SHAPE_SPHERE, 100.0, lBOSS, TRUE);;
	}
}

void FontsOfLife(object oBOSS, int nPHASE)
{
	object oPORTAL;
	object oFONT;
	int nCOUNT;
	effect eFX = EffectCutsceneParalyze();
	effect eBEAM = EffectBeam(VFX_BEAM_CONJURATION, oBOSS, BODY_NODE_CHEST);
	float fDUR = RoundsToSeconds(1);
	if (nPHASE == 3)
	{
		eFX = EffectLinkEffects(eFX, EffectVisualEffect(VFX_DUR_SHINING_SHIELD));
		eFX = EffectLinkEffects(eFX, EffectRegenerate(10, RoundsToSeconds(1)));
	}
	eFX = ExtraordinaryEffect(eFX);
	while (nCOUNT < 4)
	{
		oPORTAL = GetObjectByTag("wp_herald_font", nCOUNT);
		oFONT = CreateObject(OBJECT_TYPE_CREATURE, "heraldannhi_font", GetLocation(oPORTAL), TRUE);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, oFONT);
		if (nPHASE == 3) SetFirstName(oFONT, "Eternal Font of Life");
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBEAM, oFONT, fDUR);
		nCOUNT = nCOUNT + 1;
	}
}

void BurstLife(object oBOSS)
{
	if (PS_GetLocalInt(oBOSS, "BOSS_PHASE_CUTSCENE") == 1) return;
	location lBOSS = GetLocation(oBOSS);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_AOE_CONJURATION), oBOSS);
	effect eDIS = EffectSlow();
	eDIS = EffectLinkEffects(eDIS, EffectSilence());
	float fDUR = RoundsToSeconds(1);
	object oTARGET = GetFirstObjectInShape(SHAPE_SPHERE, 100.0, lBOSS, TRUE);
	while (oTARGET != OBJECT_INVALID)
	{
		if (GetTag(oTARGET) == "heraldannhi_font") ForceRest(oTARGET);
		else if ((GetIsEnemy(oTARGET, oBOSS) == TRUE)&&(GetIsDead(oTARGET) == FALSE))
		{
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDIS, oTARGET, fDUR);
		}
		oTARGET = GetNextObjectInShape(SHAPE_SPHERE, 100.0, lBOSS, TRUE);
	}
}

void AnnounceNova(object oBOSS)
{
	float fDUR = RoundsToSeconds(1);
	effect eFX = EffectBeam(VFX_BEAM_HOLY, oBOSS, BODY_NODE_CHEST);
	eFX = SupernaturalEffect(eFX);
	int nFONT;
	object oFONT = GetObjectByTag("heraldannhi_font", nFONT);
	while (oFONT != OBJECT_INVALID)
	{
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFX, oFONT, fDUR);
		nFONT = nFONT + 1;
		oFONT = GetObjectByTag("heraldannhi_font", nFONT);
	}
}

void CleanseNova(object oBOSS, int nPHASE)
{
	if (PS_GetLocalInt(oBOSS, "BOSS_PHASE_CUTSCENE") == 1) return;
	if (PS_GetLocalInt(oBOSS, "BOSS_DEFEATED") == 1) return;
	int nDMG;
	int nFONT;
	object oFONT = GetObjectByTag("heraldannhi_font", nFONT);
	while (oFONT != OBJECT_INVALID)
	{
		if (GetIsDead(oFONT) == FALSE) nDMG = nDMG + GetCurrentHitPoints(oFONT);
		nFONT = nFONT + 1;
		oFONT = GetObjectByTag("heraldannhi_font", nFONT);
	}
	if (nDMG <= 0) return;
	float fDUR = RoundsToSeconds(1);
	location lBOSS = GetLocation(oBOSS);
	object oTARGET = GetFirstObjectInShape(SHAPE_SPHERE, 100.0, lBOSS, TRUE);
	int nHP;
	int nSAVE;
	effect eDMG;
	effect eNOVA = EffectVisualEffect(VFX_HIT_CLEANSING_NOVA);
	effect eBLIND = EffectBlindness();
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eNOVA, oBOSS);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nDMG), oBOSS);
	while (oTARGET != OBJECT_INVALID)
	{
		if ((nPHASE < 3) && (GetTag(oTARGET) == "heraldannhi_font")) DestroyObject(oTARGET);
		else if ((GetIsEnemy(oTARGET, oBOSS) == TRUE) && (GetIsDead(oTARGET) == FALSE))
		{
			nSAVE = FortitudeSave(oTARGET, 20 + nDMG / 10, SAVING_THROW_TYPE_POSITIVE);
			if (nSAVE == SAVING_THROW_CHECK_FAILED)
			{
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBLIND, oTARGET, fDUR);
			}
			else nDMG = nDMG / 2;
			eDMG = EffectDamage(nDMG, DAMAGE_TYPE_POSITIVE, DAMAGE_POWER_NORMAL, TRUE);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eDMG, oTARGET);
		}
		oTARGET = GetNextObjectInShape(SHAPE_SPHERE, 100.0, lBOSS, TRUE);
	}
}

void TotalDarkness(object oBOSS)
{
	if (PS_GetLocalInt(oBOSS, "BOSS_DEFEATED") == 1) return;
	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_AOE_CRADLE_OF_RIME), oBOSS);
	float fDUR = RoundsToSeconds(1);
	effect eDARK = EffectDarkness();
	eDARK = EffectLinkEffects(eDARK, EffectVisualEffect(VFX_HIT_CRADLE_OF_RIME));
	eDARK = EffectLinkEffects(eDARK, EffectVisualEffect(VFX_DUR_DARKNESS));
	eDARK = SupernaturalEffect(eDARK);
	location lBOSS = GetLocation(oBOSS);
	object oTARGET = GetFirstObjectInShape(SHAPE_SPHERE, 100.0, lBOSS, TRUE);
	while (oTARGET != OBJECT_INVALID)
	{
		if ((GetIsEnemy(oTARGET, oBOSS) == TRUE)&&(GetIsDead(oTARGET) == FALSE))
		{
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDARK, oTARGET, fDUR);
		}
		oTARGET = GetNextObjectInShape(SHAPE_SPHERE, 100.0, lBOSS, TRUE);
	}
}

void CueWarning(object oBOSS, int nPHASE, int nTYPE)
{	
	if (PS_GetLocalInt(oBOSS, "BOSS_DEFEATED") == 1) return;
	int nORDER = PS_GetLocalInt(oBOSS, "BOSS_FINAL_ORDER");
	int nVFX = -1;
	switch (nPHASE)
	{
		case 0:
			CallChampions(oBOSS);
			nVFX = VFX_DUR_CONE_SONIC;
			break;
		case 1:
			if (nTYPE == 1) nVFX = VFX_SPELL_DUR_BODY_SUN;
			else nVFX = VFX_DUR_PROT_SHADOW_ARMOR;
			break;
		case 2:
			if (nTYPE == 1) FontsOfLife(oBOSS, nPHASE);
			else AnnounceNova(oBOSS);
			break;
		case 3: 
			if (nTYPE == 1)
			{
				switch (nORDER)
				{
					case 0: nVFX = VFX_DUR_CONE_SONIC; break;
					case 1: nVFX = VFX_DUR_PROT_SHADOW_ARMOR; break;
					case 2: AnnounceNova(oBOSS); break;
				}
			}
			else nVFX = VFX_DUR_SHADOW_CLOAK;
			break;
	}
	if (nVFX >= 0)
	{
		effect eFX = EffectVisualEffect(nVFX);
		eFX = SupernaturalEffect(eFX);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFX, oBOSS, RoundsToSeconds(1));
	}
}

void ExecuteSpecial(object oBOSS, int nPHASE, int nTYPE)
{
	int nORDER = PS_GetLocalInt(oBOSS, "BOSS_FINAL_ORDER");
	float fDELAY = RoundsToSeconds(1);
	switch (nPHASE)
	{
		case 0:
			CallChampions(oBOSS);
			ShockWave(oBOSS);
			break;
		case 1:
			if (nTYPE == 1) SoulFire(oBOSS, nPHASE);
			else SharePain(oBOSS);
			break;
		case 2:
			if (nTYPE == 1) BurstLife(oBOSS);
			else CleanseNova(oBOSS, nPHASE);
			break;
		case 3:
			if (nTYPE == 1) switch (nORDER)
			{
				case 0: ShockWave(oBOSS); PS_SetLocalInt(oBOSS, "BOSS_FINAL_ORDER", nORDER + 1); break;
				case 1: SharePain(oBOSS); PS_SetLocalInt(oBOSS, "BOSS_FINAL_ORDER", nORDER + 1); break;
				case 2: CleanseNova(oBOSS, nPHASE); PS_SetLocalInt(oBOSS, "BOSS_FINAL_ORDER", 0); break;
			}
			else TotalDarkness(oBOSS);
	}
}

void BeginPhase(object oBOSS, int nPHASE)
{
	PS_SetLocalInt(oBOSS, "BOSS_SPECIAL", 0);
	ResetFight(oBOSS, TRUE);
	DelayCommand(3.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(1), oBOSS));
	float fDELAY = RoundsToSeconds(1);
	string sTEXT;
	switch (nPHASE)
	{
		case 1: sTEXT = "What is the path to victory? We will learn, as we dance with the reavers."; break;
		case 2: sTEXT = "My pain shall be your pain, but, for those who embrace the warmth of the fire, a new opportunity may arise."; break;
		case 3: sTEXT = "New life, new beginning. A story told countless times. The cycle has to be interrupted if you wish to hear a different tale."; break;
		case 4: sTEXT = "Do not forget what you have learned so far. As the end draws nigh, darkness approaches us all.";
						CueWarning(oBOSS, 1, 1);
						DelayCommand(fDELAY, FinalChampions(oBOSS));
						DelayCommand(fDELAY, SoulFire(oBOSS, 3));
						FontsOfLife(oBOSS, 3);
						break;
	}
	AssignCommand(oBOSS, ClearAllActions());
	AssignCommand(oBOSS, SpeakString(sTEXT));
}

void main()
{
	object oBOSS = OBJECT_SELF;
	if (PS_GetLocalInt(oBOSS, "BOSS_DEFEATED") == 1) return;
	int nHP = GetCurrentHitPoints(oBOSS);
	int nMAX = GetMaxHitPoints(oBOSS);
	if (GetIsInCombat(oBOSS) == FALSE)
	{
		if (GetHasSpellEffect(BOSS_EFFECTS, oBOSS) == FALSE)
		{
			int nBHP = 12000;
			effect eFX = BossFX(nBHP);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, oBOSS);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nBHP), oBOSS);
		}
		if ((nHP == nMAX)&&(PS_GetLocalInt(oBOSS, "BOSS_PHASE_STARTED") == 0)) return;
		ResetFight(oBOSS, FALSE);
		ForceRest(oBOSS);
		PS_SetLocalInt(oBOSS, "BOSS_PHASE", 0);
		PS_SetLocalInt(oBOSS, "BOSS_PHASE_STARTED", 0);
		PS_SetLocalInt(oBOSS, "BOSS_PHASE_CUTSCENE", 0);
		PS_SetLocalInt(oBOSS, "BOSS_FINAL_ORDER", 0);
		PS_SetLocalInt(oBOSS, "BOSS_SPECIAL", 0);
		object oCENTER = GetObjectByTag("wp_herald_center");
		AssignCommand(oBOSS, ActionJumpToObject(oCENTER));
		ChangeToStandardFaction(oBOSS, STANDARD_FACTION_HOSTILE);
		return;
	}
	float fSWITCH;
	int nPHASE = PS_GetLocalInt(oBOSS, "BOSS_PHASE");
	switch (nPHASE)
	{
		case 0: fSWITCH = 0.75; break;
		case 1: fSWITCH = 0.50; break;
		case 2: fSWITCH = 0.25; break;
	}
	float fHEALTH = (IntToFloat(nHP))/(IntToFloat(nMAX));
	if (fHEALTH <= fSWITCH)
	{
		PS_SetLocalInt(oBOSS, "BOSS_PHASE", nPHASE + 1);
		nPHASE = nPHASE + 1;
	}
	if (PS_GetLocalInt(oBOSS, "BOSS_PHASE_STARTED") < nPHASE + 1)
	{
		BeginPhase(oBOSS, nPHASE + 1);
		PS_SetLocalInt(oBOSS, "BOSS_PHASE_STARTED", nPHASE + 1);
		PS_SetLocalInt(oBOSS, "BOSS_PHASE_CUTSCENE", 1);
		DelayCommand(RoundsToSeconds(1), PS_SetLocalInt(oBOSS, "BOSS_PHASE_CUTSCENE", 0));
		return;
	}
	if (PS_GetLocalInt(oBOSS, "BOSS_PHASE_CUTSCENE") == 1) return;
	int nSPECIAL = PS_GetLocalInt(oBOSS, "BOSS_SPECIAL");
	switch (nSPECIAL)
	{
		case 0: CueWarning(oBOSS, nPHASE, 1); break;
		case 1: ExecuteSpecial(oBOSS, nPHASE, 1); break;
		case 2: CueWarning(oBOSS, nPHASE, 2); break;
		case 3: ExecuteSpecial(oBOSS, nPHASE, 2); break;
	}
	if (nSPECIAL < 3) PS_SetLocalInt(oBOSS, "BOSS_SPECIAL", nSPECIAL + 1);
	else PS_SetLocalInt(oBOSS, "BOSS_SPECIAL", 0);
}