/*
   ----------------
   Precognition, Greater

   psi_pow_gprecog
   ----------------

   15/7/05 by Stratovarius
*/ /** @file

    Precognition, Greater

    Clairsentience
    Level: Seer 6
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 hour/level
    Power Points: 11
    Metapsionics: Extend

    Precognition allows your mind to glimpse fragments of potential future
    events - what you see will probably happen if no one takes action to change
    it. However, your vision is incomplete, and it makes no real sense until the
    actual events you glimpsed begin to unfold. That�s when everything begins to
    come together, and you can act, if you act swiftly, on the information you
    previously received when you manifested this power.

    In practice, manifesting this power grants you a �precognitive edge.�
    Normally, you can have only a single precognitive edge at one time. You must
    use your edge within a period of no more than 1 hour per level, at which
    time your preknowledge fades and you lose your edge.

    You can use your precognitive edge in a variety of ways. Essentially, the
    edge translates into a +4 insight bonus that you can apply at any time to
    either an attack roll, a damage roll, a saving throw, or a skill check. To
    apply this bonus for one round, press either the Attack, Save, Skill, or
    Damage option on the radial menu.
*/
#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
//#include "spinc_common"

void DispelMonitor(object oManifester, object oTarget, int nSpellID, int nBeatsRemaining);

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
                              METAPSIONIC_AUGMENT | METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        
		int spellID =  GetSpellId();
        float fDuration = manif.nManifesterLevel*600.0f;
        if(manif.bExtend) fDuration *= 2;
		int nMod = 3;
		if (manif.bAugment)
			nMod = 4;
		effect eEdge;
		if (spellID == 14600)
		{
			eEdge = EffectAttackIncrease(nMod);
		}
		else if (spellID == 14601)
		{
			eEdge = EffectDamageIncrease(nMod);
		}
		else if (spellID == 14602)
		{
			eEdge = EffectSavingThrowIncrease(SAVING_THROW_ALL, nMod);
		}
		else if (spellID == 14603)
		{
			eEdge = EffectSkillIncrease(SKILL_ALL_SKILLS, nMod);
		}
        
			   
		if (!GetHasSpellEffect(GetSpellId(), oTarget))
		{	   
	    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEdge, oTarget, fDuration);
		}
    }
}