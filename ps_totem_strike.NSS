#include "nwn2_inc_spells"
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 
#include "ps_totem_constants"

int GetTotemStrikePower(int nShamanLvl)
{
	// 1-3   +1
	// 4-7   +2
	// 8-11  +3
	// 12-15 +4
	// 16+   +5
	int nPower = nShamanLvl / 4;
	if(nPower > 4)
		nPower = 4;
	switch(nPower) {
	case 0: return DAMAGE_POWER_PLUS_ONE;
	case 1: return DAMAGE_POWER_PLUS_TWO;
	case 2: return DAMAGE_POWER_PLUS_THREE;
	case 3: return DAMAGE_POWER_PLUS_FOUR;
	case 4: return DAMAGE_POWER_PLUS_FIVE;
	}
	return DAMAGE_POWER_PLUS_ONE;
}

int ScaleDmgByTotemFocus( int nFocus, int nDam )
{
	// 10% per feat
	return FloatToInt(nDam * (1.0 + 0.1 * nFocus));
}

// returns at least 1
int GetDamageDicePerShamanLevel( int nShamanLvl, int nDivide )
{
	int nDmgDice = nShamanLvl / nDivide;
	nDmgDice = (nDmgDice == 0) ? 1 : nDmgDice;
	return nDmgDice;
}

void TotemStrikeAttack( object oTarget, int nElemDmgType )
{
	object oCaster = OBJECT_SELF;

	int nBonus = 0;
	int nRoll = TouchAttackRanged( oTarget, TRUE, nBonus );
	if(nRoll) {
		int nShamanLvl = GetLevelByClass(CLASS_TYPE_SPIRIT_SHAMAN, oCaster);
		int nDmgDice = GetDamageDicePerShamanLevel( nShamanLvl, 3 );

		// Focus power
		int nFocus = GetFocusPower(oCaster);

		// Twin Totem Strike
		int bTwin = GetHasFeat(FEAT_TWIN_TOTEM_STRIKE, oCaster, TRUE) && (d20(1) <= 2);
		nDmgDice *= bTwin ? 2 : 1;

		// Piercing Totem Strike
		int bPiercing = GetHasFeat(FEAT_PIERCING_TOTEM_STRIKE, oCaster, TRUE) && (d20(1) <= 2);

		int nDam = d6(nDmgDice);

		// Totem Focus
		nDam = ScaleDmgByTotemFocus( nFocus, nDam );

		// Confirm crit
		if(nRoll == 2 && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT)) {
			if(TouchAttackRanged( oTarget, FALSE, nBonus) > 0) {
				// Devastating Totem Strike
				int nCritMulti = GetHasFeat(FEAT_DEVAST_TOTEM_STRIKE, oCaster, TRUE) ? 3 : 2;
				nDam *= nCritMulti;
			}
		}

		// Damage magic power
		int nPower = GetTotemStrikePower(nShamanLvl);

		effect eVis = EffectVisualEffect(VFX_HIT_SPELL_INFLICT_1);
		effect eHurt = EffectDamage( nDam, DAMAGE_TYPE_PIERCING | DAMAGE_TYPE_SLASHING, nPower, bPiercing );
		effect eLink = EffectLinkEffects(eVis, eHurt);

		// Elemental Totem Strike
		effect eElem;
		if (GetHasFeat(FEAT_ELEM_TOTEM_STRIKE, oCaster, TRUE)) {
			int nElemDmgDice = GetDamageDicePerShamanLevel( nShamanLvl, 5 );
			nElemDmgDice *= bTwin ? 2 : 1;

			int nElemDam = d6(nElemDmgDice);
			// Totem Focus
			nElemDam = ScaleDmgByTotemFocus( nFocus, nElemDam );
			eElem = EffectDamage( nElemDam, nElemDmgType, nPower, bPiercing );
			eLink = EffectLinkEffects(eLink, eElem);
		}

		ApplyEffectToObject( DURATION_TYPE_INSTANT, eLink, oTarget );
	}
}

void RunTotemStrike(object oTotem)
{
	object   oCaster    = OBJECT_SELF;
	int nShamanLvl = GetLevelByClass(CLASS_TYPE_SPIRIT_SHAMAN, oCaster);

	location lTotemLoc = GetLocation(oTotem);

	effect eVis = EffectVisualEffect( VFX_HIT_TOTEM_STRIKE );
	ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVis, lTotemLoc );

	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTotemLoc, FALSE, OBJECT_TYPE_CREATURE);

	int nElemDmgType = 0;
	switch(Random(5)) {
	case 0: nElemDmgType = DAMAGE_TYPE_ACID; break;
	case 1: nElemDmgType = DAMAGE_TYPE_COLD; break;
	case 2: nElemDmgType = DAMAGE_TYPE_ELECTRICAL; break;
	case 3: nElemDmgType = DAMAGE_TYPE_FIRE; break;
	case 4: nElemDmgType = DAMAGE_TYPE_SONIC; break;
	}

	while(GetIsObjectValid(oTarget)) {
		if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster)) {
			TotemStrikeAttack( oTarget, nElemDmgType );
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTotemLoc, FALSE, OBJECT_TYPE_CREATURE);
	}
}

void main()
{
	if (!X2PreSpellCastCode())
	{	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
		return;
	}
	
	//Declare major variables
	object   oCaster    = OBJECT_SELF;
	location lCasterLoc = GetLocation(oCaster);
	
	// Find nearest totem of this caster
	float fActivationRange = RADIUS_SIZE_LARGE;
	object oNearTotem;
	float fMinDist = fActivationRange + 1;
	int iFound = 0;
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fActivationRange, lCasterLoc, FALSE, OBJECT_TYPE_AREA_OF_EFFECT);
	while(GetIsObjectValid(oTarget)) {
		object oCreator = GetAreaOfEffectCreator(oTarget);
		int nAoeSpellId = GetAreaOfEffectSpellId(oTarget);
		if(oCreator == oCaster && IsTotemSpell(nAoeSpellId)) {
			float fDist = GetDistanceBetween(oCaster, oTarget);
			if(fDist < fMinDist) {
				fMinDist = fDist;
				oNearTotem = oTarget;
				iFound = 1;
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fActivationRange, lCasterLoc, FALSE, OBJECT_TYPE_AREA_OF_EFFECT);
	}

	if(iFound) {
		RunTotemStrike(oNearTotem);
	}
}