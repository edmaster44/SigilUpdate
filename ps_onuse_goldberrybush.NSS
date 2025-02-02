void main()
{
	object theUser = GetLastUsedBy();
	if (theUser != OBJECT_INVALID)
	{
		string varname = "ps_got_goldenberries";
		if (GetLocalInt(theUser, varname) == 0)
		{
			SetLocalInt(theUser, varname, 1);
			CreateItemOnObject("ps_item_goldberries", theUser);
			SendMessageToPC(theUser, "You pick all of the golden berries from the bush.");
		}
		else
		{
			SendMessageToPC(theUser, "There are no more berries on this bush.");
		}
	}
}