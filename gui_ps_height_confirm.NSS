#include "ff_safevar"

#include "ps_heightadjust_includes"

void main()
{
	object oPC = OBJECT_SELF;
	AdjustHeight(oPC,PS_GetLocalInt(oPC,"heightadjust"));
}