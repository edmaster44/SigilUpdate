#include "ginc_misc"

int StartingConditional()
{
	object oPC = GetPCSpeaker();

	int nSubrace = GetSubRace(oPC);

	return (nSubrace = 41);
}