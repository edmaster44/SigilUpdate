#include "NW_I0_TOOL"

void main()
{
object oEnter = GetEnteringObject();
if (!GetIsPC(oEnter)) return;

if(CheckPartyForItem(oEnter, "ps_misc_alchemistpoisonset") || GetHasFeat(2380, oEnter, FALSE)) //Portal key
{
string SPAWNED = "nSpawned";
location lPortal = GetLocation(GetObjectByTag("ps_wp_broken_sigil02"));
if(!GetLocalInt(OBJECT_SELF, SPAWNED))
{
SetLocalInt(OBJECT_SELF, SPAWNED,TRUE);

CreateObject(OBJECT_TYPE_PLACED_EFFECT, "fx_gem_energy_blue", lPortal);
CreateObject(OBJECT_TYPE_PLACEABLE, "ps_plac_port_broken02", lPortal);
}
}
}