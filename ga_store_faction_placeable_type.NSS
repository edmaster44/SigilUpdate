

/**********************************************************
* Function created for SCOD server by Agony_Aunt/Loki_666 *
**********************************************************/

// Rather than passing resrefs of placeables to the main script, we store on PC first.  Saves adding another parameter to the main script and passing strings when not needed.

void main(string sTemplate)
{
	object oPC = OBJECT_SELF;
	SetLocalString(oPC, "FACTION_PLACEABLE", sTemplate);
}