#include "aaa_changeself_inc"
#include "ps_inc_functions"
#include "ps_inc_advscript"
#include "aaa_constants"
#include "ginc_math"

void PS_ChangeSelf_HairVariation_Barbershop(object oPC, int nHair)
{
	struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oPC);
	app.HairVariation = nHair;
	PS_SetCreatureCoreAppearance(oPC, app);
	PS_RefreshAppearance(oPC);
}

void PS_ChangeSelf_FacialHairVariation_Barbershop(object oPC, int nFacial)
{
	struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oPC);
	app.FacialHairVariation = nFacial;
	PS_SetCreatureCoreAppearance(oPC, app);
	PS_RefreshAppearance(oPC);
}

void PS_ChangeSelf_HairTint_Accessory_Barbershop(object oPC, string sHairTint0)
{
	int iTint0		= HexStringToInt(sHairTint0) << 8;
	struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oPC);
	app.HairTint_Color0 = iTint0;
	app.HairTint_Mask = PS_CCA_TINT_COLOR0;
	PS_SetCreatureCoreAppearance(oPC, app);
	PS_RefreshAppearance(oPC);
}

void PS_ChangeSelf_HairTint_Main_Barbershop(object oPC, string sHairTint1)
{
	int iTint1		= HexStringToInt(sHairTint1) << 8;
	struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oPC);
	app.HairTint_Color1 = iTint1;
	app.HairTint_Mask = PS_CCA_TINT_COLOR1;
	PS_SetCreatureCoreAppearance(oPC, app);
	PS_RefreshAppearance(oPC);
}

void PS_ChangeSelf_HairTint_Highlight_Barbershop(object oPC, string sHairTint2)
{
	int iTint2		= HexStringToInt(sHairTint2) << 8;
	struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oPC);
	app.HairTint_Color2 = iTint2;
	app.HairTint_Mask = PS_CCA_TINT_COLOR2;
	PS_SetCreatureCoreAppearance(oPC, app);
	PS_RefreshAppearance(oPC);
}

void PS_ChangeSelf_HeadTint_Eyebrows_Barbershop(object oPC, string sHeadTint2)
{
	int iHTint2		= HexStringToInt(sHeadTint2) << 8;
	struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oPC);
	app.HeadTint_Color2 = iHTint2;
	app.HeadTint_Mask = PS_CCA_TINT_COLOR2;
	PS_SetCreatureCoreAppearance(oPC, app);
	PS_RefreshAppearance(oPC);
}

void main(int nAppearanceID, int nGenderID, int nHeadID, int nTailID, int nWingsID, int nHairID, int nFacialHairID, string sAccessory, string sHairColor, string sHairHighlight, string sSkinColor, string sEyeColor, string sEyebrowColor, string sScaleX, string sScaleY, string sScaleZ)
{
	object oPC = OBJECT_SELF;
	if (GetCurrentHitPoints(OBJECT_SELF) <= 0)
	{
		SendMessageToPC(OBJECT_SELF, "You cant not use the ability while you are dead.");
		return;
	}
	
	if (GetLocalInt(OBJECT_SELF, "CharacterAppearanceChangeGUIType") == 0)
	{
		effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);

		
		PS_ChangeSelf_AppearanceType(oPC, nAppearanceID);
		PS_ChangeSelf_Gender(oPC, nGenderID);
	
		PS_ChangeSelf_FacialHairVariation(oPC, nFacialHairID); //Goes before setting HEAD(!)
		PS_ChangeSelf_HeadVariation(oPC, nHeadID);
		PS_ChangeSelf_TailVariation(oPC, nTailID);
		PS_ChangeSelf_WingVariation(oPC, nWingsID);
		PS_ChangeSelf_HairVariation(oPC, nHairID);

		PS_ChangeSelf_HairTint_Accessory(oPC, sAccessory);
		PS_ChangeSelf_HairTint_Main(oPC, sHairColor);
		PS_ChangeSelf_HairTint_Highlight(oPC, sHairHighlight);
		PS_ChangeSelf_HeadTint_Skin(oPC, sSkinColor);
		PS_ChangeSelf_HeadTint_Eyes(oPC, sEyeColor);
		PS_ChangeSelf_HeadTint_Eyebrows(oPC, sEyebrowColor);
		
	}
	else if (GetLocalInt(OBJECT_SELF, "CharacterAppearanceChangeGUIType") == 1)
	{	
		PS_ChangeSelf_FacialHairVariation_Barbershop(oPC, nFacialHairID);
		PS_ChangeSelf_HairVariation_Barbershop(oPC, nHairID);
		PS_ChangeSelf_HairTint_Accessory_Barbershop(oPC, sAccessory);
		PS_ChangeSelf_HairTint_Main_Barbershop(oPC, sHairColor);
		PS_ChangeSelf_HairTint_Highlight_Barbershop(oPC, sHairHighlight);
		PS_ChangeSelf_HeadTint_Eyebrows_Barbershop(oPC, sEyebrowColor);	
	}
	/*
	SendMessageToPC(OBJECT_SELF,
	"nAppearanceID = "+IntToString(nAppearanceID)+"\n"+
	"nGenderID = "+IntToString(nGenderID)+"\n"+
	"nHeadID = "+IntToString(nHeadID)+"\n"+
	"nTailID = "+IntToString(nTailID)+"\n"+
	"nWingsID = "+IntToString(nWingsID)+"\n"+
	"nHairID = "+IntToString(nHairID)+"\n"+
	"nFacialHairID = "+IntToString(nFacialHairID)+"\n"+
	"sAccessory = "+sAccessory+"\n"+
	"sHairColor = "+sHairColor+"\n"+
	"sHairHighlight = "+sHairHighlight+"\n"+
	"sSkinColor = "+sSkinColor+"\n"+
	"sEyeColor = "+sEyeColor+"\n"+
	"sEyebrowColor = "+sEyebrowColor+"\n"+	
	"sScaleX = "+sScaleX+"\n"+
	"sScaleY = "+sScaleY+"\n"+
	"sScaleZ = "+sScaleZ);	
	*/
	float fScaleX = StringToFloat(sScaleX);
	if (fScaleX < 0.93f) fScaleX = 0.93f;
	if (fScaleX > 1.06f) fScaleX = 1.06f;
	
	float fScaleY = StringToFloat(sScaleY);
	if (fScaleY < 0.93f) fScaleY = 0.93f;
	if (fScaleY > 1.06f) fScaleY = 1.06f;
	
	float fScaleZ = StringToFloat(sScaleZ);
	if (fScaleZ < 0.93f) fScaleZ = 0.93f;
	if (fScaleZ > 1.06f) fScaleZ = 1.06f;
	
	/* Not working, they are stacking over and over again
	effect eScale = EffectSetScale(fScaleX, fScaleY, fScaleZ);
	RemoveEffect(OBJECT_SELF, eScale);	
	ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(eScale), OBJECT_SELF);
	*/
	SetScale(OBJECT_SELF, fScaleX, fScaleY, fScaleZ);
	if (GetLocalInt(OBJECT_SELF, "CharacterAppearanceChangeGUIType") == 2)
	{
		effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);

		
		PS_ChangeSelf_AppearanceType(oPC, nAppearanceID);
		PS_ChangeSelf_Gender(oPC, nGenderID);
	
		PS_ChangeSelf_FacialHairVariation(oPC, nFacialHairID); //Goes before setting HEAD(!)
		PS_ChangeSelf_HeadVariation(oPC, nHeadID);
		PS_ChangeSelf_TailVariation(oPC, nTailID);
		PS_ChangeSelf_WingVariation(oPC, nWingsID);
		PS_ChangeSelf_HairVariation(oPC, nHairID);

		PS_ChangeSelf_HairTint_Accessory(oPC, sAccessory);
		PS_ChangeSelf_HairTint_Main(oPC, sHairColor);
		PS_ChangeSelf_HairTint_Highlight(oPC, sHairHighlight);
		PS_ChangeSelf_HeadTint_Skin(oPC, sSkinColor);
		PS_ChangeSelf_HeadTint_Eyes(oPC, sEyeColor);
		PS_ChangeSelf_HeadTint_Eyebrows(oPC, sEyebrowColor);
		
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
}