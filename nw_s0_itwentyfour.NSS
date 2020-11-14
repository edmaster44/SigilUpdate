#include "nwn2_inc_spells"
#include "nw_i0_spells"
#include "x2_inc_spellhook" 

const int SPELL_I_OTHERWORLDLY_WHISPERS = 1059;

void DoBeguilingInfluence(object oPC)
{
    //RemoveEffectsFromSpell(oPC, SPELL_I_BEGUILING_INFLUENCE);
	
	int nCasterLevel = GetWarlockCasterLevel(oPC);
	int nSkillBuff = (nCasterLevel/2) + 5;

	effect eBluff = EffectSkillIncrease(SKILL_BLUFF, nSkillBuff);
    effect eDiplomacy = EffectSkillIncrease(SKILL_DIPLOMACY, nSkillBuff);
    effect eIntimidate = EffectSkillIncrease(SKILL_INTIMIDATE, nSkillBuff);
    effect eLink = EffectLinkEffects(eBluff, eDiplomacy);
    eLink = EffectLinkEffects(eLink, eIntimidate);
    eLink = SetEffectSpellId(eLink, SPELL_I_BEGUILING_INFLUENCE);
	
	SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_I_BEGUILING_INFLUENCE, FALSE));

    if (!GetIsInCombat(oPC)) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
}

void DoDarkOnesLuck(object oPC)
{
    //RemoveEffectsFromSpell(oPC, SPELL_I_DARK_ONES_OWN_LUCK);

	int nBonus = GetAbilityModifier(ABILITY_CHARISMA, oPC);
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus, SAVING_THROW_TYPE_ALL);
    eSave = SetEffectSpellId(eSave, SPELL_I_DARK_ONES_OWN_LUCK);
		
	SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_I_DARK_ONES_OWN_LUCK, FALSE));

    if (!GetIsInCombat(oPC)) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSave, oPC);
}

void DoEntropicWarding(object oPC)
{
	//RemoveEffectsFromSpell(oPC, SPELL_I_ENTROPIC_WARDING);
	
	int nCasterLevel = GetWarlockCasterLevel(oPC);
	int nSkillBuff = (nCasterLevel/4);
	if (nSkillBuff < 1)
		nSkillBuff = 1;
	nSkillBuff = nSkillBuff+3;

    effect eShield =  EffectConcealment(20, MISS_CHANCE_TYPE_VS_RANGED);
    effect eMoveSilently = EffectSkillIncrease(SKILL_MOVE_SILENTLY, nSkillBuff);
    effect eHide = EffectSkillIncrease(SKILL_HIDE, nSkillBuff);
    effect eLink = EffectLinkEffects(eShield, eMoveSilently);
    eLink = EffectLinkEffects(eLink, eHide);
	eLink = SetEffectSpellId(eLink, SPELL_I_ENTROPIC_WARDING);

    SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_I_ENTROPIC_WARDING, FALSE));

    if (!GetIsInCombat(oPC)) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
}

void DoLeapsAndBounds(object oPC)
{
	//RemoveEffectsFromSpell(oPC, SPELL_I_LEAPS_AND_BOUNDS);
	
	int nCasterLevel = GetWarlockCasterLevel(oPC);
	int nSkillBuff = (nCasterLevel/2) + 5;
	
	int nDex = 4;
	if (nCasterLevel > 5) //Dexterity boost doesn't become 6 until you hit caster level 6
		nDex = 6;

    effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY, nDex);
    effect eTumble = EffectSkillIncrease(SKILL_TUMBLE, nSkillBuff);
    effect eLink = EffectLinkEffects(eDex, eTumble);
    eLink = SetEffectSpellId(eLink, SPELL_I_LEAPS_AND_BOUNDS);

    SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_I_LEAPS_AND_BOUNDS, FALSE));

    if (!GetIsInCombat(oPC)) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
}

void DoOtherworldlyWhispers(object oPC)
{
	//RemoveEffectsFromSpell(oPC, SPELL_I_OTHERWORLDLY_WHISPERS);
	
	int nCasterLevel = GetWarlockCasterLevel(oPC);
	int nSkillBuff = (nCasterLevel/2) + 5;

    effect eLore = EffectSkillIncrease(SKILL_LORE, nSkillBuff);
	effect eSpellCraft = EffectSkillIncrease(SKILL_SPELLCRAFT, nSkillBuff);
	effect eSearch = EffectSkillIncrease(SKILL_SEARCH, nSkillBuff);
    effect eLink = EffectLinkEffects(eLore, eSpellCraft);
	eLink = EffectLinkEffects(eLink, eSearch);
	eLink = SetEffectSpellId(eLink, SPELL_I_OTHERWORLDLY_WHISPERS);

	SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_I_OTHERWORLDLY_WHISPERS, FALSE));

	if (!GetIsInCombat(oPC)) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
}

void DoSeeTheUnseen(object oPC)
{
	//RemoveEffectsFromSpell(oPC, SPELL_I_SEE_THE_UNSEEN);

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