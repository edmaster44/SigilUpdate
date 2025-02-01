#include "ff_safevar"

void main()
{
object oExit = GetExitingObject();
if (!GetIsPC(oExit)) return;

string SPAWNED = "nSpawned";
if(PS_GetLocalInt(OBJECT_SELF, SPAWNED))
{
object oPortalEffect=GetNearestObjectByTag("fx_portal_-xy");
DestroyObject(oPortalEffect,30.0f);
object oPortal=GetObjectByTag("ps_plac_port_gw01");
SetPlotFlag(oPortal,FALSE);
DestroyObject(oPortal,30.0f);
PS_SetLocalInt(OBJECT_SELF, SPAWNED, FALSE);
}
} 