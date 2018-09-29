// script for copying the appearance from one item, the properties from another, and making a new set.
// this checks that all containers have the required setup, ie: Both source containers have only armours, that they are the same type, and that the destination is free.

#include "x2_inc_itemprop"
#include "ps_inc_cloneitems"

int StartingConditional()
{
	int iReturn = FALSE;
	
	if (CheckNewItemContainerIsEmpty() && CheckCloneItemsAreEqualType())
		iReturn = TRUE;
		
	return iReturn;
}