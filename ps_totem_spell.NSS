#include "x2_inc_spellhook" 
#include "ps_totem_constants"

void main()
{
/* 
  Spellcast Hook Code 
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
  
*/
    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
// End of Spell Cast Hook

	int spellId = GetSpellId();
	int totemType = GetTotemType(spellId);

	if(GetLastSpellCastClass() != CLASS_TYPE_SPIRIT_SHAMAN) {
		SendMessageToPC(OBJECT_SELF, "Spellcasting failed: totem spells only work if cast from a Shaman spell slot!");
		return;
	}

    effect eAOE = EffectAreaOfEffect(GetTotemAoeEffectId(spellId));
    location lTarget = GetSpellTargetLocation();
    int nDuration = TOTEM_DURATION_ROUNDS;

	int nMetaMagic = GetMetaMagicFeat();
    if (nMetaMagic == METAMAGIC_EXTEND) {
	   nDuration = nDuration * 2;
    }

	// Delete any existing totems of this caster and of same buff type in the target area
	float fSearchSize = 10.0;
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fSearchSize, lTarget, FALSE, OBJECT_TYPE_AREA_OF_EFFECT);
    while(GetIsObjectValid(oTarget)) {
		object oCreator = GetAreaOfEffectCreator(oTarget);
		int nAoeSpellId = GetAreaOfEffectSpellId(oTarget);
		if(oCreator == OBJECT_SELF && IsTotemSpell(nAoeSpellId)) {
			int aoeTotemType = GetTotemType(nAoeSpellId);
			if(totemType == aoeTotemType) {
				DestroyObject(oTarget);
			}
		}
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fSearchSize, lTarget, FALSE, OBJECT_TYPE_AREA_OF_EFFECT);
    }

    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}