void main()
{
object oExit = GetExitingObject();

string sPortal = GetLocalString(OBJECT_SELF,"portal");
string sEffect = GetLocalString(OBJECT_SELF,"effect");

if (!GetIsPC(oExit)) return;

string SPAWNED = "nSpawned";
if(GetLocalInt(OBJECT_SELF, SPAWNED))
{
object oPortal=GetObjectByTag(sPortal);
SetPlotFlag(oPortal,FALSE);
object oPortalEffect=GetNearestObjectByTag(sEffect);
DestroyObject(oPortalEffect,30.0f);
DestroyObject(oPortal,30.0f);
SetLocalInt(OBJECT_SELF, SPAWNED, FALSE);
}
} 