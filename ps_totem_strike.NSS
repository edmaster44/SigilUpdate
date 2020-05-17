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

void TotemStrikeAttack( object oTarget )
{
	object oCaster = OBJECT_SELF;

	int nBonus = 0;
	int nRoll = TouchAttackRanged( oTarget, TRUE, nBonus );
	if(nRoll) {
		int nShamanLvl = GetLevelByClass(CLASS_TYPE_SPIRIT_SHAMAN, oCaster);
		int nDmgDice = nShamanLvl / 2;
		int nDam = d6(nDmgDice);
		// Confirm crit
		if(nRoll == 2 && !GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT)) {
			if(TouchAttackRanged( oTarget, FALSE, nBonus) > 0) {
				nDam *= 2;
			}
		}

		effect eVis = EffectVisualEffect(VFX_HIT_SPELL_INFLICT_1);
		effect eHurt = EffectDamage( nDam, DAMAGE_TYPE_PIERCING | DAMAGE_TYPE_SLASHING, GetTotemStrikePower(nShamanLvl) );
		effect eLink = EffectLinkEffects(eVis, eHurt);
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
	while(GetIsObjectValid(oTarget)) {
		if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster)) {
			TotemStrikeAttack( oTarget );
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