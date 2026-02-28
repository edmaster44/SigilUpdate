// A NOTE ABOUT CURRENCY: In order to keep consistent server messages for players when 
// they pick up coins, please use PS_GiveGoldToCreature() function below in scripts awarding 
// coin and use the item ps_it_copper001 when adding coinage to chests, loot piles, etc.
// (there is a handler in x2_mod_def_aqu.nss to convert the item ps_it_copper001 into actual
// money in the player's inventory).
// -FlattedFifth, Feb 27, 2026

//This function converts the in-game gold value (default game system)
//to a value of copper coins used by the Dethia Shop System
//int	iCoins	= the in-game gold value (default gold system value)
// moved from Dethia_shop_sys
string DS_ConvertCoinsToCopper(int iCoins);

//This function converts the in-game gold value (default game system)
//to a value of silver coins used by the Dethia Shop System
//int	iCoins	= the in-game gold value (default gold system value)
// moved from Dethia_shop_sys
string DS_ConvertCoinsToSilver(int iCoins);

//This function converts the in-game gold value (default game system)
//to a value of gold coins used by the Dethia Shop System
//int	iCoins	= the in-game gold value (default gold system value)
// moved from Dethia_shop_sys
string DS_ConvertCoinsToGold(int iCoins);

//This function updates the player's coin values in the inventory screen
//object	oPC	= the player whose coin values we are updating
// moved from Dethia_shop_sys
void DS_UpdateInventoryCoinValues(object oPC);

// Wrapper for GiveGoldToCreature that gives the player a message in gold, silver, and copper
// written by FlattedFifth
void PS_GiveGoldToCreature(object oCreature, int nGP, int bDisplayFeedback=TRUE);


// for the following 3 I simplified Dethia's math. Because nwscript rounds down by default, 
// Dethia's math was unneccessarily complicated
string DS_ConvertCoinsToCopper(int iCoins){	
	return	IntToString(iCoins % 10);	
}

string DS_ConvertCoinsToSilver(int iCoins){	
	return IntToString((iCoins % 100) / 10);	
}

string DS_ConvertCoinsToGold(int iCoins){
	return IntToString(iCoins / 100);	
}

void DS_UpdateInventoryCoinValues(object oPC){
	int	iCoins	= GetGold(oPC);
	//Next just set the coin values
	SetGUIObjectText(oPC, "SCREEN_INVENTORY", "pc_gc", -1, DS_ConvertCoinsToGold(iCoins));
	SetGUIObjectText(oPC, "SCREEN_INVENTORY", "pc_sc", -1, DS_ConvertCoinsToSilver(iCoins));
	SetGUIObjectText(oPC, "SCREEN_INVENTORY", "pc_cc", -1, DS_ConvertCoinsToCopper(iCoins));
}


void PS_GiveGoldToCreature(object oCreature, int nGP, int bDisplayFeedback=TRUE){
	if (nGP < 1) return;
	if (bDisplayFeedback){

		int nGold   = nGP / 100;
		int nSilver = (nGP % 100) / 10;
		int nCopper = nGP % 10;

		string sMessage = "Acquired ";
		if (nGold > 0){
			sMessage += IntToString(nGold) + " gold";
			if (nSilver == 0 && nCopper == 0) sMessage += ".";
		}
		if (nSilver > 0){
			if (nGold == 0 && nCopper == 0) sMessage += IntToString(nSilver)  + " silver.";
			else if (nGold == 0 && nCopper > 0) sMessage += IntToString(nSilver)  + " silver and ";
			else if (nGold > 0 && nCopper == 0) sMessage += " and " + IntToString(nSilver) + " silver.";
			else if (nGold > 0 && nCopper > 0) sMessage += ", " + IntToString(nSilver) + " silver, and ";
		}
		if (nCopper > 0) sMessage += IntToString(nCopper) + " copper.";
		 
		SendMessageToPC(oCreature, sMessage);
	}
	GiveGoldToCreature(oCreature, nGP, FALSE);
	DS_UpdateInventoryCoinValues(oCreature);
}
