#include "aaa_constants"
#include "psi_inc_manifest"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "x2_inc_itemprop"
#include "psi_inc_psifunc"



int HasDissWeapProp(object oWeapon){
	if (!IPGetIsMeleeWeapon(oWeapon)) return FALSE;
    itemproperty ip = GetFirstItemProperty(oWeapon);
    while (GetIsItemPropertyValid(ip)){
        if (GetItemPropertyType(ip) == ITEM_PROPERTY_ONHITCASTSPELL){
            if (GetItemPropertySubType(ip) == IP_CONST_ONHIT_CASTSPELL_DISSOLVING_WEAPON)
                return TRUE;
        }
        ip = GetNextItemProperty(oWeapon);
    }
    return FALSE;
}


void main(){
	object oManifester = OBJECT_SELF;
	int nId = GetSpellId();
	object oTarget = GetSpellTargetObject();
	int nBurns = 0;
	int nDissWeaps = 0;
	effect eFX = GetFirstEffect(oTarget);
	while (GetIsEffectValid(eFX)){
		if (GetEffectSpellId(eFX) == nId && GetEffectCreator(eFX) == oManifester)
			nBurns++;
		eFX = GetNextEffect(oTarget);
	}
	if (HasDissWeapProp(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oManifester)))
		nDissWeaps++;
	
	if (HasDissWeapProp(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oManifester)))
		nDissWeaps++;
	
	// do not stack the DoT more times than the number of weapons with the on hit
	if (nBurns >= nDissWeaps) return;
	
	float fDur = RoundsToSeconds(8);
	if (GetLocalInt(oManifester, "AUGMENT_DISS_WEAP")) fDur = RoundsToSeconds(10);

	effect eDam = EffectDamageOverTime(d6(),6.0, DAMAGE_TYPE_ACID, TRUE);  
	eDam = EffectLinkEffects(eDam, EffectVisualEffect(VFX_HIT_SPELL_ACID));
	eDam = SetEffectSpellId(eDam, nId);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDam, oTarget, fDur);

}
/* old
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
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDam, oTarget,fDur);
}
*/
 