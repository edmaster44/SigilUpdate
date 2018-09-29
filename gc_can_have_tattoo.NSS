//::///////////////////////////////////////////////
//:: [gc_can_have_tattoo.nss]
//:: Copyright (c) 2010 SCoD
//:://////////////////////////////////////////////
//:: Returns true if speaker can have the tattoo
//:: (if the duplicates allowed parameter is false,
//:: the script will also check that the PC doesn't already have that specific tattoo)
//:://////////////////////////////////////////////
//:: Created by: Netrunner
//:: Created on: 19/10/2010
//:://////////////////////////////////////////////

#include "inc_tattoo"

int StartingConditional (string sTattooTag = "")
{
	object oPC = GetPCSpeaker();
	//check if PC doesn't already have the max number of tattoes
	if (canGetTattoo(oPC))
	{
		//if duplicate tattooes are not allowed, check if the PC already has this specific tattoo
		if (duplicatesAllowed)
		{
			return TRUE;
		}
		else
		{
			//if tattoo already exists, return FALSE. Else return TRUE (also if tattoo tag not specified)
			if (sTattooTag == "")
				return TRUE;
			else
			{
				if (findTattoo(oPC, sTattooTag) != OBJECT_INVALID)
				{
					//tattoo present, return FALSE
					return FALSE;
				}
				else
				{
					return TRUE;
				}
			}
		}
	}
	else
	{
		//PC already has the maximum allowed number of tattoes
		return FALSE;
	}
}