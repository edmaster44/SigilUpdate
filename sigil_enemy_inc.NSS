#include "ps_inc_functions"

const int NWN2_MAXDAMAGE = 9999;

//This subroutine properly inflicts damage on oTARGET. Can exceed 9999 damage.
//nTYPE: DAMAGE_TYPE_*
//nPOWER: DAMAGE_POWER_*
//nIGNORED: Percentage of the damage that ignores resistances. If set to 100, all damage will ignore resistances.
void InflictDamage(object oTARGET, int nDAMAGE, int nTYPE = DAMAGE_TYPE_MAGICAL, int nIGNORED = 0, int nPOWER = DAMAGE_POWER_NORMAL)
{
	int nIGN = (nDAMAGE * nIGNORED) / 100;
	if (nIGN > nDAMAGE) nIGN = nDAMAGE;
	else if (nIGN < 0) nIGN = 0;
	int nDMG = nDAMAGE - nIGN;
	
	effect eFX = EffectDamage(NWN2_MAXDAMAGE, nTYPE, nPOWER);
	while (nDMG > 0)
	{
		if (nDMG < NWN2_MAXDAMAGE) eFX = EffectDamage(nDMG, nTYPE, nPOWER);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eFX, oTARGET);
		nDMG = nDMG - NWN2_MAXDAMAGE;
	}
	
	eFX = EffectDamage(NWN2_MAXDAMAGE, nTYPE, nPOWER, TRUE);
	while (nIGN > 0)
	{
		if (nIGN < NWN2_MAXDAMAGE) eFX = EffectDamage(nIGN, nTYPE, nPOWER, TRUE);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eFX, oTARGET);
		nIGN = nIGN - NWN2_MAXDAMAGE;
	}
}

void EncounterReset(object oENEMY)
{
	object oAREA = GetArea(oENEMY);
	PS_DeleteLocalInt(oAREA, "SPECIAL_PHASE");
	effect eRES = EffectResurrection();
	object oSTARTER = PS_GetLocalObject(oENEMY, "START_NPC");
	object oRESPAWN = PS_GetLocalObject(oENEMY, "RESPAWN_POINT");
	object oPC = GetFirstObjectInArea(oAREA);
	while (oPC != OBJECT_INVALID)
	{
		if (GetObjectType(oPC) == OBJECT_TYPE_CREATURE)
		{
			if (GetIsOwnedByPlayer(oPC) == TRUE)
			{
				AssignCommand(oPC, JumpToObject(oRESPAWN));
				if (GetIsDead(oPC) == TRUE) ApplyEffectToObject(DURATION_TYPE_INSTANT, eRES, oPC);
			}
			else if (oPC != oSTARTER)
			{
				AssignCommand(oPC, SetIsDestroyable(TRUE));
				DestroyObject(oPC);
			}
		}
		oPC = GetNextObjectInArea(oAREA);
	}
	SetScriptHidden(oSTARTER, FALSE);
}

void EnemyCutscene(object oENEMY, float fDUR)
{
	PS_SetLocalInt(oENEMY, "ENEMY_CUTSCENE", TRUE);
	location lENEMY = GetLocation(oENEMY);
	effect eFX = EffectCutsceneParalyze();
	eFX = ExtraordinaryEffect(eFX);
	object oINVALID = OBJECT_INVALID;
	object oANY = GetFirstObjectInShape(SHAPE_SPHERE, 100.0, lENEMY, TRUE);
	while (oANY != oINVALID)
	{
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFX, oANY, fDUR);
		oANY = GetNextObjectInShape(SHAPE_SPHERE, 100.0, lENEMY, TRUE);
	}
	DelayCommand(fDUR, PS_DeleteLocalInt(oENEMY, "ENEMY_CUTSCENE"));
}

void EnemySpeak(object oENEMY, string sTEXT, int nVOLUME = TALKVOLUME_TALK, int nCLEAR = FALSE)
{
	AssignCommand(oENEMY, ClearAllActions(nCLEAR));
	AssignCommand(oENEMY, ActionSpeakString(sTEXT, nVOLUME));
}

void EnemyReward(object oPC, object oENEMY)
{
	int nRANK = PS_GetLocalInt(oENEMY, "ENEMY_RANK");
	if (nRANK < 1) nRANK = 1;
	int nDIFF = PS_GetLocalInt(oENEMY, "ENEMY_DIFF");
	if (nDIFF < 1) nDIFF = 1;
	else if (nDIFF > 4) nDIFF = 4;
	int nHD = GetHitDice(oENEMY);
	int nGAP;
	int nXP;
	int nXP_BASE = nDIFF * nHD * nRANK * 2;
	string sDROP = PS_GetLocalString(oENEMY, "ENEMY_DROP");
	int nDROP = nDIFF * nRANK;
	int nSTACK;
	object oDROP;
	object oAREA = GetArea(oENEMY);
	object oPARTY = GetFirstFactionMember(oPC, FALSE);
	while (oPARTY != OBJECT_INVALID)
	{
		if (GetIsOwnedByPlayer(oPARTY) == TRUE)
		{
			if (GetArea(oPARTY) == oAREA)
			{
				nGAP = GetHitDice(oPARTY) - nHD;
				if (nGAP < 1) nXP = nXP_BASE;
				else nXP = (nXP_BASE * (100 - nGAP * 20)) / 100;
				if (nXP > 0) PS_GiveXPReward(oPARTY, nXP);
				if (sDROP != "")
				{
					oDROP = GetItemPossessedBy(oPARTY, sDROP);
					if (oDROP == OBJECT_INVALID) CreateItemOnObject(sDROP, oPARTY, nDROP);
					else
					{
						nSTACK = GetItemStackSize(oDROP);
						if (nSTACK > 1000 - nDIFF) CreateItemOnObject(sDROP, oPARTY, nDROP);
						else SetItemStackSize(oDROP, nSTACK + nDROP);
					}
				}
			}
		}
		oPARTY = GetNextFactionMember(oPC, FALSE);
	}
}