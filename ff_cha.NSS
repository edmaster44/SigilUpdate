#include "ff_safevar"

/*
Used to raise one ability of humans and half elves by 1 after char creation, chosen via dialog
*/

void main()
{
	int nAbility = ABILITY_CHARISMA;
 	int nCurrent = GetAbilityScore(OBJECT_SELF, nAbility);
    SetBaseAbilityScore(OBJECT_SELF, nAbility, nCurrent + 1);
	
	object oEss = GetItemPossessedBy(OBJECT_SELF, "ps_essence");
	PS_SetLocalInt(oEss, "startability", TRUE);
}