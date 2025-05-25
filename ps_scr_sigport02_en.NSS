

#include "NW_I0_TOOL"

void main()
{
object oEnter = GetEnteringObject();
if (!GetIsPC(oEnter)) return;

if(CheckPartyForItem(oEnter, "NW_IT_MSMLMISC23") || GetHasFeat(2380, oEnter, FALSE)) //Portal key
{
string SPAWNED = "nSpawned";
location lPortal = GetLocation(GetObjectByTag("ps_wp_sigport_02en"));
if(!GetLocalInt(OBJECT_SELF, SPAWNED))
{
SetLocalInt(OBJECT_SELF, SPAWNED,TRUE);

CreateObject(OBJECT_TYPE_PLACED_EFFECT, "fx_betrayers_gate_planescape", lPortal);
CreateObject(OBJECT_TYPE_PLACEABLE, "ps_plac_port_sig02", lPortal);
}
}
}
