#include "nwnx_sql"
#include "ps_inc_gemstones"

void main () {

	object oPC = GetLastUsedBy();

	SQLExecDirect("TRUNCATE TABLE gemstones");

	object oChest = GetObjectByTag("plc_chest_gemstonegeneration_2");
	object oItem = GetFirstItemInInventory(oChest);
	int n = 0;
    while (GetIsObjectValid(oItem)) {
	
		string sResref = "gemstone_value_low";
		if (!GetIsGemstone(oItem)) {
			sResref = "gemstone_value_vfx";
		} else if (GetGoldPieceValue(oItem) >= 299) {
			sResref = "gemstone_value_high";
		} else if (GetGoldPieceValue(oItem) >= 99) {
			sResref = "gemstone_value_medium";
		}
		
		string sName = GetName(oItem);
		string sTag = GetTag(oItem);
		int nIcon = GetItemIcon(oItem);
		string sColor = GetLocalString(oItem, "Color");
		string sDescription = GetLocalString(oItem, "GemDescription")+"\n\n"+GetLocalString(oItem, "MineralDescription");
	
		string sQuery = "INSERT INTO gemstones SET gem_id='"+IntToString(n)+"', name='"+sName+"', tag='"+sTag+"', resref='"+sResref+"', icon='"+IntToString(nIcon)+"', color='"+sColor+"', description='"+sDescription+"', frequency='1'";
		SendMessageToPC(oPC, sQuery);
		SQLExecDirect(sQuery);
		
		n++;
		
		oItem = GetNextItemInInventory(oChest);
	}

}