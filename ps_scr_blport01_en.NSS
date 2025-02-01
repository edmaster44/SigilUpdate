#include "ff_safevar"

#include "NW_I0_TOOL"

void main()
{
object oEnter = GetEnteringObject();
if (!GetIsPC(oEnter)) return;

if(CheckPartyForItem(oEnter, "NW_IT_MSMLMISC23")) //Portal key
{
string SPAWNED = "nSpawned";
location lPortal = GetLocation(GetObjectByTag("ps_wp_blport_01"));
if(!PS_GetLocalInt(OBJECT_SELF, SPAWNED))
{
PS_SetLocalInt(OBJECT_SELF, SPAWNED,TRUE);

CreateObject(OBJECT_TYPE_PLACED_EFFECT, "fx_betrayers_gate_planescape", lPortal);
CreateObject(OBJECT_TYPE_PLACED_EFFECT, "fx_gold_smoke_planescape", lPortal);
CreateObject(OBJECT_TYPE_PLACEABLE, "ps_plac_port_bl01", lPortal);
}
}
}