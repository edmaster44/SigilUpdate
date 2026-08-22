 


/*
Used to raise one ability of humans and half elves by 1 after char creation, chosen via dialog
*/

void main(int nAbility){
 	int nCurrent = GetAbilityScore(OBJECT_SELF, nAbility, TRUE);
    SetBaseAbilityScore(OBJECT_SELF, nAbility, nCurrent + 1);
	
	object oEss = GetItemPossessedBy(OBJECT_SELF, "ps_essence");
	int nAdjustments = GetLocalInt(oEss, "startability");
	SetLocalInt(oEss, "startability", nAdjustments + 1);
}