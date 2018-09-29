//HSS on activate item event script

#include "hss_fishing_inc"
#include "ps_sigis_inc"


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

void OnActivate(object oItem, object oTarget, location lTarget, object oActivator);


// The main function.
void main()
{
    int nEvent = GetUserDefinedItemEventNumber();


    // Spells might continue to their spell scripts. All other events are
    // completely handled by this script.
    if ( nEvent != X2_ITEM_EVENT_SPELLCAST_AT )
        SetExecutedScriptReturnValue();
//SendMessageToPC(GetFirstPC(), "nEvent "+IntToString(nEvent));
    // Determine which event triggered this script's execution.
    switch ( nEvent )
    {
        // Item was activated ("activate item" or "unique power").
        case X2_ITEM_EVENT_ACTIVATE:
                OnActivate(GetItemActivated(), GetItemActivatedTarget(),
                           GetItemActivatedTargetLocation(), GetItemActivator());
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
// oItem was activated ("activate item" or "unique power").
// Run by the module.
void OnActivate(object oItem, object oTarget, location lTarget, object oActivator)
{
    // Default: do nothing.
	 //    object oItem =  GetItemActivated();
     //object oTarget = GetItemActivatedTarget();
	 
	 object oPC = oActivator;
	 string sTag = GetTag(oItem);
	 int nCooldown = GetLocalInt(oPC, "VAR_FISHING_COOLDOWN");
	 int nCurrentTime = GetRealTime();
	 int nDelay = 30;	//delay 
	 if (nCooldown > nCurrentTime)	{
		FloatingTextStringOnCreature("YOU CANNOT USE FISHING ROD AGAIN SO SOON, YOU MUST WAIT "+IntToString(nCooldown - nCurrentTime)+" SECONDS.", oPC, FALSE);
		return;
	 }
	 else	{
		//SendMessageToPC(GetFirstPC(), "CALLING CAST");
		SetLocalInt(oPC,"VAR_FISHING_COOLDOWN",nCurrentTime + nDelay);
		HSS_DoCast(oPC, oItem);
	 }
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