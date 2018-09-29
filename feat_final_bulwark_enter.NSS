#include "feat_final_bulwark_effect"

void main()
{
	object oTARGET = GetEnteringObject();
	if (GetObjectType(oTARGET)!=OBJECT_TYPE_CREATURE) return;
	object oCASTER = GetAreaOfEffectCreator();
	if (GetIsEnemy(oTARGET, oCASTER)==TRUE) RemoveBulwark(oTARGET, oCASTER);
	else
	{
		object oAURA = OBJECT_SELF;
		ApplyBulwark(oCASTER, oTARGET, oAURA);
	}
}