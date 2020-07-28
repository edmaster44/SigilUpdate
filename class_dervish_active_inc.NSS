#include "x2_inc_spellhook"
#include "aaa_constants"
#include "X0_I0_SPELLS"
#include "nw_i0_spells"
#include "class_dervish_active"


//This is an Active Include for the Dervish Class, it include feats such as Dervish Dance, and Dance of Death. 


void main()
{
	if (!X2PreSpellCastCode()) return;
    object oPC = OBJECT_SELF;
	int nSpell = GetSpellId();
	if (GetHasSpellEffect(nSpell, oPC)) RemoveEffectsFromSpell(oPC, nSpell);
	
	switch (nSpell)
	{
		case 1927:	//Dervish Dance
		DelayCommand(0.0f, Dervish_Dance(oPC, nSpell));
		break;
	
	
	
	
	}
	
	
	
}	