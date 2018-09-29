void main()
{
	string sTemplate;
	int nRoll = d12(1);
	switch (nRoll)
    {
        case 1:
            sTemplate = "ps_monster_chess_blackpawn";
        break;

        case 2:
            sTemplate = "ps_monster_chess_blackrook";
        break;

        case 3:
            sTemplate = "ps_monster_chess_blackbishop";
        break;

        case 4:
            sTemplate = "ps_monster_chess_blackknight";
        break;
		
		case 5:
            sTemplate = "ps_monster_chess_blackking";
        break;
		
		case 6:
            sTemplate = "ps_monster_chess_blackqueen";
        break;
		
		case 7:
            sTemplate = "ps_monster_chess_whitepawn";
        break;
		
		case 8:
            sTemplate = "ps_monster_chess_whiterook";
        break;
		
		case 9:
            sTemplate = "ps_monster_chess_whitebishop";
        break;
		
		case 10:
            sTemplate = "ps_monster_chess_whiteknight";
        break;
		
		case 11:
            sTemplate = "ps_monster_chess_whiteking";
        break;
		
		case 12:
            sTemplate = "ps_monster_chess_whitequeen";
        break;
    } 	
	
	object oPC = GetItemActivator();
	object oOldHench= GetHenchman(oPC);
	float fSummonDuration = 60.0; // seconds
	RemoveHenchman(oPC, oOldHench);
	DestroyObject(oOldHench);
	object oSummoned = CreateObject(OBJECT_TYPE_CREATURE, sTemplate, GetItemActivatedTargetLocation(), TRUE, "");
	DelayCommand(0.2, AddHenchman(oPC, oSummoned));
	DelayCommand(0.2, SetCreatureScriptsToSet(oSummoned, 10));
	DelayCommand(fSummonDuration,RemoveHenchman(oPC, oSummoned));
	DestroyObject(oSummoned, fSummonDuration + 0.2, FALSE);
}