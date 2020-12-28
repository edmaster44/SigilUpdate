//:://////////////////////////////////////////////
//:: Created By: Clangeddin
//:: Created On: 2015
//:://////////////////////////////////////////////

int CheckPoly(object oPC)
{
	effect eFX = GetFirstEffect(oPC);
	int nTYPE;
	while (GetIsEffectValid(eFX)==TRUE)
	{
		nTYPE = GetEffectType(eFX);
		if (nTYPE == EFFECT_TYPE_POLYMORPH) return TRUE;
		eFX = GetNextEffect(oPC);
	}
	return FALSE;
}

void main(string sWINDOW)
{
	object oPC = OBJECT_SELF;
	object oASS;
	int nTYPE = 1;
	int nPSION;
	int nPOLY;
	int nWINDOW = StringToInt(sWINDOW);
	switch (nWINDOW)
	{
		case 1: //UI options
			DisplayGuiScreen(oPC, "SCREEN_CLANGEDDIN_UI_OPTIONS", FALSE, "clangeddin_ui_options.xml");
			break;
		case 2: //Scry Panel
			DisplayGuiScreen(oPC,"KEMO_SCRY_PANEL", FALSE, "kemo_scry_panel.xml");
			break;
		case 3: //Retrieve Associates
			if (GetIsInCombat(oPC)==TRUE)
			{
				FloatingTextStringOnCreature("You may not retrieve your associates during combat.", oPC, FALSE);
				return;
			}
			while (nTYPE < 6)
			{
				oASS = GetAssociate(nTYPE, oPC);
				if (oASS != OBJECT_INVALID) AssignCommand(oASS, JumpToObject(oPC));
				nTYPE = nTYPE + 1;
			}
			break;
		case 4: //Auxiliary Bars
			nPSION = GetLevelByClass(90, oPC);
			nPOLY = CheckPoly(oPC);
			nBARB = GetLevelByClass(CLASS_TYPE_BARBARIAN, oPC);
			if (nPSION > 0) DisplayGuiScreen(oPC,"SCREEN_SPIRITBAR_PSION", FALSE, "powerpointscreen.xml");
			if (nBARB > 0) DisplayGuiScreen(OBJECT_SELF, "SCREEN_FURYBAR_BARB", FALSE, "furyscreen.xml");
			if (nPOLY==TRUE) DisplayGuiScreen(oPC,"POLYMORPH_HOTBAR", FALSE, "polybar.xml");
			if ((nPSION<=0)&&(nPOLY==FALSE)) FloatingTextStringOnCreature("Auxiliary Bars are only for Psions or Polymorphed Characters.", oPC, FALSE);
			break;
		case 5: //Difficulty
			DisplayGuiScreen(oPC,"SCREEN_DIFFICULTY_SIGIL", FALSE, "difficulty_sigil.xml");
			break;	
	}
}