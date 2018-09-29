/* Feat created by Ceremorph 11/25/15
All about undead...  */

#include "x2_inc_spellhook"
#include "aaa_lycan_inc"
#include "aaa_constants"

void main()
{
	if (!X2PreSpellCastCode())
    {	return;	}

    object oPC 		= OBJECT_SELF;
	object oTarget	= GetSpellTargetObject();
	object 	oItem	= GetItemPossessedBy(oPC,"ps_essence");
	int nSpell 		= GetSpellId();
	int iLevel;
	int iCLev;
	
	switch (nSpell)
	{
////////////////////////////////////////////////////////////////////////////////////
		case 331 :		//Affliction
		{	PS_Lycan_Affliction(oPC, oItem, nSpell);			}
		break;	
////////////////////////////////////////////////////////////////////////////////////
		case 332 :		//Animal Form
		{	PS_Lycan_AnimalForm(oPC, oItem, nSpell);			}
		break;	
////////////////////////////////////////////////////////////////////////////////////
		case 333 :		//Damage Reduction
		{	PS_Lycan_DR(oPC, nSpell);			}
		break;	
////////////////////////////////////////////////////////////////////////////////////
		case 334 :		//Hybrid Form
		{	PS_Lycan_HybridForm(oPC, oItem, nSpell);			}
		break;	
////////////////////////////////////////////////////////////////////////////////////
		case 335 :		//Bestial Power - Werewolf
		{	PS_Lycan_BPWerewolf(oPC, oTarget, oItem, nSpell);			}
		break;	
////////////////////////////////////////////////////////////////////////////////////
		case 336 :		//Bestial Power - Wereboar
		{	PS_Lycan_BPWereboar(oPC, oItem, nSpell);			}
		break;	
////////////////////////////////////////////////////////////////////////////////////
		case 337 :		//Bestial Power - Weretiger
		{	PS_Lycan_BPWeretiger(oPC, oTarget, oItem, nSpell);			}
		break;	
////////////////////////////////////////////////////////////////////////////////////
	}
}