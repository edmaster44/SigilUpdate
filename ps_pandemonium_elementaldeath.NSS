void main () {

	//DeathScript
	object oPC = GetFirstObjectInShape(SHAPE_SPHERE, 10.0f, GetLocation(OBJECT_SELF));
	while (GetIsObjectValid(oPC)) {
	
		int nDam = d6(15);
		if (FortitudeSave(oPC, 25, SAVING_THROW_TYPE_SONIC, OBJECT_SELF)) {
			nDam = nDam/2;
		}
		
		effect eDam = EffectDamage(nDam, DAMAGE_TYPE_SONIC);
		ApplyEffectToObject(0, eDam, oPC);
	
		oPC = GetNextObjectInShape(SHAPE_SPHERE, 10.0f, GetLocation(OBJECT_SELF));
	}

}