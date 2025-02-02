void main()
{
object oExit = GetExitingObject();
if (!GetIsPC(oExit)) return;

string SPAWNED = "nSpawned";
if(GetLocalInt(OBJECT_SELF, SPAWNED))
{
object oPortalEffect=GetNearestObjectByTag("fx_songportal_y");
DestroyObject(oPortalEffect,30.0f);
object oPortal=GetObjectByTag("ps_plac_port_sig03");
SetPlotFlag(oPortal,FALSE);
DestroyObject(oPortal,30.0f);
SetLocalInt(OBJECT_SELF, SPAWNED, FALSE);
}
} 