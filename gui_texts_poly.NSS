//:://////////////////////////////////////////////
//:: Created By: Clangeddin 
//:: Created On: 2016
//:://////////////////////////////////////////////

void main(string sNAME, string sDESC)
{
	object oPC = OBJECT_SELF;
	if (sNAME=="") return;
	DisplayGuiScreen(oPC, "POLYMORPH_TEXTS", FALSE, "polytexts.xml");
	int nDESC = StringToInt(sDESC);
	SetGUIObjectText(oPC, "POLYMORPH_TEXTS", "TEXT_NAME", -1, sNAME);
	SetGUIObjectText(oPC, "POLYMORPH_TEXTS", "TEXT_DESC", nDESC, "");
}