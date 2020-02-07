#include "ps_inc_gemstones"

void main()
{
	object oPC = GetPCSpeaker();
	DeleteLocalInt(oPC, "hasrough");
		
	if (GetHasRoughGemstone(oPC)) 
		SetLocalInt(oPC, "hasrough", 1);
	
}