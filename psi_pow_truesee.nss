/*
   ----------------
   True Seeing, Psionic

   psi_pow_truesee
   ----------------

   4/28/2021
*/ /** @file

    Form of Doom

    Psychometabolism
    Level: Psychic warrior 5
    Manifesting Time: 1 standard action
    Range: Personal; see text
    Target: You
    Duration: 1 round/level
    Power Points: 10
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

    object oManifester = OBJECT_SELF;
    object oTarget     = GetSpellTargetObject();
    struct manifestation manif =
       EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_EXTEND
                              );

      if(manif.bCanManifest)
    {
        effect eLink    =                          EffectVisualEffect(VFX_DUR_ULTRAVISION);
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT));
               eLink    = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
        effect eTrueSee = EffectTrueSeeing();
        float fDuration = 60.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

          eLink = EffectLinkEffects(eLink, eTrueSee);

          ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink , oTarget,fDuration);
      }
      }