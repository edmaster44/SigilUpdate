// script for copying the appearance from one item, the properties from another, and making a new set.

#include "x2_inc_itemprop"
#include "ps_inc_cloneitems"

void main()
{
	DoCloning(GetCloneItem(GetCloneContainer(CONTAINER_PROP)), GetCloneItem(GetCloneContainer(CONTAINER_APP)));
}