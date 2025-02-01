#include "ff_safevar"

//Endless Maze to Abyss

#include "NW_I0_TOOL"

void main()
{
object oEnter = GetEnteringObject();
if (!GetIsPC(oEnter)) return;

if(CheckPartyForItem(oEnter, "ps_i_balltwine")) //Portal key
{
string SPAWNED = "nSpawned";
location lPortal = GetLocation(GetObjectByTag("ps_abymazeportalinmaze"));
if(!PS_GetLocalInt(OBJECT_SELF, SPAWNED))
{
PS_SetLocalInt(OBJECT_SELF, SPAWNED,TRUE);

CreateObject(OBJECT_TYPE_PLACED_EFFECT, "fx_gem_energy_green", lPortal);
CreateObject(OBJECT_TYPE_PLACEABLE, "ps_plac_port_maze_out2", lPortal);
}
}
}