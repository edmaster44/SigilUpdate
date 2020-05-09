#include "x2_inc_spellhook"
#include "aaa_constants"
#include "X0_I0_SPELLS"
#include "nw_i0_spells"
#include "class_elemwar_immu_inc"

void main()
{
	if (!X2PreSpellCastCode()) return;
    object oPC = OBJECT_SELF;
	int nSpell = GetSpellId();
	if (GetHasSpellEffect(nSpell, oPC)) RemoveEffectsFromSpell(oPC, nSpell); //It has to be done in any case
	//Commands are delayed to make sure the spell effect is removed before it's reapplied.
	//Spell ID is reapplied within the commands to make sure it's not lost by the delay.
	
	switch (nSpell)
	{
	case 1920:	//Air - Electrical 
		DelayCommand(0.0f, ElemWar_ImmunityAir(oPC, nSpell));
		break;
	
	case 1923 :		//Earth-Acid	
			DelayCommand(0.0f, ElemWar_ImmunityEarth(oPC, nSpell));
		break;

			case 1924 :		//Earth-Acid	
			DelayCommand(0.0f, ElemWar_ImmunityFire(oPC, nSpell));
		break;
		
			case 1925 :		//Earth-Acid	
			DelayCommand(0.0f, ElemWar_ImmunityWater(oPC, nSpell));
		break;
		
			}
			}