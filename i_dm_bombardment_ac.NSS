//
/*
   Template for an Activate item script.
   This script will run each time an item's "custom activation" is used.
   
   How to use this script:
   Item needs an item property that will cause a custom activation such as Cast Spell:Unique Power
   
*/
void main()
{
    object oDM      = GetItemActivator();
	
	if (!GetIsDM(oDM)) //DM Only
		return;
		
    object oItem    = GetItemActivated();
	location lTarget 	= GetItemActivatedTargetLocation();
	float fDistance = 5.0f;
	
	object oTarget = GetItemActivatedTarget();
	location lSource = GetLocation(oDM);
	float fTravelTime = GetProjectileTravelTime( lSource, lTarget, PROJECTILE_PATH_TYPE_DEFAULT );
	int nEffect = 116;
	int nLandingEffect = 905;
	
	SpawnSpellProjectile(oDM, oTarget, lSource, lTarget, nEffect, PROJECTILE_PATH_TYPE_DEFAULT);
	effect eImpact = EffectVisualEffect(nLandingEffect);
	DelayCommand(fTravelTime, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget, 0.0f));
	
	fTravelTime += 0.1f;
	
	object oCreature = GetFirstObjectInShape(SHAPE_SPHERE, fDistance, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oCreature)) {
	
		int nBlud = d6(15);
		int nFire = d6(20);
		
		if (d100() <= 5) {
			nBlud *= 2;
			nFire *= 2;
		}
		
		effect eDam = EffectDamage(nBlud, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_NORMAL, TRUE);
		eDam = EffectLinkEffects(EffectDamage(nFire, DAMAGE_TYPE_FIRE), eDam);
		DelayCommand(fTravelTime, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oCreature));
	
		oCreature = GetNextObjectInShape(SHAPE_SPHERE, fDistance, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	} 
	
}