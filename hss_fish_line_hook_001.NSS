//HSS on activate item event script

#include "hss_fishing_inc"


// Tag-based script template.
// This is intended to be a starting point for writing an item's tag-based script.
// Copy this to a script whose name is the tag of the item in question.
// Edit the event handlers (scroll down to find them) as desired.


// -----------------------------------------------------------------------------
// This first part is standard and generic.
// There should be no need to edit it; just skip down to the next part.
// -----------------------------------------------------------------------------


#include "x2_inc_switches"


// The individual event handlers.

void OnAcquire(object oItem, object oAcquiredBy, object oTakenFrom, int nStackSize);
void OnActivate(object oItem, object oTarget, location lTarget, object oActivator);
void OnEquip(object oItem, object oEquippedBy);
void OnHit(object oItem, object oTarget, object oCaster);
int  OnSpellCast(object oItem, int nSpell, object oCaster);
void OnUnacquire(object oItem, object oLostBy);
void OnUnequip(object oItem, object oUnequippedBy);


// The main function.
void main()
{
    int nEvent = GetUserDefinedItemEventNumber();


    // Spells might continue to their spell scripts. All other events are
    // completely handled by this script.
    if ( nEvent != X2_ITEM_EVENT_SPELLCAST_AT )
        SetExecutedScriptReturnValue();

    // Determine which event triggered this script's execution.
    switch ( nEvent )
    {
        // Item was acquired.
        case X2_ITEM_EVENT_ACQUIRE:
                OnAcquire(GetModuleItemAcquired(), GetModuleItemAcquiredBy(),
                          GetModuleItemAcquiredFrom(), GetModuleItemAcquiredStackSize());
                break;

        // Item was activated ("activate item" or "unique power").
        case X2_ITEM_EVENT_ACTIVATE:
                OnActivate(GetItemActivated(), GetItemActivatedTarget(),
                           GetItemActivatedTargetLocation(), GetItemActivator());
                break;

        // Item was equipped by a PC.
        case X2_ITEM_EVENT_EQUIP:
                OnEquip(GetPCItemLastEquipped(), GetPCItemLastEquippedBy());
                break;

        // Item is a weapon that just hit a target, or it is the armor of someone
        // who was just hit.
        case X2_ITEM_EVENT_ONHITCAST:
                OnHit(GetSpellCastItem(), GetSpellTargetObject(), OBJECT_SELF);
                break;

        // A PC (or certain NPCs) cast a spell at the item.
        case X2_ITEM_EVENT_SPELLCAST_AT:
                if ( OnSpellCast(GetSpellTargetObject(), GetSpellId(), OBJECT_SELF) )
                    SetExecutedScriptReturnValue();
                break;

        // Item was unacquired.
        case X2_ITEM_EVENT_UNACQUIRE:
                OnUnacquire(GetModuleItemLost(), GetModuleItemLostBy());
                break;

        // Item was unequipped by a PC.
        case X2_ITEM_EVENT_UNEQUIP:
                OnUnequip(GetPCItemLastUnequipped(), GetPCItemLastUnequippedBy());
                break;
    }
}


// -----------------------------------------------------------------------------
// Event handlers
// -----------------------------------------------------------------------------
// This second part is where you add your desired functionality. Each event
// has its own function with relavant information passed as parameters.
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// oItem was acquired (by a PC or an NPC).
// Run by the module.
void OnAcquire(object oItem, object oAcquiredBy, object oTakenFrom, int nStackSize)
{
    // Default: do nothing.
}


// -----------------------------------------------------------------------------
// oItem was activated ("activate item" or "unique power").
// Run by the module.
void OnActivate(object oItem, object oTarget, location lTarget, object oActivator)
{
    // Default: do nothing.
	 //    object oItem =  GetItemActivated();
     object oPC = oActivator;
     //object oTarget = GetItemActivatedTarget();
     string sTag = GetTag(oItem);


 	 HSS_DoFishingLineUse(oPC, oTarget);
}


// -----------------------------------------------------------------------------
// oItem was equipped by a PC.
// Run by the module.
void OnEquip(object oItem, object oEquippedBy)
{
    // Default: do nothing.
}


// -----------------------------------------------------------------------------
// oItem is a weapon that just hit a target, or it is the armor of someone who
// was just hit by someone else's weapon.
// Run by the caster.
void OnHit(object oItem, object oTarget, object oCaster)
{
    // Default: do nothing.
}


// -----------------------------------------------------------------------------
// Someone cast a spell at oItem.
// This usually only fires if a PC cast the spell, but it also fires for
// DM-possessed NPCs and NPCs in an area with the "X2_L_WILD_MAGIC" local integer set.
//
// Return TRUE to prevent the spell script from firing.
// Return FALSE to proceed normally.
//
// This fires after the UMD check, module spellhook, item creation, and
// sequencer handlers decide they don't want to handle/interrupt this spell.
// This fires before the check to see if this is a spell that normally can
// target items (and before the spell script itself runs).
//
// Run by the caster.
int OnSpellCast(object oItem, int nSpell, object oCaster)
{
    // Default: just proceed normally.
    return FALSE;
}


// -----------------------------------------------------------------------------
// oItem was unacquired/lost (by a PC or NPC).
// Run by the module.
void OnUnacquire(object oItem, object oLostBy)
{
    // Default: do nothing.
}


// -----------------------------------------------------------------------------
// oItem was unequipped by a PC.
// Run by the module.
void OnUnequip(object oItem, object oUnequippedBy)
{
    // Default: do nothing.
}

/*
void main()
{
     object oItem =  GetItemActivated();
     object oPC = GetItemActivator();
     object oTarget = GetItemActivatedTarget();
     string sTag = GetTag(oItem);


     if (sTag == "HSS_FISH_ROD")
        {
        HSS_DoCast(oPC, oItem);
        }
		
	 if (sTag == "HSS_FISH_LINE_HOOK_001")
	    {
		HSS_DoFishingLineUse(oPC, oTarget);
		}	
}
*/