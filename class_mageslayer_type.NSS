
const int CLASS_TYPE_MAGE_SLAYER = 70;



void main()
{
	object oPC = OBJECT_SELF;
	int nSpellId = GetSpellId();
	int nDamageBonus = (GetLevelByClass(CLASS_TYPE_MAGE_SLAYER, oPC) + 1) / 3;
	int nDamageType = DAMAGE_TYPE_POSITIVE;
	if (nSpellId == 14718) nDamageType = DAMAGE_TYPE_DIVINE;
	if (nSpellId == 14719) nDamageType = DAMAGE_TYPE_MAGICAL;
	if (nDamageBonus > 0)
	{
		effect eDam	= EffectDamageIncrease(nDamageBonus, nDamageType);
		eDam = ExtraordinaryEffect(eDam);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDam, oPC);
	}
}