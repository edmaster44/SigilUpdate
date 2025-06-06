/* Feat created by Ceremorph 4/18/2016
Spell-like abilities granted by certain classes  */

#include "x2_inc_spellhook"
#include "ps0_newfeats_inc"
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
		case 1300 :		//Counterspell
			PS_Feat_Counterspell(oPC, oTarget);
		break;
////////////////////////////////////////////////////////////////////////////////////
		case 1317 :		//Control Undead
			PS_Feat_ControlUndead(oPC, oTarget, nSpell);
		break;
////////////////////////////////////////////////////////////////////////////////////
		case 1318 :		//Bolster Undead
			PS_Feat_BolsterUndead(oPC, oTarget, nSpell);
		break;
////////////////////////////////////////////////////////////////////////////////////
		case 1392 :		//Psionic Thrust
			PS_Feat_PsionicThrust(oPC, oTarget, nSpell);
		break;
////////////////////////////////////////////////////////////////////////////////////
		case 1393 :		//Psionic Dominate Person
			PS_Feat_PsionicDominate(oPC, oTarget, nSpell);
		break;
////////////////////////////////////////////////////////////////////////////////////
		case 1394 :		//Psionic Body Adjustment
			PS_Feat_PsionicBodyAdjustment(oPC, nSpell);
		break;
////////////////////////////////////////////////////////////////////////////////////
		case 1395 :		//Psionically Gifted
			PS_Feat_PsionicallyGifted(oPC, nSpell);
		break;
////////////////////////////////////////////////////////////////////////////////////
		case 1396 :		//Psionic Overcharge
			PS_Feat_PsionicOvercharge(oPC, nSpell);
		break;
////////////////////////////////////////////////////////////////////////////////////
		case 1601 :		//Servant of the Heavens Background Feat
			PS_Feat_ServantOfTheHeavens(oPC, nSpell);
		break;
////////////////////////////////////////////////////////////////////////////////////
		case 1602 :		//Disciple of Darkness Background Feat
			PS_Feat_DiscipleOfDarkness(oPC, nSpell);
		break;
////////////////////////////////////////////////////////////////////////////////////
		case 1624 :		//Sacred Vow Background Feat
			PS_Feat_SacredVow(oPC, nSpell);
		break;
////////////////////////////////////////////////////////////////////////////////////
		case 1625 :		//Unhallowed Background Feat
			PS_Feat_Unhallowed(oPC, nSpell);
		break;
////////////////////////////////////////////////////////////////////////////////////
	case 2000 :		//Stern,Background Feat
			PS_Feat_Stern(oPC, nSpell);
		break;
////////////////////////////////////////////////////////////////////////////////////
		case 2001 :		//Misdirector, Background Feat
			PS_Feat_Misdirector(oPC, nSpell);
		break;
////////////////////////////////////////////////////////////////////////////////////
		case 2002 :		//Tinker, Background Feat
			PS_Feat_Tinker(oPC, nSpell);
		break;
////////////////////////////////////////////////////////////////////////////////////
		case 2003 :		//Naturalist Background Feat
			PS_Feat_Naturalist(oPC, nSpell);
		break;
////////////////////////////////////////////////////////////////////////////////////
		case 2004 :		//Amicable Background Feat
			PS_Feat_Amicable(oPC, nSpell);
		break;


	}
}