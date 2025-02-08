#include "ff_safevar"

void main()
{
object oExit = GetExitingObject();
if (!GetIsPC(oExit)) return;

string SPAWNED = "nSpawned";
if(PS_GetLocalInt(OBJECT_SELF, SPAWNED))
{
object oPortal=GetObjectByTag("ps_plac_port_sig05");
SetPlotFlag(oPortal,FALSE);
object oPortalEffect=GetNearestObjectByTag("fx_shining_shield_planescape");
DestroyObject(oPortalEffect,30.0f);
DestroyObject(oPortal,30.0f);

PS_SetLocalInt(OBJECT_SELF, SPAWNED, FALSE);
}
} 