#include "ff_safevar"

void main()
{
object oExit = GetExitingObject();
if (!GetIsPC(oExit)) return;

string SPAWNED = "nSpawned";
if(PS_GetLocalInt(OBJECT_SELF, SPAWNED))
{
object oPortal=GetObjectByTag("ps_plac_port_carceri01");
SetPlotFlag(oPortal,FALSE);
object oPortalEffect=GetNearestObjectByTag("fx_portal_gen_small");
DestroyObject(oPortalEffect,30.0f);
DestroyObject(oPortal,30.0f);
PS_SetLocalInt(OBJECT_SELF, SPAWNED, FALSE);
}
} 