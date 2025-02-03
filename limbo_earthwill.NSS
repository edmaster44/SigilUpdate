void main ()
{
	object oPC = GetEnteringObject();
	int nStatus = GetLocalInt(oPC, "dr_"+GetTag(OBJECT_SELF));
	object oDoor = GetNearestObjectByTag("dr_"+GetTag(OBJECT_SELF));
	if (nStatus != 1 && GetIsObjectValid(oDoor))
	{
		int nWis = GetWillSavingThrow(oPC);
		int nRoll = d20();
		if ((nWis+nRoll) >= 20)
		{
			SendMessageToPC(oPC, "Will Roll: "+IntToString(nWis)+"+"+IntToString(nRoll)+"="+IntToString(nWis+nRoll)+" Success!");
			AssignCommand(oPC, ActionSpeakString("<i>"+GetName(oPC)+" moves the rock out of the passage through sheer willpower.</i>"));
			effect eDust = EffectNWN2SpecialEffectFile("fx_rockslide");
			effect eQuake = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE); //VFX_FNF_SCREEN_SHAKE
			ApplyEffectAtLocation(0, eDust, GetLocation(oDoor));
			ApplyEffectAtLocation(1, eQuake, GetLocation(oDoor), 1.0f);
			DestroyObject(oDoor);
		}
		else
		{
			SendMessageToPC(oPC, "Wisdom Roll: "+IntToString(nWis)+"+"+IntToString(nRoll)+"="+IntToString(nWis+nRoll)+" Failure.");
			SetLocalInt(oPC, "dr_"+GetTag(OBJECT_SELF), 1);
		}
	}
}