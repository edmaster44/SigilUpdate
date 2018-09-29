/* Feat created by Ceremorph 11/25/15
Spell-like abilities granted by race or racial PrC  */

#include "x2_inc_spellhook"
#include "aaa_truename_magic_inc"
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
		case 589 :		//Word Archon Word of Nurturing - Base
			PS_Ability_WordOfNurturing_Base(oPC, oTarget, nSpell);
		break;
////////////////////////////////////////////////////////////////////////////////////
		case 590 :		//Word Archon Word of Nurturing - Self
			PS_Ability_WordOfNurturing_Ally(oPC, oTarget, nSpell);
		break;
////////////////////////////////////////////////////////////////////////////////////
		case 591 :		//Word Archon Word of Nurturing - Enemy
			PS_Ability_WordOfNurturing_Enemy(oPC, oTarget, nSpell);
		break;
////////////////////////////////////////////////////////////////////////////////////
		case 593 :		//Word Archon Word of Shockwave
			PS_Ability_WordOfShockwave(oPC, nSpell);
		break;
////////////////////////////////////////////////////////////////////////////////////
		case 594:		//Word Archon Word of Peace - Base
			PS_Ability_WordOfPeace_Base(oPC, oTarget, nSpell);
		break;
////////////////////////////////////////////////////////////////////////////////////
		case 595:		//Word Archon Word of Peace - Self
			PS_Ability_WordOfPeace_Ally(oPC, oTarget, nSpell);
		break;
////////////////////////////////////////////////////////////////////////////////////
		case 596 :		//Word Archon Word of Peace - Enemy
			PS_Ability_WordOfPeace_Enemy(oPC, oTarget, nSpell);
		break;
////////////////////////////////////////////////////////////////////////////////////
	}
}