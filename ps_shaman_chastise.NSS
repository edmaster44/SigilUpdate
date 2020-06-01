// Used by nx_s2_chastisespirits and nx_s2_weakenspirits

int IsValidChastiseTarget(object oTarget)
{
	if(GetIsSpirit(oTarget))
		return 1;
		
	int race = GetRacialType(oTarget);
	switch(race) {
	case RACIAL_TYPE_ELEMENTAL:
	case RACIAL_TYPE_FEY:
	case RACIAL_TYPE_INCORPOREAL:
	case RACIAL_TYPE_OUTSIDER:
	case RACIAL_TYPE_UNDEAD:
		return 1;
	}
	
	return 0;
}