#include "ff_safevar"

void main()
{
object oExit = GetExitingObject();
if (!GetIsPC(oExit)) return;

string SPAWNED = "nSpawned";
if(PS_GetLocalInt(OBJECT_SELF, SPAWNED))
{
object oPortal=GetObjectByTag("ps_plac_port_broken02");
SetPlotFlag(oPortal,FALSE);
object oPortalEffect=GetNearestObjectByTag("fx_gem_energy_blue");
DestroyObject(oPortalEffect,30.0f);
DestroyObject(oPortal,30.0f);
PS_SetLocalInt(OBJECT_SELF, SPAWNED, FALSE);
}
} 