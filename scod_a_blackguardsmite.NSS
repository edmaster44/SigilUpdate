#include "aaa_constants"
#include "x2_inc_spellhook"
#include "scod_a_blackguardsmite_inc"

void main()
{


	if (!X2PreSpellCastCode())
    {	return;	}
    object oPC = OBJECT_SELF;
	object oTarget	= GetSpellTargetObject();
	int nSpell = GetSpellId();

switch (nSpell)

	case SPELLABILITY_BLACKGUARD_SMITE:		//Blackguard Smite
		{	blackguardsmite(oPC, oTarget,nSpell);}
		

		
		
		
	
}