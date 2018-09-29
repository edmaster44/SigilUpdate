#include "nwnx_character"
#include "ps_inc_functions"
#include "ps_inc_advscript"
#include "ps_inc_wingtail"

void main(int Type)
{
	object oPC 		= GetPCSpeaker();
	object oItem	= GetItemPossessedBy(oPC,"ps_essence");	

	PS_SetTailNumber(oPC, Type);
	PS_ApplyPCTail(oPC);
}