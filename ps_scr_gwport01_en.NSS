#include "NW_I0_TOOL"

void main()
{
object oEnter = GetEnteringObject();
if (!GetIsPC(oEnter)) return;

if(CheckPartyForItem(oEnter, "cft_gem_03")) //Portal key
{
string SPAWNED = "nSpawned";
location lPortal = GetLocation(GetObjectByTag("ps_wp_gwport_01"));
if(!GetLocalInt(OBJECT_SELF, SPAWNED))
{
SetLocalInt(OBJECT_SELF, SPAWNED,TRUE);

effect eVis = EffectVisualEffect( VFX_DUR_GATE );
ApplyEffectAtLocation ( DURATION_TYPE_TEMPORARY, eVis, lPortal, 5.0);
CreateObject(OBJECT_TYPE_PLACED_EFFECT, "fx_portal_-xy", lPortal);
CreateObject(OBJECT_TYPE_PLACEABLE, "ps_plac_port_sig01", lPortal);
}
}
}