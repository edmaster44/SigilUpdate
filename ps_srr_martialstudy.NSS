// All the required scripts for the Martial Study feats.
// By Electrohydra
// Last update 2015-03-02

#include "nw_i0_spells"
#include "x2_inc_spellhook"
#include "x2_i0_spells"
#include "ps_inc_functions"

// checks to see if the target of the feat is withing melee range. If not, reset the feat and return FALSE
int CancelIfNotInMeleeRange(object oCaller, object oTarget, int nFeatID)
{
	if (GetDistanceBetween(oCaller, oTarget) > 3.5f) // Melee range seems to be around a little less then 3.0f, so picked a number
	{                                              // a little higher to give some loose.
		SendMessageToPC(oCaller, "Target out of range.");
		ResetFeatUses(oCaller, nFeatID, FALSE, TRUE);
		return FALSE;
	}	
	return TRUE;
}

void DesertWind1(object oCaller) // Applies a Haste effect to the caller for 2 round
{		
	SendMessageToPC(oCaller, "Using <i>Flashing Sun.</i>");
	
	// Apply VFX
	effect vfx = EffectVisualEffect(VFX_HIT_BARD_INS_COMPETENCE);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, vfx, oCaller, 0.0f);
	
	// apply effect
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectHaste(), oCaller, 60.0f);
	
	// Initiates an attack against current target
	object currentTarget = GetPlayerCurrentTarget(oCaller);
	if (GetObjectType(currentTarget) == OBJECT_TYPE_CREATURE && GetIsEnemy(currentTarget, oCaller))
	{
		ActionAttack(currentTarget);
	}
}

void DesertWind2(object oCaller) // Gives the equiped weapons or gloves fire damage for one round.
{
	SendMessageToPC(oCaller, "Using <i>Burning Blade.</i>");

	// adds damage to character (to make it irresistable)
	effect fireDamage2 = EffectDamageIncrease(DAMAGE_BONUS_8, DAMAGE_TYPE_FIRE);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, fireDamage2, oCaller, 12.0f);
	
	// Apply a vfx
	effect vfx = EffectVisualEffect(VFX_HIT_SPELL_FIRE);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, vfx, oCaller, 0.0f);
	
		// Initiates an attack against current target
	object currentTarget = GetPlayerCurrentTarget(oCaller);
	if (GetObjectType(currentTarget) == OBJECT_TYPE_CREATURE && GetIsEnemy(currentTarget, oCaller))
	{
		ActionAttack(currentTarget);
	}
}

void DesertWind3(object oCaller, object oTarget) // Throws a ball of fire at the target.
{
	SendMessageToPC(oCaller, "Using <i>Fan the Flames.</i>");
	int numberOfDice = GetTotalLevels(oCaller, TRUE) ;
	int ECL 	= StringToInt(PS_GetEssenceECL(OBJECT_SELF));
	int touchAttackResult = TouchAttackRanged(oTarget, TRUE, 0);
	int touchAttackResultSTR = TouchAttackMelee(oTarget, TRUE, 0);
	int STR = GetAbilityModifier(ABILITY_STRENGTH);
	int DEX = GetAbilityModifier(ABILITY_DEXTERITY);
	
	if (DEX > STR)

	{	if (touchAttackResult == TOUCH_ATTACK_RESULT_MISS)
		{
			return;
		}
		if (touchAttackResult == TOUCH_ATTACK_RESULT_CRITICAL)
		{
			numberOfDice = (numberOfDice * 2) + (ECL*2);
		}
		int iDamage = d8(numberOfDice + ECL) + PS_AddSneakDmgToSpell(oCaller, oTarget, DAMAGE_TYPE_FIRE);
		effect eDamage = EffectDamage(iDamage, DAMAGE_TYPE_FIRE, DAMAGE_POWER_NORMAL, FALSE);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget, 0.0f);
	}
	else
	{
		if (touchAttackResultSTR == TOUCH_ATTACK_RESULT_MISS)
		{
			return;
		}
		if (touchAttackResultSTR == TOUCH_ATTACK_RESULT_CRITICAL)
		{
			numberOfDice = (numberOfDice * 2) + (ECL*2);
		}
		int iDamage = d8(numberOfDice + ECL) + PS_AddSneakDmgToSpell(oCaller, oTarget, DAMAGE_TYPE_FIRE);
		effect eDamage = EffectDamage(iDamage, DAMAGE_TYPE_FIRE, DAMAGE_POWER_NORMAL, FALSE);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget, 0.0f);
		}
}

void DiamondMind1(object oCaller, object oTarget) // If concentration check succeeds, targets gets -HisDEX (min 3) to AC for 2 round
{
	if (CancelIfNotInMeleeRange(oCaller, oTarget, 2913))
	{
		SendMessageToPC(oCaller, "Using <i>Sapphire Nightmare Blade.</i>");
		// Success if concentration VS target's AC
		if (GetIsSkillSuccessful(oCaller, SKILL_CONCENTRATION, GetAC(oTarget), TRUE))
		{
			int ACpen = GetAbilityModifier(ABILITY_DEXTERITY, oTarget);
			if (ACpen < 3)
				ACpen = 3;
			effect ACdecrease = EffectACDecrease(ACpen);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ACdecrease, oTarget, 30.0f);
			
			// Apply a vfx
			effect vfx = EffectVisualEffect(VFX_HIT_BARD_INS_REGENERATION);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, vfx, oTarget, 0.0f);
		}
	}
	
		// Initiates an attack against current target
	object currentTarget = oTarget;
	if (GetObjectType(currentTarget) == OBJECT_TYPE_CREATURE && GetIsEnemy(currentTarget, oCaller))
	{
		ActionAttack(currentTarget);
	}
}

void DiamondMind2(object oCaller) // Increases all base saves to the value of the user's concentration ranks for 2 rounds.
{
	SendMessageToPC(oCaller, "Using <i>Action Before Thought.</i>");
	int concentration = GetSkillRank(SKILL_CONCENTRATION, oCaller, TRUE);
	int reflex = GetReflexSavingThrow(oCaller);
	int fortitude = GetFortitudeSavingThrow(oCaller);
	int will = GetWillSavingThrow(oCaller);
	
	effect reflexBoost = EffectSavingThrowIncrease(SAVING_THROW_REFLEX, concentration - reflex, SAVING_THROW_TYPE_ALL, FALSE);
	effect fortBoost = EffectSavingThrowIncrease(SAVING_THROW_FORT, concentration - fortitude, SAVING_THROW_TYPE_ALL, FALSE);
	effect willBoost = EffectSavingThrowIncrease(SAVING_THROW_WILL, concentration - will, SAVING_THROW_TYPE_ALL, FALSE);
	
	if ((concentration - reflex) > 0)
	{
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, reflexBoost, oCaller, 30.0f);
	}
		if ((concentration - fortitude) > 0)
	{
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, fortBoost, oCaller, 30.0f);
	}
		if ((concentration - will) > 0)
	{
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, willBoost, oCaller, 30.0f);
	}
	
		// Apply a vfx
			effect vfx = EffectVisualEffect(VFX_HIT_BARD_INS_COMPETENCE);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, vfx, oCaller, 0.0f);
			
		// Initiates an attack against current target
	object currentTarget = GetPlayerCurrentTarget(oCaller);
	if (GetObjectType(currentTarget) == OBJECT_TYPE_CREATURE && GetIsEnemy(currentTarget, oCaller))
	{
		ActionAttack(currentTarget);
	}
}

void DiamondMind3(object oCaller) // Increases damage by 1/5 of a concentration check for 2 round.
{
	SendMessageToPC(oCaller, "Using <i>Insightful Strike.</i>");
	int damageBonus = (d20(1) + GetSkillRank(SKILL_CONCENTRATION, oCaller, FALSE))/5;
	if (damageBonus > 5) // Number fixing so the constants line up...
	{
		damageBonus = damageBonus + 10;
	}
	effect damageIncrease = EffectDamageIncrease(damageBonus, DAMAGE_TYPE_MAGICAL); // Set to magical so it will bypass DR
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, damageIncrease, oCaller, 18.0f);
	
	// Apply a vfx
	effect vfx = EffectVisualEffect(VFX_HIT_BARD_INS_COURAGE);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, vfx, oCaller, 0.0f);
	
		// Initiates an attack against current target
	object currentTarget = GetPlayerCurrentTarget(oCaller);
	if (GetObjectType(currentTarget) == OBJECT_TYPE_CREATURE && GetIsEnemy(currentTarget, oCaller))
	{
		ActionAttack(currentTarget);
	}
}

void IronHeart1(object oCaller) // +4 AB, -1 AC for 2 rounds.
{
	SendMessageToPC(oCaller, "Using <i>Steely Strike.</i>");
	effect attackBonus = EffectAttackIncrease(4);
	effect ACdecrease = EffectACDecrease(1);
	
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, attackBonus, oCaller, 12.0f);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ACdecrease, oCaller, 12.0f);
	
	// Apply a vfx
	effect vfx = EffectVisualEffect(VFX_HIT_BARD_INS_COURAGE);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, vfx, oCaller, 0.0f);	
	
		// Initiates an attack against current target
	object currentTarget = GetPlayerCurrentTarget(oCaller);
	if (GetObjectType(currentTarget) == OBJECT_TYPE_CREATURE && GetIsEnemy(currentTarget, oCaller))
	{
		ActionAttack(currentTarget);
	}
}

void IronHeart2(object oCaller, object oTarget) //  Give the target -4 damage and -2 AB for 4 rounds if you hit a touch attack
{
	if (CancelIfNotInMeleeRange(oCaller, oTarget, 2917))
	{
		SendMessageToPC(oCaller, "Using <i>Exorcism of Steel.</i>");
		int touchAttackResult = TouchAttackMelee(oTarget, TRUE, 0);
		
		if (touchAttackResult)
		{
			effect damageReduced = EffectDamageDecrease(4, DAMAGE_TYPE_ALL);
			effect ABdecrease = EffectAttackDecrease(4);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectLinkEffects(ABdecrease, damageReduced), oTarget, 30.0f);
			
			// Apply a vfx
			effect vfx = EffectVisualEffect(VFX_HIT_BARD_INS_JARRING);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, vfx, oTarget, 0.0f);	
		}
	}
	
		// Initiates an attack against current target
	object currentTarget = oTarget;
	if (GetObjectType(currentTarget) == OBJECT_TYPE_CREATURE && GetIsEnemy(currentTarget, oCaller))
	{
		ActionAttack(currentTarget);
	}
}

void IronHeart3(object oCaller) // Removes a debuff from the caller
{
	SendMessageToPC(oCaller, "Using <i>Iron Heart Surge.</i>");
	// Cycles through all the effects on the caller for the worst kind of effect, removing it if it
	// finds it. If not, moves on to the next worst kind of effect, etc etc.
	
	int found = FALSE; //Used to see if an effect of the type was found.
	
	// Apply a vfx
	effect vfx = EffectVisualEffect(VFX_HIT_BARD_INS_DEFENSE);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, vfx, oCaller, 0.0f);	

	
	// Blind
	effect penalty = GetFirstEffect(oCaller);
	while (GetIsEffectValid(penalty))
	{
		if (GetEffectType(penalty) == EFFECT_TYPE_BLINDNESS) 
		{
			RemoveEffect(oCaller, penalty);
			found = TRUE;
		}
		penalty = GetNextEffect(oCaller);
	}
	if (found) return;
	
		// Slow
	penalty = GetFirstEffect(oCaller);
	while (GetIsEffectValid(penalty))
	{
		if (GetEffectType(penalty) == EFFECT_TYPE_SLOW)
		{
			RemoveEffect(oCaller, penalty);
						found = TRUE;
		}
		penalty = GetNextEffect(oCaller);
	}
	if (found) return;
	
	// Entangle
	penalty = GetFirstEffect(oCaller);
	while (GetIsEffectValid(penalty))
	{
		if (GetEffectType(penalty) == EFFECT_TYPE_ENTANGLE) 
		{
			RemoveEffect(oCaller, penalty);
						found = TRUE;
		}
		penalty = GetNextEffect(oCaller);
	}
	if (found) return;
	
		// Damage over time
	penalty = GetFirstEffect(oCaller);
	while (GetIsEffectValid(penalty))
	{
		if (GetEffectType(penalty) == EFFECT_TYPE_DAMAGEOVERTIME) 
		{
			RemoveEffect(oCaller, penalty);
						found = TRUE;
		}
		penalty = GetNextEffect(oCaller);
	}
	if (found) return;
	
	// Wounding
	penalty = GetFirstEffect(oCaller);
	while (GetIsEffectValid(penalty))
	{
		if (GetEffectType(penalty) == EFFECT_TYPE_WOUNDING) 
		{
			RemoveEffect(oCaller, penalty);
						found = TRUE;
		}
		penalty = GetNextEffect(oCaller);
	}
	if (found) return;
	
		// Negative Level
	penalty = GetFirstEffect(oCaller);
	while (GetIsEffectValid(penalty))
	{
		if (GetEffectType(penalty) == EFFECT_TYPE_NEGATIVELEVEL) 
		{
			RemoveEffect(oCaller, penalty);
						found = TRUE;
		}
		penalty = GetNextEffect(oCaller);
	}
	if (found) return;
	
		// AC decrease
	penalty = GetFirstEffect(oCaller);
	while (GetIsEffectValid(penalty))
	{
		if (GetEffectType(penalty) == EFFECT_TYPE_AC_DECREASE) 
		{
			RemoveEffect(oCaller, penalty);
						found = TRUE;
		}
		penalty = GetNextEffect(oCaller);
	}
	if (found) return;
	
	
		// Saving throw decrease
	penalty = GetFirstEffect(oCaller);
	while (GetIsEffectValid(penalty))
	{
		if (GetEffectType(penalty) == EFFECT_TYPE_SAVING_THROW_DECREASE) 
		{
			RemoveEffect(oCaller, penalty);
						found = TRUE;
		}
		penalty = GetNextEffect(oCaller);
	}
	if (found) return;
	
		// Curse
	penalty = GetFirstEffect(oCaller);
	while (GetIsEffectValid(penalty))
	{
		if (GetEffectType(penalty) == EFFECT_TYPE_CURSE) 
		{
			RemoveEffect(oCaller, penalty);
						found = TRUE;
		}
		penalty = GetNextEffect(oCaller);
	}
	if (found) return;
	
		// Silence
	penalty = GetFirstEffect(oCaller);
	while (GetIsEffectValid(penalty))
	{
		if (GetEffectType(penalty) == EFFECT_TYPE_SILENCE) 
		{
			RemoveEffect(oCaller, penalty);
						found = TRUE;
		}
		penalty = GetNextEffect(oCaller);
	}
	if (found) return;
	
		// Ability decrease
	penalty = GetFirstEffect(oCaller);
	while (GetIsEffectValid(penalty))
	{
		if (GetEffectType(penalty) == EFFECT_TYPE_ABILITY_DECREASE) 
		{
			RemoveEffect(oCaller, penalty);
						found = TRUE;
		}
		penalty = GetNextEffect(oCaller);
	}
	if (found) return;
	
		// Miss Chance
	penalty = GetFirstEffect(oCaller);
	while (GetIsEffectValid(penalty))
	{
		if (GetEffectType(penalty) == EFFECT_TYPE_MISS_CHANCE) 
		{
			RemoveEffect(oCaller, penalty);
						found = TRUE;
		}
		penalty = GetNextEffect(oCaller);
	}
	if (found) return;
	
		// Attack decrease
	penalty = GetFirstEffect(oCaller);
	while (GetIsEffectValid(penalty))
	{
		if (GetEffectType(penalty) == EFFECT_TYPE_ATTACK_DECREASE) 
		{
			RemoveEffect(oCaller, penalty);
						found = TRUE;
		}
		penalty = GetNextEffect(oCaller);
	}
	if (found) return;
	
		// Damage decrease
	penalty = GetFirstEffect(oCaller);
	while (GetIsEffectValid(penalty))
	{
		if (GetEffectType(penalty) == EFFECT_TYPE_DAMAGE_DECREASE) 
		{
			RemoveEffect(oCaller, penalty);
						found = TRUE;
		}
		penalty = GetNextEffect(oCaller);
	}
	if (found) return;
	
		// Spell resistance decreased
	penalty = GetFirstEffect(oCaller);
	while (GetIsEffectValid(penalty))
	{
		if (GetEffectType(penalty) == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE) 
		{
			RemoveEffect(oCaller, penalty);
						found = TRUE;
		}
		penalty = GetNextEffect(oCaller);
	}
	if (found) return;
	
		// deaf
	penalty = GetFirstEffect(oCaller);
	while (GetIsEffectValid(penalty))
	{
		if (GetEffectType(penalty) == EFFECT_TYPE_DEAF) 
		{
			RemoveEffect(oCaller, penalty);
						found = TRUE;
		}
		penalty = GetNextEffect(oCaller);
	}
	if (found) return;
	
		// Poison
	penalty = GetFirstEffect(oCaller);
	while (GetIsEffectValid(penalty))
	{
		if (GetEffectType(penalty) == EFFECT_TYPE_POISON) 
		{
			RemoveEffect(oCaller, penalty);
						found = TRUE;
		}
		penalty = GetNextEffect(oCaller);
	}
	if (found) return;
	
		// Disease
	penalty = GetFirstEffect(oCaller);
	while (GetIsEffectValid(penalty))
	{
		if (GetEffectType(penalty) == EFFECT_TYPE_DISEASE) 
		{
			RemoveEffect(oCaller, penalty);
						found = TRUE;
		}
		penalty = GetNextEffect(oCaller);
	}
	if (found) return;
	
		// Skill Decrease
	penalty = GetFirstEffect(oCaller);
	while (GetIsEffectValid(penalty))
	{
		if (GetEffectType(penalty) == EFFECT_TYPE_SKILL_DECREASE) 
		{
			RemoveEffect(oCaller, penalty);
						found = TRUE;
		}
		penalty = GetNextEffect(oCaller);
	}
	if (found) return;

}

void ShadowHand1(object oCaller, object oTarget) // on a touch attack, gives the target 50% miss chance for 2 rounds
{		
	if (CancelIfNotInMeleeRange(oCaller, oTarget, 2919))
	{
		SendMessageToPC(oCaller, "Using <i>Clinging Shadows Strike.</i>");
		int touchAttackResult = TouchAttackMelee(oTarget, TRUE, 0);
	
		if (touchAttackResult)
		{
			effect visualEffect = EffectVisualEffect(VFX_INVOCATION_BESHADOWED_HIT);
			effect missChance = EffectMissChance(50, MISS_CHANCE_TYPE_NORMAL);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, visualEffect, oTarget, 0.0f);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, missChance, oTarget, 18.0f);
		}
	}
	
		// Initiates an attack against current target
	object currentTarget = oTarget;
	if (GetObjectType(currentTarget) == OBJECT_TYPE_CREATURE && GetIsEnemy(currentTarget, oCaller))
	{
		ActionAttack(currentTarget);
	}
}

void ShadowHand2(object oCaller) // User becomes invisible for 4 round
{
	SendMessageToPC(oCaller, "Using <i>Cloak of Deception.</i>");
	effect eVis = EffectVisualEffect( VFX_DUR_INVISIBILITY );
	effect invisibility = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
	effect conceal = EffectConcealment(50);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectLinkEffects(invisibility, eVis), oCaller, 30.0f);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, conceal, oCaller, 30.0f);
	
	
		// Initiates an attack against current target
	object currentTarget = GetPlayerCurrentTarget(oCaller);
	if (GetObjectType(currentTarget) == OBJECT_TYPE_CREATURE && GetIsEnemy(currentTarget, oCaller))
	{
		ActionAttack(currentTarget);
	}
}

void ShadowHand3(object oCaller, object oTarget) // User shadow jumps to a hostile target. Code is a slightly trimed down version of it.
{												// Also now grants 80% conceal for 1 round on arrival
	SendMessageToPC(oCaller, "Using <i>Shadow Jaunt.</i>");
	AssignCommand(oCaller, ClearAllActions());
	location lTarget = GetLocation(oTarget);
	location lCaster = GetLocation(oCaller);
	effect eVis = EffectNWN2SpecialEffectFile("fx_kos_teleport_small.sef");
	effect eVis2 = EffectNWN2SpecialEffectFile("fx_shadowjump.sef");

	
	if (GetAreaFromLocation(lTarget)==OBJECT_INVALID) return;
	AssignCommand(oCaller, ActionJumpToLocation(lTarget));
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis2, lTarget, RoundsToSeconds(6));
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, lCaster, RoundsToSeconds(4));
	
	// Applies the miss chance.
	effect visual = EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR);
	effect conceal = EffectConcealment(80);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectLinkEffects(visual, conceal), oCaller, 6.0f);
	
		// Initiates an attack against current target
	object currentTarget = oTarget;
	if (GetObjectType(currentTarget) == OBJECT_TYPE_CREATURE && GetIsEnemy(currentTarget, oCaller))
	{
		ActionAttack(currentTarget);
	}
}

void StoneDragon1(object oCaller, object oTarget) // on a touch attack, opponent loses DR for 3 round.
{		
	if (CancelIfNotInMeleeRange(oCaller, oTarget, 2922))
	{
		SendMessageToPC(oCaller, "Using <i>Mountain Hammer.</i>");
		int touchAttackResult = TouchAttackMelee(oTarget, TRUE, 0);
	
		if (touchAttackResult)
		{
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageReductionNegated(), oTarget, 24.0f);
			
			// Apply a vfx
			effect vfx = EffectVisualEffect(VFX_HIT_BARD_INS_JARRING);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, vfx, oTarget, 0.0f);
		}
	}
	
		// Initiates an attack against current target
	object currentTarget = oTarget;
	if (GetObjectType(currentTarget) == OBJECT_TYPE_CREATURE && GetIsEnemy(currentTarget, oCaller))
	{
		ActionAttack(currentTarget);
	}
}

void StoneDragon2(object oCaller) // DR 15/- for 3 rounds.
{		
	SendMessageToPC(oCaller, "Using <i>Stone Bones.</i>");
	effect dr = EffectDamageReduction(15, DAMAGE_POWER_NORMAL, 0, DR_TYPE_NONE);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, dr, oCaller, 24.0f);
	
	// Apply a vfx
	effect vfx = EffectVisualEffect(VFX_HIT_BARD_INS_DEFENSE);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, vfx, oCaller, 0.0f);
	
		// Initiates an attack against current target
	object currentTarget = GetPlayerCurrentTarget(oCaller);
	if (GetObjectType(currentTarget) == OBJECT_TYPE_CREATURE && GetIsEnemy(currentTarget, oCaller))
	{
		ActionAttack(currentTarget);
	}
}

void StoneDragon3(object oCaller, object oTarget) // on a touch attack, root and slow foe for 3 rounds.
{		
	if (CancelIfNotInMeleeRange(oCaller, oTarget, 2924))
	{
		SendMessageToPC(oCaller, "Using <i>Stone Vise.</i>");
		int touchAttackResult = TouchAttackMelee(oTarget, TRUE, 0);
	
		if (touchAttackResult)
		{
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectLinkEffects(EffectEntangle(), EffectSlow()), oTarget, 24.0f);
			
			// Apply a vfx
			effect vfx = EffectVisualEffect(VFX_HIT_BARD_INS_JARRING);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, vfx, oTarget, 0.0f);
		}
	}
	
		// Initiates an attack against current target
	object currentTarget = oTarget;
	if (GetObjectType(currentTarget) == OBJECT_TYPE_CREATURE && GetIsEnemy(currentTarget, oCaller))
	{
		ActionAttack(currentTarget);
	}
}

void DevotedSpirit1(object oCaller, object oTarget) // ennemy gets -4AB, you get -1 AC for 3 rounds.
{		
	if (CancelIfNotInMeleeRange(oCaller, oTarget, 2925))
	{
		SendMessageToPC(oCaller, "Using <i>Iron Guard's Glare.</i>");
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAttackDecrease(1, ATTACK_BONUS_MISC), oCaller, 18.0f);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAttackDecrease(6, ATTACK_BONUS_MISC), oTarget, 18.0f);
		
		// Apply a vfx
		effect vfx = EffectVisualEffect(VFX_HIT_BARD_INS_JARRING);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, vfx, oTarget, 0.0f);
	}
	
		// Initiates an attack against current target
	object currentTarget = oTarget;
	if (GetObjectType(currentTarget) == OBJECT_TYPE_CREATURE && GetIsEnemy(currentTarget, oCaller))
	{
		ActionAttack(currentTarget);
	}
}

void DevotedSpirit2(object oCaller) // All nearby allies get +X AC for two round, where X is your shield bonus
{
	SendMessageToPC(oCaller, "Using <i>Shield Block.</i>");
	int shieldAC = GetItemACValue(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCaller)); //Gets the AC bonus of the user's shield

	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 30.0f, GetLocation(oCaller));
	
	while (GetIsObjectValid(oTarget))
	{
		if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE && GetIsFriend(oTarget, oCaller) && oTarget != oCaller)
		{
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectACIncrease(shieldAC), oTarget, 30.0f);
		
			// Sends a message to the target to inform it.
			string hisher = "his";
			if (GetGender(oCaller) == GENDER_FEMALE) hisher = "her";
			SendMessageToPC(oTarget, GetName(oCaller) + " raises " + hisher + " shield to protect you.");
			
			// Apply a vfx
			effect vfx = EffectVisualEffect(VFX_HIT_BARD_INS_DEFENSE);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, vfx, oTarget, 0.0f);
		}
		
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, 30.0f, GetLocation(oCaller));
	}
	
		// Initiates an attack against current target
	object currentTarget = GetPlayerCurrentTarget(oCaller);
	if (GetObjectType(currentTarget) == OBJECT_TYPE_CREATURE && GetIsEnemy(currentTarget, oCaller))
	{
		ActionAttack(currentTarget);
	}
}

void DevotedSpirit3(object oCaller) // your weapon(s) gains vamp regen +7 for 2 rounds.
{		
	SendMessageToPC(oCaller, "Using <i>Revitalizing Strike.</i>");
	
	object oRightHand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCaller);
	object oLeftHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCaller);
	object oGloves = GetItemInSlot(INVENTORY_SLOT_ARMS, oCaller);	
	itemproperty healing = ItemPropertyVampiricRegeneration(7);
	
	if(GetIsObjectValid(oLeftHand) && GetMeleeWeapon(oLeftHand))
	{	
		IPSafeAddItemProperty(oLeftHand, healing, RoundsToSeconds(3), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
	}
	if(GetIsObjectValid(oRightHand) && GetMeleeWeapon(oRightHand))
	{
		IPSafeAddItemProperty(oRightHand, healing, RoundsToSeconds(3), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
	}
	if(GetIsObjectValid(oGloves))
	{
		IPSafeAddItemProperty(oGloves, healing, RoundsToSeconds(3), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
	}
	
		// Initiates an attack against current target
	object currentTarget = GetPlayerCurrentTarget(oCaller);
	if (GetObjectType(currentTarget) == OBJECT_TYPE_CREATURE && GetIsEnemy(currentTarget, oCaller))
	{
		ActionAttack(currentTarget);
	}
}

void main()
{
	int nSpell = GetSpellId(); //Gets the spell number of the manoever used
	object oTarget = GetSpellTargetObject();
	
	
	switch (nSpell) // chooses which manoever to use
	{
		case 1700: 
			DesertWind1(OBJECT_SELF);
			break;
		case 1701: 
			DesertWind2(OBJECT_SELF);
			break;
		case 1702: 
			DesertWind3(OBJECT_SELF, oTarget);
			break;
		case 1703: 
			DiamondMind1(OBJECT_SELF, oTarget);
			break;
		case 1704: 
			DiamondMind2(OBJECT_SELF);
			break;
		case 1705: 
			DiamondMind3(OBJECT_SELF);
			break;
		case 1706: 
			IronHeart1(OBJECT_SELF);
			break;
		case 1707: 
			IronHeart2(OBJECT_SELF, oTarget);
			break;
		case 1708: 
			IronHeart3(OBJECT_SELF);
			break;
		case 1709: 
			ShadowHand1(OBJECT_SELF, oTarget);
			break;
		case 1710: 
			ShadowHand2(OBJECT_SELF);
			break;
		case 1711: 
			ShadowHand3(OBJECT_SELF, oTarget);
			break;
		case 1712: 
			StoneDragon1(OBJECT_SELF, oTarget);
			break;
		case 1713: 
			StoneDragon2(OBJECT_SELF);
			break;
		case 1714: 
			StoneDragon3(OBJECT_SELF, oTarget);
			break;
		case 1715: 
			DevotedSpirit1(OBJECT_SELF, oTarget);
			break;
		case 1716: 
			DevotedSpirit2(OBJECT_SELF);
			break;
		case 1717: 
			DevotedSpirit3(OBJECT_SELF);
			break;			
	}

}