#include "lycantrope_stats"

void main()
{
	object oPC = OBJECT_SELF;
	if (GetAppearanceType(oPC) == APPEARANCE_TYPE_HUMAN)
		applyPenalties(oPC);
}