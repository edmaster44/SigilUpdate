//::///////////////////////////////////////////////////
//:: X0_STARTCONV
//:: Start a conversation with the user
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 01/13/2003
//::Edited on 1/10/2025 to Start the Conversation Safety so it doesn't crash the server
//::///////////////////////////////////////////////////


#include "ed_startconv_safe"

void main()
{

	
    ActionStartConversation(GetLastUsedBy(), "", TRUE);
}