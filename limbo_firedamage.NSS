

void main ()
{
	object oObject = GetFirstObjectInShape(SHAPE_SPHERE, 20.0f, GetLocation(OBJECT_SELF));
	while (GetIsObjectValid(oObject))
	{
		if (GetObjectType(oObject) == OBJECT_TYPE_CREATURE && GetLocalInt(oObject, "LIMBO_IMMUNE") == 0)
		{
			int nDam = d6(6);
			effect damage = EffectDamage(nDam, DAMAGE_TYPE_FIRE, DAMAGE_POWER_ENERGY);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, damage, oObject);
		}
		oObject = GetNextObjectInShape(SHAPE_SPHERE, 20.0f, GetLocation(OBJECT_SELF));
	}
}