// Deals with adding and removing penalties for lycantropes in human form. By Electrohydra.
// Called in ps_srr_changes and ps_srr_humanfraily

void applyPenalties(object oPC)
{
	int race = GetSubRace(oPC);
	if (!GetHasSpellEffect(1332, oPC)) // Only apply penalties if penalties not already applied
	{
		if (race == 144) // Werewolf
		{
			effect STRpen = ExtraordinaryEffect(EffectAbilityDecrease(ABILITY_STRENGTH, 2));
			effect DEXpen = ExtraordinaryEffect(EffectAbilityDecrease(ABILITY_DEXTERITY, 4));
			effect CONpen = ExtraordinaryEffect(EffectAbilityDecrease(ABILITY_CONSTITUTION, 2));
		
			effect eLink = SetEffectSpellId(EffectLinkEffects(STRpen, EffectLinkEffects(DEXpen, CONpen)), 1332);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC, 0.0f);
		}
		else // wererat
		{
			effect DEXpen = ExtraordinaryEffect(EffectAbilityDecrease(ABILITY_DEXTERITY, 6));
			effect CONpen = ExtraordinaryEffect(EffectAbilityDecrease(ABILITY_CONSTITUTION, 2));
		
			effect eLink = SetEffectSpellId(EffectLinkEffects(DEXpen, CONpen), 1332);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC, 0.0f);
		}
	}
}

void removePenalties(object oPC)
{	
	effect penalty = GetFirstEffect(oPC);
	while (GetIsEffectValid(penalty))
	{					// Human Frailty
		if (GetEffectSpellId(penalty) == 1332)
		{
			RemoveEffect(oPC, penalty);
			return;
		}
		penalty = GetNextEffect(oPC);
	}
}