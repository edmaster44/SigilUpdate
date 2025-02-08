// i_ps_golemrecipe_ac
/*	Script created by Ceremorph 7/19/2015 for use in the Sigil: City of Doors PW
	This will be used in conjunction with a Golem Recipe to create that type of golem	
*/  

// Modification by Agony_Aunt to store repawning of hench in event of server crash within time specified in function
// AllowRespawnHench in ps_inc_faction
// Reviewed by Clangeddin 28/12/2017

#include "ps_inc_faction"
#include "ps_inc_functions"
#include "ps_inc_golem"
#include "nw_i0_plot"
#include "ginc_2da"

void main()
{
	object oPC			= GetItemActivator();
	object oItem		= GetItemActivated();
	
	// Collect variable from the calling item to determine what type of golem is being made. This value is the row number in the file scod_golemcraft.2da
	int iRow			= PS_GetLocalInt(oItem, "golem");
	string s2da			= "scod_golemcraft";
	int nCACHE 			= GetNum2DARows(s2da); //Cache the 2da, so it's faster.
	
	// First, we determine if the PC is in the incorrect area to create this golem and end the script if they are
	string sCraftLoc1	= Get2DAString(s2da, "CraftLoc1", iRow);
	string sCraftLoc2	= Get2DAString(s2da, "CraftLoc2", iRow);
	object oArea		= GetArea(oPC);
	string sArea		= GetTag(oArea);
	if((sArea != sCraftLoc1) && (sArea != sCraftLoc2))
	{
		SendMessageToPC(oPC, "You are in the area " + sArea + ".");
		SendMessageToPC(oPC, "But you must be in " + sCraftLoc1 + " or " + sCraftLoc2 + ".");
		SendMessageToPC(oPC, "You cannot build this golem in this area.");
		return;
	}
	
	// Next, we determine if the PC has the necessary skill ranks to build this golem.
	int iAlchemyRank	= Get2DAInt(s2da, "RanskAlchemy", iRow);
	int iArmorRank		= Get2DAInt(s2da, "RanskArmor", iRow);
	int iWeaponRank		= Get2DAInt(s2da, "RanskWeapon", iRow);
	int iCasterLevel	= Get2DAInt(s2da, "CasterLevel", iRow);
	int iPCAlchemy		= GetSkillRank(27, oPC);
	int iPCArmor		= GetSkillRank(25, oPC);
	int iPCWeapon		= GetSkillRank(26, oPC);
	if((iPCAlchemy < iAlchemyRank) || (iPCArmor < iArmorRank) || (iPCWeapon < iWeaponRank))
	{
		SendMessageToPC(oPC, "You lack the necessary crafting skill ranks to build this golem.");
		return;
	}
	
	// Next, we determine if the PC has the necessary caster level and/or average skill rank (if Golem Master) to build this golem.
	int iPCCasterLevel	= PS_GetGolemCasterLevel(oPC);
	
	// DEBUG
	// SendMessageToPC(oPC, "Debug: Your character's caster level is " + IntToString(iPCCasterLevel) + ".");
	// SendMessageToPC(oPC, "Debug: Necessary caster level to cast this golem is " + IntToString(iCasterLevel) + ".");
	
	int iGMAverage;
	if (GetHasFeat(2808, oPC, TRUE)) iGMAverage = (iPCAlchemy + iPCArmor + iPCWeapon) / 3;
	if ((iPCCasterLevel < iCasterLevel) && (iGMAverage < iCasterLevel))
	{
		SendMessageToPC(oPC, "You lack either the casting ability or crafting knowledge to create this golem.");
		return;
	}
	
	//	Next, we check if the recipe is Golem Master only, and if the PC has the necessary levels.
	int iGMLevel = Get2DAInt(s2da, "GMLevel", iRow);
	int iGMClassLvl	= GetLevelByClass(77, oPC);
	if (iGMClassLvl < iGMLevel)
	{
		SendMessageToPC(oPC, "You do not have the necessary levels in Golem Master to create this golem.");
		return;
	}

	// Next, we check if the PC has the required feat to craft the golems
	int iFeat = Get2DAInt(s2da, "Feat", iRow);
	if (GetHasFeat(iFeat, oPC, TRUE) == FALSE)
	{	
		SendMessageToPC(oPC, "You do not have the necessary feat to create this golem.");
		return;
	}
		
	/* Next, we check if the PC has the required alignment to craft the golems
	
	int    ALIGNMENT_ALL                    = 0; ALIGNMENT_NEUTRAL                = 1;
	int    ALIGNMENT_LAWFUL                 = 2; ALIGNMENT_CHAOTIC                = 3;
	int    ALIGNMENT_GOOD                   = 4; ALIGNMENT_EVIL                   = 5;
	
	Hellfire = no Chaotic, no Good = 3,4
	Valor = no Chaotic, no Evil = 3,5
	Wood = no Lawful, no Evil = 2,5
	Demon = No Lawful, no Good = 2,4
	*/
	
	int iAlign1	= Get2DAInt(s2da, "Align1", iRow);
	int iAlign2	= Get2DAInt(s2da, "Align2", iRow);	
	int iAlignGood = GetAlignmentGoodEvil(oPC);
	int iAlignLawful = GetAlignmentLawChaos(oPC);
		
	if(iAlignGood == iAlign2 || iAlignLawful == iAlign1)
	{
		SendMessageToPC(oPC, "Disallowed alignment is " + IntToString(iAlign1) + " or " + IntToString(iAlign2) + ".");
		SendMessageToPC(oPC, "Your alignment is " + IntToString(iAlignLawful) + " and " + IntToString(iAlignGood) + ".");
		SendMessageToPC(oPC, "You do not have the necessary alignment to create this golem.");
		return;
	}
	
	// Now comes the determinations as to the XP cost for Golem Masters (reduced by Animating Essence feat)
	int iXP	= Get2DAInt(s2da, "CostXP", iRow);
	if (GetHasFeat(2802, oPC, TRUE)) iXP = iXP - ((iXP/10) * iGMClassLvl);
	int iPCXP = GetXP(oPC);
	if (iPCXP < iXP)
	{
		SendMessageToPC(oPC, "You lack the necessary experience to create this golem.");
		return;
	}
	
	//	And finally, we determine whether the PC can afford the gold and materials price of building the golem.
	//	If the PC is a golem master with the Secrets of Building feat, they spend only half the gold.
	int iGP				= Get2DAInt(s2da, "CostGP", iRow);
	string sMaterial1	= Get2DAString(s2da, "Material1", iRow);
	string sMaterial2	= Get2DAString(s2da, "Material2", iRow);
	string sMaterial3	= Get2DAString(s2da, "Material3", iRow);
	
	if (GetHasFeat(2804, oPC, TRUE))
	{
		if (iGMClassLvl >= 10) iGP = iGP / 4;
		else iGP = iGP / 2;
	}
	
	int nRETURN;
	if (GetGold(oPC) < iGP) nRETURN = TRUE;
	else if (GetItemQuantity(oPC, sMaterial1, TRUE) < 1) nRETURN = TRUE;
	else if (GetItemQuantity(oPC, sMaterial2, TRUE) < 1) nRETURN = TRUE;
	else if (GetItemQuantity(oPC, sMaterial3, TRUE) < 1) nRETURN = TRUE;
	if (nRETURN == TRUE)
	{	
		//SendMessageToPC(oPC, "This golem will cost " + IntToString(iGP) + "gp to build.");
		//SendMessageToPC(oPC, "You have " + IntToString(iPCGold) + "gp currently.");
		SendMessageToPC(oPC, "You lack the gold or materials necessary to create this golem.");
		return;
	}
	
	// At this point, we've gotten past all the checks and know what we're doing, so it's time to make the golem control device!
	// First we choose the tag of the device to be created based on advancement.
	
	// Collect variable from the calling item to determine what skill is used to advance the golem (Alchemy 27, Armor 25, Weapon 26);
	int iAdvance = Get2DAInt(s2da, "Advance", iRow);
	
	// Collect variable from the calling item to determine what level skill rank advances the golem (if higher ones unused, make value 99)
	//int iBase0	= Get2DAInt(s2da, "Base_0", iRow);
	int iBase1		= Get2DAInt(s2da, "Base_1", iRow);
	int iBase2		= Get2DAInt(s2da, "Base_2", iRow);
	int iBase3		= Get2DAInt(s2da, "Base_3", iRow);
	int iBase4		= Get2DAInt(s2da, "Base_4", iRow);
	int iBase5		= Get2DAInt(s2da, "Base_5", iRow);
	string sGolem 	= Get2DAString(s2da, "Golem", iRow);
	
	int iSkillRank = GetSkillRank(iAdvance, oPC, TRUE);
	if (iSkillRank >= iBase5) sGolem = sGolem + "_5";
	else if (iSkillRank >= iBase4) sGolem = sGolem + "_4";
	else if (iSkillRank >= iBase3) sGolem = sGolem + "_3";
	else if (iSkillRank >= iBase2) sGolem = sGolem + "_2";
	else if (iSkillRank >= iBase1) sGolem = sGolem + "_1";
	
	object oDevice = CreateItemOnObject(sGolem, oPC);
	if (oDevice == OBJECT_INVALID)
	{
		SendMessageToPC(oPC, "Failed to create object " + sGolem + ", this is a builder authoring error");
		return;
	}
	
	int iGolemName		= Get2DAInt(s2da, "GolemNameStrf", iRow);
	string sGolemName	= GetStringByStrRef(iGolemName);
	string sDevice = GetName(oDevice);
	AssignCommand(oPC, TakeGoldFromCreature(iGP, oPC, TRUE));
	ConsumeItems(oPC, sMaterial1);
	ConsumeItems(oPC, sMaterial2);
	ConsumeItems(oPC, sMaterial3);
	
	SetXP(oPC, iPCXP - iXP);
	SendMessageToPC(oPC, "You have successfully created the " + sGolemName + ". The " + sDevice + " has been placed in your inventory. The effort of creating this golem has cost you " + IntToString(iXP) + " experience points.");

	/* DEBUG */	
	//SendMessageToPC(oPC, "Debug: You now have " + IntToString(GetGold(oPC)) + "gp.");
}