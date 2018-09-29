//::///////////////////////////////////////////////
//:: [gc_has_tattoo.nss]
//:: Copyright (c) 2010 SCoD
//:://////////////////////////////////////////////
//:: Returns true if speaker has at least one tattoo. If Tattoo tag specified, also checks for
//:: that specific tattoo.
//:: (useful for deciding if the option to delete or create a tattoo should be shown in conversation)
//:://////////////////////////////////////////////
//:: Created by: Netrunner
//:: Created on: 19/10/2010
//:://////////////////////////////////////////////

#include "inc_tattoo"

int StartingConditional(string sTattooTag)
{
	object oPC = GetPCSpeaker();
	if (getTattooCount(oPC) > 0)
	{
		//if tag is empty, return always true. Else check for that tag
		if (sTattooTag == "")
		{
			return TRUE;
		}
		else
		{
			if (findTattoo(oPC, sTattooTag) != OBJECT_INVALID)
			{
				return TRUE;
			}
			else
			{
				return FALSE;
			}
		}
	}
	else
	{
		return FALSE;
	}
}