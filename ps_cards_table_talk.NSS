/*********************************************************
* Script for Triple Triad like card game for SCoD        *
* by Agony_Aunt/Loki_999                                 *
* script to talk silently to the table/board placeable   *
*********************************************************/

void main()
{
	object oUser = GetLastUsedBy();
    ActionStartConversation(oUser,"", TRUE, FALSE, FALSE);
}