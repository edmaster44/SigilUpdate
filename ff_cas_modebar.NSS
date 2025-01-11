// Custom modebar. This is 100% the work of CaS from Haven, I just replaced the sql with a function since I
// do not have access to the sql server and know very little sql anyway. -FlattedFifth, Sept 18, 2024

#include "aaa_constants"
//#include "nwnx_sql"

const string SCREEN = "SCREEN_MODEBAR_NEW";
const string MODEBAR = "CUSTOM_MODEBAR_BUTTON";
const string BARMODEBAR = "BARD_CUSTOM_MODEBAR_BUTTON";

void LoadModeBar(object oPC, int choice, int nFeat, int bard);
void LoadAllModeBars(object oPC, int bard);
int GetModebarFeats(int index, int bard);
void ActivateMode(object oPC, int iMode);


void main(string mode, string choice, string toggle)
{
	object oPC = OBJECT_SELF;
	SendMessageToPC(oPC,"Mode: "+mode);
	SendMessageToPC(oPC,"Choice: "+choice);
	SendMessageToPC(oPC,"Toggle: "+toggle);	
	
	if(mode == "LOAD") LoadAllModeBars(oPC,0);
	else if(mode == "LOADBARD") LoadAllModeBars(oPC,1);	
	else if(mode == "DOBUTTON") ActivateMode(oPC,StringToInt(toggle));
	else return;
}

void LoadModeBar(object oPC, int choice, int nFeat, int bard){
	string sChoice = IntToString(choice);
	string sFeat = IntToString(nFeat);
	string sIcon = Get2DAString("feat", "Icon", nFeat);
	string sName = Get2DAString("feat", "FEAT", nFeat);
	
	ClearListBox(oPC,SCREEN,MODEBAR+sChoice);
	
	string sModebar;
	if(bard == 1) sModebar = BARMODEBAR;
	else sModebar = MODEBAR;
	
	AddListBoxRow(oPC,SCREEN,sModebar+sChoice,
					"Row"+sChoice,"","CustomButtonIcon="+sIcon+".tga","1="+GetStringByStrRef(StringToInt(sName))+";2="+sFeat,"");	
					
	//SendMessageToPC(oPC,"Debug: loading custom modebar button: "+MODEBAR+sChoice);
}


void ActivateMode(object oPC, int iMode){
	ActionUseFeat(iMode,oPC);
}



void LoadAllModeBars(object oPC, int bard){

	int i;
	int nFeat = 0;
	while(nFeat != NULL){
		nFeat = GetModebarFeats(i, bard);
		if(GetHasFeat(nFeat,oPC,TRUE)){	
			LoadModeBar(oPC,i,nFeat,bard);
			i++;
		}
	}
}

int GetModebarFeats(int index, int bard){
	if (bard) return NULL; // no custom bard modes yet
	else {
		switch (index){
			case 1: return FEAT_METHODICAL_DEFENSE;
			case 2: return FEAT_CONSIDERED_STRIKE;
		}
	}
	return -1;
}



/*
void LoadAllModeBars(object oPC, int bard)
{
	SendMessageToPC(oPC,"Debug: Loading custom modebars....");
	int iLoop = 1; string sFeat;
	
	if(bard == 1) SQLExecDirect("SELECT `featid` FROM `togglemodes` WHERE `ignore`=0 AND `bard`=1;");
	else SQLExecDirect("SELECT `featid` FROM `togglemodes` WHERE `ignore`=0 AND `bard`=0;");
	
	while(SQLFetch() && 11 > iLoop)
	{
		sFeat = SQLGetData(1);
		
		if(GetHasFeat(StringToInt(sFeat),oPC,TRUE))
		{	
			LoadModeBar(oPC,iLoop,sFeat,bard);
			iLoop++;
		}
	}
}
*/