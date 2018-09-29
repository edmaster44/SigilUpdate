#include "ps_inc_faction"

void main()
{
	object	oDM     = GetItemActivator();
    object	oTarget = GetItemActivatedTarget();

	//SendMessageToPC(oDM, "DEBUG: At least entered the script");
	RemoveAllFactionData(oDM, oTarget);
}
	