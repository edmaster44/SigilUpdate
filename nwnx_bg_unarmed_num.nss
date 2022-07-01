#include "nwnx_bg"
#include "nwnx_bg_unarmed_inc"


void main()
{
	// Size category of the creature.
	int nCreatureSize = GetCreatureSize(OBJECT_SELF);
	int nDiceNumber = 0;

	if(nCreatureSize > CREATURE_SIZE_INVALID)
	{
		nDiceNumber = StringToInt(Get2DAString(sUnarmed2da, CreatureSizeToString(nCreatureSize)+"_NUM", GetUnarmed2daRow(OBJECT_SELF)));
	}

	// Tell NWNX the result of this script to set.
	nxnx_bg_fistdmg_setNum(nDiceNumber);
}