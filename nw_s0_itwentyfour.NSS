#include "nwn2_inc_spells"
#include "nw_i0_spells"
#include "x2_inc_spellhook" 

const int SPELL_I_OTHERWORLDLY_WHISPERS = 1059;

void DoBeguilingInfluence(object oPC)
{
    RemoveEffectsFromSpell(oPC, SPELL_I_BEGUILING_INFLUENCE);

	effect eBluff = EffectSkillIncrease(SKILL_BLUFF, 6);
    effect eDiplomacy = EffectSkillIncrease(SKILL_DIPLOMACY, 6);
    effect eIntimidate = EffectSkillIncrease(SKILL_INTIMIDATE, 6);
    effect eLink = EffectLinkEffects(eBluff, eDiplomacy);
    eLink = EffectLinkEffects(eLink, eIntimidate);
    eLink = SetEffectSpellId(eLink, SPELL_I_BEGUILING_INFLUENCE);
	
	SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_I_BEGUILING_INFLUENCE, FALSE));

    if (!GetIsInCombat(oPC)) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
}

void DoDarkOnesLuck(object oPC)
{
    RemoveEffectsFromSpell(oPC, SPELL_I_DARK_ONES_OWN_LUCK);

	int nBonus = GetAbilityModifier(ABILITY_CHARISMA, oPC);
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus, SAVING_THROW_TYPE_ALL);
    eSave = SetEffectSpellId(eSave, SPELL_I_DARK_ONES_OWN_LUCK);
		
	SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_I_DARK_ONES_OWN_LUCK, FALSE));

    if (!GetIsInCombat(oPC)) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSave, oPC);
}

void DoDevilsSight(object oPC)
{
    RemoveEffectsFromSpell(oPC, SPELL_I_DEVILS_SIGHT);

	effect eDark = EffectDarkVision();
    effect eUltra = EffectUltravision();	
    effect eLink = EffectLinkEffects(eDark, eUltra);
	eLink = SetEffectSpellId(eLink, SPELL_I_DEVILS_SIGHT);
	
	SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_I_DEVILS_SIGHT, FALSE));

    if (!GetIsInCombat(oPC)) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
}

void DoEntropicWarding(object oPC)
{
	RemoveEffectsFromSpell(oPC, SPELL_I_ENTROPIC_WARDING);

    effect eShield =  EffectConcealment(20, MISS_CHANCE_TYPE_VS_RANGED);
    effect eMoveSilently = EffectSkillIncrease(SKILL_MOVE_SILENTLY, 4);
    effect eHide = EffectSkillIncrease(SKILL_HIDE, 4);
    effect eLink = EffectLinkEffects(eShield, eMoveSilently);
    eLink = EffectLinkEffects(eLink, eHide);
	eLink = SetEffectSpellId(eLink, SPELL_I_ENTROPIC_WARDING);

    SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_I_ENTROPIC_WARDING, FALSE));

    if (!GetIsInCombat(oPC)) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
}

void DoLeapsAndBounds(object oPC)
{
	RemoveEffectsFromSpell(oPC, SPELL_I_LEAPS_AND_BOUNDS);

    effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY, 4);
    effect eTumble = EffectSkillIncrease(SKILL_TUMBLE, 4);
    effect eLink = EffectLinkEffects(eDex, eTumble);
    eLink = SetEffectSpellId(eLink, SPELL_I_LEAPS_AND_BOUNDS);

    SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_I_LEAPS_AND_BOUNDS, FALSE));

    if (!GetIsInCombat(oPC)) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
}

void DoOtherworldlyWhispers(object oPC)
{
	RemoveEffectsFromSpell(oPC, SPELL_I_OTHERWORLDLY_WHISPERS);

    effect eLore = EffectSkillIncrease(SKILL_LORE, 6);
	effect eSpellCraft = EffectSkillIncrease(SKILL_SPELLCRAFT, 6);
    effect eLink = EffectLinkEffects(eLore, eSpellCraft);
	eLink = SetEffectSpellId(eLink, SPELL_I_OTHERWORLDLY_WHISPERS);

	SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_I_OTHERWORLDLY_WHISPERS, FALSE));

	if (!GetIsInCombat(oPC)) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
}

void DoSeeTheUnseen(object oPC)
{
	RemoveEffectsFromSpell(oPC, SPELL_I_SEE_THE_UNSEEN);

    effect eSight = EffectSeeInvisible();
    effect eUltra = EffectDarkVision();
    effect eLink = EffectLinkEffects(eSight, eUltra);
	eLink = SetEffectSpellId(eLink, SPELL_I_SEE_THE_UNSEEN);

    SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_I_SEE_THE_UNSEEN, FALSE));

    if (!GetIsInCombat(oPC)) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
}

void TwentyFour(object oPC)
{
	if (GetLocalInt(oPC,"TwentyFour")==FALSE) return;
	
	if ((GetHasSpell(SPELL_I_BEGUILING_INFLUENCE,oPC))&&(!GetHasSpellEffect(SPELL_I_BEGUILING_INFLUENCE,oPC)))
		DoBeguilingInfluence(oPC);
	if ((GetHasSpell(SPELL_I_DARK_ONES_OWN_LUCK,oPC))&&(!GetHasSpellEffect(SPELL_I_DARK_ONES_OWN_LUCK,oPC)))
		DoDarkOnesLuck(oPC);
	if ((GetHasSpell(SPELL_I_DEVILS_SIGHT,oPC))&&(!GetHasSpellEffect(SPELL_I_DEVILS_SIGHT,oPC)))
		DoDevilsSight(oPC);
	if ((GetHasSpell(SPELL_I_ENTROPIC_WARDING,oPC))&&(!GetHasSpellEffect(SPELL_I_ENTROPIC_WARDING,oPC)))
		DoEntropicWarding(oPC);
	if ((GetHasSpell(SPELL_I_OTHERWORLDLY_WHISPERS,oPC))&&(!GetHasSpellEffect(SPELL_I_OTHERWORLDLY_WHISPERS,oPC)))
		DoOtherworldlyWhispers(oPC);
	if ((GetHasSpell(SPELL_I_LEAPS_AND_BOUNDS,oPC))&&(!GetHasSpellEffect(SPELL_I_LEAPS_AND_BOUNDS,oPC)))
		DoLeapsAndBounds(oPC);
	if ((GetHasSpell(SPELL_I_SEE_THE_UNSEEN,oPC))&&(!GetHasSpellEffect(SPELL_I_SEE_THE_UNSEEN,oPC)))
		DoSeeTheUnseen(oPC);
	DelayCommand(6.0, TwentyFour(oPC));
}

void main()
{
	object oPC = OBJECT_SELF;

	TwentyFour(oPC);
}