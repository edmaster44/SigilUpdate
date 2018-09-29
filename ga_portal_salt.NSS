void main()
{
	float fDur = 30.0;
	effect ePort = EffectNWN2SpecialEffectFile("fx_geyser");
	location lPortal = GetLocation(GetObjectByTag("bjwp_saltport"));
	object oPort = CreateObject(OBJECT_TYPE_PLACEABLE, "ps_plac_port_salt01", lPortal);
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, ePort, lPortal, fDur);
	DelayCommand(fDur, DestroyObject(oPort));
}