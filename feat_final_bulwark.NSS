#include "feat_final_bulwark_effect"

void main()
{
	object oPC = OBJECT_SELF;
	RemoveBulwark(oPC, oPC); //To Avoid stacking
	DelayCommand(0.0f, ApplyAura(oPC));
}