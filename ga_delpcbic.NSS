#include "nwnx_character"
#include "ps_inc_functions"
#include "aaa_constants"
#include "nwnx_sql"

void Finalize(object oPC)
{
string name = SQLEncodeSpecialChars(GetName(oPC));
string act = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
SQLExecDirect("DELETE FROM `generalability_tracking` WHERE `name`='"+name+"' AND `act`='"+act+"';");

}


void main()
{
	object oPC=GetPCSpeaker();
	int xp = GetXP(oPC);
	
	SetXPpools(oPC, xp);
	Finalize(oPC);
	DelayCommand(0.2f, ArchiveCharacter(oPC));
	
}