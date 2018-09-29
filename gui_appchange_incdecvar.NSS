int jumpID(int newValue, int nFrom, int nTo)
{
	if (newValue < nFrom || newValue > nTo)
		return newValue;

	else if (newValue == nFrom)
		newValue = nTo;
	else if (newValue == nTo-1)
		newValue = nFrom-1;
		
	return newValue;
}

void main(int nType, int nVarIndex, string sVarValue, string sTextFieldName)
{
int newValue;
int nAdj;

int nGenderID = GetLocalInt(OBJECT_SELF, "CharacterAppearanceChangeGUIGenderID"); //0-male; 1-female; gui_appchange_setvar
int nAppearanceID = GetLocalInt(OBJECT_SELF, "CharacterAppearanceChangeGUIAppearanceID");

	switch (nType)
	{
		case 0:
			if (sVarValue == "")
			{
				sVarValue = "0";
				break;
			}
			nAdj=1;
		break;
		case 1:
			nAdj=-1;
		break;
		case -1:
			nAdj=0;
		break;
	}
	newValue=StringToInt(sVarValue)+nAdj;
	
	if (newValue == -1)
		newValue = 0;
		
	if (sTextFieldName == "AppearanceTextField")
	{
		AddScriptParameterInt(1);
		ExecuteScriptEnhanced("gui_appchange_resetfields", OBJECT_SELF);
		ClearScriptParams();
		/*	
		Avariel: 70
		Ice Para-genasi: 71
		Xeph: 300
		
		Batiri: 38 (M only)
		Troglodyte: 59 (M only)
		Githyanki: 483
		Goblin: 534 (M only)
		Kobold: 35 (M only)
		Lizardfolk: 536 (M only)
		Bugbear: 543 (M only)
		Gnoll, Thayan: 1017 (M only)
		Ogrillion: 1087
		Orog: 1102
		Khaasta: 1509								
		*/
		if (GetSubRace(OBJECT_SELF) == 233) //DOPPELGANGER
		{
			newValue = jumpID(newValue, 7, 38);
			if (newValue == 39) newValue = newValue + nAdj;
			newValue = jumpID(newValue, 41, 45);			
			newValue = jumpID(newValue, 46, 59);
			newValue = jumpID(newValue, 60, 70);
			newValue = jumpID(newValue, 72, 300);
			newValue = jumpID(newValue, 301, 483);
			newValue = jumpID(newValue, 484, 534);
			newValue = jumpID(newValue, 537, 543);
			newValue = jumpID(newValue, 544, 563);
			newValue = jumpID(newValue, 572, 1017); //Fix
			newValue = jumpID(newValue, 579, 1017); //Fix
			newValue = jumpID(newValue, 1018, 1036);
			//newValue = jumpID(newValue, 1037, 1041);
			newValue = jumpID(newValue, 1042, 1087);
			newValue = jumpID(newValue, 1088, 1102);
			newValue = jumpID(newValue, 1103, 1509);
			if (newValue > 1509) newValue = 1509;
		}
		else
		{
			newValue = jumpID(newValue, 7, 40);
			newValue = jumpID(newValue, 41, 45);
			newValue = jumpID(newValue, 46, 70);
			newValue = jumpID(newValue, 72, 300);
			newValue = jumpID(newValue, 301, 563);
			newValue = jumpID(newValue, 568, 1036);
			if (newValue > 1041) newValue = 1041;
		}
			
		SetLocalInt(OBJECT_SELF, "CharacterAppearanceChangeGUIAppearanceID", newValue); //for limits
		SetLocalGUIVariable(OBJECT_SELF, "CharacterAppearanceChangeGUI", 0, IntToString(newValue));
	}
	
	else if (sTextFieldName == "HairTextField")
	{
		if (nGenderID == 0)
		{
			switch (nAppearanceID)
			{
				case 0: case 569: case 570: //Dwarf
					newValue = jumpID(newValue, 20, 80);
					newValue = jumpID(newValue, 83, 94);											
					if (newValue > 94) newValue = 94;
				break;
				case 2: case 568: //Gnome
					newValue = jumpID(newValue, 18, 94);					
					if (newValue > 94) newValue = 94;
				break;
				case 3: case 571: //Halfling
					newValue = jumpID(newValue, 20, 66);
					if (newValue == 70) newValue = newValue + nAdj;
					newValue = jumpID(newValue, 76, 80);
					newValue = jumpID(newValue, 81, 84);
					if (newValue > 84) newValue = 84;
				break;
				case 5: //Half-Orc
					newValue = jumpID(newValue, 20, 94);
					if (newValue > 94) newValue = 94;
				break;
				case 4: case 6: case 40: case 563://Half-elf/Human/Yuan-ti Pureblood/Aasimar
					newValue = jumpID(newValue, 26, 37);
					if (newValue == 39) newValue = newValue + nAdj;	
					newValue = jumpID(newValue, 44, 50);
					newValue = jumpID(newValue, 51, 60);
					newValue = jumpID(newValue, 61, 66);
					newValue = jumpID(newValue, 76, 79);
					newValue = jumpID(newValue, 83, 94);
					if (newValue > 94) newValue = 94;
				break;
				case 45: case 1087: case 1102: //Gray Orc / Ogrillion /Orog
					newValue = jumpID(newValue, 20, 94);
					if (newValue > 94) newValue = 94;
				break;
				case 564: //Thiefling
					newValue = jumpID(newValue, 26, 40);
					newValue = jumpID(newValue, 41, 50);
					newValue = jumpID(newValue, 55, 94);
					newValue = jumpID(newValue, 95, 100);
					if (newValue > 100) newValue = 100;
				break;
				case 1: case 70: case 565: case 566: case 567://Elf, Moon/Avariel/Sun/Wood/Drow
					newValue = jumpID(newValue, 26, 50);
					newValue = jumpID(newValue, 53, 60);
					newValue = jumpID(newValue, 61, 66);
					newValue = jumpID(newValue, 76, 79);
					newValue = jumpID(newValue, 83, 94);
					if (newValue > 94) newValue = 94;
				break;
				case 1036: //Elf, Wild
					newValue = jumpID(newValue, 4, 52);
					newValue = jumpID(newValue, 53, 66);
					newValue = jumpID(newValue, 76, 79);
					newValue = jumpID(newValue, 84, 94);
					if (newValue > 94) newValue = 94;
				break;		
				case 71: case 1037: case 1038: case 1039: case 1040: //Genasi
					newValue = jumpID(newValue, 4, 94);
					if (newValue > 94) newValue = 94;
				break;	
				case 1041: //Half-Drow
					newValue = jumpID(newValue, 4, 28);
					newValue = jumpID(newValue, 34, 42);
					if (newValue == 43) newValue = newValue + nAdj;	
					newValue = jumpID(newValue, 46, 85);
					if (newValue > 87) newValue = 87;
				break;
				case 38: case 59: case 483: case 534: case 535: case 536: case 543: case 1017: case 1509:
					if (newValue > 0) newValue = 0;
				break;
								
			}
		}
		
		else if (nGenderID == 1)
		{
			switch (nAppearanceID)
			{
				case 0: case 569: case 570: //Dwarf
					newValue = jumpID(newValue, 20, 42);
					newValue = jumpID(newValue, 43, 63);
					newValue = jumpID(newValue, 64, 94);
					if (newValue > 94) newValue = 94;
				break;			
				case 1: case 70: case 567: case 565: case 566://Elf, Avariel/Moon/Drow/Sun/Wood
					newValue = jumpID(newValue, 28, 42);
					newValue = jumpID(newValue, 43, 50);
					newValue = jumpID(newValue, 58, 60);
					newValue = jumpID(newValue, 64, 66);
					newValue = jumpID(newValue, 91, 94);
					newValue = jumpID(newValue, 95, 97);
					newValue = jumpID(newValue, 99, 106);
					if (newValue > 120) newValue = 120;
				break;	
				case 2: case 568: //Gnome
					newValue = jumpID(newValue, 18, 42);
					newValue = jumpID(newValue, 43, 63);
					newValue = jumpID(newValue, 64, 80);
					newValue = jumpID(newValue, 83, 94);
					if (newValue > 98) newValue = 98;
				break;
				case 3: case 571: //Halfling
					newValue = jumpID(newValue, 20, 42);
					newValue = jumpID(newValue, 43, 51);
					newValue = jumpID(newValue, 57, 63);
					newValue = jumpID(newValue, 64, 66);
					newValue = jumpID(newValue, 83, 94);
					newValue = jumpID(newValue, 95, 106);
					if (newValue > 120) newValue = 120;
				break;
				case 4: case 6: case 40: case 300: case 563: case 1041: //Half-Elf /Human Yuan-ti /Aasimar /Xeph /Half-Drow
					newValue = jumpID(newValue, 30, 41);
					newValue = jumpID(newValue, 43, 50);
					newValue = jumpID(newValue, 64, 66);
					newValue = jumpID(newValue, 91, 94);
					if (newValue == 95) newValue = newValue + nAdj;
					newValue = jumpID(newValue, 99, 106);
					if (newValue > 120) newValue = 120;
				break;
				case 5: case 1087: case 1102: //Half-Orc /Ogrillion /Orog
					newValue = jumpID(newValue, 20, 42);
					newValue = jumpID(newValue, 43, 94);
					if (newValue > 94) newValue = 94;
				break;
				case 564: //Thiefling
					newValue = jumpID(newValue, 22, 42);
					newValue = jumpID(newValue, 43, 50);
					if (newValue == 53) newValue = newValue + nAdj;
					newValue = jumpID(newValue, 20, 42);
					if (newValue == 55) newValue = newValue + nAdj;
					newValue = jumpID(newValue, 64, 94);
					newValue = jumpID(newValue, 95, 100);
					newValue = jumpID(newValue, 101, 106);
					if (newValue > 120) newValue = 120;
				break;
				case 1036: //Elf, Wild
					newValue = jumpID(newValue, 4, 50);
					newValue = jumpID(newValue, 58, 61);
					newValue = jumpID(newValue, 64, 66);
					if (newValue == 84) newValue = newValue + nAdj;	
					newValue = jumpID(newValue, 91, 94);
					if (newValue > 94) newValue = 94;
				break;
				case 71: case 1037: case 1039: case 1040: //Genasi no fire
					newValue = jumpID(newValue, 4, 63);
					newValue = jumpID(newValue, 64, 94);
					if (newValue > 94) newValue = 94;
				break;
				case 1038:
					newValue = jumpID(newValue, 4, 94); //Genasi fire
					if (newValue > 94) newValue = 94;
				break;			
				case 38: case 59: case 483: case 534: case 535: case 536: case 543: case 1017: case 1509:
					if (newValue > 0) newValue = 0;
				break;
			}
		}
	}
	
	else if (sTextFieldName == "HeadTextField")
	{	
		if (nGenderID == 0)
		{
			switch (nAppearanceID)
			{
				case 0: case 569: case 570: //Dwarf
					newValue = jumpID(newValue, 10, 20);
					if (newValue > 20) newValue = 20;
				break;
				case 2: case 568: //Gnome
					if (newValue == 9) newValue = newValue + nAdj;	
					else if (newValue > 10) newValue = 10;
				break;
				case 3: case 571: //Halfling
					newValue = jumpID(newValue, 14, 84);
					if (newValue > 87) newValue = 87;
				break;
				case 4: case 1041://Half-Elf/Half-Drow
					newValue = jumpID(newValue, 7, 25);
					newValue = jumpID(newValue, 31, 42);
					if (newValue == 43) newValue = newValue + nAdj;
					newValue = jumpID(newValue, 46, 85);
					if (newValue > 87) newValue = 87;
				break;
				case 5: case 1102://Half-Orc /Orog
					if (newValue > 6) newValue = 6;
				break;
				case 6: case 71: //Human / Ice para-genasi
					if (newValue == 21) newValue = newValue + nAdj;
					newValue = jumpID(newValue, 43, 50);
					newValue = jumpID(newValue, 51, 59);
					newValue = jumpID(newValue, 61, 64);
					newValue = jumpID(newValue, 65, 80);
					if (newValue == 81) newValue = newValue + nAdj;
					newValue = jumpID(newValue, 88, 90);
					if (newValue > 90) newValue = 90; //Coz 99 is a lich one
				break;
				case 40: case 45: case 1087://Yuan-ti Pureblood/Gray-Orc /Ogrillion
					if (newValue > 3) newValue = 3;
				break;
				case 1: case 70: //Avariel / Moon Elf
					newValue = jumpID(newValue, 8, 10);
					newValue = jumpID(newValue, 11, 30);
					newValue = jumpID(newValue, 38, 83);
					if (newValue == 84) newValue = newValue + nAdj;
					if (newValue > 87) newValue = 87;
				break;
				case 563: //Aasimar
					newValue = jumpID(newValue, 16, 28);
					newValue = jumpID(newValue, 31, 82);
					if (newValue > 87) newValue = 87;
				break;
				case 564: //Thiefling
					if (newValue > 25) newValue = 25;
				break;
				case 565: //Elf, Sun
					newValue = jumpID(newValue, 4, 25);
					newValue = jumpID(newValue, 28, 73);
					newValue = jumpID(newValue, 74, 76);
					newValue = jumpID(newValue, 77, 83);
					if (newValue == 84) newValue = newValue + nAdj;
					if (newValue > 87) newValue = 87;
				break;
				case 566: case 567: //Elf, Wood/Drow
					newValue = jumpID(newValue, 4, 27);
					newValue = jumpID(newValue, 29, 33);
					newValue = jumpID(newValue, 34, 73);
					newValue = jumpID(newValue, 74, 76);
					newValue = jumpID(newValue, 77, 83);
					if (newValue == 84) newValue = newValue + nAdj;
					if (newValue > 87) newValue = 87;
				break;
				case 1036: //Elf, Wild
					newValue = jumpID(newValue, 4, 27);
					newValue = jumpID(newValue, 30, 73);
					newValue = jumpID(newValue, 74, 76);
					newValue = jumpID(newValue, 77, 83);
					if (newValue == 84) newValue = newValue + nAdj;
					if (newValue > 87) newValue = 87;
				break;
				case 1037: case 1039: case 1040: //Genasi no fire
					if (newValue > 4) newValue = 4;
				break;
				case 1038: case 1509: //Fire Genasi /Khaasta
					if (newValue > 5) newValue = 5;
				break;
				case 1017: //Gnoll, Thayan
					if (newValue > 2) newValue = 2;
				break;
				case 38: case 59: case 483: case 534: case 535: case 536: case 543:
					if (newValue > 0) newValue = 0;
				break;
			}				
		}
		
		else if (nGenderID == 1)
		{
			switch (nAppearanceID)
			{
				case 0: case 569: case 570: //Dwarf
					if (newValue > 6) newValue = 6;
				break;				
				case 1: case 70://Elf, Moon/Avariel
					newValue = jumpID(newValue, 11, 14);
					newValue = jumpID(newValue, 15, 31);
					newValue = jumpID(newValue, 39, 41);
					newValue = jumpID(newValue, 44, 51);
					newValue = jumpID(newValue, 53, 70);
					newValue = jumpID(newValue, 74, 82);
					newValue = jumpID(newValue, 88, 92);
					if (newValue > 95) newValue = 95;
				break;	
				case 2: case 568: //Gnme
					if (newValue > 7) newValue = 7;
				break;
				case 3: case 571: //Halfling
					newValue = jumpID(newValue, 11, 84);
					if (newValue > 87) newValue = 87;
				break;
				case 4: case 300: //Half-Elf /Xeph
					newValue = jumpID(newValue, 7, 27);
					newValue = jumpID(newValue, 33, 51);
					newValue = jumpID(newValue, 54, 70);
					newValue = jumpID(newValue, 72, 82);
					if (newValue > 87) newValue = 87;
				break;
				case 5: //Half-orc
					if (newValue > 7) newValue = 7;
				break;
				case 6: case 71: //Human /Ice Para-genasi
					newValue = jumpID(newValue, 16, 26);
					newValue = jumpID(newValue, 38, 45);
					newValue = jumpID(newValue, 53, 58);
					newValue = jumpID(newValue, 73, 82);
					if (newValue > 97) newValue = 97;
				break;
				case 40: case 1087: //Yuan-ti /Ogrillion
					if (newValue > 3) newValue = 3;
				break;
				case 563: //Aasimar
					newValue = jumpID(newValue, 16, 28);
					newValue = jumpID(newValue, 33, 51);
					newValue = jumpID(newValue, 53, 70);
					newValue = jumpID(newValue, 73, 82);
					if (newValue > 87) newValue = 87;
				break;	
				case 564: //Thiefling
					newValue = jumpID(newValue, 33, 35);
					newValue = jumpID(newValue, 36, 50);
					newValue = jumpID(newValue, 54, 66);
					newValue = jumpID(newValue, 67, 70);
					newValue = jumpID(newValue, 72, 87);
					if (newValue > 87) newValue = 87;
				break;	
				case 565: case 566: //Elf, Sun/Wood
					newValue = jumpID(newValue, 5, 25);
					newValue = jumpID(newValue, 30, 41);
					newValue = jumpID(newValue, 44, 51);
					newValue = jumpID(newValue, 54, 70);
					newValue = jumpID(newValue, 74, 82);
					if (newValue > 87) newValue = 87;
				break;				
				case 567: //Elf, Drow
					newValue = jumpID(newValue, 16, 27);
					newValue = jumpID(newValue, 32, 41);
					newValue = jumpID(newValue, 44, 51);
					newValue = jumpID(newValue, 54, 72);
					newValue = jumpID(newValue, 76, 82);
					if (newValue > 87) newValue = 87;
				break;				
				case 1036: //Elf, Wild
					newValue = jumpID(newValue, 4, 27);
					newValue = jumpID(newValue, 30, 41);
					newValue = jumpID(newValue, 44, 51);
					newValue = jumpID(newValue, 54, 82);
					if (newValue > 87) newValue = 87;
				break;
				case 1041: //Half-Drow
					newValue = jumpID(newValue, 4, 28);
					newValue = jumpID(newValue, 34, 51);
					newValue = jumpID(newValue, 54, 82);
					if (newValue > 87) newValue = 87;
				break;
				case 1037: case 1039: case 1040: //Genasi no fire
					newValue = jumpID(newValue, 5, 83);
					if (newValue > 83) newValue = 83;
				break;
				case 1038:
					newValue = jumpID(newValue, 6, 83);
					if (newValue > 83) newValue = 83;
				break;
				case 1102: //Orog
					if (newValue > 6) newValue = 6;
				break;
				case 1509: //Khaasta
					if (newValue > 4) newValue = 4;
				break;
				case 1017: //Gnoll, Thayan
					if (newValue > 2) newValue = 2;
				break;
				case 38: case 59: case 483: case 534: case 535: case 536: case 543:
					if (newValue > 0) newValue = 0;
				break;
			}
		}
		
	}
	else if (sTextFieldName == "TailTextField")
	{
		if (GetLocalInt(OBJECT_SELF, "CharacterAppearanceChangeGUIAppearanceID") == 564)
			{
				if (nGenderID == 0)
					{
						newValue = jumpID(newValue, 1, 8);
						if (newValue > 8) newValue = 8;
					}
				else
					{
						newValue = jumpID(newValue, 1, 9);
						if (newValue > 9) newValue = 9;
					}
			}
		else newValue = 0;
	}
	else if (sTextFieldName == "WingsTextField")
	{
		if (GetLocalInt(OBJECT_SELF, "CharacterAppearanceChangeGUIAppearanceID") == 70)
			{
				if (nGenderID == 0)
					{
						newValue = jumpID(newValue, 1, 63);
						if (newValue > 63) newValue = 63;
					}
				else
					{
						newValue = jumpID(newValue, 1, 64);
						if (newValue > 64) newValue = 64;
					}
			}
		else newValue = 0;
	}
	SetLocalGUIVariable(OBJECT_SELF, "CharacterAppearanceChangeGUI", nVarIndex, IntToString(newValue));
	SetGUIObjectText(OBJECT_SELF, "CharacterAppearanceChangeGUI", sTextFieldName, -1, IntToString(newValue));
	if (sTextFieldName == "AppearanceTextField")
			SetGUIObjectText(OBJECT_SELF, "CharacterAppearanceChangeGUI", sTextFieldName, StringToInt(Get2DAString("appearance", "STRING_REF", newValue)), "");
			
	SendMessageToPC(OBJECT_SELF, "Setting VarIndex "+IntToString(nVarIndex)+" to "+IntToString(newValue));
}