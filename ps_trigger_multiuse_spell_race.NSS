#include "ff_safevar"

//Script by Dedic8ed
/*This script is designed to be used by a placed trigger, and will be fired by all entering objects
  which match the designated racial type (i.e., elf, goblinoid, vermin, etc.) It can actually be assigned up 
  to three spells to fire.
*/

void main()
{
	object oPC = GetEnteringObject();;
	int iPCRace = GetRacialType(oPC);
//These designate the placeable object from which the spell will originate. The placeable must be set to "hostile".

	int iRace = PS_GetLocalInt(OBJECT_SELF,"race");
//Designates the subrace this trigger will work for

	int iSpell = PS_GetLocalInt(OBJECT_SELF,"spell1");
	int iSpell2 = PS_GetLocalInt(OBJECT_SELF,"spell2");
	int iSpell3 = PS_GetLocalInt(OBJECT_SELF,"spell3");
//Designates what spells will be cast. Use spell IDs from spells.2da

	if (iRace != iPCRace) return;
	
AssignCommand(oPC, ActionCastSpellAtObject(iSpell, oPC, METAMAGIC_NONE, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));	

AssignCommand(oPC, ActionCastSpellAtObject(iSpell2, oPC, METAMAGIC_NONE, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));	

AssignCommand(oPC, ActionCastSpellAtObject(iSpell3, oPC, METAMAGIC_NONE, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));	

}