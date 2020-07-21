#include "nwn2_inc_spells"
#include "x2_inc_spellhook"
#include "ps_inc_functions"
#include "X0_I0_SPELLS"
#include "nw_i0_spells"

void main()
{
	if (!X2PreSpellCastCode()) return;
    object oPC = OBJECT_SELF;
	int nSpell = GetSpellId();
	if (GetHasSpellEffect(nSpell, oPC)) RemoveEffectsFromSpell(oPC, nSpell); //It has to be done in any case
	//Commands are delayed to make sure the spell effect is removed before it's reapplied.
	//Spell ID is reapplied within the commands to make sure it's not lost by the delay.
	
	
		
//	switch (nSpell)
//	{
//	case 9999:	//Speed Bonus
		//DelayCommand(0.0f, Dervish_Speed(oPC, nSpell));
	//	break;
	
//	case 9999 :		//AC BOnus	
		//	DelayCommand(0.0f, Dervish_AC_Bonus(oPC, nSpell));
	//	break;

	//		case 9999:		//Dervish-Slash	
//		//	DelayCommand(0.0f, Dervish_Slash(oPC, nSpell));
	//	break;
		
	//	
			}
	//		}