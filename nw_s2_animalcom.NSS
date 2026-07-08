 
//::///////////////////////////////////////////////
//:: Summon Animal Companion
//:: NW_S2_AnimalComp
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This spell summons a Druid's animal companion
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 27, 2001
//:://////////////////////////////////////////////
#include "nw_s2_animalcom_inc"


void main(){
    SummonAnimalCompanion();
	
	object oPC = OBJECT_SELF;
	object oCompanion = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oPC);
	NatureWarriorCompanion(oPC, oCompanion);
	
}