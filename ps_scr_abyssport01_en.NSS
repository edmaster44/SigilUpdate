#include "NW_I0_TOOL"

void main()
{
object oEnter = GetEnteringObject();
if (!GetIsPC(oEnter)) return;

if(CheckPartyForItem(oEnter, "X1_WMGRENADE002") || GetHasFeat(2380, oEnter, FALSE)) //Portal key
{
string SPAWNED = "nSpawned";
location lPortal = GetLocation(GetObjectByTag("ps_abyssportalinsigil"));
if(!GetLocalInt(OBJECT_SELF, SPAWNED))
{
SetLocalInt(OBJECT_SELF, SPAWNED,TRUE);

CreateObject(OBJECT_TYPE_PLACED_EFFECT, "fx_gem_energy_orange", lPortal);
CreateObject(OBJECT_TYPE_PLACED_EFFECT, "fx_steamroom_planescape", lPortal);
CreateObject(OBJECT_TYPE_PLACEABLE, "ps_plac_port_abyss01", lPortal);
}
}
}
