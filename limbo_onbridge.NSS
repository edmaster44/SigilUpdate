#include "ff_safevar"

void main ()
{
	object oPC = GetEnteringObject();
	PS_SetLocalInt(oPC, "onbridge", 1);
}