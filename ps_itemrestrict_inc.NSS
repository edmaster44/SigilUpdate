/***********************************************************
* Created by Loki_999/Agony_Aunt for SCoD persistent world *
*                                                          *
* i_psitemrestrict_inc - moved functions from              *
* i_psitemrestrict_eq to allow items with other tags and   *
* their own equip scripts to still call these functions    *
* from within their own scripts                            *
***********************************************************/

int CheckPCvsAlignmentGroup(object oPC, itemproperty ipCurrent)
{
	int iPCAlignGE = GetAlignmentGoodEvil(oPC);
	int iPCAlignLC = GetAlignmentLawChaos(oPC);
	int iSubType = GetItemPropertySubType(ipCurrent);
	int iRet;
	
	if (iSubType == iPCAlignGE | iSubType == iPCAlignLC)
		iRet = TRUE;
	else
		iRet = FALSE;
	
	return iRet;
}

int CheckPCvsClass(object oPC, itemproperty ipCurrent)
{
	int iSubType = GetItemPropertySubType(ipCurrent);
	int iRet;
	
	if (iSubType == GetClassByPosition(1, oPC)
		| iSubType == GetClassByPosition(2, oPC)
		| iSubType == GetClassByPosition(3, oPC)
		| iSubType == GetClassByPosition(4, oPC))
		iRet = TRUE;
	else
		iRet = FALSE;
	
	return iRet;
}

int CheckPCvsRace(object oPC, itemproperty ipCurrent)
{
	int iSubType = GetItemPropertySubType(ipCurrent);
	int iRet;
	
	if (iSubType == GetRacialType(oPC))
		iRet = TRUE;
	else
		iRet = FALSE;
	
	return iRet;
}

int CheckPCvsSpecificAlignment(object oPC, itemproperty ipCurrent)
{
	int iPCAlignGE = GetAlignmentGoodEvil(oPC);
	int iPCAlignLC = GetAlignmentLawChaos(oPC);
	int iPCSAlign;
	int iSubType = GetItemPropertySubType(ipCurrent);
	int iRet;
	
	if (iPCAlignGE == IP_CONST_ALIGNMENTGROUP_GOOD & iPCAlignLC == IP_CONST_ALIGNMENTGROUP_LAWFUL) iPCSAlign = IP_CONST_ALIGNMENT_LG;
	else if (iPCAlignGE == IP_CONST_ALIGNMENTGROUP_GOOD & iPCAlignLC == IP_CONST_ALIGNMENTGROUP_NEUTRAL) iPCSAlign = IP_CONST_ALIGNMENT_NG;
	else if (iPCAlignGE == IP_CONST_ALIGNMENTGROUP_GOOD & iPCAlignLC == IP_CONST_ALIGNMENTGROUP_CHAOTIC) iPCSAlign = IP_CONST_ALIGNMENT_CG;
	else if (iPCAlignGE == IP_CONST_ALIGNMENTGROUP_NEUTRAL & iPCAlignLC == IP_CONST_ALIGNMENTGROUP_LAWFUL) iPCSAlign = IP_CONST_ALIGNMENT_LN;
	else if (iPCAlignGE == IP_CONST_ALIGNMENTGROUP_NEUTRAL & iPCAlignLC == IP_CONST_ALIGNMENTGROUP_NEUTRAL) iPCSAlign = IP_CONST_ALIGNMENT_TN;
	else if (iPCAlignGE == IP_CONST_ALIGNMENTGROUP_NEUTRAL & iPCAlignLC == IP_CONST_ALIGNMENTGROUP_CHAOTIC) iPCSAlign = IP_CONST_ALIGNMENT_CN;
	else if (iPCAlignGE == IP_CONST_ALIGNMENTGROUP_EVIL & iPCAlignLC == IP_CONST_ALIGNMENTGROUP_LAWFUL) iPCSAlign = IP_CONST_ALIGNMENT_LE;
	else if (iPCAlignGE == IP_CONST_ALIGNMENTGROUP_EVIL & iPCAlignLC == IP_CONST_ALIGNMENTGROUP_NEUTRAL) iPCSAlign = IP_CONST_ALIGNMENT_NE;
	else if (iPCAlignGE == IP_CONST_ALIGNMENTGROUP_EVIL & iPCAlignLC == IP_CONST_ALIGNMENTGROUP_CHAOTIC) iPCSAlign = IP_CONST_ALIGNMENT_CE;
	else SendMessageToPC(oPC, "DEBUG: No specific alignment determined");
		
	if (iSubType == iPCSAlign)
		iRet = TRUE;
	else
		iRet = FALSE;

	return iRet;
}

int RestrictItemUse(object oItem, object oPC)
{
	int iAllowEquip = TRUE;
	int iAGCheckExists = FALSE;
	int iSACheckExists = FALSE;
	int iRaceCheckExists = FALSE;
	int iClassCheckExists = FALSE;
	int iSAMatch = FALSE;
	int iAGMatch = FALSE;
	int iRaceMatch = FALSE;
	int iClassMatch = FALSE;
	int iRetVal;
	itemproperty ipCurrent;
	
	ipCurrent = GetFirstItemProperty(oItem);
	
	while (GetIsItemPropertyValid(ipCurrent) == TRUE)
	{
		if (GetItemPropertyType(ipCurrent) == ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP)
		{
			iAGCheckExists = TRUE;
			iRetVal = CheckPCvsAlignmentGroup(oPC, ipCurrent);
			if (iRetVal == TRUE) iAGMatch = TRUE;
		}
		else if (GetItemPropertyType(ipCurrent) == ITEM_PROPERTY_USE_LIMITATION_CLASS)
		{
			iClassCheckExists = TRUE;
			iRetVal = CheckPCvsClass(oPC, ipCurrent);
			if (iRetVal == TRUE) iClassMatch = TRUE;
		}
		else if (GetItemPropertyType(ipCurrent) == ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE)
		{
			iRaceCheckExists = TRUE;
			iRetVal = CheckPCvsRace(oPC, ipCurrent);
			if (iRetVal == TRUE) iRaceMatch = TRUE;
		}
		else if (GetItemPropertyType(ipCurrent) == ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT)
		{
			iSACheckExists = TRUE;
			iRetVal = CheckPCvsSpecificAlignment(oPC, ipCurrent);
			if (iRetVal == TRUE) iSAMatch = TRUE;
		}

		ipCurrent = GetNextItemProperty(oItem);
	}
	
	if (iAGCheckExists == TRUE & iAGMatch == FALSE) iAllowEquip = FALSE;
	if (iSACheckExists == TRUE & iSAMatch == FALSE) iAllowEquip = FALSE;
	if (iRaceCheckExists == TRUE & iRaceMatch == FALSE) iAllowEquip = FALSE;
	if (iClassCheckExists == TRUE & iClassMatch == FALSE) iAllowEquip = FALSE;

	if (iAllowEquip == FALSE)
	{
		SendMessageToPC(oPC, "You do not meet the requirements to equip " + GetName(oItem));
		AssignCommand(oPC, ActionUnequipItem(oItem));
		return 0;
	}
	return 1;
}