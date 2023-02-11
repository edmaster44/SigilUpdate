#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "x2_inc_itemprop"





void main()
{

object oManifester = OBJECT_SELF;
object oTarget     = GetSpellTargetObject();
struct manifestation manif =
        EvaluateManifestationNew(oManifester, oTarget,
                              GetSpellId(),
                              METAPSIONIC_AUGMENT | METAPSIONIC_EMPOWER |METAPSIONIC_EXTEND 
                             );



int nNumberOfDice;



if (nPsywar(oManifester)>3)
{nNumberOfDice = 1;}

if (nPsywar(oManifester)>6)
{nNumberOfDice = 2;}

if (nPsywar(oManifester)>9)
{nNumberOfDice = 3;}

if (nPsywar(oManifester)>12)
{nNumberOfDice = 4;}

if (nPsywar(oManifester)>15)
{nNumberOfDice = 5;}

if (manif.bAugment) nNumberOfDice = nNumberOfDice+1;	

float fDur = 60.0f * nPsywar(oManifester);


if (manif.bAugment) nNumberOfDice = nNumberOfDice+1;	


	

	effect eDam = EffectDamageOverTime(d6(nNumberOfDice),6.0,DAMAGE_TYPE_ACID,TRUE);  
	eDam = EffectLinkEffects(eDam, EffectVisualEffect(VFX_HIT_SPELL_ACID));
	DelayCommand(6.0,ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget,fDur));
}