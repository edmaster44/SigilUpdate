/*************************************************************************************
Written by Dethia	-	03/12/2011

This is the main include file for the "Dethia Shop System".  It houses the various
functions the system uses.  Please read the information below on how the system
works and how to implement it into the server.  In general this system ties into the
game's default currency system.  Gold is treated like copper coins (least valueable
form of currency).  No additional item is actually used besides the gold piece (which
was modified to be a "Copper Coin" for this system).  The system simply converts
the gold piece value (whether of an item, or the gold of a store or the gold a pc
has in his/her inventory) into appropriate coin values.  These values are then
displayed in the GUI files where gold usually appears.

------READ-ME-----------------------------------------------------------------------
	System Files:
		copper_coin.tga		Icon for the copper coin
		silver_coin.tga		Icon for the silver coin
		gold_coin.tga		Icon for the gold coin
		sell_icon.tga		Sell icon (the image used for the sell button)
		inv_top_bg.tga		Modified from default inventory scren background
		it_gold.tga			Modified from gold icon to look like copper
		nw_it_gold001.uti	Modified from default gold piece blueprint
		dethia_shop.xml		The xml GUI file
		inventoryscreen.xml	Modified from default inventory screen GUI file
		splitgold.xml		Modified from default barter coin window
		dethia_shop_sys		This include file (script)
		gui_dethia_shop		The script file that handles store interaction
		ga_store_open		Replaces the default ga_store_open script allowing
								for seamless integration of the system

	System Requirements (IMPORTANT PLEASE READ):
		Sadly I could not extract all store information via scripts, the data
		I could not extract is:

			1	Whether the store buys stolen goods
			2	The mark-down on the stolen goods
			3	The store's Will Not Buy list
			4	The store's Will Only Buy list

		To rectify this problem these values must be stored as variables on the
		store itself which may be a bit of work ;(
		The variable names must be as follows:
			integer	DS_BLACKMARKET		=	0 means DOES NOT buy stolen goods.
											1-99 WILL BUY stolen goods
											The value of 1-99 is the modifier
											on the price of stolen goods.  A value
											of less than 100 indicates a percentage
											drop of the item's sell cost.  As an
											example if an item is stolen and has a
											sell value of 1000 gold and the var is
											50, that means the item will sell at
											50% of it's sell value thus 500 gold. 

			string	DS_WILL_NOT_BUY		=	This must be a string containing the
											base item types of items that will
											not be purchased delimited by a
											semi-colon.  As an example, if you do not
											want a store to buy books, potions and
											boots the string would look as follows:
												74;49;26
											where 74 is the base item type for books,
											49 for potions and 26 is the base item
											type for boots.

			string	DS_WILL_ONLY_BUY	=	This must be a string containing the
											base item types of items that the store
											is allowed to purchase delimited by a 
											semi-colon.  As an example just like for
											DS_WILL_NOT_BUY it should be set in the
											following manner:
												75;120;23;2;88
											and so on.  Each number would correspond
											to a base item type that the store is
											allowed to purchase.
			int		DS_THEFT_OVERRIDE	= 	1/0	This is an OPTIONAL variable that will
											override default theft behaviour.  So if
											for example you have theft enabled but
											would like to block stealing from a particular
											store, set this value to 1 and players will
											not be able to steal from it.

			float	DS_BUY_MOD			=	Based on a 1.0 value (if omitted or 0 a default
											value is used defined by DS_BUY_RATE).  This value modifies
											the amount the store pays for items players are selling to them

			float	DS_SELL_MOD			=	Based on a 1.0 value where 1 is 100%, this variable modifies
											the amount the store charger for items it sells.
------END OF READ-ME------------------------------------------------------------------
*************************************************************************************/
#include "ginc_param_const"
#include "ginc_item"
#include "x2_inc_itemprop"
#include "ps_inc_time"
#include "nwnx_sql"
#include "ps_inc_newcrafting"
#include "ps_inc_newenchanting"

//******************************CONSTANTS*******************************//
//Constants, gold and various conversion rates (we use copper as base currency unit)
string	GOLD			= "nw_it_gold001";	//Resref of gold piece
int		CuC				= 1;		//Copper coins (1 copper = 1 copper)
int		AgC				= 10;		//Silver coins (1 silver = 10 copper)
int		AuC				= 100;		//Gold coins, (1 gold = 100 copper)
float	DS_BUY_RATE		= 0.5f;		//50%
int		DS_THEFT_ENABLE	= FALSE;	//Enable/Disable theft from shops
float	DS_THEFT_WEIGHT	= 10.0f;	//Maximum allowed weight for stolen items
float	DS_MAX_DISTANCE	= 5.0f;		//Max shopping distance

//Timestamp for sanity checks
const string STORE_TIMESTAMP = "last_interacted";	//string for the store timestamp
const int STORE_TIMEOUT = 5; 						//store timeout in minutes

//Event Handlers
int	STORE_OPEN	= 0;	//The event handler for when a store opens
int	STORE_CLOSE	= 1;	//The event handler for when a store closes	

//Pricing system
int	PRICING_SYSTEM_OLD	= 0;	//Uses GetGoldPieceValue
int	PRICING_SYSTEM_NEW	= 1;	//Uses new logic

//Item categories
int	DS_ARMOR			= 0;	//Shields and armor
int	DS_WEAPON			= 1;	//Weapons
int	DS_USEABLE			= 2;	//Useable items
int	DS_TRINKETS			= 3;	//Trinket items (rings/amulets etc..)
int	DS_MISCELLANEOUS	= 4;	//Miscellaneous items

//The below variables are used in conjunction with DS_WillOnlyBuy and DS_WillNotBuy functions.
//In the string variables you set on stores for these functions you can specify for example
// -1 to block or allow all items that go in the armor category.  As an example your
//DS_WILL_NOT_BUY list can be -1;75;120;23;2;88 which would in addition to specified base item
//types prevent the store from purchasing any item that falls under the armor category
string	DS_BUY_FILTER_ARMOR			= "-1";	//Filter for the armor category
string	DS_BUY_FILTER_WEAPON		= "-2";	//Filter for the weapon category
string	DS_BUY_FILTER_USEABLE		= "-3";	//Filter for the useable item category
string	DS_BUY_FILTER_TRINKETS		= "-4";	//Filter for the trinkets category
string	DS_BUY_FILTER_MISCELLANEOUS	= "-5";	//Filter for the miscellaneous category
//***************************END OF CONSTANTS***************************//

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<//
//------------------------------FUNCTIONS--------------------------------//
//------------------------------PROTOTYPES-------------------------------//
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<//

//This function closes the shop, it will clear the gui, close it and execute
//the shop's OnClose script
//object	oPC		= the player for whom the shop is being closed
//object	oStore	= the store being closed
void DS_CloseShop(object oPC, object oStore);

//This function is used to open the store.  It opens and populates the shop
//gui with all relevant data and items.
//object	oStore		= the store waypoint that is being accessed by oPC
//object	oPC			= the player who is shopping
//int		iMarkUp		= the mark-up in the shop for the various items
//int		iMarkDown	= the mark-down in the shop for the various items
void DS_OpenShop(object oStore, object oPC, int iMarkUp = 0, int iMarkDown = 0);

//This function retrieves the NPC or placeable that is running oStore.
object DS_GetStoreKeeper(object oStore);

//This function converts the in-game gold value (default game system)
//to a value of copper coins used by the Dethia Shop System
//int	iCoins	= the in-game gold value (default gold system value)
string DS_ConvertCoinsToCopper(int iCoins);

//This function converts the in-game gold value (default game system)
//to a value of silver coins used by the Dethia Shop System
//int	iCoins	= the in-game gold value (default gold system value)
string DS_ConvertCoinsToSilver(int iCoins);

//This function converts the in-game gold value (default game system)
//to a value of gold coins used by the Dethia Shop System
//int	iCoins	= the in-game gold value (default gold system value)
string DS_ConvertCoinsToGold(int iCoins);

//This function adds actual items to the shop GUI that are of the
//specified category
//object	oStore		= the store from which items are drawn
//object	oPC			= the player who is shopping
//object	iCategory	= the category of the items we wish to display
//int		iMarkUp		= the mark up of the store
//int		iMarkDown	= the mark down of the store
void DS_AddItemsToShop(object oStore, object oPC, int iCategory, int iMarkUp, int iMarkDown);

//This function checks if the specified store will not buy the specified item.
//Returns TRUE if the item CANNOT be purchased, false otherwise
//object	oItem		= the item we are testing to see if the store will buy it or not
//string	sNoBuyList	= a list stored as a local string on the store "DS_WILL_NOT_BUY"
int DS_WillNotBuy(object oItem, string sNoBuyList);

//This function checks if the specified store will buy the specified item.  It takes
//precedence of DS_WillNotBuy
//Returns TRUE if the item can be purchased, FALSE otherwise
//object	oItem			= the item we are testing to see if the store will buy it or not
//string	sBuyOnlyList	= a list stored as a local string on the store "DS_WILL_ONLY_BUY"
int DS_WillOnlyBuy(object oItem, string sBuyOnlyList);

//This function gets the sell value of an item taking into consideration the mark-up and
//mark-down, as well as whether the item is stolen or not, and DS_BUY_RATE.  This sell
//value is for items being sold by a player to a store not the other way around!
//object	oItem			= the item the player is selling
//int		iMarkUp			= the mark-up of the store involved
//int		iMarkDown		= the mark-down of the store involved
//int		iBlackMarket	= black-market buy value for the store to which we are selling
//float		fSellMod		= Obtained from the local float variable "DS_BUY_MOD" on the store
int DS_GetItemSellValue(object oItem, int iMarkUp, int iMarkDown, int iBlackMarket = 0, float fSellMod = 0.0f);

//This function gets the amount of currency oCreature has
//object	oCreature	= creature whose current financial state we wish to know
int	DS_GetCoinsOnCreature(object oCreature);

//This function will remove an appropriate amount of coins from the specified creature
//object	oCreature	= the creature / player from which we are removing gold
//int		iCoins		= how many coins we are removing in terms of least valueable
void DS_TakeCoinsFromCreature(object oCreature, int iCoins);

//This function gives the specified creature coins equal to iCoins.  Use the least
//valueable currency for iCoins.  So if you wish to give 1 silver, gives 100 iCoins
//which means give 100 copper and that is translated into 1 silver automatically
//object	oCreature	= the creature / player to whom we are giving the currency
//int		iCoins		= the amount of currency given (in terms of least valueable)
void DS_GiveCoinsToCreature(object oCreature, int iCoins);

//This function updates oStore's gold by either decreasing or increasing it
//with the value iCoins.  If iAdd is FALSE it will decrease the store's gold
//object	oStore	= the store whose current gold value we are adjusting
//object	oPC		= the player currently interacting with the shop
//int		iCoins	= the value by how much the store's gold will increase/decrease
//int		iAdd	= TRUE (increasing), FALSE indicates we are decreasing
void DS_UpdateStoreCurrency(object oStore, object oPC, int iCoins, int iAdd = TRUE);

//This function updates the player's coin values in the inventory screen
//object	oPC	= the player whose coin values we are updating
void DS_UpdateIventoryCoinValues(object oPC);

//This function determines if the theft by oPC from oStore of oItem with a
//iStackSize was successful or not.  Returns TRUE if yes, FALSE otherwise
//object	oPC			= the player who is doing the stealing
//object	oStore		= the store from which the item is being stolen
//object	oItem		= the item being stolen
//int		iCost		= the cost of the item being stolen (in least valueable currency)
//int		iStackSize	= oItem's selected stack size to steal
int	DS_GetIsTheftSuccessful(object oPC, object oStore, object oItem, int iCost, int iStackSize);

//This function checks if the player is within an acceptable distance from the store.
//Returns TRUE if yes, FALSE otherwise
int DS_DistanceCheck(object oPC, object oStore);

//This function determines the category an item goes into within a store
//based on its base item type.  Refer to dethia_shop_sys for item categories
//object	oItem	= the item whose category we wish to retrieve
int DS_GetItemCategory(object oItem);

//This function checks whether an item is a projectile or not.  Returns TRUE if yes,
//FALSE otherwise
//object	oItem	= the item we are checking whether it is a projectile or not
int DS_GetIsProjectile(object oItem);

//This function gets the absolute value of fValue
//float	fValue	= the floating point number of which we want the absolut value
float DS_AbsoluteValue(float fValue);

//*****************************************************************************
//Written by Dethia	-	 01/4/2010
//Will determine if the player has a certain amount of free inventory slots.
//Generally you want to perform this check before giving PC some cursed items
//oPC		-	whose inventory you will be checking
//iSlots	-	how many slots should be free, 1 by default
//Returns TRUE if they have enough inventory slots, FALSE otherwise
//*************************************************************************************
int DoesPCHaveFreeInvSlots(object oPC, int iSlots = 1);

//This function gets the appraise modifier for the store using the original
//(default nwn2) logic.
//object	oNPC	= the npc running the shop
//object	oPC		= the player doing the shopping
int DS_AppraiseModifier(object oNPC, object oPC);

//Check alignment restrictions
int GetSpecificAlignment(object oPC);

//Does the item have any properties which restrict its use by this PC?
//returns TRUE if the item is useable, and FALSE if not.
int GetItemUseLimited(object oItem, object oPC);

//Check if you have proficiency
int GetItemUseable(object oItem, object oPC);

//A function to fetch the "real" gold piece value of an item
int PS_GetItemValue(object oItem, object oPC = OBJECT_INVALID);

//get whether the item is in the database
int GetItemInDB(object oItem);

//Add all the items in the store to the database 
void AddAllItemsInStoreToDatabase(object oStore, object oPC = OBJECT_INVALID);

//Get the cost of an item property
int GetCostOfProperty(itemproperty iProp, object oPC = OBJECT_INVALID);

//Get the total cost of the item (manually calculated)
int GetCostOfItem(object oItem, object oPC = OBJECT_INVALID);

//Get the cost of the item from the database (must have already been calculated)
int GetCostOfItemByString(string sItem, object oPC = OBJECT_INVALID);

//Add this property to the DB - never seen it before!
void AddPropertyToDB(itemproperty iProp);

//Checks whether we need to recalculate the price for an item
int GetItemCostUpdated(object oItem, object oPC = OBJECT_INVALID);

//Set up all the variables for this item
void SetItemCostVariables(object oItem, object oPC = OBJECT_INVALID);

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<//
//------------------------------FUNCTIONS--------------------------------//
//------------------------------IMPLEMENTATION---------------------------//
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<//

void DS_CloseShop(object oPC, object oStore)
{//First we remove the "DS_SELL_PRICE" variable from all items upon closing
	object	oItem	= GetFirstItemInInventory(oStore);
	while(GetIsObjectValid(oItem))
	{
		DeleteLocalInt(oItem, "DS_SELL_PRICE");
		oItem	= GetNextItemInInventory(oStore);
	}

	//Clear the GUI listbox
	ClearListBox(oPC, "dethia_shop", "store_items");
	//Close the shop GUI
	CloseGUIScreen(oPC, "dethia_shop");

	if(GetLocalInt(oStore, "DS_INFINITE_GOLD"))
	{//If the store had infinite gold we reset its gold to infinite
		SetStoreGold(oStore, -1);
		DeleteLocalInt(oStore, "DS_INFINITE_GOLD");
	}
	
	//Lastly we set the store as closed and execute the OnClose event script
	SetLocalInt(oStore, "DS_OPEN", FALSE);
	ExecuteScript(GetEventHandler(oStore, STORE_CLOSE), oStore);
}

void DS_OpenShop(object oStore, object oPC, int iMarkUp = 0, int iMarkDown = 0)
{//First we check if the shop is already open
	//SendMessageToPC(oPC, "opening new shop");
	object	oCustomer	= GetLocalObject(oStore, "DS_CUSTOMER");	//The currently registered customer
	
	//Another person who isn't the currently registered customer wants to open the store
	if (GetLocalInt(oStore, "DS_OPEN") && GetIsObjectValid(oCustomer) && (oCustomer != oPC))  {
	
		//original customer is still close enough and active
		if ((PS_GetTimestamp_Age_Minutes(oStore, STORE_TIMESTAMP) < 5) && (DS_DistanceCheck(oCustomer, oStore))) { 
			FloatingTextStringOnCreature("Sorry I'm with another customer right now.", oPC);
			return;
		}
		//original customer doesn't seem to be around. Time to clear variables.
		else {
			DS_CloseShop(oCustomer, oStore); //this function is in distance check, but it doesn't hurt to do it twice!
		}
	}
	//Player tried to steal from here before and failed, tell him to get lost
	else if(GetLocalInt(oPC, "DS_THIEF_" + GetTag(oStore)))
	{
		FloatingTextStringOnCreature("Dirty thief I'm not showing you my wares, go away.", oPC);
		return;
	}
	
	//Safe to proceed - mark store as open and register new customer
	SetLocalObject(oStore, "DS_CUSTOMER", oPC);
	SetLocalInt(oStore, "DS_OPEN", TRUE);
	
	PS_Timestamp_UNIX(oStore, STORE_TIMESTAMP);

	//Open the shop GUI, store some vars and populate the shop
	SetLocalObject(oStore, "DS_SHOP_KEEPER", OBJECT_SELF);	//Store the shop keeper
	DisplayGuiScreen(oPC, "dethia_shop", FALSE, "dethia_shop.xml");
	//Set the store and mark up/mark down values as local variables in the gui
	SetLocalGUIVariable(oPC, "dethia_shop", 0, IntToString(ObjectToInt(oStore)));
	SetLocalGUIVariable(oPC, "dethia_shop", 1, IntToString(iMarkUp));
	SetLocalGUIVariable(oPC, "dethia_shop", 2, IntToString(iMarkDown));
	SetLocalGUIVariable(oPC, "dethia_shop", 8, "0");	//Indicate buying mode
	SetLocalGUIVariable(oPC, "dethia_shop", 9, "0");	//page 0 on sell tab
	//For buying disable sell/identify and check whether STEAL should be disabled
	SetGUIObjectDisabled(oPC, "dethia_shop", "sell_item_button", TRUE);
	SetGUIObjectDisabled(oPC, "dethia_shop", "identify_item_button", TRUE);
		
	SetGUIObjectText(oPC, "dethia_shop", "PAGE_TEXT", -1, "Page 1 of 1");
	SetGUIObjectDisabled(oPC, "dethia_shop", "PREVIOUS_PAGE", TRUE);
	SetGUIObjectDisabled(oPC, "dethia_shop", "NEXT_PAGE", TRUE);
	
	if((DS_THEFT_ENABLE && GetLocalInt(oStore, "DS_THEFT_OVERRIDE"))	||
		(!DS_THEFT_ENABLE && !GetLocalInt(oStore, "DS_THEFT_OVERRIDE"))	)
	{	SetGUIObjectDisabled(oPC, "dethia_shop", "steal_item_button", TRUE);	}

	//Set the max-buy price values
	int	iMaxBuyPrice	= GetStoreMaxBuyPrice(oStore);
	if(iMaxBuyPrice	== -1)	{	iMaxBuyPrice	= 500000;	}
	else if(iMaxBuyPrice == -2)
	{
		SendMessageToPC(oPC, "The store could not be found sorry, report to devs.");
		return;
	}
	SetGUIObjectText(oPC, "dethia_shop", "mbp_cc", -1, DS_ConvertCoinsToCopper(iMaxBuyPrice));
	SetGUIObjectText(oPC, "dethia_shop", "mbp_sc", -1, DS_ConvertCoinsToSilver(iMaxBuyPrice));
	SetGUIObjectText(oPC, "dethia_shop", "mbp_gc", -1, DS_ConvertCoinsToGold(iMaxBuyPrice));

	//Set the identify cost
	int	iIdentifyCost	= GetStoreIdentifyCost(oStore);
	if(iIdentifyCost == -1)
	{//If this store does not identify items add red x's
		SetGUIObjectText(oPC, "dethia_shop", "idc_cc", -1, "<color=red>x</color>");
		SetGUIObjectText(oPC, "dethia_shop", "idc_sc", -1, "<color=red>x</color>");
		SetGUIObjectText(oPC, "dethia_shop", "idc_gc", -1, "<color=red>x</color>");
	}
	else
	{//Otherwise set the cost to the determined value
		SetGUIObjectText(oPC, "dethia_shop", "idc_cc", -1, DS_ConvertCoinsToCopper(iIdentifyCost));
		SetGUIObjectText(oPC, "dethia_shop", "idc_sc", -1, DS_ConvertCoinsToSilver(iIdentifyCost));
		SetGUIObjectText(oPC, "dethia_shop", "idc_gc", -1, DS_ConvertCoinsToGold(iIdentifyCost));
	}

	//Set the current store gold
	int	iStoreGold	= GetStoreGold(oStore);
	if(iStoreGold == -1)
	{//If the store has infinite gold we set a local int indicating that it does
		iStoreGold	= 500000;	//And set the store gold to 500,000
		SetStoreGold(oStore, iStoreGold);
		SetLocalInt(oStore, "DS_INFINITE_GOLD", TRUE);
	}
	SetGUIObjectText(oPC, "dethia_shop", "sg_cc", -1, DS_ConvertCoinsToCopper(iStoreGold));
	SetGUIObjectText(oPC, "dethia_shop", "sg_sc", -1, DS_ConvertCoinsToSilver(iStoreGold));
	SetGUIObjectText(oPC, "dethia_shop", "sg_gc", -1, DS_ConvertCoinsToGold(iStoreGold));

	//Now that basic information has been set we proceed to populate the shop's inventory
	DS_AddItemsToShop(oStore, oPC, DS_ARMOR, iMarkUp, iMarkDown);

	//Lastly we execute the store's OnOpen event script
	ExecuteScript(GetEventHandler(oStore, STORE_OPEN), oStore);
}

object DS_GetStoreKeeper(object oStore)
{	return GetLocalObject(oStore, "DS_SHOP_KEEPER");	}

string DS_ConvertCoinsToCopper(int iCoins)
{	return	IntToString(iCoins%AgC);	}

string DS_ConvertCoinsToSilver(int iCoins)
{	return IntToString((iCoins%AuC - iCoins%AgC)/AgC);	}

string DS_ConvertCoinsToGold(int iCoins)
{	return IntToString((iCoins - iCoins%AuC)/AuC);	}

void DS_AddItemsToShop(object oStore, object oPC, int iCategory, int iMarkUp, int iMarkDown)
{//We first empty the shop of currently available items
	ClearListBox(oPC, "dethia_shop", "store_items");

	int		iRowID	= 0;	//The listbox row item ID
	object	oItem	= GetFirstItemInInventory(oStore);	//Get the first item in the store
	while(GetIsObjectValid(oItem))	//As long as there are valid items add them
	{//First check the category, if it doesn't match skip the item
		if(DS_GetItemCategory(oItem) != iCategory)
		{//Get the next item in the store and continue
			oItem	= GetNextItemInInventory(oStore);
			continue;
		}
		//Add the items to the "store_items" listbox
		string	sStackSize	= IntToString(GetItemStackSize(oItem));
		if(GetInfiniteFlag(oItem))	//If infinite set stack size to max
		{//First set the item stack size to 99 (extra is disregarded)
			SetItemStackSize(oItem, 99, FALSE);
			sStackSize	= IntToString(GetItemStackSize(oItem));
		}
		
		float	fCostMod	= GetLocalFloat(oStore, "DS_SELL_MOD");
		if(fCostMod == 0.0f)	{	fCostMod	= 1.0f;	}	//If no value is set, set the value to 100%
		fCostMod	+= (iMarkUp + iMarkDown)/200.0f;
		
		//putting debug into title, because why not. . 
		int		iOldCost	= FloatToInt((GetGoldPieceValue(oItem)*fCostMod)/GetItemStackSize(oItem));
		string	sItemName	= GetName(oItem) + " (" + sStackSize + ") - "+IntToString(iOldCost);
		
		string	sItemIcon	= Get2DAString("nwn2_icons", "ICON", GetItemIcon(oItem)) + ".tga";
		int		iItemCost	= FloatToInt((PS_GetItemValue(oItem, oPC)*fCostMod)/GetItemStackSize(oItem));
		if(iItemCost <= 0)	//If the item cost is less than or equal to 0, set it to 1
		{		iItemCost	= 1;	}
		//If this is greater than 0, the item was sold, we set it's sell price to purchase price
		if(GetLocalInt(oItem, "DS_SELL_PRICE") > 0)
		{	iItemCost	= GetLocalInt(oItem, "DS_SELL_PRICE");	}
		//Finally add the item details into the GUI
		
		//Debug Stuff
		/*int nOldPrice = GetGoldPieceValue(oItem);
		int nNewPrice = PS_GetItemValue(oItem);
		SendMessageToPC(oPC, GetName(oItem)+" - Old price: "+IntToString(nOldPrice)+" vs. New: "+IntToString(nNewPrice));
		*/
		
		if (GetItemUseable(oItem, oPC) == FALSE){
			//SendMessageToPC(oPC, "You can't use "+sItemName);
			AddListBoxRow(oPC, "dethia_shop", "store_items", IntToString(iRowID),
									"item_cost_cc=" + DS_ConvertCoinsToCopper(iItemCost) + ";"	+
									"item_cost_sc=" + DS_ConvertCoinsToSilver(iItemCost) + ";"	+
									"item_cost_gc=" + DS_ConvertCoinsToGold(iItemCost) + ";"	+
									"item_name=" + sItemName,
									"item_icon=" + sItemIcon+";item_prof=red.tga",
									"0=" + IntToString(ObjectToInt(oItem)) + ";"	+
									"1=" + IntToString(iItemCost) + ";"	+
									"2=" + sStackSize + ";"				+
									"3=" + IntToString(iRowID), "");
		} else {
			//SendMessageToPC(oPC, "You can use "+sItemName);
			AddListBoxRow(oPC, "dethia_shop", "store_items", IntToString(iRowID),
									"item_cost_cc=" + DS_ConvertCoinsToCopper(iItemCost) + ";"	+
									"item_cost_sc=" + DS_ConvertCoinsToSilver(iItemCost) + ";"	+
									"item_cost_gc=" + DS_ConvertCoinsToGold(iItemCost) + ";"	+
									"item_name=" + sItemName,
									"item_icon=" + sItemIcon+";item_prof=b_empty.tga",
									"0=" + IntToString(ObjectToInt(oItem)) + ";"	+
									"1=" + IntToString(iItemCost) + ";"	+
									"2=" + sStackSize + ";"				+
									"3=" + IntToString(iRowID), "");
		}
		
		iRowID++;	//Increment the item ID
		oItem	= GetNextItemInInventory(oStore);	//Get the next item in the store
	}
}

int DS_WillNotBuy(object oItem, string sNoBuyList)
{//First we check if the store has a "Will Not Buy" list
	//SpeakString("Checking will not buy", TALKVOLUME_SHOUT);
	if(sNoBuyList == "")	{	return FALSE;	}
	//SpeakString("We have a list: "+sNoBuyList, TALKVOLUME_SHOUT);
	
	//If there is a No Buy List, we check the item against it
	string	sBaseType	= IntToString(GetBaseItemType(oItem));
	int		iCategory	= DS_GetItemCategory(oItem);	//The item's category

	//Now we iterate through the whole list to see if the item is not allowed
	int		iListItem	= 0;
	string	sCheck		= GetStringParam(sNoBuyList, iListItem, ";");	//The the first string element
	while(sCheck != "")
	{//As long as there is a valid value in the list we check it
		//SpeakString("Checking baseType "+sBaseType+" vs. "+sCheck, TALKVOLUME_SHOUT);
		if(sBaseType == sCheck)
		{	return TRUE;	}	//If the item matches it cannot be sold here!
		iListItem++;
		sCheck = GetStringParam(sNoBuyList, iListItem, ";");	//Get the next string element
	}
	//If no match is found in the list, then this item is allowed so we return FALSE
	return FALSE;
}

int DS_WillOnlyBuy(object oItem, string sBuyOnlyList)
{//First we check if the store has a "Will Only Buy" list
	//SpeakString("Checking will only buy", TALKVOLUME_SHOUT);
	if(sBuyOnlyList == "")	{	return TRUE;	}
	//SpeakString("We have a list: "+sBuyOnlyList, TALKVOLUME_SHOUT);

	//If there is a Only Buy List, we check the item against it
	string	sBaseType	= IntToString(GetBaseItemType(oItem));
	int		iCategory	= DS_GetItemCategory(oItem);	//The item's category

	//Now we iterate through the whole list to see if the item is allowed
	int		iListItem	= 0;
	string	sCheck		= GetStringParam(sBuyOnlyList, iListItem, ";");	//The first string element
	while(sCheck != "")
	{//As long as there is a valid value in the list we check it
		//SpeakString("Checking baseType "+sBaseType+" vs. "+sCheck, TALKVOLUME_SHOUT);
		if(sBaseType == sCheck)
		{	return TRUE;	}	//If the item matches it can be sold here!
		iListItem++;
		sCheck = GetStringParam(sBuyOnlyList, iListItem, ";");	//Get the next string element
	}
	//If no match was found in the while loop, the item cannot be sold here
	return FALSE;
}

int DS_GetItemSellValue(object oItem, int iMarkUp, int iMarkDown, int iBlackMarket = 0, float fSellMod = 0.0f)
{//First determine if the store buys stolen goods
	int		iItemCost	= 1;	//Yet to be determined item cost
	float	fCostMod	= (iMarkUp + iMarkDown)/200.0f;	//The buy price modifier
	//If the sell modifier is not zero we add it to the fCostMod, otherweise we use the default DS_BUY_RATE
	if(fSellMod > 0.0f)	{	fCostMod	+= fSellMod;	}
	else				{	fCostMod	+= DS_BUY_RATE;	}
	if(GetStolenFlag(oItem) && iBlackMarket > 0)	//If stolen adjust modifier for black-market value
	{	fCostMod	*= (iBlackMarket/100.0f);	}

	//Next we generate the item cost
	if(!GetIdentified(oItem))	//If item is not identified set the price to 10 coppers
	{	iItemCost	= 10;	}
	else	//If all is well compute the item's sell value
	{	iItemCost	= FloatToInt(fCostMod*PS_GetItemValue(oItem)/GetItemStackSize(oItem));	}
	
	
	//If the cost is less than or equal to 0, set it to 1
	if(iItemCost <= 0)	{	iItemCost	= 1;	}

	//Lastly return the determined item cost
	return iItemCost;
}

int	DS_GetCoinsOnCreature(object oCreature)
{	return GetGold(oCreature);	}

void DS_TakeCoinsFromCreature(object oCreature, int iCoins)
{//We take the specified amount of gold (coins) from oCreature
	TakeGoldFromCreature(iCoins, oCreature, TRUE, FALSE);

	//Send a message to oCreature indicating how much coins he lost
	string	sCoinsLost	= "Lost";
	if(DS_ConvertCoinsToGold(iCoins) != "0")	//Add gold if non-zero
	{		sCoinsLost	+= " <color=gold>" + DS_ConvertCoinsToGold(iCoins) + "</color> gold";	}
	if(DS_ConvertCoinsToSilver(iCoins) != "0")	//Add silver if non-zero
	{		sCoinsLost	+= " <color=silver>" + DS_ConvertCoinsToSilver(iCoins) + "</color> silver";	}
	if(DS_ConvertCoinsToCopper(iCoins) != "0")	//Add copper if non-zero
	{		sCoinsLost	+= " <color=tan>" + DS_ConvertCoinsToCopper(iCoins) + "</color> copper";	}
	SendMessageToPC(oCreature, sCoinsLost + " coins.");
	//Lastly update oCreature's inventory screen
	DS_UpdateIventoryCoinValues(oCreature);
}

void DS_GiveCoinsToCreature(object oCreature, int iCoins)
{//Give oCreature the specified value of coins
	GiveGoldToCreature(oCreature, iCoins, FALSE);

	//Give a feed-back message of how much curency the player acquired
	string	sAcquiredCoins	= "Acquired";
	if(DS_ConvertCoinsToGold(iCoins) != "0")	//Add gold if non-zero
	{		sAcquiredCoins	+= " <color=gold>" + DS_ConvertCoinsToGold(iCoins) + "</color> gold";	}
	if(DS_ConvertCoinsToSilver(iCoins) != "0")	//Add silver if non-zero
	{		sAcquiredCoins	+= " <color=silver>" + DS_ConvertCoinsToSilver(iCoins) + "</color> silver";	}
	if(DS_ConvertCoinsToCopper(iCoins) != "0")	//Add copper if non-zero
	{		sAcquiredCoins	+= " <color=tan>" + DS_ConvertCoinsToCopper(iCoins) + "</color> copper";	}
	SendMessageToPC(oCreature, sAcquiredCoins + " coins.");
	//Lastly update oCreature's inventory screen
	DS_UpdateIventoryCoinValues(oCreature);
}

void DS_UpdateStoreCurrency(object oStore, object oPC, int iCoins, int iAdd = TRUE)
{//First get the current store gold
	int	iStoreGold	= GetStoreGold(oStore);

	if(iAdd)
	{//Add the coins to the specified store
		iStoreGold	+= iCoins;
		SetStoreGold(oStore, iStoreGold);
	}
	else
	{//Subtract the coins from the specified store
		iStoreGold	-= iCoins;
		SetStoreGold(oStore, iStoreGold - iCoins);
	}
	//Lastly we update the store's current gold value in the GUI
	SetGUIObjectText(oPC, "dethia_shop", "sg_cc", -1, DS_ConvertCoinsToCopper(iStoreGold));
	SetGUIObjectText(oPC, "dethia_shop", "sg_sc", -1, DS_ConvertCoinsToSilver(iStoreGold));
	SetGUIObjectText(oPC, "dethia_shop", "sg_gc", -1, DS_ConvertCoinsToGold(iStoreGold));
}

void DS_UpdateIventoryCoinValues(object oPC)
{//First get how much gold the player has
	int	iCoins	= DS_GetCoinsOnCreature(oPC);
	//Next just set the coin values
	SetGUIObjectText(oPC, "SCREEN_INVENTORY", "pc_gc", -1, DS_ConvertCoinsToGold(iCoins));
	SetGUIObjectText(oPC, "SCREEN_INVENTORY", "pc_sc", -1, DS_ConvertCoinsToSilver(iCoins));
	SetGUIObjectText(oPC, "SCREEN_INVENTORY", "pc_cc", -1, DS_ConvertCoinsToCopper(iCoins));
}

int	DS_GetIsTheftSuccessful(object oPC, object oStore, object oItem, int iCost, int iStackSize)
{//First get some values, and get the player's the d20 and sleight of hand rolls
	int		iSuccesFail	= FALSE;	//Yet to be determined
	string	sSuccesFail	= "Failure";	//Addendum indicating success or failure
	int		iD20		= d20();	//We assume at most the d20 + iPP = 65!
	int		iDC			= d20();
	int		iPP			= GetSkillRank(SKILL_SLEIGHT_OF_HAND, oPC);
	float	fWeight		= GetWeight(oItem)/10.0f;
	float	fMaxWeight	= DS_THEFT_WEIGHT;

	//Now we determine the DC of the item starting with the cost modifier
	int		iCopper		= StringToInt(DS_ConvertCoinsToCopper(iCost));
	int		iSilver		= StringToInt(DS_ConvertCoinsToSilver(iCost));
	int		iGold		= StringToInt(DS_ConvertCoinsToGold(iCost));
	float	fCostMod	= 1.0f	+
							DS_AbsoluteValue(sin(iCopper*0.9f))	+
							1.4f*DS_AbsoluteValue(sin(iSilver*0.9f))	+
							(100/(iGold + 1))*1.8*DS_AbsoluteValue(sin(iGold*0.9f));
	//Next get the weight modifier (log fit for {(0, -0.5), (1, 0), (10, 1)})
	if(DS_GetIsProjectile(oItem))
	{	iStackSize	= 1;	}	//Projectiles are treated as 1 bulk item
	float	fWeightMod	= 0.166667 + 0.325721*log(fWeight);
			fWeightMod	*=iStackSize;	//Weight modifier depends on stack size!
	//Now that we have the modifier for both weight and price get the DC
			iDC	= FloatToInt((10 + iDC)*(fCostMod + fWeightMod));
	//Finally check if the player succeeded in the theft or not
	if(iD20 + iPP >= iDC)	//Success
	{//Set iSuccess and sSuccesFail to "Success"
		iSuccesFail	= TRUE;
		sSuccesFail	= "Success";

		//Next check the weight of the item
		if(fWeight > fMaxWeight && d100() <= 98)
		{//Player has a 2% chance to steal an overweight item
			iSuccesFail	= FALSE;
			sSuccesFail	= "Failed to sneak away with such a large item";
		}
	}
	else
	{//If failure set the values to failure
		iSuccesFail	= FALSE;
		sSuccesFail	= "Failure";
	}
	//Send a message to the player on success or fail
	SendMessageToPC(oPC, "<color=#00FF66>" + GetName(oPC)	+
							" attempts to steal an item *"	+ sSuccesFail + "* ("	+
							IntToString(iD20) + " + " + IntToString(iPP) + " = "	+
							IntToString(iD20 + iPP) + " vs. DC: " + IntToString(iDC));
	//Lastly return whether the PC was successful or not
	return iSuccesFail;
}

int DS_DistanceCheck(object oPC, object oStore) {

	object oShopkeeper =  DS_GetStoreKeeper(oStore);
		
	//Make sure the PC is in the same area + witihn a reasonable distance
	if(GetArea(oPC) == GetArea(oShopkeeper) && GetDistanceBetween(oPC, oShopkeeper) < DS_MAX_DISTANCE)
	{	return TRUE;	}	//If within range return TRUE
	else
	{//If the player is out of range we close the shop
		SendMessageToPC(oPC, "You are too far away from the store.");
		DS_CloseShop(oPC, oStore);
		return FALSE;
	}
	
}

int DS_GetItemCategory(object oItem)
{//First get the base item type of oItem
	int	iBaseType	= GetBaseItemType(oItem);
	int	iCategory	= 0;	//Yet to be determined

	if(iBaseType == BASE_ITEM_ARMOR			||
		iBaseType == BASE_ITEM_BOOTS		||
		iBaseType == BASE_ITEM_HELMET		||
		iBaseType == BASE_ITEM_SMALLSHIELD	||
		iBaseType == BASE_ITEM_LARGESHIELD	||
		iBaseType == BASE_ITEM_TOWERSHIELD	||
		iBaseType == BASE_ITEM_CLOAK		||
		iBaseType == BASE_ITEM_GLOVES		||
		iBaseType == BASE_ITEM_BRACER		||
		iBaseType == BASE_ITEM_BELT			)
	{	iCategory	= DS_ARMOR;	}
	else if(IPGetIsMeleeWeapon(oItem)	||
			IPGetIsRangedWeapon(oItem)	||
			DS_GetIsProjectile(oItem)	)
	{	iCategory	= DS_WEAPON;	}
	else if(iBaseType == BASE_ITEM_POTIONS			||
			iBaseType == BASE_ITEM_SCROLL			||
			iBaseType == BASE_ITEM_SPELLSCROLL		||
			iBaseType == BASE_ITEM_BLANK_POTION		||
			iBaseType == BASE_ITEM_BLANK_SCROLL		||
			iBaseType == BASE_ITEM_BLANK_WAND		||
			iBaseType == BASE_ITEM_BOOK				||
			iBaseType == BASE_ITEM_ENCHANTED_POTION	||
			iBaseType == BASE_ITEM_ENCHANTED_SCROLL	||
			iBaseType == BASE_ITEM_ENCHANTED_WAND	||
			iBaseType == BASE_ITEM_MAGICROD			||
			iBaseType == BASE_ITEM_MAGICWAND		)
	{	iCategory	= DS_USEABLE;	}			
	else if(iBaseType == BASE_ITEM_GEM		||
			iBaseType == BASE_ITEM_RING		||
			iBaseType == BASE_ITEM_AMULET	)
	{	iCategory	= DS_TRINKETS;	}
	else
	{	iCategory	= DS_MISCELLANEOUS;	}
	//Lastly return the determined category
	return iCategory;
}

int DS_GetIsProjectile(object oItem)
{//Simply do the check
	if(IPGetIsProjectile(oItem)	||
		GetBaseItemType(oItem) == BASE_ITEM_THROWINGAXE	||
		GetBaseItemType(oItem) == BASE_ITEM_SHURIKEN	||
		GetBaseItemType(oItem) == BASE_ITEM_DART		)
	{	return TRUE;	}
	//If we got this far return FALSE
	return FALSE;
}

float DS_AbsoluteValue(float fValue)
{	return	pow(pow(fValue, 2.0f), 0.5f);	}

int DoesPCHaveFreeInvSlots(object oPC, int iSlots)
{	//Get the first item in inventory
	object	oItem	= GetFirstItemInInventory(oPC);
	int		iNum	= 0;	//The item counter
	while(GetIsObjectValid(oItem))
	{//While the item is valid add it to the item counter
		iNum++;
		oItem	= GetNextItemInInventory(oPC);
	}
	//Now simply check if max # of item slots (128) - total # of items, is
	//greater than or equal to how many slots you need.
	if((128-iNum) >= iSlots)
	{	return TRUE;	}	//If yes, then we're good to go.
	else
	{	return FALSE;	}	//If not, then we don't have enough inventory slots.
}

int DS_AppraiseModifier(object oNPC, object oPC)
{
	int	STATE_FAILED		= 1;
	int	STATE_TIE			= 2;
	int	STATE_WON			= 3;
	int	nPlayerSkillRank	= GetSkillRank(SKILL_APPRAISE, oPC);
    int	nNPCSkillRank		= GetSkillRank(SKILL_APPRAISE, oNPC) - N2_GetNPCEasyMark(oNPC);
	int	nState				= 0;

	if(nNPCSkillRank < 1)	{	nNPCSkillRank	= 1;	}

	int	nAdjust = nNPCSkillRank - nPlayerSkillRank; // * determines the level of price modification

	if(nNPCSkillRank > nPlayerSkillRank)		{	nState	= STATE_FAILED;	}
	else if(nNPCSkillRank < nPlayerSkillRank)	{   nState	= STATE_WON;	}
	else if(nNPCSkillRank == nPlayerSkillRank)	{	nState	= STATE_TIE;	}

	if(nState == STATE_FAILED)
	{	FloatingTextStrRefOnCreature(182468, oPC, FALSE);	}
	else if(nState == STATE_WON)
	{	FloatingTextStrRefOnCreature(182470, oPC, FALSE);	}
	else if (nState == STATE_TIE)
	{	FloatingTextStrRefOnCreature(182469, oPC, FALSE);	}

	// * Hard cap of 30% max up or down
	if(nAdjust > 30)	{	nAdjust	= 30;	}
	if(nAdjust < -30)	{	nAdjust = -30;	}

	return nAdjust;
}

int GetSpecificAlignment(object oPC)
{
	if (GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD)
	{
		if (GetAlignmentLawChaos(oPC) == ALIGNMENT_LAWFUL)
			return 0;
		else if (GetAlignmentLawChaos(oPC) == ALIGNMENT_CHAOTIC)
			return 6;
		else if (GetAlignmentLawChaos(oPC) == ALIGNMENT_NEUTRAL)
			return 3;
		return -1;
	}
	else if (GetAlignmentGoodEvil(oPC) == ALIGNMENT_NEUTRAL)
	{
		if (GetAlignmentLawChaos(oPC) == ALIGNMENT_LAWFUL)
			return 1;
		else if (GetAlignmentLawChaos(oPC) == ALIGNMENT_CHAOTIC)
			return 7;
		else if (GetAlignmentLawChaos(oPC) == ALIGNMENT_NEUTRAL)
			return 4;
		return -1;
	}
	else if (GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL)
	{
		if (GetAlignmentLawChaos(oPC) == ALIGNMENT_LAWFUL)
			return 2;
		else if (GetAlignmentLawChaos(oPC) == ALIGNMENT_CHAOTIC)
			return 8;
		else if (GetAlignmentLawChaos(oPC) == ALIGNMENT_NEUTRAL)
			return 5;
		return -1;
	}
	return -1;
}

int GetItemUseLimited(object oItem, object oPC)
{
	itemproperty ip = GetFirstItemProperty(oItem);
	int count = 0;
	while (GetIsItemPropertyValid(ip) && count <= 10)
	{
		if (GetItemPropertyType(ip) == 62)
		{
			int sub = GetItemPropertySubType(ip);
			if (GetAlignmentGoodEvil(oPC) == sub ||
				GetAlignmentLawChaos(oPC) == sub)
				return TRUE;
			else
				return FALSE;
		}
		else if (GetItemPropertyType(ip) == 63)
		{
			int sub = GetItemPropertySubType(ip);
			if (GetLevelByClass(sub, oPC) > 0)
				return TRUE;
			else
				return FALSE;
		}
		else if (GetItemPropertyType(ip) == 64)
		{
			int sub = GetItemPropertySubType(ip);
			if (GetRacialType(oPC) == sub)
				return TRUE;
			else
				return FALSE;
		}
		else if (GetItemPropertyType(ip) == 65)
		{
			int sub = GetItemPropertySubType(ip);
			if (GetSpecificAlignment(oPC) == sub)
				return TRUE;
			else
				return FALSE;
		}
		count++;
		ip = GetNextItemProperty(oItem);
	}
	return TRUE;
}

int GetItemUseable(object oItem, object oPC)
{
	if (GetIsArmorOrShield(oItem))
	{
		if ((GetBaseItemType(oItem) == 57) && (GetHasFeat(1115, oPC, TRUE)))
			return GetItemUseLimited(oItem, oPC);
		else if (GetIsShield(oItem) && GetHasFeat(32, oPC, TRUE))
			return GetItemUseLimited(oItem, oPC);
		else if ((GetArmorRank(oItem) == ARMOR_RANK_LIGHT) && (GetHasFeat(3, oPC, TRUE)))
			return GetItemUseLimited(oItem, oPC);
		else if ((GetArmorRank(oItem) == ARMOR_RANK_MEDIUM) && (GetHasFeat(4, oPC, TRUE)))
			return GetItemUseLimited(oItem, oPC);
		else if ((GetArmorRank(oItem) == ARMOR_RANK_HEAVY) && (GetHasFeat(2, oPC, TRUE)))
			return GetItemUseLimited(oItem, oPC);
		else if (GetArmorRank(oItem) == ARMOR_RANK_NONE)
			return GetItemUseLimited(oItem, oPC);
		return FALSE;
	}
	else if (GetIsWeapon(oItem))
	{
		string reqFeat0 = Get2DAString("baseitems", "ReqFeat0", GetBaseItemType(oItem));
		string reqFeat1 = Get2DAString("baseitems", "ReqFeat1", GetBaseItemType(oItem));
		string reqFeat2 = Get2DAString("baseitems", "ReqFeat2", GetBaseItemType(oItem));
		string reqFeat3 = Get2DAString("baseitems", "ReqFeat3", GetBaseItemType(oItem));
		string reqFeat4 = Get2DAString("baseitems", "ReqFeat4", GetBaseItemType(oItem));
		string reqFeat5 = Get2DAString("baseitems", "ReqFeat5", GetBaseItemType(oItem));
		if (reqFeat0 == "****" && reqFeat1 == "****" && reqFeat1 == "****" && reqFeat2 == "****" &&
		 	reqFeat3 == "****" && reqFeat4 == "****" && reqFeat5 == "****")
			return GetItemUseLimited(oItem, oPC);
		else if (GetHasFeat(StringToInt(reqFeat0), oPC, TRUE) ||
			GetHasFeat(StringToInt(reqFeat1), oPC, TRUE) ||
			GetHasFeat(StringToInt(reqFeat2), oPC, TRUE) ||
			GetHasFeat(StringToInt(reqFeat3), oPC, TRUE) ||
			GetHasFeat(StringToInt(reqFeat4), oPC, TRUE) ||
			GetHasFeat(StringToInt(reqFeat5), oPC, TRUE))
			return GetItemUseLimited(oItem, oPC);
		return FALSE;
	}
	else
		return GetItemUseLimited(oItem, oPC);
	return FALSE;
}

//A function to fetch the "real" gold piece value of an item
int PS_GetItemValue(object oItem, object oPC = OBJECT_INVALID) {

	SetItemCostVariables(oItem, oPC);
	int nCost = GetLocalInt(oItem, "PRICE");
		
	return nCost;

}

//get whether the item is in the database
int GetItemInDB(object oItem) {

	string sTag = GetResRef(oItem);
	string sQuery = "SELECT item_id FROM item_prices WHERE item_tag='"+sTag+"'";
	
	SQLExecDirect(sQuery);
	
	while (SQLFetch() != SQL_ERROR) {
		int id = StringToInt(SQLGetData(1));
		return (id > 0);
	}
	return FALSE;
	
}

//Add all the items in this store to the database
void AddAllItemsInStoreToDatabase(object oStore, object oPC = OBJECT_INVALID) {

	float	fCostMod	= GetLocalFloat(oStore, "DS_SELL_MOD");
	object oItem = GetFirstItemInInventory(oStore);
	while(GetIsObjectValid(oItem)) {
	
		string sName = SQLEncodeSpecialChars(GetName(oItem));
		string sTag = GetResRef(oItem);
		int nPrice = FloatToInt(GetGoldPieceValue(oItem)*fCostMod);
		int nOldPrice = GetGoldPieceValue(oItem);
		
		if (!GetItemInDB(oItem)) {
			string sQuery = "INSERT INTO item_prices SET item_name='"+sName+"', item_tag='"+sTag+"', item_price='"+IntToString(nPrice)+"', item_oldvalue='"+IntToString(nOldPrice)+"', store_tag='"+GetTag(oStore)+"'";
			SQLExecDirect(sQuery);
		} else {
			SetItemCostVariables(oItem);
			int nOldCost = GetLocalInt(oItem, "PRICE_OLD");
			int nPoints = GetLocalInt(oItem, "PRICE_POINTS");
			
			string sQuery = "UPDATE item_prices SET item_points='"+IntToString(nPoints)+"', item_oldvalue='"+IntToString(nOldCost)+"' WHERE item_tag='"+sTag+"'";
			SQLExecDirect(sQuery);
		}
	
		oItem = GetNextItemInInventory(oStore);
	}

}

int GetCostOfItemByString(string sItem, object oPC = OBJECT_INVALID) {

	string sQuery = "SELECT item_price FROM item_prices WHERE item_tag = '"+sItem+"'";
	SQLExecDirect(sQuery);
	if (SQLFetch() != SQL_ERROR) {
		int nCost = StringToInt(SQLGetData(1));
		return nCost;
	}
	return FALSE;

}

int GetCostOfItem(object oItem, object oPC = OBJECT_INVALID) {

	int nCost = 0;
	itemproperty iProp = GetFirstItemProperty(oItem);
	
	if (GetIsObjectValid(oPC)) SendMessageToPC(oPC, "Get cost for: "+GetName(oItem));
	
	nCost += GetBaseCostOfItem(GetBaseItemType(oItem));
	if (GetIsObjectValid(oPC)) SendMessageToPC(oPC, "Base item cost: "+IntToString(nCost));
	
	while(GetIsItemPropertyValid(iProp)) {
	
		nCost += GetCostOfProperty(iProp, oPC);
	
		iProp = GetNextItemProperty(oItem);
	}
	
	//Increase price if there are enchanting slots on an otherwise slotted item
	int nSlots = GetItemTotalPoints(oItem);
	int nSlotsLeft = GetItemTotalPointsAllowed(oItem)-GetItemTotalPoints(oItem);
	if (nSlots >= 7 && nSlotsLeft > 0)
		nCost += (nSlotsLeft*1000);
	
	if (GetIsObjectValid(oPC)) SendMessageToPC(oPC, "Final cost for "+GetName(oItem)+": "+IntToString(nCost));
	
	if (nCost <= 10)
		return GetGoldPieceValue(oItem);
	
	return nCost;

}

int GetCostOfProperty(itemproperty iProp, object oPC = OBJECT_INVALID) {

	int iType = GetItemPropertyType(iProp);
	int iSub = GetItemPropertySubType(iProp);
	int iParam = GetItemPropertyCostTableValue(iProp);
	int iSpecial = GetItemPropertyParam1Value(iProp);
	
	//Special Material
	if (iType == 100) {
		int costTier = GetCostTierOfMaterial(iProp);
		if (costTier > 0)
			return costTier*1000;
		return 1000;
	}
	
	string sQuery = "SELECT Recipe_Id, Points, Gold, Essence, Gemstone FROM recipes WHERE Type='"+IntToString(iType)+"' AND Subtype='"+IntToString(iSub)+"' AND Numerical='"+IntToString(iParam)+"' AND Special='"+IntToString(iSpecial)+"'";
	SQLExecDirect(sQuery);
	
	if (SQLFetch() != SQL_ERROR) {
		int enchant_id = StringToInt(SQLGetData(1));
		int points = StringToInt(SQLGetData(2));
		int gold = StringToInt(SQLGetData(3));
		string sEssence = SQLGetData(4);
		string sGem = SQLGetData(5);
		
		int nQReq = StringToInt(GetSubString(sGem, GetStringLength(sGem)-1, 1));
		nQReq = nQReq-1;
		
		int nGemCost = 100;
		if (nQReq >= 2)
			nGemCost = 3000;
		else if (nQReq >= 1)
			nGemCost = 1000;
			
		if (gold <= 0) {
			if (GetIsObjectValid(oPC)) SendMessageToPC(oPC, "We have a no-gold entry: "+IntToString(enchant_id));
		}
		
		if (enchant_id > 0) {
			int nCost = gold;
			int nEssence = GetCostOfItemByString(sEssence);
			if (GetIsObjectValid(oPC)) SendMessageToPC(oPC, "gold: "+IntToString(gold)+" + essence: "+IntToString(nEssence)+" + gem: "+IntToString(nGemCost));
			
			nCost += nEssence;
			nCost += nGemCost;
			
			nCost *= 2;
			
			if (GetIsObjectValid(oPC)) SendMessageToPC(oPC, GetItemPropertyString(iProp)+" - Success / generated price: "+IntToString(nCost));
			return nCost;
		} else {
			if (GetIsObjectValid(oPC)) SendMessageToPC(oPC, GetItemPropertyString(iProp)+" - Failed / Not found: "+sQuery);
			AddPropertyToDB(iProp);
		}
	} else {
		if (GetIsObjectValid(oPC)) SendMessageToPC(oPC, GetItemPropertyString(iProp)+" - Failed: "+sQuery);
		AddPropertyToDB(iProp);
	}
		
	return FALSE;
}

void AddPropertyToDB(itemproperty iProp) {

	int iType = GetItemPropertyType(iProp);
	int iSub = GetItemPropertySubType(iProp);
	int iParam = GetItemPropertyCostTableValue(iProp);
	int iSpecial = GetItemPropertyParam1Value(iProp);
	string sName = SQLEncodeSpecialChars(GetItemPropertyString(iProp));
	
	string sQuery = "INSERT INTO recipes SET Label='"+sName+"', Type='"+IntToString(iType)+"', Subtype='"+IntToString(iSub)+"', Numerical='"+IntToString(iParam)+"', Special='"+IntToString(iSpecial)+"'";
	SQLExecDirect(sQuery);
	
	sQuery = "INSERT INTO recipes_names SET Prefix='"+sName+"'";
	SQLExecDirect(sQuery);
	
}

//Checks whether we need to recalculate the price for an item
int GetItemCostUpdated(object oItem, object oPC = OBJECT_INVALID) {
		
	int nCost = GetLocalInt(oItem, "PRICE");
	int nDirty = GetLocalInt(oItem, "PRICE_DIRTY");
	int nTime = GetLocalInt(oItem, "PRICE_TIMESTAMP");
	int nOldCost = GetLocalInt(oItem, "PRICE_OLD");
	int nPoints = GetLocalInt(oItem, "PRICE_POINTS");
	int nBaseGold = GetGoldPieceValue(oItem); //may not be reliable, so we're going to also compare with properties
	
	//We haven't run SetItemCostVariables at ALL on this item, so we probably should
	if (nTime <= 0) {
		if (GetIsObjectValid(oPC)) SendMessageToPC(oPC, GetName(oItem)+" - no timestamp, recalculate.");
		return TRUE;
	}
		
	//The item was enchanted or something; time to update
	if (nDirty == 1) {
		if (GetIsObjectValid(oPC)) SendMessageToPC(oPC, GetName(oItem)+" - properties updated, recalculate.");
		return TRUE;
	}
	
	//We haven't set the variables yet, or there's something otherwise wrong
	if (!GetPlotFlag(oItem) && nCost <= 0) {
		if (GetIsObjectValid(oPC)) SendMessageToPC(oPC, GetName(oItem)+" - no price found, recalculate.");
		return TRUE;
	}
		
	//Because we can't strictly trust the base cost function, we're going to double check with the points funtion
	if (nOldCost != nBaseGold && GetItemTotalPoints(oItem) != nPoints) {
		if (GetIsObjectValid(oPC)) SendMessageToPC(oPC, GetName(oItem)+" - gold cost and/or item points have changed.");
		return TRUE;
	}
		
	return FALSE;
	
}

//Set up all the variables for this item
void SetItemCostVariables(object oItem, object oPC = OBJECT_INVALID) {	

	if (GetIsObjectValid(oPC)) SendMessageToPC(oPC,  GetName(oItem)+" - here we are.");		
		
	if (GetItemCostUpdated(oItem, oPC)) {
	
		SetLocalInt(oItem, "PRICE_POINTS", GetItemTotalPoints(oItem));
		SetLocalInt(oItem, "PRICE_OLD", GetGoldPieceValue(oItem));
	
		int nCost = GetLocalInt(oItem, "PRICE");
		int nDirty = GetLocalInt(oItem, "PRICE_DIRTY");
		int nTime = GetLocalInt(oItem, "PRICE_TIMESTAMP");
		int nOldCost = GetLocalInt(oItem, "PRICE_OLD");
		int nPoints = GetLocalInt(oItem, "PRICE_POINTS");
	
		int nDBCost = 0;
		int nDBOldCost = 0;
		int nDBOldPoints = 0;
		int nDBLoaded = FALSE;
	
		//Check whether this item is in the DB
		string sQuery = "SELECT item_price, item_oldvalue, item_points FROM item_prices WHERE item_tag = '"+GetResRef(oItem)+"'";
		SQLExecDirect(sQuery);
		if (SQLFetch() != SQL_ERROR) {
			nDBCost = StringToInt(SQLGetData(1));
			nDBOldCost = StringToInt(SQLGetData(2));
			nDBOldPoints = StringToInt(SQLGetData(3));
			nDBLoaded = TRUE;
	    }
		
		if (nDBLoaded) {
			if (nDBOldCost == nOldCost || nPoints == nDBOldPoints) {
			   	nCost = nDBCost;
				if (GetIsObjectValid(oPC)) SendMessageToPC(oPC, GetName(oItem)+" - using database cost.");
			} else {
			   	nCost = GetCostOfItem(oItem);
				if (GetIsObjectValid(oPC)) SendMessageToPC(oPC, GetName(oItem)+" - calculating cost from scratch.");
			}
		} else {
			nCost = GetCostOfItem(oItem);
			if (GetIsObjectValid(oPC)) SendMessageToPC(oPC, GetName(oItem)+" - calculating cost from scratch because no DB info.");		
		}
	
		SetLocalInt(oItem, "PRICE", nCost);
		PS_Timestamp_UNIX(oItem, "PRICE_TIMESTAMP");
		SetLocalInt(oItem, "PRICE_DIRTY", 0);
	}
	
}