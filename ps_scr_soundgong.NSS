/*   ps_scr_soundgong    */

// Put this script in the On Melee Attacked property of a gong placeable.
// Make sure the gong is set as "plot", is "usable", and is not "static".

void main()
{

object oPC = GetLastAttacker();

if (!GetIsPC(oPC)) return;

	ActionSpeakString("<b><i>*BONG!*</i></b>");
    PlaySound("as_sw_x2gong1");
}