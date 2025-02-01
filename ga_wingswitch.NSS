#include "nwnx_character"
#include "ps_inc_functions"
#include "ps_inc_advscript"
#include "ps_inc_wingtail"

void main(int type)
{
	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	object oItem	= GetItemPossessedBy(oPC,"ps_essence");	
	
	PS_DeleteLocalInt(oItem, "WingSwitch");
	PS_SetLocalInt(oItem, "WingOverride", type);
	PS_WingTailSetup(oPC);
	PS_ApplyPCWings(oPC);
}