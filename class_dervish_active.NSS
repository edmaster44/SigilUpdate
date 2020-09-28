#include "nwn2_inc_spells"
#include "aaa_constants"
#include "ps_inc_equipment"




void Dervish_Dance(object oPC,int nSpell)
{


int nLevel = GetLevelByClass(CLASS_DERVISH, oPC);
	int nBonus = (nLevel +1) / 2;
	float fDuration = RoundsToSeconds(10);
	int nValid = nDervishValid(oPC);
	if (nValid )
	{effect eAB = EffectAttackIncrease(nBonus);
		effect eSlash = EffectDamageIncrease(nBonus, DAMAGE_TYPE_SLASHING);
		effect eFatigue = EffectFatigue ();
		effect eLink = EffectLinkEffects(eAB, eSlash);
		eLink = SupernaturalEffect(eLink);
		eLink = SetEffectSpellId(eLink, SPELLABILITY_DERVISH_DANCE );
		
    	RemoveEffectsFromSpell(OBJECT_SELF, SPELLABILITY_DERVISH_DANCE);
	//Dance of Death	
	object oArmorNew = GetItemInSlot(INVENTORY_SLOT_CARMOUR,OBJECT_SELF);				
		if (nLevel > 9)
		{
			itemproperty iBonusFeat1 = ItemPropertyBonusFeat(IP_CONST_FEAT_CLEAVE);  //Cleave
			itemproperty iBonusFeat2 = ItemPropertyBonusFeat(45);	//Great Cleave
			if (oArmorNew == OBJECT_INVALID)
			{
				oArmorNew = CreateItemOnObject("x2_it_emptyskin", OBJECT_SELF, 1, "", FALSE);
				AddItemProperty(DURATION_TYPE_TEMPORARY,iBonusFeat1,oArmorNew,fDuration);
				AddItemProperty(DURATION_TYPE_TEMPORARY,iBonusFeat2,oArmorNew,fDuration);
				DelayCommand(fDuration, DestroyObject(oArmorNew,0.0f,FALSE));
				ActionEquipItem(oArmorNew,INVENTORY_SLOT_CARMOUR);		
			}
			else
			{
		        IPSafeAddItemProperty(oArmorNew, iBonusFeat1, fDuration,X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE,FALSE );	
		        IPSafeAddItemProperty(oArmorNew, iBonusFeat2, fDuration,X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE,FALSE );	
			}		
		}
		else
		if (nLevel > 3)
		{
			itemproperty iBonusFeat1 = ItemPropertyBonusFeat(IP_CONST_FEAT_CLEAVE);  //Cleave
			if (oArmorNew == OBJECT_INVALID)
			{
				oArmorNew = CreateItemOnObject("x2_it_emptyskin", OBJECT_SELF, 1, "", FALSE);
				AddItemProperty(DURATION_TYPE_TEMPORARY,iBonusFeat1,oArmorNew,fDuration);
				DelayCommand(fDuration, DestroyObject(oArmorNew,0.0f,FALSE));
				ActionEquipItem(oArmorNew,INVENTORY_SLOT_CARMOUR);		
			}
			else
			{
		        IPSafeAddItemProperty(oArmorNew, iBonusFeat1, fDuration,X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE,FALSE );	
			}		
		}
		
		if (nLevel < 9)	
		{	
			if (!GetHasFeat(FEAT_DERVISH_TIRELESS_DANCE,oPC))				
					DelayCommand(fDuration, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFatigue, OBJECT_SELF, RoundsToSeconds(10)));
		}
		DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, fDuration));	
		}	
	else
	{
		SendMessageToPC(oPC, "You must be wearing light or no armor and wielding a slashing weapon (both must be slashing if two weapons are used).");
	}	

}