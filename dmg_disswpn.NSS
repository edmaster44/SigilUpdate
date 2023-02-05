#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "x2_inc_itemprop"





void main()
{

object oManifester = OBJECT_SELF;
object oTarget     = IPGetTargetedOrEquippedMeleeWeapon();
struct manifestation manif =
        EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_AUGMENT | METAPSIONIC_EMPOWER |METAPSIONIC_EXTEND 
                             );



int nNumberOfDice;

if (GetManifesterLevel(oManifester)>3)
{nNumberOfDice = 1;}

if (GetManifesterLevel(oManifester)>6)
{nNumberOfDice = 2;}

if (GetManifesterLevel(oManifester)>9)
{nNumberOfDice = 3;}

if (GetManifesterLevel(oManifester)>12)
{nNumberOfDice = 4;}

if (GetManifesterLevel(oManifester)>15)
{nNumberOfDice = 5;}

if (manif.bAugment) nNumberOfDice = nNumberOfDice+1;	

float fDur = 60.0f * manif.nManifesterLevel;

	

	effect eDam = EffectDamageOverTime(d6(nNumberOfDice),6.0,DAMAGE_TYPE_ACID,TRUE);  
	eDam = EffectLinkEffects(eDam, EffectVisualEffect(VFX_HIT_SPELL_ACID));
	DelayCommand(6.0,ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget,fDur));
}