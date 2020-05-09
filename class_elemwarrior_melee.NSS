#include "aaa_constants"
#include "x2_inc_spellhook"
#include "class_elemwarrior_melee_inc"

void main()
{


	if (!X2PreSpellCastCode())
    {	return;	}
    object oPC = OBJECT_SELF;
	object oTarget	= GetSpellTargetObject();
	int nSpell = GetSpellId();

switch (nSpell)

	case 1922 :		//Elemental Strike
		{	ElementalStrike(oPC, oTarget,nSpell);}
		

		
		
		
	
}