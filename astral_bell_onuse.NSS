#include "ps_astral_inc"

// When the astral bell is used, call for the ship
void main()
{
	object oPC = GetLastUsedBy();
	//AstralDebug("Used the bell in area: " + GetTag(GetArea(oPC)));
	AssignCommand(GetArea(oPC), CallAstralShip(oPC));
}