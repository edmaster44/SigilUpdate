

void SpecialChest(object oPC, object oPLACE)
{
	int nDC = GetLocalInt(oPLACE, "DC");
	if (GetSkillRank(SKILL_OPEN_LOCK, oPC) < nDC)
	{
		SendMessageToPC(oPC, "You need at least " + IntToString(nDC) + " ranks in Open Lock skill to be able to open this chest.");
		return;
	}
	int nQTY = GetLocalInt(oPLACE, "ITEM_QTY");
	if (nQTY < 1) nQTY = 1;
	string sTYPE = GetLocalString(oPLACE, "ITEM_REF");
	string sTXT;
	string sPARTY;
	object oITEM;
	object oPARTY = GetFirstFactionMember(oPC, FALSE);
	while (oPARTY != OBJECT_INVALID)
	{
		if (GetIsOwnedByPlayer(oPARTY) == TRUE)
		{
			sPARTY = GetBicFileName(oPARTY);
			if (GetLocalInt(oPLACE, sPARTY) == TRUE) sTXT = "*You have already received the contents from that chest.*";
			else
			{
				if (sTYPE == "")
				{
					GiveGoldToCreature(oPARTY, nQTY, FALSE);
					sTXT = "*You obtain " + IntToString(nQTY) + " gold pieces from the chest.*";
				}
				else
				{
					oITEM = CreateItemOnObject(sTYPE, oPARTY, nQTY, "", FALSE);
					if (oITEM == OBJECT_INVALID)
					{
						SendMessageToPC(oPC, "ERROR: REWARD IS INVALID OBJECT. IF THIS ERROR PERSISTS, CONTACT ADMIN.");
						return;
					}
					sTXT = "*You obtain " + IntToString(nQTY) + " " + GetName(oITEM) + " from the chest.*";
				}
				SetLocalInt(oPLACE, sPARTY, TRUE);
			}
			FloatingTextStringOnCreature(sTXT, oPARTY, FALSE);
		}
		oPARTY = GetNextFactionMember(oPC, FALSE);
	}
}

void LifeCrystal(object oPC)
{
	ActionCastSpellAtObject(SPELL_GREATER_RESTORATION, oPC, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
	ActionCastFakeSpellAtLocation(SPELL_METEOR_SWARM, GetLocation(oPC));
	DelayCommand(0.0f, ForceRest(oPC));
}

void ReturnPortal(object oPC, object oPLACE)
{
	string sWP = GetLocalString(oPLACE, "WAYPOINT");
	object oWP = GetWaypointByTag(sWP);
	if (oWP == OBJECT_INVALID) return;
	SetLocalObject(oPC, "RETURN_PORTAL", oWP);
	string sTXT = "This portal will send you back to " + GetName(oWP) + ". Do you wish to enter?";
	DisplayMessageBox(oPC, 0, sTXT, "gui_returnportal", "", TRUE, "SCREEN_MESSAGEBOX_DEFAULT", 0, "YES", 0, "NO");
}

void main()
{
	object oPC = GetLastUsedBy();
	if (GetIsPC(oPC) == FALSE) return;
	if (GetIsOwnedByPlayer(oPC) == FALSE) return;
	if (GetIsInCombat(oPC) == TRUE)
	{
		SendMessageToPC(oPC, "This object cannot be used during combat."); 
		return;
	}
	object oPLACE = OBJECT_SELF;
	int nTYPE = GetLocalInt(oPLACE, "TYPE");
	switch (nTYPE)
	{
		case 1: LifeCrystal(oPC); break;
		case 2: ReturnPortal(oPC, oPLACE); break;
		case 3: SpecialChest(oPC, oPLACE); break;
	}
}