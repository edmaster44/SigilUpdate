#include "psi_inc_manifest"
#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "x2_inc_itemprop"





void main()
{

object oManifester = OBJECT_SELF;
object oTarget     = GetSpellTargetObject();


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

if(GetLocalInt(oManifester,"METAPSI_AUGMENT"))
{
nNumberOfDice = nNumberOfDice+1;	}

float fDur = TurnsToSeconds(nPsywar(oManifester));




	

	
	
	effect eDam = EffectDamageOverTime(d6(nNumberOfDice),6.0,DAMAGE_TYPE_ACID,TRUE);  
	eDam = EffectLinkEffects(eDam, EffectVisualEffect(VFX_HIT_SPELL_ACID));
	if (GetHasSpellEffect(2893, oTarget))
	{
		RemoveEffect(oTarget, eDam);
	}
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget,fDur);
	}
	
 
