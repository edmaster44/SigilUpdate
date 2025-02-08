#include "ff_safevar"

#include "NW_I0_TOOL"

void main()
{
object oEnter = GetEnteringObject();
if (!GetIsPC(oEnter)) return;

if(CheckPartyForItem(oEnter, "n2_it_flute")) //Portal key
{
string SPAWNED = "nSpawned";
location lPortal = GetLocation(GetObjectByTag("ps_wp_elport_01en"));
if(!PS_GetLocalInt(OBJECT_SELF, SPAWNED))
{
PS_SetLocalInt(OBJECT_SELF, SPAWNED,TRUE);

CreateObject(OBJECT_TYPE_PLACED_EFFECT, "fx_songportal_y", lPortal);
CreateObject(OBJECT_TYPE_PLACEABLE, "ps_plac_port_el01", lPortal);
}
}
}