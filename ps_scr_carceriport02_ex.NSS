

void main()
{
object oExit = GetExitingObject();
if (!GetIsPC(oExit)) return;

string SPAWNED = "nSpawned";
if(GetLocalInt(OBJECT_SELF, SPAWNED))
{
object oPortal=GetObjectByTag("ps_plac_port_carceri02");
SetPlotFlag(oPortal,FALSE);
object oPortalEffect=GetNearestObjectByTag("fx_portal_gen_small");
DestroyObject(oPortalEffect,30.0f);
DestroyObject(oPortal,30.0f);
SetLocalInt(OBJECT_SELF, SPAWNED, FALSE);
}
} 