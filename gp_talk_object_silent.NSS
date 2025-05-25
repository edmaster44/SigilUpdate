

//
// gp_talk_object_silent.nss
//
// This script enables an object to start a conversation when spoken to.
//
// The conversation has the following properties :
//
// - It is marked as a private conversation so it does not send text to other
//   players.
//
// - Unlike normal conversations, multiple players are not allowed to
//   participate with the conversation.  When a new player attempts to join the
//   conversation, the previous conversation owner has their conversation
//   aborted.
//
// These properties are valuable for conversations that are stateful and need
// to be bound to their conversation owner for their state.
//

const string PS_CONV_OWNER = "PS_CONV_OWNER";

void StartConversationWith(object ConverseWith)
{
	SetLocalObject(OBJECT_SELF, PS_CONV_OWNER, ConverseWith);
	ActionStartConversation(ConverseWith, "", TRUE);
}

void CancelPreviousConversation()
{
	object ConversationOwner;

	//
	// Find the previous conversation owner and check if they are in a
	// conversation.  If so, it's assumed to be the same one as the current
	// object, so break the current object out of its conversation.
	//

	ConversationOwner = GetLocalObject(OBJECT_SELF, PS_CONV_OWNER);
	if (!GetIsObjectValid(ConversationOwner) || !IsInConversation(ConversationOwner))
		return;

	AssignCommand(ConversationOwner, ActionStartConversation(ConversationOwner, "", TRUE, FALSE));
}

void main()
{
	object ConverseWith = GetLastUsedBy();

	//
	// If the object is already in a conversation then break it out by starting
	// a conversation with self, first.
	//

	if (IsInConversation(OBJECT_SELF))
	{
		CancelPreviousConversation();
		AssignCommand(OBJECT_SELF, StartConversationWith(ConverseWith));
		return;
	}

	StartConversationWith(ConverseWith);
}
