#include "ps_inc_advscript"

const string PS_AREA_ONENTER = "PS_AREA_ONENTER";

void main()
{
	string PreviousScript = GetLocalString(OBJECT_SELF, PS_AREA_ONENTER);
	object EnteringObject = GetEnteringObject();

	//
	// Send weather to entering PCs.
	//

	if (GetIsPC(EnteringObject))
		PS_SendAreaWeatherToPlayer(OBJECT_SELF, EnteringObject);

	//
	// Call previous on enter script in hook chain.
	//

	if (PreviousScript != "")
		ExecuteScript(PreviousScript, OBJECT_SELF);
}