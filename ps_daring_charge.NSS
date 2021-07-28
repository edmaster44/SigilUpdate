#include "nwn2_inc_spells"
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 
#include "ps_inc_functions"

void main()
{
	if (!X2PreSpellCastCode())
	{	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
		return;
	}

	//Declare major variables
	object oCaster = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	float fDist = GetDistanceToObject(oTarget);

	if(fDist >= 31.0f) {
		SendMessageToPC(oCaster, "Daring Charge failed, maximum range is 30 meters, current distance is "
			+ IntToString(FloatToInt(fDist)) + " meters.");
		return;
	}
		
	object armorItem = GetItemInSlot(INVENTORY_SLOT_CHEST);
	int nArmorRank = GetArmorRank(armorItem);
	if(nArmorRank == ARMOR_RANK_MEDIUM || nArmorRank == ARMOR_RANK_HEAVY) {
		SendMessageToPC(oCaster, "Daring Charge failed, can not be used in medium or heavy armor.");
		return;
	}

	object mainWpnItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
	int mainWpnOk = (mainWpnItem == OBJECT_INVALID);
	if(!mainWpnOk) {
		int nMainWpnType = GetBaseItemType(mainWpnItem);
		switch(nMainWpnType) {
		case BASE_ITEM_INVALID:
		case BASE_ITEM_DAGGER:
		case BASE_ITEM_HANDAXE:
		case BASE_ITEM_KAMA:
		case BASE_ITEM_KUKRI:
		case BASE_ITEM_LIGHTHAMMER:
		case BASE_ITEM_LIGHTMACE:
		case BASE_ITEM_RAPIER:
		case BASE_ITEM_SHORTSWORD:
		case BASE_ITEM_SICKLE:
		case BASE_ITEM_WHIP:
			mainWpnOk = TRUE;
		default:
			break;
		}
	}
	if(mainWpnOk) {
		object offhandWpnItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
		if(offhandWpnItem != OBJECT_INVALID) {
			int nOffhandWpnType = GetBaseItemType(offhandWpnItem);
			switch(nOffhandWpnType) {
			case BASE_ITEM_SMALLSHIELD:
			case BASE_ITEM_LARGESHIELD:
			case BASE_ITEM_TOWERSHIELD:
				mainWpnOk = FALSE;
			default:
				break;
			}
		}
	}
	if(!mainWpnOk) {
		SendMessageToPC(oCaster, "Daring Charge failed, can not be used with a non-finessable main weapon or with a shield.");
		return;
	}
	
    location locSpellTarget = GetLocation(OBJECT_SELF);

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectNWN2SpecialEffectFile("lcda_movement_trail"), oCaster, 1.0f);
	
	SetLocalObject(oCaster, "DARING_CHARGE_TARGET_OBJ", oTarget);
	DelayCommand(0.2f, ExecuteScript("ps_daring_charge_cb", oCaster));
	
	DelayCommand(0.1f, ActionJumpToObject(oTarget));
}