#include "ps_inc_legal"

void JumpToObjectIfLegal(object Destination)
{
	string ErrorMsg = PS_CheckCharacterLegality(OBJECT_SELF, FALSE);

	if (ErrorMsg != "") {
		SendMessageToPC(OBJECT_SELF, "Portal failed due to character validation failure.");
		SendMessageToPC(OBJECT_SELF, ErrorMsg);
		return;
	}

	JumpToObject(Destination);
}

void main(string sDestTag, int bWholeParty, int bOnlyThisArea)
{
	object PC = GetPCSpeaker();
	object PartyMember;
	object Target = GetObjectByTag(sDestTag);
	object Area;

	if (PC == OBJECT_INVALID) {
		PC = OBJECT_SELF;
	}

	//
	// Send the PC to the target object.
	//

	AssignCommand(PC, JumpToObjectIfLegal(Target));

	//
	// If the rest of the party is desired to be transferred as well, sweep the
	// party for other party members and (if they match the area restrictions)
	// perform the transfer for them as well.
	//

	if (bWholeParty != FALSE) {
		Area = GetArea(PC);
		PartyMember = GetFirstFactionMember(PC, FALSE);

		while (PartyMember != OBJECT_INVALID) {
			if ((PartyMember != PC) &&
			    ((bOnlyThisArea == FALSE) || (GetArea(PartyMember) == Area))) {

				 AssignCommand(PartyMember, JumpToObjectIfLegal(Target));
			}

			PartyMember = GetNextFactionMember(PC, FALSE);
		}
	}
}