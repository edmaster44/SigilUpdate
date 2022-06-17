#include "nwnx_bg"
#include "ps_adjust_knight"
#include "ps_inc_functions"
// Calculate Great Smiting Multiplier based on feat count [1, 11].
int GreatSmiteMultiplier(object oPC);


// For some reason OEI didn't include this constant in nwscript.nss.
const int FEAT_SMITE_INFIDEL = 1761;

// Not sure if this is a custom feat or not for bgtscc.
// This is used to check for Destruction Domain for Clerics.
const int FEAT_EPITHET_DESTRUCTION_DOMAIN = 1837;


void main()
{

	// Information from NWNX.
	int nFeat = LastSpcFeatId();
	object oPC = LastSpcAttacker();
	object oTarget = LastSpcTarget();
	
	// Tally amount to be sent back to NWNX.
	int nAmount = 0;

	switch(nFeat)
	{

		case FEAT_STUNNING_FIST:

			if(GetLevelByClass(CLASS_TYPE_MONK, oPC) == 0)
			{
				// Non-monks deal four less damage when executing a stunning fist.
				nAmount = -4;
			}
		break;


		case FEAT_SMITE_EVIL:						

			if(GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
			{
				nAmount = KnightLevels(oPC);
				//nAmount += GetLevelByClass(CLASS_TYPE_DIVINECHAMPION, oPC);
				nAmount *= GreatSmiteMultiplier(oPC);
			}
		break;

		
		case FEAT_SMITE_GOOD:

			if(GetAlignmentGoodEvil(oTarget) == ALIGNMENT_GOOD)
			{
				nAmount = KnightLevels(oPC);
				//nAmount += GetLevelByClass(CLASS_TYPE_DIVINECHAMPION, oPC);
				nAmount *= GreatSmiteMultiplier(oPC);
			}
		break;


		case FEAT_SMITE_INFIDEL:

			if(GetAlignmentGoodEvil(oPC) != GetAlignmentGoodEvil(oTarget) ||
			   GetAlignmentLawChaos(oPC) != GetAlignmentLawChaos(oTarget))
			{


				nAmount = GetLevelByClass(CLASS_TYPE_DIVINECHAMPION, oPC);

				if(GetHasFeat(FEAT_EPITHET_DESTRUCTION_DOMAIN, oPC))
				{
					nAmount += GetClericTRUECasterlevel(oPC);
				}
				nAmount *= GreatSmiteMultiplier(oPC);
			}
		break;


		case FEAT_FLOURISH:

			nAmount = d6(2);	
		break;


		case FEAT_BOND_OF_FATAL_TOUCH:

			int doomLvls = GetLevelByClass(CLASS_TYPE_DOOMGUIDE, oPC);

			if(GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
			{
				if(doomLvls > 4)
				{
					nAmount = d6();	// d6 extra vs. undead if level 5 or greater.
				}

				if(doomLvls > 6)
				{
					nAmount += 2 + d6(2); // 2+2d6 additional if level 7 or higher.  (+2 is from extra enhancement).
				}
			}
		break;
	
	}


	// Pass total damage amount back to NWNX.
	SetLastSpcDmg(nAmount);


}

int GreatSmiteMultiplier(object oPC)
{
	int multiplier = 1;
	// Great Smite Feats are 824 through 833 inclusive.
	int i;
	for(i = 0; i < 10; i++)
	{
		multiplier += GetHasFeat(FEAT_EPIC_GREAT_SMITING_1+i, oPC);
	}
	return multiplier;
}