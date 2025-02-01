#include "ff_safevar"

void main()
{
object oExit = GetExitingObject();

string sPortal = PS_GetLocalString(OBJECT_SELF,"portal");
string sEffect = PS_GetLocalString(OBJECT_SELF,"effect");

if (!GetIsPC(oExit)) return;

string SPAWNED = "nSpawned";
if(PS_GetLocalInt(OBJECT_SELF, SPAWNED))
{
object oPortal=GetObjectByTag(sPortal);
SetPlotFlag(oPortal,FALSE);
object oPortalEffect=GetNearestObjectByTag(sEffect);
DestroyObject(oPortalEffect,30.0f);
DestroyObject(oPortal,30.0f);
PS_SetLocalInt(OBJECT_SELF, SPAWNED, FALSE);
}
} 