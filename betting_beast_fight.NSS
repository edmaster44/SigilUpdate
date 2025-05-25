

#include "gm_include"

int GetMonsterNumber(string sMon);

void main() {
	object oBeastmaster = OBJECT_SELF;

	object oWP1 = GetWaypointByTag("wp_fw_monster1");
	object oMonster1 = CreateObject(OBJECT_TYPE_CREATURE, "ps_fw_monster1", GetLocation(oWP1));
	object oWP2 = GetWaypointByTag("wp_fw_monster2");
	object oMonster2 = CreateObject(OBJECT_TYPE_CREATURE, "ps_fw_monster2", GetLocation(oWP2));
	string sWinner = GetLocalString(OBJECT_SELF, "POTENTIAL_WINNER");
	string sMon1 = GetLocalString(OBJECT_SELF, "MONSTER1");
	string sMon2 = GetLocalString(OBJECT_SELF, "MONSTER2");
	int nMon1 = GetMonsterNumber(sMon1);
	int nMon2 = GetMonsterNumber(sMon2);
	
	if (nMon1 != 0)
		SetCreatureAppearanceType(oMonster1, nMon1);
	if (nMon2 != 0)
		SetCreatureAppearanceType(oMonster2, nMon2);
	SetFirstName(oMonster1, sMon1);
	SetFirstName(oMonster2, sMon2);
	
	AssignCommand(oMonster1, ActionAttack(oMonster2));
	AssignCommand(oMonster2, ActionAttack(oMonster1));
	
	if (GetFirstName(oMonster2) == sWinner)
		SetLocalInt(oMonster2, "Winner", 1);
	else
		SetLocalInt(oMonster1, "Winner", 1);
}

int GetMonsterNumber(string sMon) {
	if (sMon == BEAR)
		return BEAR_NUM;
	else if (sMon == WOLF)
		return WOLF_NUM;
	else if (sMon == DISPLACER_BEAST)
		return BEAST_NUM;
	else if (sMon == TIGER)
		return TIGER_NUM;
	else if (sMon == LION)
		return LION_NUM;
	else if (sMon == SPIDER)
		return SPIDER_NUM;
	else if (sMon == DEINONYCHUS)
		return DEINONYCHUS_NUM;
	return 0;
}