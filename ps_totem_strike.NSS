#include "nwn2_inc_spells"
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 
#include "ps_totem_constants"
#include "ps_inc_functions"

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

void TotemStrikeAttack( object oTarget, int nShamanLvl, int nElemDmgType, float fDmgMulti )
{
	object oCaster = OBJECT_SELF;

	int nBonus = 0;
	int nRoll = TouchAttackRanged( oTarget, TRUE, nBonus );
	if(nRoll) {
		int nDmgDice = GetDamageDicePerShamanLevel( nShamanLvl, 3 );

		// Focus power
		int nFocus = GetFocusPower(oCaster);

		// Twin Totem Strike
		int bTwin = GetHasFeat(FEAT_TWIN_TOTEM_STRIKE, oCaster, TRUE) && (d20(1) <= 2);
		if(bTwin) {
			SendMessageToPC(oCaster, "Twin Totem Strike!");
		}
		nDmgDice *= bTwin ? 2 : 1;

		// Piercing Totem Strike
		int bPiercing = GetHasFeat(FEAT_PIERCING_TOTEM_STRIKE, oCaster, TRUE) && (d20(1) <= 2);
		if(bPiercing) {
			SendMessageToPC(oCaster, "Piercing Totem Strike!");
		}

		int nDam = d6(nDmgDice);

		// Totem Focus
		nDam = ScaleDmgByTotemFocus( nFocus, nDam );

		// Damage multi
		nDam = FloatToInt(nDam * fDmgMulti);

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

			// Damage multi
			nElemDam = FloatToInt(nElemDam * fDmgMulti);

			eElem = EffectDamage( nElemDam, nElemDmgType, nPower, bPiercing );
			eLink = EffectLinkEffects(eLink, eElem);
		}

		ApplyEffectToObject( DURATION_TYPE_INSTANT, eLink, oTarget );
	}
}

void RunTotemStrike(object oTotem, int nShamanLvl, float fDmgMulti)
{
	object   oCaster    = OBJECT_SELF;
	location lTotemLoc = GetLocation(oTotem);

	effect eVis = EffectVisualEffect( VFX_HIT_TOTEM_STRIKE );
	ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVis, lTotemLoc );

	int nElemDmgType = 0;
	switch(Random(5)) {
	case 0: nElemDmgType = DAMAGE_TYPE_ACID; break;
	case 1: nElemDmgType = DAMAGE_TYPE_COLD; break;
	case 2: nElemDmgType = DAMAGE_TYPE_ELECTRICAL; break;
	case 3: nElemDmgType = DAMAGE_TYPE_FIRE; break;
	case 4: nElemDmgType = DAMAGE_TYPE_SONIC; break;
	}

	float strikeRadius = RADIUS_SIZE_LARGE * 1.5;
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, strikeRadius, lTotemLoc, FALSE, OBJECT_TYPE_CREATURE);
	while(GetIsObjectValid(oTarget)) {
		if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster)) {
			TotemStrikeAttack( oTarget, nShamanLvl, nElemDmgType, fDmgMulti );
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, strikeRadius, lTotemLoc, FALSE, OBJECT_TYPE_CREATURE);
	}
}

void TriggerNearbyTotems(object oCaster, location lStartLoc)
{
	// Find all active totems of the caster in activation range
	int nCount = 0;
	float fActivationRange = RADIUS_SIZE_LARGE * 5;

	object totem_1 = OBJECT_INVALID;
	object totem_2 = OBJECT_INVALID;
	object totem_3 = OBJECT_INVALID;
	object totem_4 = OBJECT_INVALID;
	object totem_5 = OBJECT_INVALID;
	object totem_6 = OBJECT_INVALID;
	object totem_7 = OBJECT_INVALID;
	object totem_8 = OBJECT_INVALID;
	int nMaxCount = 8;

	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fActivationRange, lStartLoc, FALSE, OBJECT_TYPE_AREA_OF_EFFECT);
	while(GetIsObjectValid(oTarget)) {
		object oCreator = GetAreaOfEffectCreator(oTarget);
		int nAoeSpellId = GetAreaOfEffectSpellId(oTarget);
		if(oCreator == oCaster && IsTotemSpell(nAoeSpellId)) {
			++nCount;
			switch(nCount) {
				case 1: totem_1 = oTarget; break;
				case 2: totem_2 = oTarget; break;
				case 3: totem_3 = oTarget; break;
				case 4: totem_4 = oTarget; break;
				case 5: totem_5 = oTarget; break;
				case 6: totem_6 = oTarget; break;
				case 7: totem_7 = oTarget; break;
				case 8: totem_8 = oTarget; break;
				default: break;
			}
			if(nCount == nMaxCount) {
				break;
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fActivationRange, lStartLoc, FALSE, OBJECT_TYPE_AREA_OF_EFFECT);
	}

	int nCasterLevel = GetSpiritShamanTRUECasterlevel(oCaster);
	float fMultiIncPerCount = 0.4;
	float fDmgMulti = 1.0 + (nCount - 1) * fMultiIncPerCount;
	float fMaxMulti = 3.0;
	if(fDmgMulti > fMaxMulti) {
		fDmgMulti = fMaxMulti;
	}
	if(nCount > 0) {
		SendMessageToPC(oCaster, "Totem Strike caster level "
			+ IntToString(nCasterLevel)
			+ ", damage multiplier " + IntToString( FloatToInt(fDmgMulti * 100.0) ) + "%" );
	}

	// Run strike for each active totem
	switch(nCount) {
		case 8: RunTotemStrike(totem_8, nCasterLevel, fDmgMulti);
		case 7: RunTotemStrike(totem_7, nCasterLevel, fDmgMulti);
		case 6: RunTotemStrike(totem_6, nCasterLevel, fDmgMulti);
		case 5: RunTotemStrike(totem_5, nCasterLevel, fDmgMulti);
		case 4: RunTotemStrike(totem_4, nCasterLevel, fDmgMulti);
		case 3: RunTotemStrike(totem_3, nCasterLevel, fDmgMulti);
		case 2: RunTotemStrike(totem_2, nCasterLevel, fDmgMulti);
		case 1: RunTotemStrike(totem_1, nCasterLevel, fDmgMulti);
		default:
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
	TriggerNearbyTotems(oCaster, GetLocation(oCaster));
}