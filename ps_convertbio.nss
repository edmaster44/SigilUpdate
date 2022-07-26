
#include "nwnx_sql"

void ConvertBio (object oPC)
{
if (GetIsDM(oPC) == TRUE) return;

string name = SQLEncodeSpecialChars(GetName(oPC));
string player = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
string sQuery; string sDB; string sBio; string sPortrait;
//string sBio = GetCampaignString(sDB,"Bio",oPC);
//string sPortrait = GetCampaignString(sDB,"Portrait",oPC);

	if (sBio == "")
	{	sDB = GetSubString(GetPCPlayerName(oPC), 0, 12) +
		"_" + GetSubString(GetFirstName(oPC), 0, 6) +
		"_" + GetSubString(GetLastName(oPC), 0, 9);
		sBio = GetCampaignString(sDB,"Bio");
	}

	if (sPortrait == "")
	{	sDB = GetSubString(GetPCPlayerName(oPC), 0, 12) +
		"_" + GetSubString(GetFirstName(oPC), 0, 6) +
		"_" + GetSubString(GetLastName(oPC), 0, 9);
		sPortrait = GetCampaignString(sDB,"Portrait");
	if (GetStringLength(sPortrait) < 2) sPortrait = "bg_60_alpha";
	}
	sQuery = "INSERT INTO kemo_bios (bioid, name, player, biotext, portrait) SELECT 1 + coalesce((SELECT max(bioid)"+
	" FROM kemo_bios), 0), '"+name+"', '"+player+"',"+
	"AES_ENCRYPT('"+SQLEncodeSpecialChars(sBio)+"','PdSgVkYp3s5v8y/B?E(H+MbQeThWmZq4'),"+
	"'"+SQLEncodeSpecialChars(sPortrait)+"';";

	SQLExecDirect(sQuery);

	SendMessageToPC(oPC,"KEMO bio succesfully converted to SQL.");	
	DeleteCampaignVariable(sDB,sBio);
	DeleteCampaignVariable(sDB,sPortrait);
	SendMessageToPC(oPC,"Deleting Campaign Variable.");

	
}