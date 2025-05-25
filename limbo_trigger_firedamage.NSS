

void main ()
{
	object oObject = GetEnteringObject();
	if (GetLocalInt(oObject, "LIMBO_IMMUNE") > 0)
		return;
		
	int nDam = d6(6);
	effect damage = EffectDamage(nDam, DAMAGE_TYPE_FIRE, DAMAGE_POWER_ENERGY);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, damage, oObject);

}