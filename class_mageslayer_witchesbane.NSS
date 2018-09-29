const int CLASS_TYPE_MAGE_SLAYER = 70;

void main()
{
	int charLevel = GetTotalLevels(OBJECT_SELF, TRUE);
	int classLevels = GetLevelByClass(CLASS_TYPE_MAGE_SLAYER, OBJECT_SELF);
	
	effect SR = SupernaturalEffect(EffectSpellResistanceIncrease(5 + charLevel + 2*classLevels, -1));
	
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, SR, OBJECT_SELF);
}