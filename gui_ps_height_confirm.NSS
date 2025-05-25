

#include "ps_heightadjust_includes"

void main()
{
	object oPC = OBJECT_SELF;
	AdjustHeight(oPC,GetLocalInt(oPC,"heightadjust"));
}