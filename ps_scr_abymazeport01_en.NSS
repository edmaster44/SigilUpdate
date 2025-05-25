

#include "NW_I0_TOOL"

void main()
{
object oEnter = GetEnteringObject();
if (!GetIsPC(oEnter)) return;

if(CheckPartyForItem(oEnter, "ps_i_balltwine")) //Portal key
{
string SPAWNED = "nSpawned";
location lPortal = GetLocation(GetObjectByTag("ps_abymazeportalinaby"));
if(!GetLocalInt(OBJECT_SELF, SPAWNED))
{
SetLocalInt(OBJECT_SELF, SPAWNED,TRUE);

CreateObject(OBJECT_TYPE_PLACED_EFFECT, "fx_gem_energy_green", lPortal);
CreateObject(OBJECT_TYPE_PLACEABLE, "ps_plac_port_maze_in2", lPortal);
}
}
}