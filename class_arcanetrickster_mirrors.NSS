// Prism of Mirrors ability for Arcane Trickster on SCOD
// Creates 6 clones of the character who all run off in different directions
// By Michel Remillard / Electrohydra
// michel.remillard1@gmail.com
// Last edit 31/05/2017
#include "ps_inc_advscript"
#include "ps_inc_functions"

const string CLONE_TEMPLATE = "mirrorclone";

object CreateClone(object oCreature, location lLocation);

void main()
{
	effect eInvisible = ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY));
	location lLocation = GetLocation(OBJECT_SELF);

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvisible, OBJECT_SELF, 1.0f);
	
	int i;
	for (i = 1; i <= 4; ++i)
	{
		object oClone = CreateClone(OBJECT_SELF, lLocation);
		DelayCommand(0.2f, SetCommandable(TRUE, oClone));
		DelayCommand(0.2f + (IntToFloat(d10(1)) / 10), AssignCommand(oClone, ActionMoveAwayFromLocation(lLocation, TRUE, 500.0f)));
		
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvisible, oClone, 1.0f);

		DelayCommand(18.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(FALSE, FALSE, TRUE,TRUE), oClone, 2.0f));
	}

	return;
}

object CreateClone(object oCreature, location lLocation)
{
 	object oClone = CreateObject(OBJECT_TYPE_CREATURE, CLONE_TEMPLATE, lLocation);
	
	// Sets apperance
	SetCreatureAppearanceType(oClone, GetAppearanceType(oCreature));
	PS_SetCreatureCoreAppearance(oClone, PS_GetCreatureCoreAppearance(oCreature));
	
	effect eEffect = GetFirstEffect(oCreature);
	
	// Applies all visual effects from the user to the clone
	while (GetIsEffectValid(eEffect) == TRUE)
	{
		if (GetEffectType(eEffect) == EFFECT_TYPE_VISUALEFFECT)
		{
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oClone); 
		}
		
		eEffect = GetNextEffect(oCreature);
	}
	
	SetFirstName(oClone, GetFirstName(oCreature));
	SetLastName(oClone, GetLastName(oCreature));
	
	// Loop through inventory
	int iSlot;
	for (iSlot = INVENTORY_SLOT_CHEST; iSlot <= INVENTORY_SLOT_CARMOUR; ++iSlot)
	{
		object oItem = GetItemInSlot(iSlot ,oCreature);
		
		if (GetIsObjectValid(oItem) && GetObjectType(oItem) == OBJECT_TYPE_ITEM)
		{
			object oItemCopy = CopyItem(oItem, oClone, FALSE);
			SetDroppableFlag(oItemCopy, FALSE);
			// Remove any equiping restrictions on the item
			itemproperty prop = GetFirstItemProperty(oItemCopy);
			while (GetIsItemPropertyValid(prop))
			{
				if (GetItemPropertyType(prop) == ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP
				|| GetItemPropertyType(prop) == ITEM_PROPERTY_USE_LIMITATION_CLASS
				|| GetItemPropertyType(prop) == ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE
				|| GetItemPropertyType(prop) == ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT)
					RemoveItemProperty(oItemCopy, prop);
					
				prop = GetNextItemProperty(oItemCopy);
			}

			AssignCommand(oClone, ActionEquipItem(oItemCopy, iSlot));
		}
	}
	
	// Cutscene Dominate lets you have multiple clones at once unlike summoning. Delayed so that it won't interrupt actions
	effect eClone = ExtraordinaryEffect(EffectLinkEffects(EffectBlindness(), EffectCutsceneDominated()));
	DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eClone, oClone));
	
	// Adds some hit points to the clone so they aren't made of paper
	effect eBonusHP = ExtraordinaryEffect(EffectBonusHitpoints(GetCurrentHitPoints(oCreature)));
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonusHP, oClone, 20.0f);
	effect eHealing = EffectHeal(1000);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eHealing, oClone, 0.0f);
	
	return oClone;
}