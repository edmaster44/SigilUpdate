/*
	The purpose of this script is to Resolve Special Attack Damage Bonus (rsadb).

	Normally, these are feats which are hardcoded in engine to calculate their
	damage bonus when used.  This includes:

	Stunning Fist (non-monks get -4 damage bonus when using)
	Smite Evil
	Smite Good
	Smite Infidel
	Flourish
	Bond of Fatal Touch

	If the rsadb mod is enabled in the xp_dae.ini then this script is called
	instead of normal engine routine for the calculation of the damage bonus
	for those feats.

	The plug-in gives you the following important functions:

	rsadb_FeatId() --> Gives you the FeatID of the feat used.
	rsadb_Attacker() --> Gives you the object which is attacking with the feat.
	rsadb_Target() --> Gives you the target object being attacked.

	rsadb_SetDamage(int nAmount) --> Used to tell the plug-in the final damage bonus
									 you wish to set.

	Important:
		Be careful when changing the state of the objects attacking or being attacked.
		This script is called mid-round.  So things like granting the character a 
		feat in the middle of a round can interrupt the round causing weird behavior.

*/
#include "nwnx_dae"
#include "ps_adjust_knight"

// Calculate Great Smiting Multiplier based on feat count [1, 11].
int GreatSmiteMultiplier(object oAttacker);


// For some reason OEI didn't include this constant in nwscript.nss.
const int FEAT_SMITE_INFIDEL = 1761;

// Not sure if this is a custom feat or not for bgtscc.
// This is used to check for Destruction Domain for Clerics.
const int FEAT_EPITHET_DESTRUCTION_DOMAIN = 1837;

const int FEAT_SMITE_EVIL_6 = 1934;
const int FEAT_SMITE_EVIL_7 = 1935;

void main()
{

	// Information from NWNX.
	int nFeat = rsadb_FeatId();
	object oAttacker = rsadb_Attacker();
	object oTarget = rsadb_Target();
	
	// Tally amount to be sent back to NWNX.
	int nAmount = 0;

	switch(nFeat)
	{

		case FEAT_STUNNING_FIST:

			if(GetLevelByClass(CLASS_TYPE_MONK, oAttacker) == 0)
			{
				// Non-monks deal four less damage when executing a stunning fist.
				nAmount = -4;
			}
		break;


		case FEAT_SMITE_EVIL:
		case FEAT_SMITE_EVIL_2:
		case FEAT_SMITE_EVIL_3:
		case FEAT_SMITE_EVIL_4:
		case FEAT_SMITE_EVIL_5:
		case FEAT_SMITE_EVIL_6:
		case FEAT_SMITE_EVIL_7:

			if(GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
			{
				nAmount = KnightLevels(oAttacker);
				nAmount *= GreatSmiteMultiplier(oAttacker);
			}
		break;

		
		case FEAT_SMITE_GOOD:

			if(GetAlignmentGoodEvil(oTarget) == ALIGNMENT_GOOD)
			{
			nAmount = KnightLevels(oAttacker);
				nAmount *= GreatSmiteMultiplier(oAttacker);
			}
		break;


		case FEAT_SMITE_INFIDEL:

			if(GetAlignmentGoodEvil(oAttacker) != GetAlignmentGoodEvil(oTarget) ||
			   GetAlignmentLawChaos(oAttacker) != GetAlignmentLawChaos(oTarget))
			{

				nAmount = KnightLevels(oAttacker);

				if(GetHasFeat(FEAT_EPITHET_DESTRUCTION_DOMAIN, oAttacker))
				{
					nAmount += GetLevelByClass(CLASS_TYPE_CLERIC, oAttacker);
				}
				nAmount *= GreatSmiteMultiplier(oAttacker);
			}
		break;


		case FEAT_FLOURISH:

			nAmount = d6(2);	
		break;


		case FEAT_BOND_OF_FATAL_TOUCH:

			int doomLvls = GetLevelByClass(CLASS_TYPE_DOOMGUIDE, oAttacker);

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
	rsadb_SetDamage(nAmount);


}

int GreatSmiteMultiplier(object oAttacker)
{
	int multiplier = 1;
	// Great Smite Feats are 824 through 833 inclusive.
	int i;
	for(i = 0; i < 10; i++)
	{
		multiplier += GetHasFeat(FEAT_EPIC_GREAT_SMITING_1+i, oAttacker);
	}
	return multiplier;
}