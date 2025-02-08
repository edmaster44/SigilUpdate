#include "ff_safevar"

#include "NW_I0_TOOL"

void main()
{
object oEnter = GetEnteringObject();
if (!GetIsPC(oEnter)) return;

if(CheckPartyForItem(oEnter, "ps_misc_shovel")) //Portal key
{
string SPAWNED = "nSpawned";
location lPortal = GetLocation(GetObjectByTag("ps_wp_sigport_05en"));
if(!PS_GetLocalInt(OBJECT_SELF, SPAWNED))
{
PS_SetLocalInt(OBJECT_SELF, SPAWNED,TRUE);

CreateObject(OBJECT_TYPE_PLACED_EFFECT, "fx_shining_shield_planescape", lPortal);
CreateObject(OBJECT_TYPE_PLACEABLE, "ps_plac_port_sig05", lPortal);
}
}
}