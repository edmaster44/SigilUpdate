#include "NW_I0_TOOL"

void main()
{
object oEnter = GetEnteringObject();
if (!GetIsPC(oEnter)) return;

if(CheckPartyForItem(oEnter, "NW_IT_MRING023")) //Portal key
{
string SPAWNED = "nSpawned";
location lPortal = GetLocation(GetObjectByTag("ps_mercuriaportalinsigil"));
if(!GetLocalInt(OBJECT_SELF, SPAWNED))
{
SetLocalInt(OBJECT_SELF, SPAWNED,TRUE);

CreateObject(OBJECT_TYPE_PLACED_EFFECT, "fx_songportal_-xy", lPortal);
CreateObject(OBJECT_TYPE_PLACED_EFFECT, "fx_gold_smoke", lPortal);
CreateObject(OBJECT_TYPE_PLACEABLE, "ps_plac_port_mercuria01", lPortal);
}
}
}