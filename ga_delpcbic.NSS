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
	//remove all fx from the pc to prevent them "sticking" to the character
	//after remake, a phenomenon reported as a bug and then verified by me -FlattedFifth
	effect eFX = GetFirstEffect(oPC);
	while(GetIsEffectValid(eFX)){
		RemoveEffect(oPC, eFX);
		eFX = GetFirstEffect(oPC);
	}
	int xp = GetXP(oPC);
	
	SetXPpools(oPC, xp);
	Finalize(oPC);
	DelayCommand(0.2f, ArchiveCharacter(oPC));
	
}