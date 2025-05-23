void main()
{
	object oPC = GetItemActivator();
	//SendMessageToPC(oPC, "Smoking kills.");
   	SetCollision(oPC, FALSE);
	ClearAllActions();

	// Slow the Animation down to half speed..
	PlayCustomAnimation(oPC, "smoking", FALSE, 0.5f);
	
	effect eSmoke = EffectNWN2SpecialEffectFile("fx_smoking_exhale");

	// Wait the "puff" keyframe is about 2 seconds in
    DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSmoke, oPC, 0.5f));
}