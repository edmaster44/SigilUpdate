/*Script constants for the class Nature Warrior by edmaster44 7/6/2021*/
#include "aaa_constants"
#include "x2_inc_spellhook"
#include "class_nc"

void main()
{
	if (!X2PreSpellCastCode())
    {	return;	}
    object oPC = OBJECT_SELF;
	object oTarget	= GetSpellTargetObject();
	int nSpell = GetSpellId();
	if (GetHasSpellEffect(nSpell, oPC)) RemoveEffectsFromSpell(oPC, nSpell);
	
	
		
	switch (nSpell)
	{
		
	case SPELLABILITY_ARMOR_OF_THE_CROCODILE :		//Armor of the Crocidile	
			DelayCommand(0.0f, Armor_of_the_crocodile(oPC, nSpell));
		break;

			case SPELLABILITY_CLAWS_OF_THE_GRIZZLY:		//Claws of the Grizzly
			DelayCommand(0.0f, Claws_of_the_grizzly(oPC, nSpell));
		break;
		case SPELLABILITY_EARTH_RESILIENCE:		//Earth Resilience
			DelayCommand(0.0f, Earth_Resilience(oPC, nSpell));
		break;
		
			case SPELLABILITY_NATURES_WEAPON:		//Nature's Weapon
			DelayCommand(0.0f, Nature_Weapon(oPC, nSpell));
		break;
				case SPELLABILITY_WILD_GROWTH:		//Wild Growt
			DelayCommand(0.0f, Wild_Growth(oPC, nSpell));
		break;
		
		}
		}