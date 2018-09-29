#include "ps_inc_advscript"

void main()
{
	if (OBJECT_SELF == OBJECT_INVALID)
		return;

	PS_ActivateCounterSpell(GetPlayerCurrentTarget(OBJECT_SELF));
	return;

	/*
	 * Counterspell code moved into Sigil.Core.ActionQueue.ActivateCounterSpell.
	 *

	int Spellcaster;
	object Target;

	if (OBJECT_SELF == OBJECT_INVALID)
		return;

	//
	// Interested only on creature targets.
	//

	Target = GetPlayerCurrentTarget(OBJECT_SELF);
	if (GetObjectType(Target) != OBJECT_TYPE_CREATURE)
		return;

	//
	// If not a DM, only spellcasters can engage counterspell mode.  This check
	// is not strictly required as the game enforces the required checks anyway
	// but at least feedback is provided to the user that they have done an
	// invalid action.
	//

	if (GetIsDM(OBJECT_SELF) == FALSE)
	{
		int ClassIdx;

		Spellcaster = FALSE;

		for (ClassIdx = 1; ClassIdx < 5; ClassIdx += 1)
		{
			int ClassId = GetClassByPosition(ClassIdx, OBJECT_SELF);

			if (ClassId == CLASS_TYPE_INVALID)
			{
				break;
			}

			if (Get2DAString("classes", "SpellCaster", ClassId) == "1")
			{
				Spellcaster = TRUE;
				break;
			}
		}
	}
	else
	{
		Spellcaster = TRUE;
	}

	if (Spellcaster == FALSE)
	{
		SendMessageToPC(OBJECT_SELF, "Only spellcasters can counterspell.");
		return;
	}

	ActionCounterSpell(Target);
	return;
	*/
}

