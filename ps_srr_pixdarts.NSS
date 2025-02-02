#include "ff_safevar"

// Pixies can magically create darts which have sleep enchantment on them.

void main()
{
	object oPC = OBJECT_SELF;
	
	object oItem = CreateItemOnObject("pssrrpixdarts", oPC, 50);
	int iLevels = GetTotalLevels(oPC, TRUE);
	PS_SetLocalInt(oItem, "CLEVEL", iLevels); // store the caster level on the dart itself.
	
	// this didn't work for some unknown reason, so making it a unique on-hit property.
	/*int iDur;
	int iDC = GetTotalLevels(oPC, TRUE)/3 + 1;
	
	if (iLevels < 6) iDur = IP_CONST_ONHIT_DURATION_50_PERCENT_1_ROUNDS;
	else if (iLevels < 11) iDur = IP_CONST_ONHIT_DURATION_50_PERCENT_2_ROUNDS;
	else if (iLevels < 16) iDur = IP_CONST_ONHIT_DURATION_50_PERCENT_3_ROUNDS;
	else if (iLevels < 21) iDur = IP_CONST_ONHIT_DURATION_50_PERCENT_4_ROUNDS;
	else if (iLevels < 26) iDur = IP_CONST_ONHIT_DURATION_50_PERCENT_5_ROUNDS;
	else iDur = IP_CONST_ONHIT_DURATION_100_PERCENT_5_ROUND;
	
	itemproperty ipSleep = ItemPropertyOnHitProps(IP_CONST_ONHIT_SLEEP, iDC, iDur);
	AddItemProperty(DURATION_TYPE_PERMANENT, ipSleep, oItem);
	*/
}