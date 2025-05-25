

//Endless Maze to Abyss

#include "NW_I0_TOOL"

void main()
{
object oEnter = GetEnteringObject();

string sWaypoint = GetLocalString(OBJECT_SELF,"waypoint");
string sPortal = GetLocalString(OBJECT_SELF,"portal");
string sEffect = GetLocalString(OBJECT_SELF,"effect");

if (!GetIsPC(oEnter)) return;

if(CheckPartyForItem(oEnter, "ps_i_balltwine") || GetHasFeat(2380, oEnter, FALSE)) //Portal key
{
string SPAWNED = "nSpawned";
location lPortal = GetLocation(GetObjectByTag(sWaypoint));
if(!GetLocalInt(OBJECT_SELF, SPAWNED))
{
SetLocalInt(OBJECT_SELF, SPAWNED,TRUE);

CreateObject(OBJECT_TYPE_PLACED_EFFECT, sEffect, lPortal);
CreateObject(OBJECT_TYPE_PLACEABLE, sPortal, lPortal);
}
}
}
