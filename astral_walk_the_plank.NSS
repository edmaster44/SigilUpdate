#include "ps_astral_inc"

void main()
{
	object oPC = GetLastUsedBy();
	object oCurrentArea = GetArea(oPC);
	
	//AstralDebug(GetTag(oCurrentArea));
	//AstralDebug(GetTag(GetArea(GetAstralShipObject())));
	
	if (oCurrentArea == GetArea(GetAstralShipObject()))
		DisembarkAstralShip(oPC);
	else
		BoardAstralShip(oPC);
}