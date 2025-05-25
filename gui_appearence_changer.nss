

#include "nwnx_craft_system"
#include "ps_inc_advscript"

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
				case BASE_ITEM_LONGSWORD :
				case BASE_ITEM_MACE :
				case BASE_ITEM_MORNINGSTAR :
				case BASE_ITEM_RAPIER :
				case BASE_ITEM_SCIMITAR :
				case BASE_ITEM_SCYTHE :
				case BASE_ITEM_SHORTSWORD :
				case BASE_ITEM_WARHAMMER :
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
				if((XP_CRAFT_AVT_DISALLOW_NAKED_BODY==1) && (iVisualType ==10))	bReturn = FALSE; //no naked avt allowed	
				else if(XP_CRAFT_AVT_LIGHT_AGAINST_METAL==1) //group "light" material appearanes against "metal-like" appearances
				{
					int iAVT_CurrentValue = GetLocalInt(oPC,"XC_AVT_VALUE");
					switch(iAVT_CurrentValue)
					{
						case 0 : //Cloth
						case 1 : //Padded Cloth
						case 2 : //Leather
						case 3 : //Studded Leather
						case 9 : //Hide 
						case 10: //Naked
							//material group "light"
							switch(iVisualType)
							{
								case 0 : //Cloth
								case 1 : //Padded Cloth
								case 2 : //Leather
								case 3 : //Studded Leather
								case 9 : //Hide 
								case 10: //Naked
									//same material group : "light" -> do the condition as usual, using the lists
									bReturn = (FindSubString(GetLocalString(GetModule(),GetLocalString(oPC,"XC_AVT_LISTNAME")),"#" + IntToString(iVisualType) + "#") !=-1);
									break;
									
								case 4 : //Chainmail
								case 5 : //Scale
								case 6 : //Banded
								case 7 : //Half-Plate
								case 8 : //Full-Plate
								case 16 : //DMCB
								case 17 : //Acme
									//different material group : "metal-like" against "light"
									bReturn = FALSE;
									break;
							}							
							break;
							
						case 4 : //Chainmail
						case 5 : //Scale
						case 6 : //Banded
						case 7 : //Half-Plate
						case 8 : //Full-Plate
						case 16 : //DMCB
						case 17 : //Acme
							//material group "metal-like" 
							switch(iVisualType)
							{
								case 0 : //Cloth
								case 1 : //Padded Cloth
								case 2 : //Leather
								case 3 : //Studded Leather
								case 9 : //Hide 
								case 10: //Naked
									//different material group : "light" angainst "metal-like" 
 									bReturn = FALSE;
									break;
									
								case 4 : //Chainmail
								case 5 : //Scale
								case 6 : //Banded
								case 7 : //Half-Plate
								case 8 : //Full-Plate
								case 16 : //DMCB
								case 17 : //Acme
									//same material group : "metal-like" -> do the condition as usual, using the lists
									bReturn = (FindSubString(GetLocalString(GetModule(),GetLocalString(oPC,"XC_AVT_LISTNAME")),"#" + IntToString(iVisualType) + "#") !=-1);
									break;
							}								
							break;
					}					
				
				}
				else bReturn = (FindSubString(GetLocalString(GetModule(),GetLocalString(oPC,"XC_AVT_LISTNAME")),"#" + IntToString(iVisualType) + "#") !=-1); 
				//no special switch to care about, do the condition as usual, using the lists
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
			SendMessageToPC(oPC, "Marking the item.");
			
			object oSavedItem = CopyItem(oItemToCraft,GetLocalObject(GetModule(),"XC_HIDDEN_CONTAINER"),TRUE);
			SetLocalObject(GetModule(),"XC_TEMP_" + XPCraft_GetPCID(oPC),oSavedItem);
			//cryptc: Added "timestamp" variable to be unique identifier accepting that its same item to be modified.
			string tso = TimeStamp();
			SetLocalString(oPC,"TSO",tso);
			SetLocalString(oItemToCraft,"TSO",tso);
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
		SendMessageToPC(oPC, "This is not the same item!");
		//XPCraft_Debug(oPC,"No Item In Slot : " + IntToString(iInventorySlot)+ "- restoring last unchanged Item");
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
		case XP_CRAFT_ACTION_SET_AVT : SetLocalObject(oPC,"XC_ITEM_TO_CRAFT", XPCraft_ActionChangeArmorVisualType(oPC, oItemToCraft, iAvtValue)); break;
			
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
	SetGUIObjectHidden(oPC, sSCREEN, "EQUIPMENT_PANE", TRUE);
	SetGUIObjectHidden(oPC, sSCREEN, "CHOICE_PANE", TRUE);
	SetGUIObjectHidden(oPC, sSCREEN, "VARIATION_PANE", TRUE);
	SetGUIObjectHidden(oPC, sSCREEN, "STYLE_PANE", TRUE);
	SetGUIObjectHidden(oPC, sSCREEN, "COLORS_PANE", TRUE);
	SetGUIObjectHidden(oPC, sSCREEN, "PARTS_PANE", TRUE);
	SetGUIObjectHidden(oPC, sSCREEN, "DEFAULT_PANE", TRUE);
	switch (nSTAGE)
	{
		case 2: //The Starting Choice Pane
			SetLocalGUIVariable(oPC, sSCREEN, 1, "1");
			SetLocalInt(oPC, "APPEAR_DEFAULT_CHOICE",0);
			SetLocalInt(oPC, "APPEAR_DEFAULT_PANE", 0);
			SetGUIObjectHidden(oPC, sSCREEN, "CHOICE_PANE", FALSE);
			SetGUIObjectHidden(oPC, sSCREEN, "ARMOR_PARTS", TRUE);
			SetGUIObjectHidden(oPC, sSCREEN, "DEFAULT_PIECES", TRUE);
			SetGUIObjectHidden(oPC, sSCREEN, "MODEL_1", TRUE);
			SetGUIObjectHidden(oPC, sSCREEN, "MODEL_2", TRUE);
			SetGUIObjectHidden(oPC, sSCREEN, "MODEL_3", TRUE);
			SetGUIObjectHidden(oPC, sSCREEN, "VARIATION", FALSE);
			SetGUIObjectHidden(oPC, sSCREEN, "STYLE", FALSE);
			DelayCommand(0.1, InitializeItem(oPC, 1, nSLOT, ""));
			if (nSLOT == INVENTORY_SLOT_CHEST)
			{
				SetGUIObjectHidden(oPC, sSCREEN, "ARMOR_PARTS", FALSE);
				SetGUIObjectHidden(oPC, sSCREEN, "DEFAULT_PIECES", FALSE);
			}
			else if ((nSLOT == INVENTORY_SLOT_RIGHTHAND)||(nSLOT == INVENTORY_SLOT_LEFTHAND))
			{
				SetGUIObjectHidden(oPC, sSCREEN, "VARIATION", TRUE);
				SetGUIObjectHidden(oPC, sSCREEN, "STYLE", TRUE);
				SetGUIObjectHidden(oPC, sSCREEN, "MODEL_1", FALSE);
				SetGUIObjectHidden(oPC, sSCREEN, "MODEL_2", FALSE);
				SetGUIObjectHidden(oPC, sSCREEN, "MODEL_3", FALSE);
			}
			SetLocalGUIVariable(oPC, sSCREEN, 1, IntToString(nSTAGE-1));
			break;
		case 3: //The Parts Pane
			SetLocalInt(oPC, "APPEAR_DEFAULT_PANE", 0);
			SetGUIObjectHidden(oPC, sSCREEN, "PARTS_PANE", FALSE);
			DelayCommand(0.1, InitializeItem(oPC, 1, nSLOT, ""));
			break;
		case 4: //The Choice Pane of default pieces
			SetGUIObjectHidden(oPC, sSCREEN, "DEFAULT_PIECES", TRUE);
			SetGUIObjectHidden(oPC, sSCREEN, "ARMOR_PARTS", TRUE);
			SetGUIObjectHidden(oPC, sSCREEN, "MODEL_1", TRUE);
			SetGUIObjectHidden(oPC, sSCREEN, "MODEL_2", TRUE);
			SetGUIObjectHidden(oPC, sSCREEN, "MODEL_3", TRUE);	
			SetGUIObjectHidden(oPC, sSCREEN, "CHOICE_PANE", FALSE);
			SetGUIObjectHidden(oPC, sSCREEN, "VARIATION", FALSE);
			SetGUIObjectHidden(oPC, sSCREEN, "STYLE", FALSE);
			SetLocalInt(oPC, "APPEAR_DEFAULT_CHOICE",1);
			SetLocalInt(oPC, "APPEAR_DEFAULT_PANE", 1);
			break;
		case 5://The Default Pane itself
			SetGUIObjectHidden(oPC, sSCREEN, "CHOICE_PANE", TRUE);
			SetGUIObjectHidden(oPC, sSCREEN, "VARIATION", TRUE);
			SetGUIObjectHidden(oPC, sSCREEN, "STYLE", TRUE);
			SetGUIObjectHidden(oPC, sSCREEN, "DEFAULT_PANE", FALSE);
			SetLocalInt(oPC, "APPEAR_DEFAULT_PANE", 0);
			break;
		default: 
			RemovePolymorph(oPC); // The Equipment Pane
			SetGUIObjectHidden(oPC, sSCREEN, "EQUIPMENT_PANE", FALSE);
			SetGUIObjectText(oPC, sSCREEN, "ITEM_NAME", -1, "");
			SetLocalInt(oPC, "APPEARENCE_SLOT_TOMOD", -1);
			SetLocalInt(oPC, "APPEAR_DEFAULT_PANE", 0);
			SetLocalGUIVariable(oPC, sSCREEN, 1, "0");
	}
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
		DeleteLocalInt(oPC, "APPEAR_DEFAULT_CHOICE");
		DeleteLocalInt(oPC, "APPEAR_DEFAULT_PANE");
		DeleteLocalInt(oPC, "APPEARCHANGE_ANTIEXPLOIT");
		XPCraft_ActionCancelChanges(oPC);
		CloseGUIScreen(oPC, sSCREEN);
		return;
	}
	
	if (GetLocalInt(oPC, "APPEARCHANGE_ANTIEXPLOIT") == 1) return; //This is to prevent duplication
	
	SetLocalInt(oPC, "APPEARCHANGE_ANTIEXPLOIT", 1);
	
	int nSLOT = GetLocalInt(oPC, "APPEARENCE_SLOT_TOMOD");	
	int nINPUT = StringToInt(sINPUT);
	
	if (sCOMMAND == "EQUIP")
	{
		if (sINPUT == "HEAD") nSLOT = INVENTORY_SLOT_HEAD;
		else if (sINPUT == "CHEST") nSLOT = INVENTORY_SLOT_CHEST;
		else if (sINPUT == "ARMS") nSLOT = INVENTORY_SLOT_ARMS;
		else if (sINPUT == "FEET") nSLOT = INVENTORY_SLOT_BOOTS;
		else if (sINPUT == "BACK") nSLOT = INVENTORY_SLOT_CLOAK;
		else if (sINPUT == "RHAND") nSLOT = INVENTORY_SLOT_RIGHTHAND;
		else if (sINPUT == "LHAND") nSLOT = INVENTORY_SLOT_LEFTHAND;
		else 
		{
			SendMessageToPC(oPC, "Error.");
			SetLocalInt(oPC, "APPEARCHANGE_ANTIEXPLOIT", 0);
			return;
		}
		object oITEM = GetItemInSlot(nSLOT, oPC);
		if (oITEM == OBJECT_INVALID)
		{
			SendMessageToPC(oPC, "No item found in that slot.");
			SetLocalInt(oPC, "APPEARCHANGE_ANTIEXPLOIT", 0);
			return;
		}
		if (StartingConditional(oPC, 1, nSLOT, 0) == FALSE)
		{
			SendMessageToPC(oPC, "You're not allowed to modify this item.");
			SetLocalInt(oPC, "APPEARCHANGE_ANTIEXPLOIT", 0);
			return;
		}
		SetGUIObjectText(oPC, sSCREEN, "ITEM_NAME", -1, GetName(oITEM));
		SetLocalInt(oPC, "APPEARENCE_SLOT_TOMOD", nSLOT);
		RewindUI(oPC, sSCREEN, 2, nSLOT);
	}
	else if (sCOMMAND == "SELECT")
	{
		if (GetLocalInt(oPC, "APPEAR_DEFAULT_CHOICE") == 0) SetLocalGUIVariable(oPC, sSCREEN, 1, "2");
		SetGUIObjectHidden(oPC, sSCREEN, "CHOICE_PANE", TRUE);
		SetGUIObjectHidden(oPC, sSCREEN, "VARIATION_PANE", TRUE);
		SetGUIObjectHidden(oPC, sSCREEN, "STYLE_PANE", TRUE);
		SetGUIObjectHidden(oPC, sSCREEN, "COLORS_PANE", TRUE);
		SetGUIObjectHidden(oPC, sSCREEN, "PARTS_PANE", TRUE);
		SetGUIObjectHidden(oPC, sSCREEN, "DEFAULT_PANE", TRUE);
		
		if (sINPUT == "VARIATION")
		{
			InitializeItem(oPC, 0, 0, "Variation");
			SetGUIObjectHidden(oPC, sSCREEN, "VARIATION_PANE", FALSE);
		}
		else if (sINPUT == "STYLE")
		{
			InitializeItem(oPC, 0, 0, "ArmorVisualType");
			SetGUIObjectHidden(oPC, sSCREEN, "STYLE_PANE", FALSE);
		}
		else if (sINPUT == "COLORS")
		{
			SetGUIObjectHidden(oPC, sSCREEN, "COLORS_PANE", FALSE);
		}
		else if (sINPUT == "PARTS")
		{
			SetGUIObjectHidden(oPC, sSCREEN, "PARTS_PANE", FALSE);
		}
		else if (sINPUT == "DEFAULT")
		{
			SetGUIObjectHidden(oPC, sSCREEN, "DEFAULT_PANE", FALSE);
		}
		else if (GetStringLeft(sINPUT, 5) == "Model")
		{
			InitializeItem(oPC, 0, nSLOT, sINPUT);
			SetGUIObjectHidden(oPC, sSCREEN, "VARIATION_PANE", FALSE);
		}
	}
	else if (sCOMMAND == "PARTS")
	{
		InitializeItem(oPC, 0, 1, sINPUT);
		SetLocalGUIVariable(oPC, sSCREEN, 1, "3");
		SetGUIObjectHidden(oPC, sSCREEN, "PARTS_PANE", TRUE);
		SetGUIObjectHidden(oPC, sSCREEN, "VARIATION_PANE", FALSE);
	}
	else if (sCOMMAND == "STYLE")
	{
		if (StartingConditional(oPC, 4, 0, nINPUT) == FALSE) SendMessageToPC(oPC, "This item cannot be changed to that style.");
		else CraftAction(oPC, 8, nINPUT);
	}
	else if (sCOMMAND == "DEFAULT")
	{
		if (StartingConditional(oPC, 6, nINPUT, 0) == FALSE) SendMessageToPC(oPC, "You cannot modify this default piece.");
		else
		{
			SetLocalGUIVariable(oPC, sSCREEN, 1, "4");
			CraftAction(oPC, 11, nINPUT);
			RewindUI(oPC, sSCREEN, 4, nSLOT);
		}
	}
	else if (sCOMMAND == "COLOR")
	{
		CraftAction(oPC, nINPUT, 0);
	}
	else if (sCOMMAND == "FIND")
	{
		if (sINPUT == "NEXT") CraftAction(oPC, 6, 0);
		else if (sINPUT == "PREVIOUS") CraftAction(oPC, 5, 0);
	}
	else if (sCOMMAND == "CONFIRM")
	{
		if (StartingConditional(oPC, 5, nSLOT, 0) == FALSE)
		{
			SendMessageToPC(oPC, "You're not allowed to modify this item.");
			SetLocalInt(oPC, "APPEARCHANGE_ANTIEXPLOIT", 0);
			return;
		}
		CraftAction(oPC, 9, 0);
		RewindUI(oPC, sSCREEN, nINPUT, nSLOT);
	}
	else if (sCOMMAND == "CANCEL")
	{
		if (nINPUT == 3)
		{
			SetLocalInt(oPC, "APPEARCHANGE_ANTIEXPLOIT", 0);
			return;
		}
		CraftAction(oPC, 0, 0);
		if ((GetLocalInt(oPC, "APPEAR_DEFAULT_CHOICE") == 1)&&((GetLocalInt(oPC, "APPEAR_DEFAULT_PANE") == 1))) RewindUI(oPC, sSCREEN, 5, nSLOT);
		else RewindUI(oPC, sSCREEN, nINPUT, nSLOT);
	}
	DelayCommand(0.0f, SetLocalInt(oPC, "APPEARCHANGE_ANTIEXPLOIT", 0));
}