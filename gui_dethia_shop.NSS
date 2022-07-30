/*************************************************************************************
Written by Dethia	-	03/12/2011

This GUI script is part of the "Dethia Shops" system, it handles all calls from the
"dethia_shop.xml" file.  The xml file will send various events to the script after
which an appropriate action will be taken.  The events and their corresponding
behaviour are listed below.  There are also numerous local variables in the gui
file that store information which are also listed below.

Loval GUI vars:
local:0		The store ID in the form of a string
local:1		The store's mark-up value
local:2		The store's mark-down value
local:3		Currently selected item's ID in the form of a string
local:4		Currently selected item's price
local:5		Currently selected item's stack size inside the store (thus max stack to sell)
local:6		Item's listbox row ID.  If an item is bought we can edit it based on this value
local:7		The player selected stack size for purchase/sale
local:8		Whether we are buying or selling (0 = buying ; 1 = selling)
local:9		current page on the sell tab
local:10		max page on the sell tab
--The below variables are not used as the whole section does not work--
local:100	100-110 are only used in "splitgold.xml", stores the player's total coin value
local:101	Stores the player's current gold
local:102	Stores the player's current silver
local:103	Stores the player's current copper
local:104	Stores the gold scrollbar position
local:105	Stores the silver scrollbar position
local:106	Stores the copper scrollbar position
local:107	Storse the player selected gold value
local:108	Storse the player selected silver value
local:109	Storse the player selected copper valueActionRandomWalk
local:110	Stores the actual value of the selected coins
---------------------------------------------------------------------
Events:
0-4		Populate the shop with the corresponding item category
5		An item was selected within the shop, we update total cost and stack size
6		Quantity slider is being moved, either increase/decrease quantity and update
			the quantity field
7		The examine button is pressed, so we try to examine an item
8		The sell category is pressed, the player is selling items (populate sell list)
9		Player clicked on Identify button in sell menu, we identify the item
10		Player clicked on Buy item, an item is being purchased.  In this event the
			sUp variable will contain the player selected item stack size (local:7)
11		Player clicks on the Sell item, an item is being sold.  In this event the
			sUp variable will contain the player selected item stack size (local:7)
12		Player clicked on the Steal icon, a theft attempt will be made for the selected
			item.  The sUp variable will contain the player selected item stack size
13		This event fires from the "inventoryscreen.xml" (when player opens the inventory)
			It populates the player's current financial status
14		Player has double clicked to purchase/sell an item.  They purchase/sell 1 item or 1 stack if it is ammo.
				sUp		= item's listbox row id
				sDown	= whether the store is in buy(0)/sell(1) mode
15		This event fires from the "splitgold.xml" (when players are trading)  It
(NOT USED)	adjusts the trade value selected by the players.  This event uses
			sub-events, and provides overall the following data:
				sItemCost	= the sub-event value of 0 is the OnAdd event where we 
								populate max coin values into respective fields
								sub-event 1 is where we update coins to trade
				sStackSize	= will pass the player's current total coin value (local:996)
				sUp			= local:997 (selected gold)
				sDown		= local:998 (selected silver)
				sExtra		= local:999 (selected copper)
16 		This event takes you to the previous page of inventory in the sell tab (if applicable)
17 		This event takes to the next page of inventory in the sell tab (if applicable)
99		The store is being closed so we run the DS_CloseStore function
*************************************************************************************/
#include "dethia_shop_sys"

void main(string sEvent, string sItemID = "0", string sItemCost = "0", string sStackSize = "0", string sStoreID = "0", string sUp = "0", string sDown = "0", string sExtra = "0")
{//First we convert sEvent to an integer value
	int		iEvent	= StringToInt(sEvent);
	object	oPC		= OBJECT_SELF;	//The player interacting with the gui
	object	oItem	= IntToObject(StringToInt(sItemID));	//The item in question
	object	oStore	= StringToObject(sStoreID);

	//Before we perform specified actions we check what action it is
	if(iEvent != 13 && iEvent != 14 && iEvent != 15)	//13 and 14 are not store related actions
	{//If it is a store action we do a distance check
		if(!DS_DistanceCheck(oPC, oStore))
		{	return;	}	//If the player is too far away let them know and end here
	}

	//Now perform the action associated with the event
	if(iEvent >= 0 && iEvent <= 4)	//populate shop with corresponding category
	{//First disable/enable the sell/buy buttons (since we are buying)
		SetGUIObjectDisabled(oPC, "dethia_shop", "buy_item_button", FALSE);
		SetGUIObjectDisabled(oPC, "dethia_shop", "sell_item_button", TRUE);
		SetGUIObjectDisabled(oPC, "dethia_shop", "identify_item_button", TRUE);
		
		//Remove Pagination
		SetGUIObjectDisabled(oPC, "dethia_shop", "PAGE_TEXT", TRUE);
		SetGUIObjectDisabled(oPC, "dethia_shop", "PREVIOUS_PAGE", TRUE);
		SetGUIObjectDisabled(oPC, "dethia_shop", "NEXT_PAGE", TRUE);
		
		//If theft is enabled, allow stealing from the shop
		if((DS_THEFT_ENABLE && !GetLocalInt(oStore, "DS_THEFT_OVERRIDE"))	||
			(!DS_THEFT_ENABLE && GetLocalInt(oStore, "DS_THEFT_OVERRIDE"))	)
		{	SetGUIObjectDisabled(oPC, "dethia_shop", "steal_item_button", FALSE);	}
		//Convert the various values for use
		int	iMarkUp		= StringToInt(sUp);
		int	iMarkDown	= StringToInt(sDown);

		//Now populate the store with the appropriate items
		DS_AddItemsToShop(oStore, oPC, iEvent, iMarkUp, iMarkDown);
	}

	else if(iEvent == 5)	//Item selected within the shop
	{//First set the max stack value to quantity and update local:7 (quant-selected)
		int nStack = StringToInt(sStackSize);
		if(DS_GetIsProjectile(oItem)) {
			if (nStack >= 99)
				sStackSize = "99";
			else 
				sStackSize = IntToString(nStack);
				
		} else {
			sStackSize = "1";
		}
		SetGUIObjectText(oPC, "dethia_shop", "quantity", -1, sStackSize);
		SetLocalGUIVariable(oPC, "dethia_shop", 7, sStackSize);

		//Next set the item's cost (ammunition is not affected by stack size)
		int	iCost	= StringToInt(sStackSize)*StringToInt(sItemCost);
		if(DS_GetIsProjectile(oItem) && GetGoldPieceValue(oItem) <= 1)
		{	iCost	/= StringToInt(sStackSize);	}
		SetGUIObjectText(oPC, "dethia_shop", "sb_cost_cc", -1, DS_ConvertCoinsToCopper(iCost));
		SetGUIObjectText(oPC, "dethia_shop", "sb_cost_sc", -1, DS_ConvertCoinsToSilver(iCost));
		SetGUIObjectText(oPC, "dethia_shop", "sb_cost_gc", -1, DS_ConvertCoinsToGold(iCost));
	}

	else if(iEvent == 6)	//Update quantity field as the slider is moved
	{//First we update the gui text field, then the price fields
		sStackSize	= IntToString(FloatToInt((StringToInt(sStackSize))*(StringToInt(sExtra)/100.0f)));
		SetGUIObjectText(oPC, "dethia_shop", "quantity", -1, sStackSize);
		SetLocalGUIVariable(oPC, "dethia_shop", 7, sStackSize);
		
		//SpeakString("Stack size: "+sStackSize, TALKVOLUME_SHOUT);
	
		if(DS_GetIsProjectile(oItem) && GetGoldPieceValue(oItem) <= 1) //Don't update price for base ammunition
		{	return;	}
		int	iCost	= StringToInt(sStackSize)*StringToInt(sItemCost);
		SetGUIObjectText(oPC, "dethia_shop", "sb_cost_cc", -1, DS_ConvertCoinsToCopper(iCost));
		SetGUIObjectText(oPC, "dethia_shop", "sb_cost_sc", -1, DS_ConvertCoinsToSilver(iCost));
		SetGUIObjectText(oPC, "dethia_shop", "sb_cost_gc", -1, DS_ConvertCoinsToGold(iCost));
	}

	else if(iEvent == 7 && GetIsObjectValid(oItem))	//The player is examining the item
	{//First we must create a safe location to recreate the item
		if(!GetIsObjectValid(oItem))	{	return;	}	//Skip invalid items
		vector		vStorePos	= GetPosition(oPC);
					vStorePos.z	-= 10.0f;
		float		fDirection	= GetFacing(oPC);
		location	lLoc		= Location(GetArea(oPC), vStorePos, fDirection);

		//Now recreate and identify the item
		object		oExamine	= CopyObject(oItem, lLoc);
		if(sExtra == "0")	//iExtra in this case indicated buying(0)/selling(1)
		{	SetIdentified(oExamine, TRUE);	}
		DelayCommand(0.5f, ActionExamine(oExamine));
		DestroyObject(oExamine, 0.6f);
	}

	else if(iEvent == 8)	//The player chose "sell" category
	{//First disable/enable the buy, steal/sell buttons (since we are selling)
		SendMessageToPC(oPC, "selling tab generation");
		SetGUIObjectDisabled(oPC, "dethia_shop", "buy_item_button", TRUE);
		SetGUIObjectDisabled(oPC, "dethia_shop", "sell_item_button", FALSE);
		SetGUIObjectDisabled(oPC, "dethia_shop", "identify_item_button", FALSE);
		SetGUIObjectDisabled(oPC, "dethia_shop", "steal_item_button", TRUE);
		
		//Add Pagination
		SetGUIObjectDisabled(oPC, "dethia_shop", "PAGE_TEXT", FALSE);
		SetGUIObjectDisabled(oPC, "dethia_shop", "PREVIOUS_PAGE", FALSE);
		SetGUIObjectDisabled(oPC, "dethia_shop", "NEXT_PAGE", FALSE);
		
		int nMaxBuy = GetStoreMaxBuyPrice(oStore);
		if (nMaxBuy < 0)
			nMaxBuy = 999999;
		
		//pagination variables	
		int nPageLength = 143;
		int nCurrentPage = StringToInt(sExtra);
		
		//We will populate the shop gui with all non-cursed items and allowed items
		object	oItem		= GetFirstItemInInventory(oPC);
		int		iBlkMark	= GetLocalInt(oStore, "DS_BLACKMARKET");	//Blackmarket buy rate
		int		iRowID		= 0;	//The listbox row ID for a particular item
		//Before we populate the listbox we must first clear it
		ClearListBox(oPC, "dethia_shop", "store_items");
		
		//this page's limits
		int lastItem = (nCurrentPage+1) * nPageLength; // last item in current page
		int firstItem = lastItem - nPageLength; // first item in current page
		int nCount = 0;

		//As long as there are valid items we list them for sale
		while(GetIsObjectValid(oItem)) {
		
			SendMessageToPC(oPC, "Count: "+IntToString(nCount));
		
			if (!GetItemCursedFlag(oItem) && !GetPlotFlag(oItem)) {
			
				if (nCount >= firstItem && nCount < lastItem) {
					//We add the item to the "store_items" listbox
					string	sStackSize	= IntToString(GetItemStackSize(oItem));
					string	sItemName	= GetName(oItem) + " (" + sStackSize + ")";
					string	sItemIcon	= Get2DAString("nwn2_icons", "ICON", GetItemIcon(oItem)) + ".tga";
					int		iItemCost	= DS_GetItemSellValue(oItem, StringToInt(sUp), StringToInt(sDown),
											GetLocalInt(oStore, "DS_BLACKMARKET"), GetLocalFloat(oStore, "DS_BUY_MOD"));
											
					if (iItemCost > nMaxBuy)
						iItemCost = nMaxBuy;			
											
					if(!GetIdentified(oItem))	//If not identified hide the item name
					{	sItemName	= "<color=cyan>Unidentified (" + sStackSize + ")</color>";	}
		
					//Add the item into the store sell list
					AddListBoxRow(oPC, "dethia_shop", "store_items", IntToString(iRowID),
										"item_cost_cc=" + DS_ConvertCoinsToCopper(iItemCost) + ";"	+
										"item_cost_sc=" + DS_ConvertCoinsToSilver(iItemCost) + ";"	+
										"item_cost_gc=" + DS_ConvertCoinsToGold(iItemCost) + ";"	+
										"item_name=" + sItemName,
										"item_icon=" + sItemIcon,
										"0=" + IntToString(ObjectToInt(oItem)) + ";"	+
										"1=" + IntToString(iItemCost) + ";"	+
										"2=" + sStackSize + ";"				+
										"3=" + IntToString(iRowID), "");
					iRowID++;	//Increment the item ID
				}
				nCount++;
			}
			
			oItem	= GetNextItemInInventory(oPC);	//Get the next item
		}
		
		int nMaxPage = FloatToInt(IntToFloat(nCount)/IntToFloat(nPageLength));
		SetLocalInt(oPC, "shop_max_pages", nMaxPage);
		
	}

	else if(iEvent == 9)	//Player has selected some item and hit Identify button
	{//First we get the store and then its identify price
		if(!GetIsObjectValid(oItem) || GetIdentified(oItem))
		{	return;	}	//Skip invalid items

		int	iCost	= GetStoreIdentifyCost(oStore);
		//Check if PC has enough gold to ID the item
		if(DS_GetCoinsOnCreature(oPC) < iCost)
		{//If the player doesn't have enough currency let them know and end script
			FloatingTextStringOnCreature("You don't have enough coins friend.", oPC, FALSE);
			return;	
		}

		//If all checks out with the identify cost we identify the item in oPC's
		//inventory and update the sell-item listbox row with name and new price as
		//well as take the gold from oPC and add it to the store's current gold
		DS_TakeCoinsFromCreature(oPC, iCost);
		DS_UpdateStoreCurrency(oStore, oPC, iCost);
		SetIdentified(oItem, TRUE);
		int		iBlkMark	= GetLocalInt(oStore, "DS_BLACKMARKET");	//Blackmarket
		int		iItemCost	= DS_GetItemSellValue(oItem, StringToInt(sUp), StringToInt(sDown), iBlkMark);
		SetLocalGUIVariable(oPC, "dethia_shop", 4, IntToString(iItemCost));	//Update price
		ModifyListBoxRow(oPC, "dethia_shop", "store_items", sExtra,
								"item_cost_cc=" + DS_ConvertCoinsToCopper(iItemCost) + ";"	+
								"item_cost_sc=" + DS_ConvertCoinsToSilver(iItemCost) + ";"	+
								"item_cost_gc=" + DS_ConvertCoinsToGold(iItemCost) + ";"	+
								"item_name=" + GetName(oItem) + " (" + sStackSize + ")", "",
								"1=" + IntToString(iItemCost), "");
	}

	else if(iEvent == 10)	//Player clicked on "Buy" item, an item is being purchased
	{//First we check if the player has enough room in his inventory!!!
		int	iAmount	= StringToInt(sUp);
		int	iStack	= StringToInt(sStackSize);
		int	iPrice	= StringToInt(sItemCost)*iAmount;
		
		//Updating the stack size if it got stuck in memory
		//SpeakString("iStack "+IntToString(iStack)+" vs. item stack size "+IntToString(GetItemStackSize(oItem)), TALKVOLUME_SHOUT);
		if (iStack > GetItemStackSize(oItem)) {
			iStack =  GetItemStackSize(oItem);
		}
		
		if(DS_GetIsProjectile(oItem) && GetGoldPieceValue(oItem) <= 1)
		{	iPrice	/= iAmount;	}
		if(!GetIsObjectValid(oItem))	{	return;	}	//Skip invalid items
		/*else if(!DoesPCHaveFreeInvSlots(oPC))
		{//If the player doesn't have enough room let them know and end script
			FloatingTextStringOnCreature("Sorry, I don't think you can carry anymore things.", oPC);
			return;
		}*/
		else if(DS_GetCoinsOnCreature(oPC) < iPrice)
		{//If the player doesn't have enough currency let them know and end script
			FloatingTextStringOnCreature("You don't have enough coins friend.", oPC);
			return;	
		}
		else if(!GetInfiniteFlag(oItem) && iStack < iAmount)
		{//If the store's stock is less than player selected value let them know
			FloatingTextStringOnCreature("Terribly sorry but I don't have that much in stock.", oPC);
			return;	
		}
		else if(iAmount == 0)
		{//If a quantity of 0 was selected - obviously don't sell anything
			FloatingTextStringOnCreature("Nothing for nothing, free as the air we breath.", oPC);
			return;	
		}

		//If the player has enough gold we subtract it and add it to the store
		DS_TakeCoinsFromCreature(oPC, iPrice);
		DS_UpdateStoreCurrency(oStore, oPC, iPrice);
		//Next add the specified quantity of the item to oPC's inventory
		SetItemStackSize(oItem, iAmount, FALSE);	//Temporarily set oItem stack size
		CopyObject(oItem, GetLocation(oPC), oPC);	//Copy the item to oPC's inventory
		SetItemStackSize(oItem, iStack, FALSE);	//Return item stack size to normal

		if(!GetInfiniteFlag(oItem))
		{//Lastly we update the quantity for sale in the shop if it is not unlimited
			//SpeakString("Item is not infinite, update stack size to: ", TALKVOLUME_SHOUT);
			int nNewStack = iStack - iAmount;
			string sNewStack	= IntToString(nNewStack);
			//SpeakString(sNewStack, TALKVOLUME_SHOUT);
			if(nNewStack > 0)
			{//If any of the item is left we update its stack size in the shop and gui
				SetItemStackSize(oItem, nNewStack);
				ModifyListBoxRow(oPC, "dethia_shop", "store_items", sExtra,
										"item_name=" + GetName(oItem) + " (" + sNewStack + ")", "",
										"2=" + sNewStack, "");
			}
			else if(iStack - iAmount <= 0)
			{	//If 0 we remove the item from shop and gui
				DestroyObject(oItem);
				RemoveListBoxRow(oPC, "dethia_shop", "store_items", sExtra);
			}
		}
	}

	else if(iEvent == 11)	//Player clicked "Sell item" button, an item is being sold
	{//First we must check that the store BUYS the specified item and can afford to buy it
		//Disable the buy gui for 0.5 seconds to prevent it from being spammed
		SetGUIObjectDisabled(oPC, "dethia_shop", "sell_item_button", TRUE);
		DelayCommand(0.5f, SetGUIObjectDisabled(oPC, "dethia_shop", "sell_item_button", FALSE));
		string	sNoBuyList	= GetLocalString(oStore, "DS_WILL_NOT_BUY");
		string	sBuyOnlyLst	= GetLocalString(oStore, "DS_WILL_ONLY_BUY");
		int		iBlkMark	= GetLocalInt(oStore, "DS_BLACKMARKET");	//Blackmarket

		if(!GetIsObjectValid(oItem))	{	return;	}	//Skip invalid items
		else if(GetPlotFlag(oItem))
		{//If this is a plot item don't buy it
			FloatingTextStringOnCreature("Odds are you need that more than I do.", oPC);
			return;
		}
		else if(GetItemCursedFlag(oItem))
		{//If the item is cursed don't buy it
			FloatingTextStringOnCreature("I don't think I can take that of your hands.", oPC);
			return;
		}
		else if(GetStolenFlag(oItem) && !iBlkMark)
		{//If the item is stolen and the store doesn't buy them reject it
			FloatingTextStringOnCreature("I don't know where you got that but I don't want it.", oPC);
			return;
		}
		else if(DS_WillNotBuy(oItem, sNoBuyList) || !DS_WillOnlyBuy(oItem, sBuyOnlyLst))
		{//If item is in the "Will Not Buy" list, or is NOT in the "Will Only Buy" list skip it
			FloatingTextStringOnCreature("I don't deal in such wares try someone else.", oPC);
			return;
		}
		//If we passed all the preliminaries next make sure the store can afford the item
		int		iSellAmount		= StringToInt(sUp);
		int		iStackSize		= StringToInt(sStackSize);
		int		iSellPrice		= StringToInt(sItemCost)*iSellAmount;
		
		if(DS_GetIsProjectile(oItem) && GetGoldPieceValue(oItem) <= 1)
		{		iSellPrice		/= iSellAmount;	}
		
		int		iMaxBuyPrice	= GetStoreMaxBuyPrice(oStore);
		int		iStoreGold		= GetStoreGold(oStore);

		if(iMaxBuyPrice != -1 && iStoreGold < iMaxBuyPrice && iSellPrice > iStoreGold)
		{//Not enough gold in the store, let player know and end here
			FloatingTextStringOnCreature("Sorry but I don't have the coin to pay for that.", oPC);
			return;	
		}
		//If the player is selling nothing, nothing happens
		else if(iSellAmount <= 0)
		{	return;	}
		//If selling ammunition and the selected stack size is less than 99, don't buy it
		else if(DS_GetIsProjectile(oItem)&& iSellAmount < 99 && GetGoldPieceValue(oItem) <= 1)
		{//If player is selling less than 99 units of ammunition tell them it's a no no
			FloatingTextStringOnCreature("I prefer to purchase a full quiver of the stuff, otherwise it's not so good for business.", oPC);
			return;	
		}
		//If selling price exceeds the max buying price, set it to max buying price
		else if(iMaxBuyPrice != -1 && iSellPrice > iMaxBuyPrice)
		{	iSellPrice	= iMaxBuyPrice;	}

		//If the store has enough gold the item is sold.  First we transfer it from
		//the player's inventory to the store, and give the player his/her cash
		object	oSoldItem	= CopyObject(oItem, GetLocation(oStore), oStore);
		if(iSellAmount == iStackSize)
		{//If amount sold is equal to the stack size, destroy the whole lot
			DestroyObject(oItem);
			RemoveListBoxRow(oPC, "dethia_shop", "store_items", sExtra);
		}
		else
		{//If only a portion we update the stack sizes both in the store,
			//in the player's inventory and in the GUI
			iStackSize	-= iSellAmount;
			sStackSize	= IntToString(iStackSize);
			SetItemStackSize(oItem, iStackSize);
			SetItemStackSize(oSoldItem, iSellAmount);
			ModifyListBoxRow(oPC, "dethia_shop", "store_items", sExtra,
									"item_name=" + GetName(oItem) + " (" + sStackSize + ")", "",
									"2=" + sStackSize, "");
			//Update the local:5 variable which stores the item's total stack size
			SetLocalGUIVariable(oPC, "dethia_shop", 5, sStackSize);
			//Update the player selected stack size to the maximum remaining stock value
			SetGUIObjectText(oPC, "dethia_shop", "quantity", -1, sStackSize);
			SetLocalGUIVariable(oPC, "dethia_shop", 7, sStackSize);
		}
		//Give the player the mula and update the shop's gold
		DS_GiveCoinsToCreature(oPC, iSellPrice);
		DS_UpdateStoreCurrency(oStore, oPC, iSellPrice, FALSE);
		//Lastly save the sell-price on the item, it can be bought back at that price
		SetLocalInt(oSoldItem, "DS_SELL_PRICE", iSellPrice);
	}

	else if(iEvent == 12)	//Player is trying to steal a selected item
	{//First we check if the theft was successful
		if(!GetIsObjectValid(oItem))	{	return;	}	//Skip invalid items

		if(DS_GetIsTheftSuccessful(oPC, oStore, oItem, StringToInt(sItemCost), StringToInt(sUp)))
		{//If yes the player managed to steal the item, add it to their inventory
			SetItemStackSize(oItem, StringToInt(sUp), FALSE);
			//Add item to oPC's inventory and mark it as stolen
			SetStolenFlag(CopyObject(oItem, GetLocation(oPC), oPC), TRUE);
			SetItemStackSize(oItem, StringToInt(sStackSize), FALSE);

			if(!GetInfiniteFlag(oItem))
			{//Update the quantity for sale in the shop if it is not unlimited
				int	iStackSize	= StringToInt(sStackSize) - StringToInt(sUp);
				if(iStackSize > 0)
				{//Update the quantity if it is non-zero
					SetItemStackSize(oItem, iStackSize);
					ModifyListBoxRow(oPC, "dethia_shop", "store_items", sExtra,
										"item_name=" + GetName(oItem)	+
										" (" + IntToString(iStackSize) + ")",
										"", "2=" + IntToString(iStackSize), "");
				}
				else if(iStackSize <= 0)
				{//If 0 we remove the item from shop and gui
					DestroyObject(oItem);
					RemoveListBoxRow(oPC, "dethia_shop", "store_items", sExtra);
				}
			}
		}
		else	//Player failed to steal the item, time to punish them
		{//First set a local int on them labeling them as a thief for this shop
			SetLocalInt(oPC, "DS_THIEF_" + GetTag(oStore), TRUE);
			//Yell at the player
			FloatingTextStringOnCreature("Why you dirty scoundrel get out of here before I call the guards!", oPC);
			DS_CloseShop(oPC, oStore);	//Close the store
		}
	}

	else if(iEvent == 13)	//Update the player's coin values in the inventory
	{	DS_UpdateIventoryCoinValues(oPC);	}

	else if(iEvent == 14)	//Player is purchasing/selling an item using double click
	{//First we check if the event passed is a purchase or a sale
		if(sDown == "0")	//Player is buying an item
		{//We simply re-run this script with the appropriate parameters
			AddScriptParameterString("10");			//Buying event
			AddScriptParameterString(sItemID);		//Item's ID
			AddScriptParameterString(sItemCost);	//Item's cost
			AddScriptParameterString(sStackSize);	//Item's maximum stack size
			AddScriptParameterString(sStoreID);		//Store's ID
			//Next we set the stack size, which is 1 unless the item is ammunition
			if(DS_GetIsProjectile(oItem))
			{	AddScriptParameterString(IntToString(GetItemStackSize(oItem)));	}
			else	{	AddScriptParameterString("1");	}
			AddScriptParameterString("");			//sDown is passed a blank value
			AddScriptParameterString(sUp);			//Item listbox row ID
			ExecuteScriptEnhanced("gui_dethia_shop", oPC);
		}
		else if(sDown == "1")	//Player is selling an item
		{//We simply re-run this script with the appropriate parameters
			AddScriptParameterString("11");			//Seling event
			AddScriptParameterString(sItemID);		//Item's ID
			AddScriptParameterString(sItemCost);	//Item's cost
			AddScriptParameterString(sStackSize);	//Item's maximum stack size
			AddScriptParameterString(sStoreID);		//Store's ID
			//Next we set the stack size, which is 1 unless the item is ammunition
			if(DS_GetIsProjectile(oItem))
			{	AddScriptParameterString(IntToString(GetItemStackSize(oItem)));	}
			else	{	AddScriptParameterString("1");	}			
			AddScriptParameterString("");			//sDown is passed a blank value
			AddScriptParameterString(sUp);			//Item listbox row ID
			ExecuteScriptEnhanced("gui_dethia_shop", oPC);
		}	
	}
	else if (iEvent == 16) { //Player clicked the last page button
		int nPage = StringToInt(sExtra);
		SendMessageToPC(oPC, "Clicked last page button, current page: "+sExtra);
		if (nPage <= 0)
			nPage = 0;
		else
			nPage -= 1;
		SetLocalGUIVariable(oPC, "dethia_shop", 9, IntToString(nPage));
		
		//rerun sell tab generation
		AddScriptParameterString("8");
		AddScriptParameterString("");
		AddScriptParameterString("");
		AddScriptParameterString("");
		AddScriptParameterString(sStoreID);
		AddScriptParameterString(sUp);
		AddScriptParameterString(sDown);
		AddScriptParameterString(IntToString(nPage));
		ExecuteScriptEnhanced("gui_dethia_shop", oPC);
		
	} 
	else if (iEvent == 17) { //Player clicked the next page button
		int nPage = StringToInt(sExtra);
		int nMaxPage = GetLocalInt(oPC, "shop_max_pages");
		SendMessageToPC(oPC, "Clicked next page button, current page: "+sExtra);
		if (nPage >= nMaxPage)
			nPage = (nMaxPage-1);
		else
			nPage += 1;
		SetLocalGUIVariable(oPC, "dethia_shop", 9, IntToString(nPage));
		
		//rerun sell tab generation
		AddScriptParameterString("8");
		AddScriptParameterString("");
		AddScriptParameterString("");
		AddScriptParameterString("");
		AddScriptParameterString(sStoreID);
		AddScriptParameterString(sUp);
		AddScriptParameterString(sDown);
		AddScriptParameterString(IntToString(nPage));
		ExecuteScriptEnhanced("gui_dethia_shop", oPC);

	}
/*The below section does not work at all for various reasons.  If I am up to it sometime
I will re-do this entire segment of the barter window (trading coins) but that is for another time
	else if(iEvent == 15)	//Player is trading some cash, manage selections
	{//First we check what sub-event was passed to the script
		if(sItemCost == "0")	//Populate the max field values
		{//Get the amount of gold the player has and store it in local:100
			int	iCoins	= DS_GetCoinsOnCreature(oPC);
			SetLocalGUIVariable(oPC, "splitgold.xml", 100, IntToString(iCoins));
			//Store in 101-103 the currently held coin values by the player
			SetLocalGUIVariable(oPC, "splitgold.xml", 101, DS_ConvertCoinsToGold(iCoins));
			SetLocalGUIVariable(oPC, "splitgold.xml", 102, DS_ConvertCoinsToSilver(iCoins));
			SetLocalGUIVariable(oPC, "splitgold.xml", 103, DS_ConvertCoinsToCopper(iCoins));
			//The below segment doesn't work for god knows what reason ;/
			//SetGUIObjectText(oPC, "splitgold.xml", "pcc_gc", -1, DS_ConvertCoinsToGold(iCoins));
			//SetGUIObjectText(oPC, "splitgold.xml", "pcc_sc", -1, DS_ConvertCoinsToSilver(iCoins));
			//SetGUIObjectText(oPC, "splitgold.xml", "pcc_cc", -1, DS_ConvertCoinsToCopper(iCoins));
		}
		else if(sItemCost == "1")	//We set the trade value to the selected value
		{//First get the player's total gold then convert each selected value
			int iTotal	= DS_GetCoinsOnCreature(oPC);//StringToInt(sStackSize);	//Total amount of coins
			//First gold
			int	iGold	= StringToInt(DS_ConvertCoinsToGold(iTotal));
				iGold	= FloatToInt((StringToFloat(sUp)/100.0f)*iGold);
			SetLocalGUIVariable(oPC, "splitgold.xml", 107, IntToString(iGold));
			//SetGUIObjectText(oPC, "splitgold.xml", "pcs_gc", -1, IntToString(iGold));
				iGold	*= AuC;
			//Next silver
			int	iSilver	= StringToInt(DS_ConvertCoinsToSilver(iTotal));
				iSilver	= FloatToInt((StringToFloat(sDown)/100.0f)*iSilver);
			SetLocalGUIVariable(oPC, "splitgold.xml", 108, IntToString(iSilver));
			//SetGUIObjectText(oPC, "splitgold.xml", "pcs_sc", -1, IntToString(iSilver));
				iSilver *= AgC;
			//Next copper
			int	iCopper	= StringToInt(DS_ConvertCoinsToCopper(iTotal));
				iCopper	= FloatToInt((StringToFloat(sExtra)/100.0f)*iCopper);
			SetLocalGUIVariable(oPC, "splitgold.xml", 109, IntToString(iCopper));
			//SetGUIObjectText(oPC, "splitgold.xml", "pcs_cc", -1, IntToString(iCopper));
				iCopper	*= CuC;
			//Lastly update the player input value
			SetLocalGUIVariable(oPC, "splitgold.xml", 110, IntToString(iGold + iSilver + iCopper));
			//SetGUIObjectText(oPC, "splitgold.xml", "GoldAmountEDIT", -1, IntToString(iGold + iSilver + iCopper));
		}
	}
*/

	else if(iEvent == 99)	//The store is being closed
	{	DS_CloseShop(oPC, oStore);	}
}