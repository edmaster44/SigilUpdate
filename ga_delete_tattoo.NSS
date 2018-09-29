//::///////////////////////////////////////////////
//:: [ga_delete_tattoo.nss]
//:: Copyright (c) 2010 SCoD
//:://////////////////////////////////////////////
//:: Deletes the specified tattoo from the character
//:://////////////////////////////////////////////
//:: Created by: Netrunner
//:: Created on: 19/10/2010
//:://////////////////////////////////////////////

#include "inc_tattoo"


void main(string sTattooTag)
{
	object oPC=GetPCSpeaker();
	//delete the specified Tattoo
	removeTattoo(oPC, sTattooTag);
	ExportSingleCharacter(oPC);
}