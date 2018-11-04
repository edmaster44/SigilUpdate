#include "ps_inc_randomitems"
void main() {

	SpeakString("here we are", TALKVOLUME_SHOUT);
	object oPC = GetLastUsedBy();
	int nType = GetLocalInt(OBJECT_SELF, "type");
	AssignCommand(OBJECT_SELF, SpeakString("generating an item of type: "+IntToString(nType), TALKVOLUME_SHOUT));
	
	if (nType == 1)
		CreateExperimentalPotionOnTarget(oPC, d3());
	else if (nType == 2)
		CreateExperimentalScrollOnTarget(oPC, d3());
	else if (nType == 3)
		CreateTrinketOnTarget(oPC, d3());
}

/*void CreatePaperJunkOnTarget(object oPC) {

	string sTitle = "";
	string sContent = "";
	int nIcon = 0;

	int nRandom = d100();
	if (nRandom <= 15) {
		SendMessageToPC(oPC, "Generating grocery list");
		sTitle = "Grocery List";
		sContent = GenerateGroceryList();
		nIcon = GetRandomIcon(oPC, "it_qi_smugglerdocs");
	} else if (nRandom <= 30) {
		SendMessageToPC(oPC, "Generating alchemical recipe");
		sTitle = "Alchemical Recipe";
		sContent = GenerateRecipeText();
		nIcon = GetRandomIcon(oPC, "it_qi_smugglerdocs");
	} else if (nRandom <= 45) {
		SendMessageToPC(oPC, "Generating old wanted poster");
		sTitle = "Old Wanted Poster";
		sContent = GenerateWantedPoster();
		nIcon = GetRandomIcon(oPC, "it_blankscroll");
	} else if (nRandom <= 60) {
		SendMessageToPC(oPC, "Generating love letter");
		sTitle = "Love Letter";
		sContent = GenerateLoveLetterText();
		nIcon = GetRandomIcon(oPC, "it_qi_issanidoc");
	} else {
		SendMessageToPC(oPC, "Generating book");
		CreateBookOnTarget(oPC);
		return;
	}
	
	SendMessageToPC(oPC, "creating the object");
	object oPaper = CreateItemOnObject("ps_crft_basemisc", oPC);
	SetFirstName(oPaper, sTitle);
	SetDescription(oPaper, sContent);
	SetItemIcon(oPaper, nIcon);
}*/