#include "sigil_enemy_inc"

void TransportParty(object oBOSS, object oPC, string sLOC_PARTY, string sHELP_REF, string sHELP_TAG, string sHELP_LOC, string sRESPAWN, object oAREA)
{
	object oDESTINATION = GetObjectByTag(sLOC_PARTY);
	if (oDESTINATION == OBJECT_INVALID) return;
	
	if (sHELP_REF != "")
	{
		location lHELPER = GetLocation(GetObjectByTag(sHELP_LOC));
		object oHELPER = CreateObject(OBJECT_TYPE_CREATURE, sHELP_REF, lHELPER, FALSE, sHELP_TAG);
	}
	object oSTARTER = OBJECT_SELF;
	object oRESPAWN = GetObjectByTag(sRESPAWN);
	SetLocalObject(oBOSS, "RESPAWN_POINT", oRESPAWN);
	SetLocalObject(oBOSS, "START_NPC", oSTARTER);
	SetScriptHidden(oSTARTER, TRUE);
	
	object oPARTY = GetFirstFactionMember(oPC, FALSE);
	while (oPARTY != OBJECT_INVALID)
	{
		if (GetArea(oPARTY) == oAREA) AssignCommand(oPARTY, JumpToObject(oDESTINATION));
		oPARTY = GetNextFactionMember(oPC, FALSE);
	}
}

void main(string sBOSS, string sLOC_BOSS, string sLOC_PARTY, string sHELP_REF, string sHELP_TAG, string sHELP_LOC, int nDIFF, string sRESPAWN)
{
	location lBOSS = GetLocation(GetObjectByTag(sLOC_BOSS));
	if (GetIsLocationValid(lBOSS) == FALSE) return;

	if(nDIFF < 1) nDIFF = 1;
	
	object oPC = GetPCSpeaker();
	object oAREA = GetArea(oPC);
	SetLocalInt(oAREA, "ENEMY_DIFF", nDIFF);
	SetLocalInt(oAREA, "WRECK_HAVOC", TRUE);
	object oBOSS = CreateObject(OBJECT_TYPE_CREATURE, sBOSS, lBOSS);
	if (oBOSS == OBJECT_INVALID) return;
	
	DelayCommand(0.0f, TransportParty(oBOSS, oPC, sLOC_PARTY, sHELP_REF, sHELP_TAG, sHELP_LOC, sRESPAWN, oAREA));
}