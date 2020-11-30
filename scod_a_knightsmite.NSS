#include "aaa_constants"
#include "x2_inc_spellhook"
#include "scod_a_knightsmite_inc"

void main()
{


	if (!X2PreSpellCastCode())
    {	return;	}
    object oPC = OBJECT_SELF;
	object oTarget	= GetSpellTargetObject();
	int nSpell = GetSpellId();

switch (nSpell)

	case SPELLABILITY_KNIGHTSMITE:		//Knight Smite
		{	KnightSmite(oPC, oTarget,nSpell);}
		

		
		
		
	
}