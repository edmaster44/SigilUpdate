#include "feat_iud_effect"

void main()
{	
	object oTARGET = GetEnteringObject();
	if (GetObjectType(oTARGET)!=OBJECT_TYPE_CREATURE) return;
	object oPC = GetAreaOfEffectCreator();
	if (FailSafeIUD(oPC)==TRUE) DelayCommand(0.0f, ApplyIUD(oPC));
	else DelayCommand(0.0f, RemoveIUD(oPC));
}