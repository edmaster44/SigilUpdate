const int FEAT_IMPROVED_TELTHOR_COMPANION = 2879;
const int FEAT_BEAR_KINGS_BOON = 2878;
const string WOLF_PREFIX = "c_ancom_twolf";
const string BEAR_PREFIX = "c_ancom_tbear";

#include "ps_inc_functions"
void main()
{
	object oPC = OBJECT_SELF;
	int CL = PS_GetCasterLevel(oPC); // TODO - HAH Done
	int summonLevel = (CL / 3) + 1;
	if (GetHasFeat(FEAT_IMPROVED_TELTHOR_COMPANION, oPC)) summonLevel = ++summonLevel;
	string prefix = WOLF_PREFIX;
	string name = "Telthor Wolf";
	if (GetHasFeat(FEAT_BEAR_KINGS_BOON, oPC)) {
		prefix = BEAR_PREFIX;
		name = "Telthor Bear"; }
	
	SummonAnimalCompanion(oPC, prefix + IntToString(summonLevel));
	
	object oCompanion = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oPC);
	SetFirstName(oCompanion, name);
	
	SendMessageToPC(oPC, "Calling rank " + IntToString(summonLevel) + " spirit. (Caster Level " + IntToString(CL) + ").");
	
	return;
}