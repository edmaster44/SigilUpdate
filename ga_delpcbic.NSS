#include "nwnx_character"
void main()
{
	object oPC=GetPCSpeaker();
	ArchiveCharacter(oPC);
	//DeleteCharacter(oPC);
}