//:://////////////////////////////////////////////
//:: Created By: Clangeddin 
//:: Created On: 2015
//:://////////////////////////////////////////////

void main(string sCOMMAND)
{
	object oPC = OBJECT_SELF;
	if (sCOMMAND == "1") //refresh points
	{
		int nMAX = GetLocalInt(oPC, "PSI_PP_MAX");
		if (nMAX <= 0) return;
		int nPP = GetLocalInt(oPC, "PSI_PP");
		string sTEXT = IntToString(nPP) + "/" + IntToString(nMAX);
		float fBAR = IntToFloat(nPP)/IntToFloat(nMAX);
  		SetGUIObjectText(oPC, "SCREEN_SPIRITBAR_PSION", "PP_TXT", -1, sTEXT);
		SetGUIProgressBarPosition(oPC, "SCREEN_SPIRITBAR_PSION", "PP_BAR", fBAR);
	}
	else
	{
		string sBUTTON = GetStringLeft(sCOMMAND, 1);
		string sACTIVE = GetStringRight(sCOMMAND, 1);
		int nFEAT;
		int nSPELL;
		string sVAR;
		string sSCRIPT = "psi_metapsi_";
		if (sBUTTON=="2") {nFEAT = 21375; nSPELL = 14346; sVAR = "METAPSI_AUGMENT";}
		else if (sBUTTON=="3") {nFEAT = 21373; nSPELL = 14344; sVAR = "METAPSI_EMPOWER";}
		else if (sBUTTON=="4") {nFEAT = 21372; nSPELL = 14343; sVAR = "METAPSI_EXTEND";}
		else if (sBUTTON=="5") {nFEAT = 21376; nSPELL = 14347; sVAR = "METAPSI_MAXIMIZE";}
		else if (sBUTTON=="6") {nFEAT = 21374; nSPELL = 14345; sVAR = "METAPSI_TWIN";}
		if (sACTIVE=="a") //Activate
		{
			if (GetLocalInt(oPC, sVAR) == 1) return; //Do nothing if it's already active.
			if (GetHasFeat(nFEAT, oPC, TRUE)==FALSE) SendMessageToPC(oPC, "You don't have access to this metapsionic yet.");
			else ActionCastSpellAtObject(nSPELL, oPC, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
		}
		else if (GetLocalInt(oPC, sVAR) == 1) ActionCastSpellAtObject(nSPELL, oPC, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE); //Deactivate
	}
}