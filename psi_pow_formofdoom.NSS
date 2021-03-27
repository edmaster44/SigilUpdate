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
    5/-, and a +4 bonus to your Strength score. In addition, you gain +33% to
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


void main()
{
/*
  Spellcast Hook Code
  Added 2004-11-02 by Stratovarius
  If you want to make changes to all powers,
  check psi_spellhook to find out more

*/

    if (!PsiPrePowerCastCode())
    {
    // If code within the PrePowerCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook
	itemproperty iBonusFeat1 = ItemPropertyBonusFeat(3369);
    object oManifester = OBJECT_SELF;
    object oTarget     = GetSpellTargetObject();
	object oWeapon	   = IPGetTargetedOrEquippedMeleeWeapon();
    struct manifestation manif =
       EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        effect eLink    =                          EffectAreaOfEffect(AOE_MOB_MENACE);
               eLink    = EffectLinkEffects(eLink, EffectACIncrease(5, AC_NATURAL_BONUS));
               eLink    = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_SLASHING,    5));
               eLink    = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_PIERCING,    5));
               eLink    = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, 5));
               eLink    = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_STRENGTH, 4));
               eLink    = EffectLinkEffects(eLink, EffectMovementSpeedIncrease(33));
               //eLink    = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_INTIMIDATE, 10));
               eLink = EffectLinkEffects(eLink, EffectNWN2SpecialEffectFile("psi_sp__form_of_doom.sef"));
        effect eTest;
        float fDuration = 6.0f * (manif.nManifesterLevel + (2 * manif.nManifesterLevel));
        if(manif.bExtend) fDuration *= 2;

        // Will not work if under the effects of Polymorph. Also will not stack with itself
        eTest = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eTest))
        {
            if(GetEffectType(eTest) == EFFECT_TYPE_POLYMORPH ||
               GetEffectSpellId(eTest) == POWER_FORM_OF_DOOM
               )
                return;
            eTest = GetNextEffect(oTarget);
        }
		//Feral Path
		if (GetHasFeat(FEAT_PSYWAR_FERAL,oManifester))
		{
		  
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, GetItemPossessor(oWeapon));
            IPSafeAddItemProperty(oTarget, iBonusFeat1, fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, TRUE, TRUE);
        }
	else
	
        // Apply the effects
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration); 
		
		}
       // string sResRef = "prc_fod_tent_";
      //  sResRef += GetAffixForSize(PRCGetCreatureSize(oTarget));
     //   AddNaturalSecondaryWeapon(oTarget, sResRef, 4);
        // Start dispelling monitor and tentacles heartbeat
        //DelayCommand(6.0f, 
            //NaturalSecondaryWeaponTempCheck(oManifester, oTarget, manif.nSpellID, FloatToInt(fDuration) / 6, sResRef));
    }// end if - Successfull manifestation