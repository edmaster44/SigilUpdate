//::///////////////////////////////////////////////
//:: [ga_create_tattoo.nss]
//:: Copyright (c) 2010 SCoD
//:://////////////////////////////////////////////
//:: Creates the specified tattoo on the Character
//:://////////////////////////////////////////////
//:: Created by: Netrunner
//:: Created on: 19/10/2010
//:://////////////////////////////////////////////

#include "inc_tattoo"


void main(string sTattooTag)
{
	object oPC=GetPCSpeaker();
	//create the specified Tattoo
	createTattooOnCreature(sTattooTag, oPC);
	ExportSingleCharacter(oPC);
}