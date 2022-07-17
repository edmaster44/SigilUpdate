#include "nwnx_sql"
#include "x0_i0_spells"

//select floor(cm/(12*2.54)) as foot , 
//round((cm mod (12*2.54))/2.54) as inch from ps_barber_height ;

string GetRace(object oPC)
{
	int iRace = GetRacialType(oPC);	int iSubrace = GetSubRace(oPC);
	
	string race;

	if (iRace == RACIAL_TYPE_HUMAN) race = "human";
	if (iSubrace == RACIAL_SUBTYPE_AASIMAR) race = "aasimar";
	if (iRace == RACIAL_TYPE_HALFELF || iSubrace == 43) race = "halfelf";	
	if (iSubrace == RACIAL_SUBTYPE_YUANTI ) race = "yuanti";
	if (iRace == RACIAL_TYPE_HALFLING || iSubrace == 86 || iSubrace == 85) race = "halfling";
	if (iRace == RACIAL_TYPE_ELF || iSubrace == 83 || iSubrace == 84) race = "elf";
	if (iSubrace == 70) race = "avariel";	
	if (iSubrace == RACIAL_SUBTYPE_WILD_ELF) race = "wildelf";
	if (iSubrace == RACIAL_SUBTYPE_DROW) race = "drow";
	if (iSubrace == 52) race = "human";//Xeph
		
	if (iRace == RACIAL_TYPE_DWARF) race = "dwarf";
	if (iRace == RACIAL_TYPE_HALFORC || iRace == RACIAL_TYPE_GRAYORC || iSubrace == 76) race = "halforc";
	if (iSubrace == 193) race = "halforc";
	if (iSubrace == 203) race = "halforc";
	if (iSubrace == 61) race = "halforc";//Khaasta
	if (iSubrace == 57) race = "human";//Githyanki
	if (iSubrace == 58) race = "human";//Githzerai
	if (iSubrace == 68) race = "halforc";//Hobgoblin
	if (iSubrace == 67) race = "halfling";//Kobold
	if (iSubrace == 54) race = "halfling";//Goblin

	if (iSubrace == 72 || iSubrace == 103) race = "mountainorc";
	if (iRace == RACIAL_TYPE_GNOME) race = "gnome";
	
	
	
	if (iSubrace == RACIAL_SUBTYPE_TIEFLING) race = "tiefling";
	if (iSubrace == RACIAL_SUBTYPE_OUTSIDER) race = "tiefling";
	if (iSubrace == 182) race = "tiefling";
	if (iSubrace == RACIAL_SUBTYPE_DRAGON) race = "tiefling";
	if (iSubrace == 194) race ="tiefling";
	if (iSubrace == 195) race = "tiefling";
	if (iSubrace == RACIAL_SUBTYPE_AIR_GENASI ||
	 iSubrace == RACIAL_SUBTYPE_FIRE_GENASI ||
	  iSubrace == RACIAL_SUBTYPE_EARTH_GENASI ||
	   iSubrace == RACIAL_SUBTYPE_WATER_GENASI ||
	    iSubrace == 71) race = "genasi";
	
	
	
	
				
	return race;
}

int GetCMDifference(object oPC)
{
	string sQuery = "SELECT ROUND((max_cm - min_cm) / 2.54) FROM `ps_barber_height` WHERE `race`='"+
	GetRace(oPC)+"' AND `gender`='"+IntToString(GetGender(oPC))+"';";

	//if(GetHasFeat(3053,oPC,TRUE) || GetHasFeat(2706,oPC,TRUE)) sQuery = "SELECT ROUND(((max_cm * 1.1) - min_cm) / 2.54) FROM `ps_barber_height` WHERE `race`='"+
	//GetRace(oPC)+"' AND `gender`='"+IntToString(GetGender(oPC))+"';";

	SQLExecDirect(sQuery);
	SQLFetch();
	
	return StringToInt(SQLGetData(1));
}

float GetCMMin(object oPC)
{

	SQLExecDirect("SELECT `min_cm` FROM `ps_barber_height` WHERE `race`='"+
	GetRace(oPC)+"' AND `gender`='"+IntToString(GetGender(oPC))+"';");
	SQLFetch();
	
	return StringToFloat(SQLGetData(1));
}

float GetCMMax(object oPC)
{

	SQLExecDirect("SELECT `max_cm` FROM `ps_barber_height` WHERE `race`='"+
	GetRace(oPC)+"' AND `gender`='"+IntToString(GetGender(oPC))+"';");
	SQLFetch();
	
	return StringToFloat(SQLGetData(1));
}

float RacialAdjust(object oPC, float adjust)
{
	adjust = 22.86 * adjust;

	string race = GetRace(oPC);
	
	SQLExecDirect("SELECT `adjustment` FROM `ps_barber_height_racialadjust` WHERE `race`='"+race+"';");
	SQLFetch();
	
	return StringToFloat(SQLGetData(1)) + adjust;	
}

void RemoveSizeEffects(object oPC)
{
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSetScale(1.0, 1.0, 1.0), oPC, 0.5f);	
}

void SaveOriginalHeight(object oPC)
{
	string x = FloatToString(GetScale(oPC, SCALE_X));
	string y = FloatToString(GetScale(oPC, SCALE_Y));
	string z = FloatToString(GetScale(oPC, SCALE_Z));
	
	string name = SQLEncodeSpecialChars(GetName(oPC));
	string act = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
	
	SQLExecDirect("INSERT INTO `ps_barber_height_history` (`name`,`act`,`original_x`,`original_y`,`original_z`)"+
	" VALUES ('"+name+"','"+act+"','"+x+"','"+y+"','"+z+"');");	
}

void SaveAdjustedHeight(object oPC, float x, float y, float z)
{
	string sX = FloatToString(x);
	string sY = FloatToString(y);
	string sZ = FloatToString(z);
	
	string name = SQLEncodeSpecialChars(GetName(oPC));
	string act = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
	
	SQLExecDirect("UPDATE `ps_barber_height_history` SET `adjusted_x`='"+sX+"', `adjusted_y`='"+sY+"', `adjusted_z`='"+sZ+"'"+
	", `active`='1' WHERE `name`='"+name+"' AND `act`='"+act+"';");	
}

int FirstTime(object oPC)
{
	string name = SQLEncodeSpecialChars(GetName(oPC));
	string act = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
	
	SQLExecDirect("SELECT `original_x` FROM `ps_barber_height_history` WHERE `name`='"+name+"' AND `act`='"+act+"';");
	SQLFetch();

	if(SQLGetData(1) == "") return TRUE;
	else return FALSE;	
}

int FirstTimeAdjust(object oPC)
{
	string name = SQLEncodeSpecialChars(GetName(oPC));
	string act = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
	
	SQLExecDirect("SELECT `adjusted_x` FROM `ps_barber_height_history` WHERE `name`='"+name+"' AND `act`='"+act+"';");
	SQLFetch();

	if(SQLGetData(1) == "") return TRUE;
	else return FALSE;	
}


void AdjustToOriginalHeight(object oPC)
{
	string name = SQLEncodeSpecialChars(GetName(oPC));
	string act = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
	
	SQLExecDirect("SELECT `original_x`, `original_y`, `original_z` FROM `ps_barber_height_history` WHERE `name`='"+name+"' AND `act`='"+act+"';");
	SQLFetch();

	float x = StringToFloat(SQLGetData(1));
	float y = StringToFloat(SQLGetData(2));
	float z = StringToFloat(SQLGetData(3));
	
	SetScale(oPC, x, y, z);
	
	SQLExecDirect("UPDATE `ps_barber_height_history` SET `active`='0' WHERE `name`='"+name+"' AND `act`='"+act+"';");	
}

void AdjustToAdjustedHeight(object oPC)
{
	string name = SQLEncodeSpecialChars(GetName(oPC));
	string act = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
	
	SQLExecDirect("SELECT `adjusted_x`, `adjusted_y`, `adjusted_z` FROM `ps_barber_height_history` WHERE `name`='"+name+"' AND `act`='"+act+"';");
	SQLFetch();

	float x = StringToFloat(SQLGetData(1));
	float y = StringToFloat(SQLGetData(2));
	float z = StringToFloat(SQLGetData(3));
	
	SetScale(oPC, x, y, z);
	
	SetLocalFloat(oPC,"ScaledAdjust",z);
	
	SQLExecDirect("UPDATE `ps_barber_height_history` SET `active`='1' WHERE `name`='"+name+"' AND `act`='"+act+"';");	
}

void AdjustHeight(object oPC, int selection)
{
	float cm; float iMin = GetCMMin(oPC); string sQuery; float iMin2; float cm2;
	string race = GetRace(oPC);	
	
	iMin2 = iMin + RacialAdjust(oPC, 0.00);
	iMin = iMin + RacialAdjust(oPC, 1.00);
	
	if(race == "avariel") iMin2 = iMin2 + 14;
	
	if(selection == 0)
	{
		if(race == "halfling") sQuery = "SELECT ("+FloatToString(iMin)+" / 120), ("+FloatToString(iMin2)+" / 120)";
		else if(race == "dwarf") sQuery = "SELECT ("+FloatToString(iMin)+" / 150), ("+FloatToString(iMin2)+" / 150)";
		else if(race == "gnome") sQuery = "SELECT ("+FloatToString(iMin)+" / 130), ("+FloatToString(iMin2)+" / 130)";
		else if(race == "halforc") sQuery = "SELECT ("+FloatToString(iMin)+" / 210), ("+FloatToString(iMin2)+" / 230)";
		else if(race == "mountainorc") sQuery = "SELECT ("+FloatToString(iMin)+" / 230), ("+FloatToString(iMin2)+" / 250)";
		else if(race == "halfbreed") sQuery = "SELECT ("+FloatToString(iMin)+" / 210), ("+FloatToString(iMin2)+" / 210)";
		else sQuery = "SELECT ("+FloatToString(iMin)+" / 200), ("+FloatToString(iMin2)+" / 200)";
	}
	if(selection > 0)
	{
		if(race == "halfling") sQuery = "SELECT ("+FloatToString(iMin)+" + ("+IntToString(selection-1)+" * 2.54)) / 120, ("+FloatToString(iMin2)+" + ("+IntToString(selection-1)+" * 2.54)) / 120";
		else if(race == "dwarf") sQuery = "SELECT ("+FloatToString(iMin)+" + ("+IntToString(selection-1)+" * 2.54)) / 150, ("+FloatToString(iMin2)+" + ("+IntToString(selection-1)+" * 2.54)) / 150";
		else if(race == "gnome") sQuery = "SELECT ("+FloatToString(iMin)+" + ("+IntToString(selection-1)+" * 2.54)) / 130, ("+FloatToString(iMin2)+" + ("+IntToString(selection-1)+" * 2.54)) / 130";
		else if(race == "halforc") sQuery = "SELECT ("+FloatToString(iMin)+" + ("+IntToString(selection-1)+" * 2.54)) / 230, ("+FloatToString(iMin2)+" + ("+IntToString(selection-1)+" * 2.54)) / 210";
		else if(race == "mountainorc") sQuery = "SELECT ("+FloatToString(iMin)+" + ("+IntToString(selection-1)+" * 2.54)) / 250, ("+FloatToString(iMin2)+" + ("+IntToString(selection-1)+" * 2.54)) / 230";
		else if(race == "halfbreed") sQuery = "SELECT ("+FloatToString(iMin)+" + ("+IntToString(selection-1)+" * 2.54)) / 210, ("+FloatToString(iMin2)+" + ("+IntToString(selection-1)+" * 2.54)) / 210";
		else sQuery = "SELECT ("+FloatToString(iMin)+" + ("+IntToString(selection-1)+" * 2.54)) / 200, ("+FloatToString(iMin2)+" + ("+IntToString(selection-1)+" * 2.54)) / 200";
	}

	SQLExecDirect(sQuery);
	SQLFetch();
	
	cm = StringToFloat(SQLGetData(1));
	cm2 = StringToFloat(SQLGetData(2));
		
	if(cm < 0.01) return;
	
	if(FirstTime(oPC)) SaveOriginalHeight(oPC);
//	else SetXP(oPC, FloatToInt(GetXP(oPC) - (GetXP(oPC) * 0.10)));
	
	SaveAdjustedHeight(oPC, cm2, cm2, cm);

	SetScale(oPC, cm2, cm2, cm);
	DelayCommand(1.0f, ExportSingleCharacter(oPC));
}

void ScaleAdjust(object oPC)
{
	string name = SQLEncodeSpecialChars(GetName(oPC));
	string act = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
	
	SQLExecDirect("SELECT `active` FROM `ps_barber_height_history` WHERE `name`='"+name+"' AND `act`='"+act+"';");
	SQLFetch();
	
	string yes = SQLGetData(1);
	
	if(yes == "1")
	{
			effect eCheck = GetFirstEffect(oPC);
			while (GetIsEffectValid(eCheck))
			{
			if (GetEffectType(eCheck) == EFFECT_TYPE_POLYMORPH || GetEffectType(eCheck) == EFFECT_TYPE_WILDSHAPE)
			{
				SendMessageToPC(oPC,"Failed to adjust your height due to being in polymorph.");
				return;
			}
			eCheck = GetNextEffect(oPC);
			}
	
		AdjustToAdjustedHeight(oPC);
		SendMessageToPC(oPC,"<I>Adjusted character to adjusted height.</I>");
	}
}

void AdjustWeight(object oPC, int adjust)
{
	string name = SQLEncodeSpecialChars(GetName(oPC));
	string act = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
	
	string sAdjust;
	
	if (adjust == 1) sAdjust = "+ 0.02";
	if (adjust == 0) sAdjust = "- 0.02";
	
	SQLExecDirect("SELECT `adjusted_x`"+sAdjust+", `adjusted_y`"+sAdjust+", `adjusted_z` FROM `ps_barber_height_history` WHERE `name`='"+name+"' AND `act`='"+act+"';");
	SQLFetch();

	float x = StringToFloat(SQLGetData(1));
	float y = StringToFloat(SQLGetData(2));
	float z = StringToFloat(SQLGetData(3));
	
	if (x > z + 0.18 || x <= z - 0.18)
	{
		SendMessageToPC(oPC,"You can't adjust your weight that much.");
		return;
	}
	
	SaveAdjustedHeight(oPC, x, y, z);
	SetScale(oPC, x, y, z);
}