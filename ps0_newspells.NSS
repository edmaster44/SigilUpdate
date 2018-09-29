/* Feat created by Ceremorph 11/25/15
Spell-like abilities granted by race or racial PrC  */

#include "x2_inc_spellhook"
#include "ps0_newspells_inc"
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
		case 1483 :		//Dread Word
			PS_Spell_DreadWord(oPC, oTarget, nSpell);
		break;
////////////////////////////////////////////////////////////////////////////////////
		case 1484 :		//Gutwrench
			PS_Spell_Gutwrench(oPC, oTarget, nSpell);
		break;
////////////////////////////////////////////////////////////////////////////////////
		case 1485 :		//Freezing Fog
			PS_Spell_FreezingFog(oPC, lTarget, nSpell);
		break;
////////////////////////////////////////////////////////////////////////////////////
	}
}