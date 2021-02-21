#include "ps_inc_functions"
#include "ps_inc_advscript"
#include "aaa_constants"
#include "ginc_math"

/*	This is the include file for CreatureCoreAppearance functions.
	Created by Ceremorph 12/25/2015
	Advanced Scripting features by Astral Eclipse 2015	*/

// Change character appearance type using values from appearance.2da or APPEARANCE_TYPE_*
// Be careful with changing to non-humanoid appearances without testing!
// ALWAYS REMEMBER TO REFRESH AFTER CHANGING using PS_RefreshAppearance(oPC)
// PS_Changeself_AppearanceType(object oPC, int nAppVar = APPEARANCE_TYPE_DWARF)
void PS_ChangeSelf_AppearanceType(object oPC, int nAppVar)
{
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oPC);
	app.AppearanceType = nAppVar;
	PS_SetCreatureCoreAppearance(oPC, app);
	SetLocalInt(oItem, "TempChange", 1);
	PS_RefreshAppearance(oPC);
	//SendMessageToPC(oPC, "Appearance type changed to " + IntToString(nAppVar) + ".");
}

// Change character gender using GENDER_* values
// ALWAYS REMEMBER TO REFRESH AFTER CHANGING using PS_RefreshAppearance(oPC)
// PS_ChangeSelf_Gender(object oPC, int nGender = GENDER_MALE)
void PS_ChangeSelf_Gender(object oPC, int nGender)
{
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oPC);
	app.Gender = nGender;
	PS_SetCreatureCoreAppearance(oPC, app);
	SetLocalInt(oItem, "TempChange", 1);
	PS_RefreshAppearance(oPC);
	//SendMessageToPC(oPC, "Gender changed to " + IntToString(nGender) + ".");
}

// Change character head (appearance-specific) using values from .mdl files
// ALWAYS REMEMBER TO REFRESH AFTER CHANGING using PS_RefreshAppearance(oPC)
// PS_ChangeSelf_HeadVariation(object oPC, int nHead)
void PS_ChangeSelf_HeadVariation(object oPC, int nHead)
{
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oPC);
	app.HeadVariation = nHead;
	PS_SetCreatureCoreAppearance(oPC, app);
	SetLocalInt(oItem, "TempChange", 1);
	PS_RefreshAppearance(oPC);
	//SendMessageToPC(oPC, "Head variation changed to " + IntToString(nHead) + ".");
}


// Change character's tail using values from tailmodel.2da; note not all tails fit all races
// ALWAYS REMEMBER TO REFRESH AFTER CHANGING using PS_RefreshAppearance(oPC)
// PS_ChangeSelf_TailVariation(object oPC, int nTail)
void PS_ChangeSelf_TailVariation(object oPC, int nTail)
{
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oPC);
	app.TailVariation = nTail;
	PS_SetCreatureCoreAppearance(oPC, app);
	SetLocalInt(oItem, "TempChange", 1);
	PS_RefreshAppearance(oPC);
	//SendMessageToPC(oPC, "Tail variation changed to " + IntToString(nTail) + ".");
}

// Change character's wing using values from wingmodel.2da or WING_TYPE_*
// Note not all wings fit all races
// ALWAYS REMEMBER TO REFRESH AFTER CHANGING using PS_RefreshAppearance(oPC)
// PS_ChangeSelf_WingVariation(object oPC, int nWing = WING_TYPE_NONE)
void PS_ChangeSelf_WingVariation(object oPC, int nWing)
{
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oPC);
	app.WingVariation = nWing;
	PS_SetCreatureCoreAppearance(oPC, app);
	SetLocalInt(oItem, "TempChange", 1);
	PS_RefreshAppearance(oPC);
	//SendMessageToPC(oPC, "Wing variation changed to " + IntToString(nWing) + ".");
}

// Change character's hair (appearance-specific) using values from .mdl files
// ALWAYS REMEMBER TO REFRESH AFTER CHANGING using PS_RefreshAppearance(oPC)
// PS_ChangeSelf_HairVariation(object oPC, int nHair)
void PS_ChangeSelf_HairVariation(object oPC, int nHair)
{
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oPC);
	app.HairVariation = nHair;
	PS_SetCreatureCoreAppearance(oPC, app);
	SetLocalInt(oItem, "TempChange", 1);
	PS_RefreshAppearance(oPC);
	//SendMessageToPC(oPC, "Hair variation changed to " + IntToString(nHair) + ".");
}

// Turn facial hair on and off using TRUE (1) or FALSE (0) values only
// Not all faces have a facial hair variant, so nothing may happen when using this
// ALWAYS REMEMBER TO REFRESH AFTER CHANGING using PS_RefreshAppearance(oPC)
// PS_ChangeSelf_FacialHairVariation(object oPC, int nFacial)
void PS_ChangeSelf_FacialHairVariation(object oPC, int nFacial)
{
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oPC);
	app.FacialHairVariation = nFacial;
	PS_SetCreatureCoreAppearance(oPC, app);
	SetLocalInt(oItem, "TempChange", 1);
	PS_RefreshAppearance(oPC);
	//SendMessageToPC(oPC, "Facial hair variation changed to " + IntToString(nFacial) + ".");
}

// Change the color of the character's hair accessory
// Use Hexidecimal color values (e.g., FFFFFF for White)
// PS_ChangeSelf_HairTint_Accessory(oPC, string sHairTint0)
void PS_ChangeSelf_HairTint_Accessory(object oPC, string sHairTint0)
{
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	int iTint0		= HexStringToInt(sHairTint0) << 8;
	struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oPC);
	app.HairTint_Color0 = iTint0;
	app.HairTint_Mask = PS_CCA_TINT_COLOR0;
	PS_SetCreatureCoreAppearance(oPC, app);
	SetLocalInt(oItem, "TempChange", 1);
	PS_RefreshAppearance(oPC);
	//SendMessageToPC(oPC, "Hair accessory tint changed to " + sHairTint0 + ".");
}

// Change the color of the character's primary haircolor
// Use Hexidecimal color values (e.g., FFFFFF for White)
// PS_ChangeSelf_HairTint_Main(oPC, string sHairTint1)
void PS_ChangeSelf_HairTint_Main(object oPC, string sHairTint1)
{
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	int iTint1		= HexStringToInt(sHairTint1) << 8;
	struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oPC);
	app.HairTint_Color1 = iTint1;
	app.HairTint_Mask = PS_CCA_TINT_COLOR1;
	PS_SetCreatureCoreAppearance(oPC, app);
	SetLocalInt(oItem, "TempChange", 1);
	PS_RefreshAppearance(oPC);
	//SendMessageToPC(oPC, "Hair tint changed to " + sHairTint1 + ".");
}

// Change the color of the character's highlight haircolor
// Use Hexidecimal color values (e.g., FFFFFF for White)
// PS_ChangeSelf_HairTint_Highlight(oPC, string sHairTint2)
void PS_ChangeSelf_HairTint_Highlight(object oPC, string sHairTint2)
{
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	int iTint2		= HexStringToInt(sHairTint2) << 8;
	struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oPC);
	app.HairTint_Color2 = iTint2;
	app.HairTint_Mask = PS_CCA_TINT_COLOR2;
	PS_SetCreatureCoreAppearance(oPC, app);
	SetLocalInt(oItem, "TempChange", 1);
	PS_RefreshAppearance(oPC);
	//SendMessageToPC(oPC, "Hair highlight tint changed to " + sHairTint2 + ".");
}

// Change the color of the character's skin
// Use Hexidecimal color values (e.g., FFFFFF for White)
// PS_ChangeSelf_HeadTint_Skin(oPC, string sHeadTint0)
void PS_ChangeSelf_HeadTint_Skin(object oPC, string sHeadTint0)
{
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	int iHTint0		= HexStringToInt(sHeadTint0) << 8;
	struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oPC);
	app.HeadTint_Color0 = iHTint0;
	app.HeadTint_Mask = PS_CCA_TINT_COLOR0;
	PS_SetCreatureCoreAppearance(oPC, app);
	SetLocalInt(oItem, "TempChange", 1);
	PS_RefreshAppearance(oPC);
	//SendMessageToPC(oPC, "Skin tint changed to " + sHeadTint0 + ".");
}

// Change the color of the character's eyes
// Use Hexidecimal color values (e.g., FFFFFF for White)
// PS_ChangeSelf_HeadTint_Eyes(oPC, string sHeadTint1)
void PS_ChangeSelf_HeadTint_Eyes(object oPC, string sHeadTint1)
{
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	int iHTint1		= HexStringToInt(sHeadTint1) << 8;
	struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oPC);
	app.HeadTint_Color1 = iHTint1;
	app.HeadTint_Mask = PS_CCA_TINT_COLOR1;
	PS_SetCreatureCoreAppearance(oPC, app);
	SetLocalInt(oItem, "TempChange", 1);
	PS_RefreshAppearance(oPC);
	//SendMessageToPC(oPC, "Eye tint changed to " + sHeadTint1 + ".");
}

// Change the color of the character's eyebrows
// Use Hexidecimal color values (e.g., FFFFFF for White)
// PS_ChangeSelf_HeadTint_Eyebrows(oPC, string sHeadTint2)
void PS_ChangeSelf_HeadTint_Eyebrows(object oPC, string sHeadTint2)
{
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	int iHTint2		= HexStringToInt(sHeadTint2) << 8;
	struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oPC);
	app.HeadTint_Color2 = iHTint2;
	app.HeadTint_Mask = PS_CCA_TINT_COLOR2;
	PS_SetCreatureCoreAppearance(oPC, app);
	SetLocalInt(oItem, "TempChange", 1);
	PS_RefreshAppearance(oPC);
	//SendMessageToPC(oPC, "Eyebrow tint changed to " + sHeadTint2 + ".");
}

// Alternate Form ability: save alternate form
void PS_AltForm_SaveForm(object oPC)
{
	struct CreatureCoreAppearance Appearance = PS_GetCreatureCoreAppearance(oPC); 
	// Set all the masks so that if we reset the appearance, we set everything.
	Appearance.Tint_Mask = PS_CCA_TINT_ALL;
	Appearance.HeadTint_Mask = PS_CCA_TINT_ALL;
	Appearance.HairTint_Mask = PS_CCA_TINT_ALL;
	
	object oEssence = GetItemPossessedBy(oPC, "ps_essence");
	
	PS_CreatureCoreAppearanceToScriptVariables(oEssence, "AltForm", Appearance);
	SendMessageToPC(oPC, "Alternate form appearance information saved.");
	SetLocalInt(oEssence, "AltFormSet", 1);
	SetLocalInt(oEssence, "TempChange", 1);
}

// Alternate Form ability: assume alternate form
void PS_AltForm_Assume(object oPC)
{
	object oEssence = GetItemPossessedBy(oPC, "ps_essence");
	struct CreatureCoreAppearance Appearance = PS_RetrieveStoredCreatureCoreAppearance(oEssence, "AltForm");
	PS_SetCreatureCoreAppearance(oPC, Appearance);
	SendMessageToPC(oPC, "Alternative form assumed.");
	PS_RefreshAppearance(oPC);
	SetLocalInt(oEssence, "TempChange", 1);
}

// Dragons assuming Alternate Form have their creature weapons unequipped when doing so.
// This script should be used in conjunction with PS_AltForm_Assume or PS_ChangeForm_AppearanceType.
void PS_HumForm_DragonUE(object oPC)
{
	object oWpn6 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
	object oWpn7 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int iType6 = GetBaseItemType(oWpn6);
	int iType7 = GetBaseItemType(oWpn7);	

	if (GetHasFeat(3625, oPC, TRUE))
	{	if (iType6 > 160 || iType6 < 177) // Unequipps creature weapons if PC changes into humanoid form. Dragon only.
		{	if (GetIsObjectValid(oWpn6))
			{	AssignCommand(oPC, ActionUnequipItem(oWpn6));
				SendMessageToPC(oPC, "<c=red>Your character does not have claws or a bite in humanoid form");
			}
		}
				
		if (iType7 > 160 || iType7 < 177) // Slot2
		{	if (GetIsObjectValid(oWpn7))
			{	AssignCommand(oPC, ActionUnequipItem(oWpn7));
				SendMessageToPC(oPC, "<c=red>Your character does not have claws or a bite in humanoid form");
			}
		}
	}

	// removes multiattack from "claw" dragons when assuming humanoid form.
	int iDragon = GetLevelByClass(CLASS_TYPE_DRAGON_PRC, oPC);
		
	if (GetHasFeat(3649, oPC, FALSE))
	{	
		FeatRemove(oPC, 1784);
	}
	
}

// Dragons assuming their natural Dragon form have any melee weapons unequipped when doing so.
// This script should be used in conjunction with PS_RestoreOriginalAppearance.
void PS_DragForm_DragonUE(object oPC)
{
	object oWpn6 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
	object oWpn7 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	int iType6 = GetBaseItemType(oWpn6);
	int iType7 = GetBaseItemType(oWpn7);

	if (GetHasFeat(3625, oPC, TRUE))
	{	if (iType6 < 160 || iType6 > 177) // Slot1: Unequipps every weapon except creature weapons.
		{	if (GetIsObjectValid(oWpn6))
			{	AssignCommand(oPC, ActionUnequipItem(oWpn6));
				SendMessageToPC(oPC, "<c=red>You cannot wield humanoid weapons in your natural form.");
			}
		}
				
		if (iType7 < 160 || iType7 > 177) // Slot2
		{	if (GetIsObjectValid(oWpn7))
			{	AssignCommand(oPC, ActionUnequipItem(oWpn7));
				SendMessageToPC(oPC, "<c=red>You cannot wield humanoid weapons or shields in your natural form.");
			}
		}
	}

	// applies multiattack to "claw" dragons	
	int iDragon = GetLevelByClass(CLASS_TYPE_DRAGON_PRC, oPC);  
		
	if (GetHasFeat(3649, oPC, FALSE) && iDragon >= 6)
	{	
		FeatAdd(oPC, 1784, 0, 1, 1);
	}	
}