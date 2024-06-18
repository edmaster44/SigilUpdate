/* Feat created by Ceremorph 11/25/15
Boosts immunity of the creature based on level  */

#include "x2_inc_spellhook"
#include "aaa_racial_immune_inc"
#include "aaa_constants"
#include "nw_i0_spells"

void main()
{
	if (!X2PreSpellCastCode()) return;
    object oPC = OBJECT_SELF;
	int nSpell = GetSpellId();
	if (GetHasSpellEffect(nSpell, oPC)) RemoveEffectsFromSpell(oPC, nSpell); //It has to be done in any case
	//Commands are delayed to make sure the spell effect is removed before it's reapplied.
	//Spell ID is reapplied within the commands to make sure it's not lost by the delay.
	
	switch (nSpell)
	{
		case 575 :		//Archons	
			DelayCommand(0.0f, PS_Immunity_Archon(oPC, nSpell));
		break;
		case 1245 :		//Eladrin	
			DelayCommand(0.0f, PS_Immunity_Eladrin(oPC, nSpell));
		break;
		case 1442 :		//Fire and Frost Giants	
			DelayCommand(0.0f, PS_Immunity_Giant(oPC, nSpell));
		break;
		case 1447 :		//Astral, Monadic, and Movanic Deva
			DelayCommand(0.0f, PS_Immunity_Deva(oPC, nSpell));
		break;
		case 1455 :		//Baatezu
			DelayCommand(0.0f, PS_Immunity_Baatezu(oPC, nSpell));
		break;
		case 1458 :		//Tanar'ri
		case 2605 :		//Hezrou , because I didnt get it to work included in 1458 and I dont do half-things.
			DelayCommand(0.0f, PS_Immunity_Tanarri(oPC, nSpell));
		break;
		case 1488 :		//Night Hag
			DelayCommand(0.0f, PS_Immunity_NightHag(oPC, nSpell));
		break;
		case 1493 :		//Night Hag - Mistress of the Coven PrC
			DelayCommand(0.0f, PS_Immunity_NightHag_MOTC(oPC, nSpell));
		break;
		case 1900 :		//Rakshasa - Racial & PrC Effects
			DelayCommand(0.0f, PS_Immunity_Rakshasa(oPC, nSpell));
		break;
		case 1913 :     // Khayal
			DelayCommand(0.0f, PS_Immunity_Khayal(oPC, nSpell));
		break;
		case 1429 :     // Rilmani
			DelayCommand(0.0f, PS_Immunity_Rilmani(oPC, nSpell));
		break;		
	}
}