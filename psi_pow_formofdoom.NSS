/*
   ----------------
   Form of Doom

   psi_pow_formdoom
   ----------------

   13/12/05 by Stratovarius
*/ /** @file

    Form of Doom

    Psychometabolism
    Level: Psychic warrior 6
    Manifesting Time: 1 standard action
    Range: Personal; see text
    Target: You
    Duration: 1 round/level
    Power Points: 11
    Metapsionics: Extend

    You wrench from your subconscious a terrifying visage of deadly hunger and
    become one with it. You are transformed into a nightmarish version of
    yourself, complete with an ooze-sleek skin coating, lashing tentacles, and a
    fright-inducing countenance. You retain your basic shape and can continue to
    use your equipment. This power cannot be used to impersonate someone; while
    horrible, your form is recognizably your own.

    You gain the frightful presence extraordinary ability, which takes effect
    automatically. Opponents within 30 feet of you that have fewer Hit Dice or
    levels than you become shaken for 5d6 rounds if they fail a Will save
    (DC 16 + your Cha modifier). An opponent that succeeds on the saving throw
    is immune to your frightful presence for 24 hours. Frightful presence is a
    mind-affecting fear effect.

    Your horrific form grants you a natural armor bonus of +5, damage reduction
    5/-, and a +6 bonus to your Strength score. In addition, you gain +33% to
    your land speed as well as a +10 bonus on Jump checks.

    A nest of violently flailing black tentacles sprout from your hair and back.
    You can make up to four additional attacks with these tentacles in addition
    to your regular melee attacks. You can make tentacle attacks within the
    space you normally threaten. Each tentacle attacks at your highest base
    attack bonus with a -5 penalty. These tentacles deal 2d8 points of damage
    plus one-half your Strength bonus on each successful strike.

    This power functions only while you inhabit your base form (for instance,
    you can’t be metamorphed or polymorphed into another form, though you can
    use, claws of the beast, and bite of the wolf in conjunction with this power
    for your regular attacks), and while your mind resides within your own body.

    Augment: For every additional power point you spend, this power’s duration
             increases by 2 rounds.
*/

#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "aaa_constants"
#include "x2_inc_itemprop"
#include "ps_inc_functions"


void main()
{
	if (!PsiPrePowerCastCode()) return;

	object oManifester = OBJECT_SELF;
	int nId = GetSpellId();
	
	// Will not work if under the effects of Polymorph. Also will not stack with itself
	effect eTest = GetFirstEffect(oManifester);
	while(GetIsEffectValid(eTest))
	{
		if(GetEffectType(eTest) == EFFECT_TYPE_POLYMORPH){
			SendMessageToPC(oManifester, "You cannot use this power while polymorphed");
			return;
		}
		if (GetEffectSpellId(eTest) == nId){
			SendMessageToPC(oManifester, "You are already using this power");
			return;
		}
		eTest = GetNextEffect(oManifester);
	}
	struct manifestation manif = EvaluateManifestationNew(oManifester, oManifester, nId,
			  METAPSIONIC_EXTEND | METAPSIONIC_AUGMENT);

	if(!manif.bCanManifest) return;

	string sTag = (manif.bAugment) ? "augmented" : "";
	effect eLink = EffectAreaOfEffect(102, "", "", "", sTag);
	eLink = EffectLinkEffects(EffectACIncrease(6, AC_NATURAL_BONUS), eLink);
	eLink = EffectLinkEffects(EffectDamageResistance(DAMAGE_TYPE_SLASHING, 5), eLink);
	eLink = EffectLinkEffects(EffectDamageResistance(DAMAGE_TYPE_PIERCING, 5), eLink);
	eLink = EffectLinkEffects(EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, 5), eLink);
	eLink = EffectLinkEffects(EffectAbilityIncrease(ABILITY_STRENGTH, 6), eLink);
	eLink = EffectLinkEffects(EffectMovementSpeedIncrease(33), eLink);
	eLink = EffectLinkEffects(EffectSkillIncrease(SKILL_INTIMIDATE, 10), eLink);
	eLink = EffectLinkEffects(EffectNWN2SpecialEffectFile("psi_sp__form_of_doom.sef"), eLink);
	eLink = SetEffectSpellId(eLink,nId);
	float fDuration = 6.0f * (manif.nManifesterLevel);
	if(manif.bExtend) fDuration *= 2;

	//Feral Path gets multiattack
	if (GetHasFeat(FEAT_PSYWAR_FERAL,oManifester)){	
		object oSkin = PS_GetCreatureSkin(oManifester);
		itemproperty iBonusFeat1 = ItemPropertyBonusFeat(1315);
		IPSafeAddItemProperty(oSkin, iBonusFeat1, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
	}
	
	// Apply the effects
	SignalAndApplyEffectToObject(oManifester, nId, FALSE, DURATION_TYPE_TEMPORARY, eLink, 
		oManifester, fDuration);
}