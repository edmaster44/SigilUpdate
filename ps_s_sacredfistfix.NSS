#include "x2_inc_spellhook"
#include "nwn2_inc_spells"
#include "x2_inc_itemprop"

void main()
{

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
	//Yeah, failing to use proper defined consts here.  If i do more work like this ill setup and include
	//Anyway, this is reserved row in spells.2da, not a real spell.
	int nSpellId = 1150;	
	
	object oWpn1 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, OBJECT_SELF);
	object oWpn2 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF);

	int iType1 = GetBaseItemType(oWpn1);
	int iType2 = GetBaseItemType(oWpn2);
	
	// check for creature weapons	
	if ((GetIsObjectValid(oWpn1) && (iType1 < 160 || iType1 > 174)) || (GetIsObjectValid(oWpn2) && (iType2 < 160 || iType2 > 174)))
	{
		if (GetHasSpellEffect(nSpellId,OBJECT_SELF))
		{
			return;
		}	
		else
		{
			effect eAB =  EffectAttackDecrease(8);
			eAB = SetEffectSpellId(eAB,nSpellId);
			eAB = SupernaturalEffect(eAB);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAB, OBJECT_SELF);
		}
	}
	else
	{
		if (GetHasSpellEffect(nSpellId,OBJECT_SELF))
		{
			RemoveSpellEffects(nSpellId, OBJECT_SELF, OBJECT_SELF);
		}
	}
}      