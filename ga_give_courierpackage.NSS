int GetFaction(object oPC)
{
	object oItem = GetItemPossessedBy(oPC,"ps_essence");
    if(GetIsObjectValid(oItem))
    {
	 	int nFaction = GetLocalInt(oItem,"Faction");
		return nFaction;
    }
	
	return 0;
}

void main() {

	object oPC = GetPCSpeaker();

	object oItem = CreateItemOnObject("ps_crft_basemisc", OBJECT_SELF);
	
	string sLocation = GetLocalString(OBJECT_SELF, "Destination");
	
	string sTag = "ps_package_fated";
	string sDescription = "You took this package from an unfortunate berk, who claimed it was their only way out of Sigil. They had been geas'ed by a powerful wizard to deliver the package to the "+sLocation+". \n\nNo doubt the package would be worth a great deal to the right person.";
	string sName = "A Mysterious Package";
	
	//Make sure factioneers take it home!
	if (sLocation == "Hall of Records" && GetFaction(oPC) == 8) { //Fated
		sDescription += " You had better take it to Aram Oakwright at the "+sLocation+".";
		sTag = "ps_package_fated";
	} else if (sLocation == "Civic Festhall" && GetFaction(oPC) == 14) { //Sensate
		sDescription += " You had better take it to your fellow factioneers at the "+sLocation+".";
		sTag = "ps_package_sensates";
	} else if (sLocation == "Shattered Temple" && GetFaction(oPC) == 3) { //Athar
		sDescription += " You had better take it to Hobard at the "+sLocation+".";
		sTag = "ps_package_athar";
	} else if (sLocation == "Mortuary" && GetFaction(oPC) == 7) { //Dustman
		sDescription += " You had better take it to Factotum Lor at the "+sLocation+".";
		sTag = "ps_package_dustmen";
	} else if (sLocation == "Armory" && GetFaction(oPC) == 6) { //Doomguard
		sDescription += " You had better take it to your fellow factioneers at the "+sLocation+".";
		sTag = "ps_package_doomguard";
	}
	
	//Other checks; defaults to "take it to fated"
	else {
		if (GetFaction(oPC) >= 9 && GetFaction(oPC) <= 11) {
			sDescription += " But it might also be a danger in the wrong hands. You should take it to your faction headquarters.";
			sTag = "ps_package_triad";
		} else if (GetFaction(oPC) == 14) { //Sensates are sneaky and like information
			sDescription += " Perhaps one of your fellow Senates at the Civic Festhall may be interested?";
			sTag = "ps_package_sensates";
		} else if (GetFaction(oPC) == 14) { //So are fated
			sDescription += " Perhaps one of your fellow Fated at the Hall of Records may be interested? You should take it to Aram Oakwright.";
			sTag = "ps_package_fated";
		} else if (GetFaction(oPC) == 3 && sLocation == "Temple of the Abyss") { //Athar want to mess with a temple
			sDescription += " Perhaps your fellow factioneers at the Shattered Temple would be interested? You should take the package to Hobard.";
			sTag = "ps_package_athar";
		} else {
			sDescription += " Perhaps the Fated would be interested? You should take it to Aram Oakwright, in the Hall of Records.";
			sTag = "ps_package_fated";
		}
	}
	
	//fancy description things
	if (sLocation == "Temple of the Abyss") {
		sDescription = "<i>This box appears to be full of occult objects, spell components, and a few vials of blood.</i>\n\n"+sDescription;
	} else if (sLocation == "Hall of Records") {
		sDescription = "<i>This box appears to be full of papers; deeds, titles, finances, etc.</i>\n\n"+sDescription;
	} else if (sLocation == "Civic Festhall") {
		sDescription = "<i>This box appears to be full of novelties; magical trinkets, exotic ingrediants, and maps.</i>\n\n"+sDescription;
	} else if (sLocation == "Shattered Temple") {
		sDescription = "<i>This box appears to be full of correspondances; the running theme seems to be the evils of the gods.</i>\n\n"+sDescription;
	} else if (sLocation == "Mortuary") {
		sDescription = "<i>This box appears to be full of occult objects, bones, incense, and ashes.</i>\n\n"+sDescription;
	} else if (sLocation == "Armory") {
		sDescription = "<i>This box appears to be full of alchemical ingrediants; they look explosive.</i>\n\n"+sDescription;
	} else {
		sDescription = "<i>This box appears to be full of magical components, and scrolls.</i>\n\n"+sDescription;
	}
	
	//Set up the item
	SetTag(oItem, sTag);
	SetDescription(oItem, sDescription);
	SetFirstName(oItem, sName);
	SetPlotFlag(oItem, TRUE);
	SetItemIcon(oItem, 1246); //it_qi_tithebox
	
	//Pass the finished item off to the PC
	CopyItem(oItem, oPC);

}