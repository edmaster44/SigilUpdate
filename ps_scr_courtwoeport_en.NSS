

#include "NW_I0_TOOL"

void main()
{
object oEnter = GetEnteringObject();
if (!GetIsPC(oEnter)) return;

if(CheckPartyForItem(oEnter, "ps_parchment")) //Portal key
{
string SPAWNED = "nSpawned";
location lPortal = GetLocation(GetObjectByTag("ps_wp_courtwoe_01en"));
if(!GetLocalInt(OBJECT_SELF, SPAWNED))
{
SetLocalInt(OBJECT_SELF, SPAWNED,TRUE);

CreateObject(OBJECT_TYPE_PLACED_EFFECT, "fx_b_fiery_song_portal", lPortal);
CreateObject(OBJECT_TYPE_PLACEABLE, "ps_plac_port_courtwoe01", lPortal);
}
}
}