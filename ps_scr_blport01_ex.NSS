

void main()
{
object oExit = GetExitingObject();
if (!GetIsPC(oExit)) return;

string SPAWNED = "nSpawned";
if(GetLocalInt(OBJECT_SELF, SPAWNED))
{
object oPortal=GetObjectByTag("ps_plac_port_bl01");
SetPlotFlag(oPortal,FALSE);
object oPortalEffect=GetNearestObjectByTag("fx_betrayers_gate_planescape");
DestroyObject(oPortalEffect,30.0f);
object oPortalEffect2=GetNearestObjectByTag("fx_gold_smoke_planescape");
DestroyObject(oPortalEffect2,30.0f);

DestroyObject(oPortal,30.0f);
SetLocalInt(OBJECT_SELF, SPAWNED, FALSE);
}
} 