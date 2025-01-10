//::///////////////////////////////////////////////////
//:: X0_STARTCONV
//:: Start a conversation with the user
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 01/13/2003
//::///////////////////////////////////////////////////


#include "ed_startconv_safe"

void main()
{

	
    ActionStartConversationSafe(GetLastUsedBy(), "", TRUE);
}