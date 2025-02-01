#include "ff_safevar"

// script called from ps_srr_conv_dbreath - sets dragonman race breath weapon

void main(int iType)
{
	object oPC = GetPCSpeaker();
	object oItem = GetItemPossessedBy(oPC,"ps_essence");
	int iImmunity;
	
	if(GetIsObjectValid(oItem))
	{
		PS_SetLocalInt(oItem, "DRAGONTYPE", iType);
		
		// give appropriate immunity.
		switch (iType)
		{
			case 2: // silver
      			case 10: //white
				iImmunity = 2261;
				break;
			case 3: //copper
      			case 7: //black
			case 9: //green
				iImmunity = 2282;
				break;
			case 1: //gold
			case 4: //brass
			case 6: //red
				iImmunity = 2260;
				break;
			case 5: // bronze
			case 8: //blue
				iImmunity = 2283;
				break;
		}
		FeatAdd(oPC, iImmunity, FALSE, TRUE, FALSE);
	}
	else
	{
		SendMessageToPC(oPC, "You appear to be missing your Essence. Unable to set Dragon breath type. Contact a member of staff.");
	}
}