//Plays a nwn2 vfx at the location of the target
//whose tag is specified
//If sTarg is blank, use pc speaker
//vfx string is the name of the effect file
//uses EffectNWN2SpecialEffectFile()
//vfx is temporary, lasting one second

void main (string sVFX, string sTarg) {

	object oTarget;
	if (sTarg == "")
		oTarget = GetPCSpeaker();
	else
		oTarget = GetNearestObjectByTag(sTarg);
	
	effect eEffect = EffectNWN2SpecialEffectFile(sVFX);
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eEffect, GetLocation(oTarget), 1.0f);
	
}