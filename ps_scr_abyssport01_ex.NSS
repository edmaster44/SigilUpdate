#include "ff_safevar"

void main()
{
object oExit = GetExitingObject();
if (!GetIsPC(oExit)) return;

string SPAWNED = "nSpawned";
if(PS_GetLocalInt(OBJECT_SELF, SPAWNED))
{
object oPortal=GetObjectByTag("ps_plac_port_abyss01");
SetPlotFlag(oPortal,FALSE);
object oPortalEffect=GetNearestObjectByTag("fx_gem_energy_orange");
DestroyObject(oPortalEffect,30.0f);
object oPortalEffect2=GetNearestObjectByTag("fx_steamroom_planescape");
DestroyObject(oPortalEffect2,30.0f);

DestroyObject(oPortal,30.0f);
PS_SetLocalInt(OBJECT_SELF, SPAWNED, FALSE);
}
} 