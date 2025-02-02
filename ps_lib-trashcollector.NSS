#include "ff_safevar"

////////////////////////////////////////////////////////////////
// ps_lib-trashcollector
//
//
// Library of routines our trash collectors need
//
//
//
// Author:						ADnD'R (Savageaxe)
// Last Modified By:			ADnD'R
// Last Modified Date:			11JUNE2010
//
/////////////////////////////////////////////////////////////////
/*
History of changes

	27AUG2010 - ADnD'R
		1. TrashCollectorRandomMove(): now moves to a random placeable should
		be even more random than before. 
		2. GetTrash(): now we double check to make sure we have the item in our (the trash critter's)
		inventory before doing a DestroyObject(). Moved item destruction to a wrapper function so I could
		queue (delay) the action using ActionDoCommand().
		3. The "don't chat" 9 times out of 10 was released commented out for debugging purposes, corrected it.	
*/



/// Function Declarations
void GetTrash();
void TrashCollectorRandomMove(object oTrash);
void TrashCollectedChat(object oTrash);



void
TrashCollectedChat(object oTrash)
{

	// Only emote 10% of the time
	if (d10() != 1)
		return;

	string sEmote = PS_GetLocalString(OBJECT_SELF, "EATING_TALK");
	
	if (sEmote == "")
		return;			

	// we need to now possess the item (eating it)
	// before any eating noises
	object oNewOwner = GetItemPossessor(oTrash);
	if (oNewOwner == OBJECT_SELF)
		SpeakString(sEmote, TALKVOLUME_TALK); 	

}

void
TrashCollectorRandomMove(object oTrash)
{
	// see if there's any other trash items near our location - like if more than one was dropped
	object oNextItem = GetNearestObject(OBJECT_TYPE_ITEM, oTrash);
		
	// If there's no such item, or it has an owner, we can do a random move (no trash to grab)
	
	if (oNextItem != oTrash && (
		oNextItem == OBJECT_INVALID || GetItemPossessor(oNextItem) != OBJECT_INVALID))
	//Move to the nearest random placeable 
		DelayCommand(3.0f, ActionMoveToObject(GetNearestObject(OBJECT_TYPE_PLACEABLE, OBJECT_SELF, d10())));


}

void
DestroyTrashObject(object oTrash)
{
	/// Only destroy it if we picked it up!
	if (GetItemPossessor(oTrash) == OBJECT_SELF)
		DestroyObject(oTrash, 0.0f, FALSE);
	
}

void
GetTrash()
{
	object oTrash = PS_GetLocalObject(OBJECT_SELF, "TRASH_OBJECT");

	ActionForceMoveToObject(oTrash, TRUE, 0.5f);
	ActionPickUpItem(oTrash);
	ActionDoCommand(TrashCollectedChat(oTrash));
	ActionDoCommand(TrashCollectorRandomMove(oTrash));
	DelayCommand(60.0f, ActionDoCommand(DestroyTrashObject(oTrash))); 	

}