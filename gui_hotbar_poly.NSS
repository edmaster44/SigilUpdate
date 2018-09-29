//:://////////////////////////////////////////////
//:: Created By: Clangeddin 
//:: Created On: 2016
//:://////////////////////////////////////////////

effect CheckPoly(object oPC)
{
	int nTYPE;
	int nID;
	effect eDUMMY;
	effect eFX = GetFirstEffect(oPC);
	while (GetIsEffectValid(eFX)==TRUE)
	{
		nTYPE = GetEffectType(eFX);
		if (nTYPE == EFFECT_TYPE_POLYMORPH)
		{
			return eFX;
		}
		eFX = GetNextEffect(oPC);
	}
	return eDUMMY;
} 

void PolyCast(object oPC, string sVAR)
{
	int nCAST = GetLocalInt(oPC, "POLY_SPELL_"+sVAR);
	if (nCAST == 0) return;
	string sFEAT = Get2DAString("spells", "FeatID",	nCAST);
	int	nFEAT =	StringToInt(sFEAT);
	if ((sFEAT!="")&&(GetHasFeat(nFEAT, oPC)==FALSE))
	{	
		SendMessageToPC(oPC, "You cannot use this ability at the moment.");
		return;
	}
	object oTARGET = GetPlayerCurrentTarget(oPC);
	string sHOSTILE = Get2DAString("spells", "HostileSetting", nCAST);
	string sTARGET = Get2DAString("spells", "TargetType", nCAST);
	if (sTARGET =="0x01") 
	{
		oTARGET = oPC;
		ActionCastSpellAtObject(nCAST, oTARGET, 0, TRUE);
	}
	else if (sTARGET =="0x04") ActionCastSpellAtLocation(nCAST, GetLocation(oTARGET), 0, TRUE);
	else if ((GetIsEnemy(oTARGET, oPC)==FALSE)&&(sHOSTILE=="1")) return; 
	else ActionCastSpellAtObject(nCAST, oTARGET, 0, TRUE);
	if (sFEAT!="") 
	{
		float fCAST = StringToFloat(Get2DAString("spells", "ConjTime", nCAST))/1000;
		DelayCommand(fCAST, DecrementRemainingFeatUses(oPC, nFEAT));
	}
}

void main(string sCOMMAND)
{
	object oPC = OBJECT_SELF;
	effect eFX = CheckPoly(oPC);
	int nCHECK = GetIsEffectValid(eFX);
	if (nCHECK == FALSE) return;
	if (sCOMMAND == "0") DisplayGuiScreen(oPC,"POLYMORPH_HOTBAR",FALSE,"polybar.xml"); //Opens the Poly Buddy Screen
	else if (sCOMMAND == "1") //Updates the Poly Buddy Screen with the proper spells, if available.
	{	
		int nPOLY = GetEffectInteger(eFX, 0);
		int nCOUNT = 1;
		string sCOUNT;
		string sSPELL;
		int nSPELL;
		string sICON;
		string sDESC;
		string sNAME;
		int nNAME;
		while (nCOUNT < 4)
		{
			sCOUNT = IntToString(nCOUNT);
			sSPELL = Get2DAString("polymorph","SPELL"+sCOUNT,nPOLY);
			if (sSPELL!="")
			{
				nSPELL = StringToInt(sSPELL);
				SetLocalInt(oPC, "POLY_SPELL_"+sCOUNT, nSPELL);
				sNAME = Get2DAString("spells","Name", nSPELL);
				sICON = Get2DAString("spells","IconResRef", nSPELL);
				sDESC = Get2DAString("spells","SpellDesc", nSPELL);
				nNAME = StringToInt(sNAME);
				SetLocalGUIVariable(oPC, "POLYMORPH_HOTBAR", nCOUNT, GetStringByStrRef(nNAME));
				SetLocalGUIVariable(oPC, "POLYMORPH_HOTBAR", nCOUNT+10, sDESC);
				SetGUITexture(oPC, "POLYMORPH_HOTBAR", "SPELL_"+sCOUNT, sICON+".tga");
			}
			nCOUNT = nCOUNT + 1;
		}
	}
	else if (sCOMMAND=="2a") PolyCast(oPC, "1");
	else if (sCOMMAND=="2b") PolyCast(oPC, "2");
	else if (sCOMMAND=="2c") PolyCast(oPC, "3");
}