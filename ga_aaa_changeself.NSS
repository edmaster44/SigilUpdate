/*	Ceremorph 12/25/2015
	Change Self script for racial PrC ability
	
	Parameters (iParam):		|
	0 = RESET ALL				|	No values
	1 = Appearance Type			|	Uses iValue; from appearance.2da
	2 = Gender					|	Uses iValue; 0 = Male, 1 = Female
	3 = Head Variation			|	Uses iValue; from .mdl files
	4 = Tail Variation			|	Uses iValue; from tailmodel.2da
	5 = Wing Variation			|	Uses iValue; from wingmodel.2da
	6 = Hair Variation			|	Uses iValue; from .mdl files
	7 = FacialHair Variation	|	Uses iValue; 0 = False, 1 = True
	8 = Hair Accessory Tint		|	Uses sValue; Hex color value
	9 = Hair Tint				|	Uses sValue; Hex color value
	10 = Hair Highlight Tint	|	Uses sValue; Hex color value
	11 = Skin Tint				|	Uses sValue; Hex color value
	12 = Eye Tint				|	Uses sValue; Hex color value
	13 = Eyebrow Tint			|	Uses sValue; Hex color value
	14 = Save Alternate Form
	15 = Assume Alternate Form
	
    Alersia 03/04/2016
	Added lines to "restore orginal form", "assume alternate form" and "appearance type".
	They checks first for a draconic feat, then if the character has humanoid/natural 
	weapons equipped and de-equipps them depending on action.*
	
*/

#include "aaa_changeself_inc"
//#include "ps_inc_functions"
//#include "ps_inc_advscript"
//#include "aaa_constants"

// Params for dragon alt form are (15, 0, "", 0.0, 0.0, 0.0)
// Params for dragon true form are (0, 0, "", 0.0, 0.0, 0.0)
	
void main(int iParam, int iValue, string sValue, float fValue1, float fValue2, float fValue3)
{
	object oPC		= OBJECT_SELF;
	object oItem	= GetItemPossessedBy(oPC, "ps_essence");
	
	SetLocalInt(oItem, "TempChange", 1);
	effect eVFX = EffectNWN2SpecialEffectFile("fx_spirit_gorge_hit");

	switch(iParam)
	{	case 0:
			PS_RestoreOriginalAppearance(oPC);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oPC);
			PS_DragForm_DragonUE(oPC);
			SetLocalInt(oItem, "TempChange", 0);
			//DelayCommand(1.0f, AssignCommand(oPC, ActionRest()));
		break;	
	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */		
		case 1:
			PS_ChangeSelf_AppearanceType(oPC, iValue);
			PS_HumForm_DragonUE(oPC);
		break;
	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */		
		case 2:
			PS_ChangeSelf_Gender(oPC, iValue);
		break;
	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
		case 3:
			PS_ChangeSelf_HeadVariation(oPC, iValue);
		break;
	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
		case 4:
			PS_ChangeSelf_TailVariation(oPC, iValue);
		break;
	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
		case 5:
			PS_ChangeSelf_WingVariation(oPC, iValue);
		break;
	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
		case 6:
			PS_ChangeSelf_HairVariation(oPC, iValue);
		break;
	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
		case 7:
			PS_ChangeSelf_FacialHairVariation(oPC, iValue);
		break;
	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
		case 8:
			PS_ChangeSelf_HairTint_Accessory(oPC, sValue);
		break;
	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
		case 9:
			PS_ChangeSelf_HairTint_Main(oPC, sValue);
		break;
	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
		case 10:
			PS_ChangeSelf_HairTint_Highlight(oPC, sValue);
		break;
	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
		case 11:
			PS_ChangeSelf_HeadTint_Skin(oPC, sValue);
		break;
	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
		case 12:
			PS_ChangeSelf_HeadTint_Eyes(oPC, sValue);
		break;
	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
		case 13:
			PS_ChangeSelf_HeadTint_Eyebrows(oPC, sValue);
		break;
	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
		case 14:
			PS_AltForm_SaveForm(oPC);
		break;
	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
		case 15:
			PS_AltForm_Assume(oPC);
			PS_HumForm_DragonUE(oPC);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oPC);
			SetLocalInt(oItem, "TempChange", 1);
		break;	
	}
}