

#include "NW_I0_TOOL"

void main()
{
object oEnter = GetEnteringObject();
if (!GetIsPC(oEnter)) return;

if(CheckPartyForItem(oEnter, "nx1_poison019")) //Portal key
{
string SPAWNED = "nSpawned";
location lPortal = GetLocation(GetObjectByTag("ps_wp_sigport_06en"));
if(!GetLocalInt(OBJECT_SELF, SPAWNED))
{
SetLocalInt(OBJECT_SELF, SPAWNED,TRUE);

CreateObject(OBJECT_TYPE_PLACED_EFFECT, "fx_shadow_portal_y", lPortal);
CreateObject(OBJECT_TYPE_PLACEABLE, "ps_plac_port_sig06", lPortal);
}
}
}