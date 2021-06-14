const int CLASS_TYPE_MAGE_SLAYER = 70;

void main()
{
	int charLevel = GetTotalLevels(OBJECT_SELF, TRUE);
	int classLevels = GetLevelByClass(CLASS_TYPE_MAGE_SLAYER, OBJECT_SELF);
	
	effect eSR = SupernaturalEffect(EffectSpellResistanceIncrease(5 + charLevel + 3*classLevels, -1));
	effect eMS = EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE);
	effect eLink = EffectLinkEffects(eSR, eMS);
	eLink = SupernaturalEffect(eLink);
	
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, OBJECT_SELF);
}