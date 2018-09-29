// kills the object being talked to

void main()
{
	object oTarget = GetObjectByTag("ps_carceri_captive");
	effect eDeath = EffectDeath(FALSE, FALSE, TRUE, TRUE);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);
}