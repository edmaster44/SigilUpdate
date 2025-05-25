

#include "nwnx_craft_system"
//************************************************
//THIS IS THE REAL APPEARANCE CHANGER CODE
//************************************************
//Timestamp
string ClangStamp()
{
	int iMillisecond = GetTimeMillisecond();
	int iSecond  = GetTimeSecond();
	int iMinute  = GetTimeMinute();
	int iHour    = GetTimeHour();
	int iDay     = GetCalendarDay();
	int iMonth   = GetCalendarMonth();
	int iYear    = GetCalendarYear();
    
	return IntToString(iMillisecond) + IntToString(iSecond) + IntToString(iMinute) + IntToString(iHour) + IntToString(iDay) + IntToString(iMonth) + IntToString(iYear);
}

int StartingConditional(object oPC, int iCondition, int iInventorySlot, int iVisualType)
{
	object oInventoryItem = GetItemInSlot(iInventorySlot, oPC);
	
	// For XP_CRAFT_CONDITION_HAS_ARMOR_PIECE, we run after the craft system has
	// initialized for an item.  The 'inventory slot' argument is in this case
	// actually the armor piece mask of the armor piece we want to check if is
	// editable.

	if (iCondition != XP_CRAFT_CONDITION_HAS_ARMOR_PIECE) oInventoryItem = GetItemInSlot(iInventorySlot, oPC);
	int bReturn = FALSE;
	switch(iCondition) //edit nwnx_craft_system in order to code your own specifications 
	{
		case XP_CRAFT_CONDITION_ITEM_IN_SLOT : bReturn = (oInventoryItem!=OBJECT_INVALID); break;
		case XP_CRAFT_CONDITION_IS_CRAFTABLE : bReturn = XPCraft_GetIsCraftable(oPC, oInventoryItem); break;
		case XP_CRAFT_CONDITION_CHANGES_ALLOWED : bReturn = XPCraft_GetChangesAllowed(oPC, oInventoryItem); break;
		case XP_CRAFT_CONDITION_IS_MULTI_MODELPART: //since this list is supposably not subjet to changes, i coded it here with a case statement
			switch(GetBaseItemType(oInventoryItem)) //list of base item types that got multi model part ("_b" and "_c" .mdb)
			{			
				case BASE_ITEM_BATTLEAXE :
				case BASE_ITEM_BASTARDSWORD :
				case BASE_ITEM_WARMACE :
				case BASE_ITEM_FALCHION :
				case BASE_ITEM_LIGHTFLAIL :
				case BASE_ITEM_FLAIL :
				case BASE_ITEM_GREATAXE :
				case BASE_ITEM_GREATSWORD :
				case BASE_ITEM_HALBERD :
				case BASE_ITEM_KATANA :
				case BASE_ITEM_LIGHTHAMMER :
				case 87: // maul
				case BASE_ITEM_LONGSWORD :
				case BASE_ITEM_MACE :
				case BASE_ITEM_MORNINGSTAR :
				case BASE_ITEM_RAPIER :
				case BASE_ITEM_SCIMITAR :
				case BASE_ITEM_SCYTHE :
				case BASE_ITEM_SHORTSWORD :
				case BASE_ITEM_WARHAMMER :
				case 111:
				case 202:
				case 50:
				case 45:
				case 96:
				case 97:
					bReturn = TRUE;
					break;
			}		
			break;
		case XP_CRAFT_CONDITION_HAS_VISUAL_TYPE :
			//conditions here are mainly exemples of restrictions you can add in this script
			// in order to control what's being done by your players.
			//currently only dealing with special behaviours on Armor/Clothes, you can extend the system to helms and boots if you wish
			
			if(GetLocalInt(oPC,"XC_INVENT_SLOT")==1) //item is an armor/clothe 
			{
				bReturn = (FindSubString(GetLocalString(GetModule(),GetLocalString(oPC,"XC_AVT_LISTNAME")),"#" + IntToString(iVisualType) + "#") !=-1);
			}
			else bReturn = (FindSubString(GetLocalString(GetModule(),GetLocalString(oPC,"XC_AVT_LISTNAME")),"#" + IntToString(iVisualType) + "#") !=-1);
			break;
		
		// Does the edited item have this (default) auxiliary armor piece?
		case XP_CRAFT_CONDITION_HAS_ARMOR_PIECE: bReturn = (XPCraft_GetHasArmorPiece(oPC,iInventorySlot) ? TRUE : FALSE); break;
	}
	return bReturn;
}

void InitializeItem(object oPC, int bStore, int iInventorySlot, string sRoadMap)
{
	//Storage of the item wihtin the bioware database
	if(bStore==1) //storing a persistant object is quite a time consuming process (it creates 3 files.... ) so we try not to do it if it's not necessary
	{
		object oItemToCraft = GetItemInSlot(iInventorySlot,oPC);
		if (oItemToCraft!=OBJECT_INVALID) //never too carefull
		{	
			XPCraft_StoreItemToCraft(oPC,oItemToCraft);
			SetLocalInt(oPC,"XC_INVENT_SLOT",iInventorySlot);
			SetLocalObject(oPC,"XC_ITEM_TO_CRAFT", oItemToCraft);
			object oSavedItem = CopyItem(oItemToCraft,GetLocalObject(GetModule(),"XC_HIDDEN_CONTAINER"),TRUE);
			SetLocalObject(GetModule(),"XC_TEMP_" + XPCraft_GetPCID(oPC),oSavedItem);
			
			//cryptc: Added "timestamp" variable to be unique identifier accepting that its same item to be modified.
			string tso = ClangStamp();
			SetLocalString(oPC,"TSO",tso);
			SetLocalString(oItemToCraft,"TSO",tso);
			//SendMessageToPC(oPC, "Item stamp set.");
			
			// Figure out which armor pieces are part of this items armor set in case
			// we were to edit it.
			XPCraft_InitArmorSetMask(oPC);
		}
		//else XPCraft_Debug(oPC,"No Item In Slot : " + IntToString(iInventorySlot)); //todo : there's surely things to do in this specific case... 		
		return;		
	}

	//initialisation of local vars
	SetLocalString(oPC,"XC_ROAD_MAP",sRoadMap);	
	string sSubAction = GetStringLeft(sRoadMap,2);
	if(sSubAction =="Va") XPCraft_InitVariationValues(oPC); //initialising the Variation 
	else if(sSubAction =="Ar") XPCraft_InitArmorVisualTypeValues(oPC); //initialising the ArmorVisualType 
	else if(sSubAction =="AC") XPCraft_InitItemPartValues(oPC, sRoadMap + "|Accessory"); //initialising an ArmorPart 
	else if(sSubAction == "Mo")	XPCraft_InitItemPartValues(oPC, sRoadMap); //initialising a Weapon or Shield ModelPart
}

void RemovePolymorph(object oPC)
{
	effect eEffect = GetFirstEffect(oPC);
	while (GetIsEffectValid(eEffect))
	{
		if (GetEffectType(eEffect) == EFFECT_TYPE_POLYMORPH) RemoveEffect(oPC, eEffect);
	    eEffect = GetNextEffect(oPC);
	}
}

void CraftAction(object oPC, int iAction, int iAvtValue)
{
	//Check for the object to craft
	int iInventorySlot = GetLocalInt(oPC,"XC_INVENT_SLOT");
	object oItemToCraft = GetItemInSlot(iInventorySlot,oPC);

	//cryptc: this is where to check for identical TSO.
	if(	GetLocalString(oPC,"TSO") != GetLocalString(oItemToCraft,"TSO")) {
		//XPCraft_Debug(oPC,"No Item In Slot : " + IntToString(iInventorySlot)+ "- restoring last unchanged Item");
		//SendMessageToPC(oPC, "Not the same item!");
		XPCraft_ActionCancelChanges(oPC);		
		return;
	}//END
			
	if((oItemToCraft==OBJECT_INVALID) && (iAction!=XP_CRAFT_ACTION_EXIT))
	{
		//XPCraft_Debug(oPC,"No Item In Slot : " + IntToString(iInventorySlot)+ "- restoring last unchanged Item");
		XPCraft_ActionCancelChanges(oPC);		
		return;
	}//END
	
	
	//ACTION MANGEMENT
	//since we can't declare a variable into a case statement, we do it here though it won't be used in every case.
	string sSubAction =  GetStringLeft( GetLocalString(oPC,"XC_ROAD_MAP"),2);
	//sub action we be like "Va" for Variation, "Ar" for ArmorVisualType, "AC" for ArmorParts and "Mo" for ModelParts 
	
	switch(iAction)
	{		
		case XP_CRAFT_ACTION_EXIT ://Terminate the craft dialog
			//XPCraft_Debug(oPC,"Craft Session Ended");
			XPCraft_CleanLocals(oPC);
			break;
		
		case XP_CRAFT_ACTION_VALIDATE ://Confirm the changes made 
			XPCraft_OnChangesConfirmed(oPC, oItemToCraft);
			XPCraft_CleanLocals(oPC);
			//XPCraft_Debug(oPC,"Changes Confirmed"); 
			break;
			
		case XP_CRAFT_ACTION_CANCEL ://cancel the changes made 
			XPCraft_ActionCancelChanges(oPC);
			XPCraft_ActionSelectArmorPiece(oPC, 0); // Unselect the current armor piece if we were editing one.
			XPCraft_CleanLocals(oPC);
			//XPCraft_Debug(oPC,"Changes Cancelled"); 
			break;
			
		case XP_CRAFT_ACTION_TINT_1 ://change colors (without a break once it enters the statement
		case XP_CRAFT_ACTION_TINT_2 ://it'll execute whatever comes after ;) )
		case XP_CRAFT_ACTION_TINT_3 :
			SetLocalInt(oPC,"XC_ACTION_TINT",iAction);
			DisplayGuiScreen(oPC,"SCREEN_COLOR_TLS",TRUE,"elechos_colortls.xml");
			break;
		
		//sets a new ArmorVisualType
		//previously using the same Next/Previous system  than for Vairations and ArmorPArts... ,
		//I've changed for this approach in order to make it more readeable for the end user
		//since AVTypes are number that truly means something (unlike Variations, ArmorParts or ModelParts)
		case XP_CRAFT_ACTION_SET_AVT : 
			SetLocalObject(oPC,"XC_ITEM_TO_CRAFT", XPCraft_ActionChangeArmorVisualType(oPC, oItemToCraft, iAvtValue)); 
			break;
			
		// Choose an armor piece in this items armor set to edit.
		case XP_CRAFT_ACTION_SELECT_ARMOR_PIECE: XPCraft_ActionSelectArmorPiece(oPC, iAvtValue); break;
		
		//any other action (next or previous, since First and Last weren't displayed in the dialog)
		default:
			if(sSubAction == "Va") SetLocalObject(oPC,"XC_ITEM_TO_CRAFT", XPCraft_ActionChangeVariation(oPC, oItemToCraft, iAction));
			else if(sSubAction == "AC")	SetLocalObject(oPC,"XC_ITEM_TO_CRAFT", XPCraft_ActionChangeArmorPart(oPC, oItemToCraft, iAction));
			else if(sSubAction == "Mo")	SetLocalObject(oPC,"XC_ITEM_TO_CRAFT", XPCraft_ActionChangeModelPart(oPC, oItemToCraft, iAction));	
	}
}

void ColotTint(object oPC, int iTeinte, int iLuminosite, int iSaturation)
{	
	// Make sure that the item still exists so that the slot zero item isn't
	// destroyed when trying to change colors after backing out of the menu.
	if (GetLocalObject(oPC, "XC_ITEM_TO_CRAFT") == OBJECT_INVALID)
	{
		//XPCraft_Debug(oPC, "No item selected for color change, aborted.");
		return;
	}
	
	struct strTint strMyTint = XPCraft_HLSToTintStruct(iTeinte, iLuminosite, iSaturation);
	int iNewColorValue =  XPCraft_strTintToInt(strMyTint);
	SetLocalObject(oPC, "XC_ITEM_TO_CRAFT", XPCraft_ActionChangeColor(oPC, iNewColorValue));		
}

void RewindUI(object oPC, string sSCREEN, int nSTAGE, int nSLOT)
{
	string sROAD = GetLocalString(oPC, "APPEAR_ROADMAP");
	object oITEM = GetItemInSlot(nSLOT, oPC);
	string sNAME = GetName(oITEM);
	int nEXTRA = GetLocalInt(oPC, "APPEAR_EXTRA"); //Parts (1) or Defaults (2)
	int nRETURN = GetLocalInt(oPC, "APPEAR_RETURN"); //To know that if we are using Confirm/Cancel or Return
	SetGUIObjectHidden(oPC, sSCREEN, "EQUIPMENT_PANE", TRUE);
	SetGUIObjectHidden(oPC, sSCREEN, "CHOICE_PANE", TRUE);
	SetGUIObjectHidden(oPC, sSCREEN, "VARIATION_PANE", TRUE);
	SetGUIObjectHidden(oPC, sSCREEN, "STYLE_PANE", TRUE);
	SetGUIObjectHidden(oPC, sSCREEN, "COLORS_PANE", TRUE);
	SetGUIObjectHidden(oPC, sSCREEN, "PARTS_PANE", TRUE);
	SetGUIObjectHidden(oPC, sSCREEN, "DEFAULT_PANE", TRUE);
	SetLocalGUIVariable(oPC, sSCREEN, 1, "0");
	switch (nSTAGE)
	{
		case 1: //The Choice Pane
			SetLocalString(oPC, "APPEAR_ITEMTEXT", sNAME);
			SetGUIObjectHidden(oPC, sSCREEN, "CHOICE_PANE", FALSE);
			SetGUIObjectHidden(oPC, sSCREEN, "ARMOR_PARTS", TRUE);
			SetGUIObjectHidden(oPC, sSCREEN, "DEFAULT_PIECES", TRUE);
			SetGUIObjectHidden(oPC, sSCREEN, "MODEL_1", TRUE);
			SetGUIObjectHidden(oPC, sSCREEN, "MODEL_2", TRUE);
			SetGUIObjectHidden(oPC, sSCREEN, "MODEL_3", TRUE);
			SetGUIObjectHidden(oPC, sSCREEN, "VARIATION", FALSE);
			SetGUIObjectHidden(oPC, sSCREEN, "STYLE", FALSE);
			if ((nEXTRA == 0)||(nRETURN == 1)) InitializeItem(oPC, 1, nSLOT, "");
			if (nSLOT == INVENTORY_SLOT_CHEST)
			{		
				if (nEXTRA == 1) //Parts
				{
					SetLocalString(oPC, "APPEAR_ITEMTEXT", sNAME+" > Parts > "+sROAD);
					SetLocalGUIVariable(oPC, sSCREEN, 1, "2");
					SetGUIObjectHidden(oPC, sSCREEN, "STYLE", TRUE);
					DelayCommand(0.1, InitializeItem(oPC, 0, 1, sROAD));
				}
				else if (nEXTRA == 2) //Default
				{
					SetLocalString(oPC, "APPEAR_ITEMTEXT", sNAME+" > Default > "+sROAD);
					SetLocalGUIVariable(oPC, sSCREEN, 1, "3");
					DelayCommand(0.1, CraftAction(oPC, 11, GetLocalInt(oPC, "APPEAR_DEFAULT")));
				}
				else
				{
					SetGUIObjectHidden(oPC, sSCREEN, "ARMOR_PARTS", FALSE);
					SetGUIObjectHidden(oPC, sSCREEN, "DEFAULT_PIECES", FALSE);
				}
			}
			else if ((nSLOT == INVENTORY_SLOT_RIGHTHAND)||(nSLOT == INVENTORY_SLOT_LEFTHAND))
			{
				SetGUIObjectHidden(oPC, sSCREEN, "VARIATION", TRUE);
				SetGUIObjectHidden(oPC, sSCREEN, "STYLE", TRUE);
				SetGUIObjectHidden(oPC, sSCREEN, "MODEL_1", FALSE);
				SetGUIObjectHidden(oPC, sSCREEN, "MODEL_2", FALSE);
				SetGUIObjectHidden(oPC, sSCREEN, "MODEL_3", FALSE);
			}
			break;
		case 2: //The Parts Pane
			SetLocalString(oPC, "APPEAR_ITEMTEXT", sNAME+" > Parts");
			SetLocalInt(oPC, "APPEAR_EXTRA", 0);
			SetLocalGUIVariable(oPC, sSCREEN, 1, "0");
			SetGUIObjectHidden(oPC, sSCREEN, "PARTS_PANE", FALSE);
			DelayCommand(0.1, InitializeItem(oPC, 1, 1, ""));
			break;
		case 3://The Default Pane
			SetLocalString(oPC, "APPEAR_ITEMTEXT", sNAME+" > Default");
			SetLocalInt(oPC, "APPEAR_EXTRA", 0);
			SetLocalGUIVariable(oPC, sSCREEN, 1, "0");
			SetGUIObjectHidden(oPC, sSCREEN, "DEFAULT_PANE", FALSE);
			DelayCommand(0.1, InitializeItem(oPC, 1, 1, ""));
			break;
		default: 
			RemovePolymorph(oPC); // The Equipment Pane
			SetGUIObjectHidden(oPC, sSCREEN, "EQUIPMENT_PANE", FALSE);
			SetLocalString(oPC, "APPEAR_ITEMTEXT", "");
			SetLocalInt(oPC, "APPEARENCE_SLOT_TOMOD", -1);
			SetLocalGUIVariable(oPC, sSCREEN, 1, "0");
			XPCraft_CleanLocals(oPC);
	}
	string sTEXT = GetLocalString(oPC, "APPEAR_ITEMTEXT");
	DelayCommand(0.0f, SetGUIObjectText(oPC, sSCREEN, "ITEM_NAME", -1, sTEXT));
}

void main(string sCOMMAND, string sINPUT)
{
	object oPC = OBJECT_SELF;
	string sSCREEN = "SCREEN_APPEARENCE_CHANGER";
	
	if (sCOMMAND == "START")
	{
		RewindUI(oPC, sSCREEN, 0, 0);
		SetLocalInt(oPC, "APPEARCHANGE_ANTIEXPLOIT", 0);
		return;
	}
	else if (sCOMMAND == "EXIT")
	{
		DeleteLocalInt(oPC, "APPEARENCE_SLOT_TOMOD");
		DeleteLocalInt(oPC, "APPEARCHANGE_ANTIEXPLOIT");
		DeleteLocalInt(oPC, "APPEAR_EXTRA");
		DeleteLocalInt(oPC, "APPEAR_RETURN");
		DeleteLocalString(oPC, "APPEAR_ROADMAP");
		DeleteLocalString(oPC, "APPEAR_ITEMTEXT");
		DeleteLocalString(oPC, "APPEAR_DEFAULT");
		XPCraft_ActionCancelChanges(oPC);
		CloseGUIScreen(oPC, sSCREEN);
		return;
	}
	
	if (GetLocalInt(oPC, "APPEARCHANGE_ANTIEXPLOIT") == 1) return; //This is to prevent duplication
	
	SetLocalInt(oPC, "APPEARCHANGE_ANTIEXPLOIT", 1);
	SetLocalInt(oPC, "APPEAR_RETURN", 0);
	
	int nSLOT = GetLocalInt(oPC, "APPEARENCE_SLOT_TOMOD");
	string sTEXT = GetLocalString(oPC, "APPEAR_ITEMTEXT");
	int nCOMMAND = StringToInt(sCOMMAND);
	int nINPUT = StringToInt(sINPUT);
	object oITEM = GetItemInSlot(nINPUT, oPC);
	
	switch (nCOMMAND)
	{
		case 1: //EQUIP
			if (oITEM == OBJECT_INVALID) SendMessageToPC(oPC, "No item found in that slot.");
			else if (StartingConditional(oPC, 1, nINPUT, 0) == FALSE) SendMessageToPC(oPC, "You're not allowed to modify this item.");
			else
			{
				SetGUIObjectText(oPC, sSCREEN, "ITEM_NAME", -1, GetName(oITEM));
				SetLocalInt(oPC, "APPEARENCE_SLOT_TOMOD", nINPUT);
				RewindUI(oPC, sSCREEN, 1, nINPUT);
			}
			break;
		case 2: //SELECT
			SetGUIObjectHidden(oPC, sSCREEN, "CHOICE_PANE", TRUE);
			SetGUIObjectHidden(oPC, sSCREEN, "VARIATION_PANE", TRUE);
			SetGUIObjectHidden(oPC, sSCREEN, "STYLE_PANE", TRUE);
			SetGUIObjectHidden(oPC, sSCREEN, "COLORS_PANE", TRUE);
			SetGUIObjectHidden(oPC, sSCREEN, "PARTS_PANE", TRUE);
			SetGUIObjectHidden(oPC, sSCREEN, "DEFAULT_PANE", TRUE);
			switch (nINPUT)
			{
				case 1: //VARIATION
					SetGUIObjectText(oPC, sSCREEN, "ITEM_NAME", -1, sTEXT + " > Variation");
					if (GetLocalInt(oPC, "APPEAR_EXTRA")!=1) InitializeItem(oPC, 0, 0, "Variation"); //Exclude Armor Parts
					SetGUIObjectHidden(oPC, sSCREEN, "VARIATION_PANE", FALSE);
					break;
				case 2: //STYLE
					SetGUIObjectText(oPC, sSCREEN, "ITEM_NAME", -1, sTEXT + " > Style");
					InitializeItem(oPC, 0, 0, "ArmorVisualType");
					SetGUIObjectHidden(oPC, sSCREEN, "STYLE_PANE", FALSE);
					break;
				case 3: //COLORS
					SetGUIObjectText(oPC, sSCREEN, "ITEM_NAME", -1, sTEXT + " > Colors");
					SetGUIObjectHidden(oPC, sSCREEN, "COLORS_PANE", FALSE);
					break;
				case 4: //PARTS
					SetGUIObjectText(oPC, sSCREEN, "ITEM_NAME", -1, sTEXT + " > Parts");
					SetGUIObjectHidden(oPC, sSCREEN, "PARTS_PANE", FALSE);
					break;
				case 5: //DEFAULT
					SetGUIObjectText(oPC, sSCREEN, "ITEM_NAME", -1, sTEXT + " > Default");
					SetGUIObjectHidden(oPC, sSCREEN, "DEFAULT_PANE", FALSE);
					break;
				default: //WEAPON MODELS
					SetGUIObjectText(oPC, sSCREEN, "ITEM_NAME", -1, sTEXT + " > "+ sINPUT);
					InitializeItem(oPC, 0, nSLOT, sINPUT);
					SetGUIObjectHidden(oPC, sSCREEN, "VARIATION_PANE", FALSE);
			}
			break;
		case 3: //PARTS
			SetLocalInt(oPC, "APPEAR_EXTRA", 1);
			SetLocalString(oPC, "APPEAR_ROADMAP", sINPUT);
			RewindUI(oPC, sSCREEN, 1, 1);
			break;
		case 4: //STYLE
			if (StartingConditional(oPC, 4, 0, nINPUT) == FALSE) SendMessageToPC(oPC, "This item cannot be changed to that style.");
			else CraftAction(oPC, 8, nINPUT);
			break;
		case 5: //DEFAULT
			if (StartingConditional(oPC, 6, nINPUT, 0) == FALSE) SendMessageToPC(oPC, "You cannot modify this default piece.");
			else
			{
				switch (nINPUT)
				{
					case 1: SetLocalString(oPC, "APPEAR_ROADMAP", " Helm"); break;
					case 2: SetLocalString(oPC, "APPEAR_ROADMAP", " Gloves"); break;
					case 4: SetLocalString(oPC, "APPEAR_ROADMAP", " Boots"); break;
					case 8: SetLocalString(oPC, "APPEAR_ROADMAP", " Belt"); break;
					case 16: SetLocalString(oPC, "APPEAR_ROADMAP", " Cloak"); break;
				}
				SetLocalInt(oPC, "APPEAR_DEFAULT", nINPUT);
				SetLocalInt(oPC, "APPEAR_EXTRA", 2);
				RewindUI(oPC, sSCREEN, 1, 1);
			}
			break;
		case 6: //COLOR
			CraftAction(oPC, nINPUT, 0);
			break;
		case 7: //FIND
			if (sINPUT == "NEXT") CraftAction(oPC, 6, 0);
			else if (sINPUT == "PREVIOUS") CraftAction(oPC, 5, 0);
			break;
		case 8: //CONFIRM
			if (StartingConditional(oPC, 5, nSLOT, 0) == FALSE) SendMessageToPC(oPC, "You're not allowed to modify this item.");
			else
			{
				SetLocalInt(oPC, "APPEAR_RETURN", 1);
				CraftAction(oPC, 9, 0);
				DelayCommand(0.1, RewindUI(oPC, sSCREEN, nINPUT, nSLOT));
			}
			break;
		case 9: //CANCEL
			SetLocalInt(oPC, "APPEAR_RETURN", 1);
			CraftAction(oPC, 0, 0);
			DelayCommand(0.1, RewindUI(oPC, sSCREEN, nINPUT, nSLOT));
			break;
	}
	DelayCommand(0.0f, SetLocalInt(oPC, "APPEARCHANGE_ANTIEXPLOIT", 0));
}