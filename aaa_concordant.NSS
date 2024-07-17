#include "x2_inc_spellhook"
#include "aaa_concordant_inc"
#include "aaa_constants"
#include "ps_inc_advscript"

void main()
{
	if (!X2PreSpellCastCode())
    {	return;	}

    object oPC 			= OBJECT_SELF;
	object oTarget		= GetSpellTargetObject();
	location lTarget	= GetSpellTargetLocation();
	object 	oItem		= GetItemPossessedBy(oPC,"ps_essence");
	
	int nSpell 			= GetSpellId();
	int iLevel;
	int iCLev;
	
	switch (nSpell)
	{
///////////////////////////////////////////////////////////////////////////////////
		case 1436 :		//Cuprilach - Concordant Precision
			PS_ConcordantPrecision(oPC, nSpell);
		break;
///////////////////////////////////////////////////////////////////////////////////
		case 1437 :		//Ferrumach - Concordant Prowess
			PS_ConcordantProwess(oPC, nSpell);
		break;
///////////////////////////////////////////////////////////////////////////////////
	}
}