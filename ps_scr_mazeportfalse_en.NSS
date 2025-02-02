#include "ff_safevar"

//Endless Maze to Abyss

#include "NW_I0_TOOL"

void main()
{
object oEnter = GetEnteringObject();

string sWaypoint = PS_GetLocalString(OBJECT_SELF,"waypoint");
string sPortal = PS_GetLocalString(OBJECT_SELF,"portal");
string sEffect = PS_GetLocalString(OBJECT_SELF,"effect");

if (!GetIsPC(oEnter)) return;

if(CheckPartyForItem(oEnter, "ps_i_balltwine") || GetHasFeat(2380, oEnter, FALSE)) //Portal key
{
string SPAWNED = "nSpawned";
location lPortal = GetLocation(GetObjectByTag(sWaypoint));
if(!PS_GetLocalInt(OBJECT_SELF, SPAWNED))
{
PS_SetLocalInt(OBJECT_SELF, SPAWNED,TRUE);

CreateObject(OBJECT_TYPE_PLACED_EFFECT, sEffect, lPortal);
CreateObject(OBJECT_TYPE_PLACEABLE, sPortal, lPortal);
}
}
}
