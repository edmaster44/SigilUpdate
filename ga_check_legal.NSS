#include "ps_inc_legal"

void main () {

	// Set default message if the script aborts unexpectedly.
	SetCustomToken(5001, "Details unavailable. Perhaps you have too many items in your inventory? Please contact a DM.  If none are in game at the moment, you may post on the forum or send a PM to a DM/Admin.");

	// Check legality of player, forcing the check through so that the player
	// is rested and buffs are cleared.  It's expected that this script is used
	// only from OOC room transitions so the check is forced to always clear
	// buffs even if it had previously passed.  Note that this will set the
	// canEnterModule flag on the PC as appropriate for the calling script to
	// test.
	string errorMessage = PS_CheckCharacterLegality(GetPCSpeaker(), TRUE);

	if (errorMessage == "") {
		return;
	}

	// Set diagnostic error message to send to the player.
	SetCustomToken(5001, errorMessage);
}