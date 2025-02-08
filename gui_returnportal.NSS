#include "ff_safevar"

void main()
{
	object oWP = PS_GetLocalObject(OBJECT_SELF, "RETURN_PORTAL");
	if (oWP == OBJECT_INVALID) return;
	JumpToObject(oWP);
}