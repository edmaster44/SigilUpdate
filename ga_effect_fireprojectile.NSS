void main(int nEffect, int nLandingEffect, string sSource, string sTarget) {

	object oTarget = GetNearestObjectByTag(sTarget);
	object oSource = GetNearestObjectByTag(sSource);
	location lTarget = GetLocation(oTarget);
	location lSource = GetLocation(oSource);
	float fTravelTime = GetProjectileTravelTime( lSource, lTarget, PROJECTILE_PATH_TYPE_DEFAULT );
	
	SpawnSpellProjectile(oSource, oTarget, lSource, lTarget, nEffect, PROJECTILE_PATH_TYPE_DEFAULT);
	effect eImpact = EffectVisualEffect(nLandingEffect);
	DelayCommand(fTravelTime, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget, 0.0f));
					

}