void RunTaunt(object oPC, object oTARGET, float fDUR, int nINTERRUPT = TRUE, int nPVP = TRUE, int nSTART = TRUE)
{	
	if (nSTART == TRUE)
	{
		if ((nPVP != TRUE) && (GetIsPC(oTARGET) == TRUE)) return;
		if (GetLocalObject(oTARGET, "TAUNT_SOURCE") != OBJECT_INVALID) return;
		if (nINTERRUPT == TRUE) AssignCommand(oTARGET, ClearAllActions());
		effect eTAUNT = ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_TAUNT));
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTAUNT, oTARGET, fDUR);
		SetLocalObject(oTARGET, "TAUNT_SOURCE", oPC);	
	}
	if (fDUR <= 0.0f)
	{
		DeleteLocalObject(oTARGET, "TAUNT_SOURCE");
		return;
	}
	if ((GetAttackTarget(oTARGET) != oPC))
	{
		if (GetCurrentAction(oTARGET) != ACTION_CASTSPELL) AssignCommand(oTARGET, ClearAllActions());
		AssignCommand(oTARGET, ActionAttack(oPC));
	}
	DelayCommand(0.5, RunTaunt(oPC, oTARGET, fDUR - 0.5, nINTERRUPT, nPVP, FALSE));
}

void main()
{
	object oPC = OBJECT_SELF;
	location lPC = GetLocation(oPC);
	effect eVFX = EffectVisualEffect(VFX_HIT_AOE_SONIC);
	
	ActionPlayAnimation(ANIMATION_FIREFORGET_TAUNT);
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVFX, lPC);
	
	float fRADIUS = RADIUS_SIZE_HUGE;
	int nCON = GetAbilityModifier(ABILITY_CONSTITUTION, oPC);
	int nDC = 5 + GetSkillRank(SKILL_TAUNT, oPC);
	int nDEFEND = GetLevelByClass(180, oPC);
	if (nDEFEND >= 9) fRADIUS = RADIUS_SIZE_TREMENDOUS;
	effect eHP = EffectTemporaryHitpoints(8 + 1 * nCON);
	eHP = EffectLinkEffects(eHP, EffectVisualEffect(VFX_DUR_SPELL_AID));
	eHP = ExtraordinaryEffect(eHP);
	
	effect ePEN = EffectSkillDecrease(SKILL_HIDE, 50);	
	ePEN = EffectLinkEffects(ePEN, EffectSkillDecrease(SKILL_MOVE_SILENTLY, 50));
	ePEN = ExtraordinaryEffect(ePEN);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePEN, oPC, 24.0);
	
	object oTARGET = GetFirstObjectInShape(SHAPE_SPHERE, fRADIUS, lPC, TRUE);
	while (oTARGET != OBJECT_INVALID)
	{
		if (GetIsEnemy(oTARGET, oPC) == TRUE)
		{
			if (GetIsPC(oTARGET) == FALSE)
			{
				
					RunTaunt(oPC, oTARGET, 12.0, FALSE, FALSE);
				
			}	
		}
		else if (nDEFEND >= 3) ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, oTARGET, 24.0);
		oTARGET = GetNextObjectInShape(SHAPE_SPHERE, fRADIUS, lPC, TRUE);
	}
}