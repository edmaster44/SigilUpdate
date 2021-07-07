/*Script constants for the class Nature Warrior by edmaster44 7/6/2021*/
#include "aaa_constants"
#include "x2_inc_spellhook"
#include "class_nc_activate"

void main()
{
	if (!X2PreSpellCastCode())
    {	return;	}
    object oPC = OBJECT_SELF;
	object oTarget	= GetSpellTargetObject();
	int nSpell = GetSpellId();
	
	
	switch (nSpell)
{	

	case SPELLABILITY_BLAZE_OF_POWER:		//Earth Resilience
			DelayCommand(0.0f, Blaze_Of_Power(oPC, nSpell));
		break;
		
			case SPELLABILITY_ROBE_OF_CLOUDS:		//Nature's Weapon
			DelayCommand(0.0f, Robe_Of_Clouds(oPC, nSpell));
		break;
	
	case SPELLABILITY_SERPENTINE_COIL :		//Armor of the Crocidile	
			Serpentine_Coil(oPC,oTarget, nSpell);
		break;
	
	}
}