void main () {

	if (GetLocalInt(OBJECT_SELF, "initialized") == 0)
	{
		effect spawn = EffectNWN2SpecialEffectFile("fx_magical_explosion", OBJECT_SELF);
		ApplyEffectToObject(0, spawn, OBJECT_SELF);
		SetLocalInt(OBJECT_SELF, "initialized", 1);
		return;
	}

	object potentialHostile = GetFirstObjectInShape(SHAPE_SPHERE, 20.0f, GetLocation(OBJECT_SELF), TRUE, OBJECT_TYPE_CREATURE);
	int attackBonus = GetLocalInt(OBJECT_SELF, "AB");
	int damageDice = GetLocalInt(OBJECT_SELF, "DAMAGE");
	while (GetIsObjectValid(potentialHostile))
	{
		if (GetFactionEqual(OBJECT_SELF, potentialHostile))
		{
			potentialHostile = GetNextObjectInShape(SHAPE_SPHERE, 20.0f, GetLocation(OBJECT_SELF), TRUE, OBJECT_TYPE_CREATURE);
			continue;
		}
			
		int nRoll = d20();
		ActionCastSpellAtObject(844, potentialHostile);
		if ((attackBonus+nRoll) > GetAC(potentialHostile))
		{
			SendMessageToPC(potentialHostile, "Attack: "+IntToString(attackBonus)+" + "+IntToString(nRoll)+" = "+IntToString((attackBonus+nRoll))+" \n The ray hits!");
			effect damage = EffectDamage(d6(damageDice));
			ApplyEffectToObject(0, damage, potentialHostile);
		}
		break;
		
		potentialHostile = GetNextObjectInShape(SHAPE_SPHERE, 20.0f, GetLocation(OBJECT_SELF), TRUE, OBJECT_TYPE_CREATURE);
	}
}