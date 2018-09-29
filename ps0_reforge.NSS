/* Feat created by Ceremorph 4/18/2016
Spell-like abilities granted by certain classes  */

#include "x2_inc_spellhook"
#include "ps0_reforge_inc"
#include "aaa_constants"
#include "ps_inc_functions"


void main()
{
	if (!X2PreSpellCastCode())
    {	return;	}

    object oPC 			= OBJECT_SELF;
	int nSpell 			= GetSpellId();
	object oTarget		= GetSpellTargetObject();
	location lTarget	= GetSpellTargetLocation();
	int iLevel;
	
	switch (nSpell)
	{
		case 633 :		//Reforge Weapon
			PS_Reforge_Weapon(oTarget, oPC);
		break;
////////////////////////////////////////////////////////////////////////////////////
		case 634 :		//Reforge Armor
			PS_Reforge_Armor(oTarget, oPC);
		break;
////////////////////////////////////////////////////////////////////////////////////
		case 635 :		//Reforge Shield
			PS_Reforge_Shield(oTarget, oPC);
		break;
////////////////////////////////////////////////////////////////////////////////////
	}
}