const int SPELL_ID_TOTEM_RESISTANCE = 13000;
const int SPELL_ID_TOTEM_HEALING = 13001;
const int SPELL_ID_TOTEM_BLINDING = 13002;
const int SPELL_ID_TOTEM_DESPAIR = 13003;
const int SPELL_ID_TOTEM_SHELTERING = 13004;
const int SPELL_ID_TOTEM_HARDINESS = 13005;
const int SPELL_ID_TOTEM_SLOWING = 13006;
const int SPELL_ID_TOTEM_NAUSEA = 13007;
const int SPELL_ID_TOTEM_SWIFTNESS = 13008;
const int SPELL_ID_TOTEM_SERENITY = 13009;
const int SPELL_ID_TOTEM_CLEANSING = 13010;
const int SPELL_ID_TOTEM_BREACHING = 13011;
const int SPELL_ID_TOTEM_UNDEAD_HEALING = 13012;

const int VFX_PER_TOTEM_RESISTANCE = 200;
const int VFX_PER_TOTEM_HEALING = 201;
const int VFX_PER_TOTEM_BLINDING = 202;
const int VFX_PER_TOTEM_DESPAIR = 203;
const int VFX_PER_TOTEM_SHELTERING = 204;
const int VFX_PER_TOTEM_HARDINESS = 205;
const int VFX_PER_TOTEM_SLOWING = 206;
const int VFX_PER_TOTEM_NAUSEA = 207;
const int VFX_PER_TOTEM_SWIFTNESS = 208;
const int VFX_PER_TOTEM_SERENITY = 209;
const int VFX_PER_TOTEM_CLEANSING = 210;
const int VFX_PER_TOTEM_BREACHING = 211;
const int VFX_PER_TOTEM_UNDEAD_HEALING = 212;

const int TOTEM_TYPE_BUFF = 0;
const int TOTEM_TYPE_DEBUFF = 1;

const int TOTEM_DURATION_ROUNDS = 10;
const int TOTEM_EXT_DURATION_ROUNDS = 20;

int IsTotemSpell(int spellId)
{
	switch(spellId) {
	case SPELL_ID_TOTEM_RESISTANCE:
	case SPELL_ID_TOTEM_HEALING:
	case SPELL_ID_TOTEM_BLINDING:
	case SPELL_ID_TOTEM_DESPAIR:
	case SPELL_ID_TOTEM_SHELTERING:
	case SPELL_ID_TOTEM_HARDINESS:
	case SPELL_ID_TOTEM_SLOWING:
	case SPELL_ID_TOTEM_NAUSEA:
	case SPELL_ID_TOTEM_SWIFTNESS:
	case SPELL_ID_TOTEM_SERENITY:
	case SPELL_ID_TOTEM_CLEANSING:
	case SPELL_ID_TOTEM_BREACHING:
	case SPELL_ID_TOTEM_UNDEAD_HEALING:
		return 1;
	}
	return 0;
}

int GetTotemType(int spellId)
{
	switch(spellId) {
	case SPELL_ID_TOTEM_RESISTANCE:
	case SPELL_ID_TOTEM_HEALING:
	case SPELL_ID_TOTEM_SHELTERING:
	case SPELL_ID_TOTEM_HARDINESS:
	case SPELL_ID_TOTEM_SWIFTNESS:
	case SPELL_ID_TOTEM_SERENITY:
	case SPELL_ID_TOTEM_CLEANSING:
	case SPELL_ID_TOTEM_UNDEAD_HEALING:
		return TOTEM_TYPE_BUFF;
	}
	return TOTEM_TYPE_DEBUFF;
}

int GetTotemAoeEffectId(int spellId)
{
	switch(spellId) {
	case SPELL_ID_TOTEM_RESISTANCE:
		return VFX_PER_TOTEM_RESISTANCE;
	case SPELL_ID_TOTEM_HEALING:
		return VFX_PER_TOTEM_HEALING;
	case SPELL_ID_TOTEM_BLINDING:
		return VFX_PER_TOTEM_BLINDING;
	case SPELL_ID_TOTEM_DESPAIR:
		return VFX_PER_TOTEM_DESPAIR;
	case SPELL_ID_TOTEM_SHELTERING:
		return VFX_PER_TOTEM_SHELTERING;
	case SPELL_ID_TOTEM_HARDINESS:
		return VFX_PER_TOTEM_HARDINESS;
	case SPELL_ID_TOTEM_SLOWING:
		return VFX_PER_TOTEM_SLOWING;
	case SPELL_ID_TOTEM_NAUSEA:
		return VFX_PER_TOTEM_NAUSEA;
	case SPELL_ID_TOTEM_SWIFTNESS:
		return VFX_PER_TOTEM_SWIFTNESS;
	case SPELL_ID_TOTEM_SERENITY:
		return VFX_PER_TOTEM_SERENITY;
	case SPELL_ID_TOTEM_CLEANSING:
		return VFX_PER_TOTEM_CLEANSING;
	case SPELL_ID_TOTEM_BREACHING:
		return VFX_PER_TOTEM_BREACHING;
	case SPELL_ID_TOTEM_UNDEAD_HEALING:
		return VFX_PER_TOTEM_UNDEAD_HEALING;
	}
	return 0;
}

// Return the value or the caster's WIS bonus, whichever is lower. Returns at least 0.
int LimitToWisBonus(object oCreator, int n)
{
	int maxn = GetAbilityModifier(ABILITY_WISDOM, oCreator);
	if(n > maxn)
		n = maxn;
	if(n < 0)
		n = 0;
	return n;
}

// The bonus is +1 at caster level 1 and increases by 1 at level 5 and every 5 levels thereafter,
// up to a maximum of +5 at level 20, or the caster's Wisdom bonus, whichever is lower.
int GetTotemScaledEffect(object oCreator, int nCasterLevel)
{
	int n = 1 + nCasterLevel / 5;
	if(n > 5)
		n = 5;
	n = LimitToWisBonus(oCreator, n);
	return n;
}