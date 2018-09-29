#include "feat_final_bulwark_effect"

void main()
{
	object oTARGET = GetExitingObject();
	if (GetObjectType(oTARGET)!=OBJECT_TYPE_CREATURE) return;
	object oCASTER = GetAreaOfEffectCreator();
	RemoveBulwark(oTARGET, oCASTER);
}