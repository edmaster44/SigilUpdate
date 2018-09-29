void main()
{
	object oPC = OBJECT_SELF;
	effect eFX = EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK);
	eFX = ExtraordinaryEffect(eFX);
	DelayCommand(0.0f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, oPC));
	
	//The Old Script
	/*int nID = GetSpellId();
	if (GetHasSpellEffect(nID, oPC)==TRUE) return;
	effect eFX = EffectAreaOfEffect(88);
	eFX = ExtraordinaryEffect(eFX);
	DelayCommand(0.0f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFX, oPC));*/
}