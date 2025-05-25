

/*variation on i_waitercontract_ac to handle slaves of a non-combat nature*/
/* modified by Mimi Fearthegn */

void main()
{
	object	oPC = GetItemActivator();
	location lTarget = GetItemActivatedTargetLocation();
	object oItem = GetItemActivated();
	string sResRef = GetLocalString(oItem, "RESREF");
	string info = GetSubString(GetTag(oItem), 4, GetStringLength(GetTag(oItem))-4);
	string newName = sResRef+"_"+GetFirstName(oPC);
	if (info != "")
		newName += "_"+info;
	
	object oServant = GetNearestObjectByTag(newName);
	if (GetIsObjectValid(oServant))
		return;
	
	oServant = CreateObject(OBJECT_TYPE_CREATURE, sResRef, lTarget, TRUE, newName);
	SetLocalString(oServant, "OwnerName", GetName(oPC));
	SetLocalObject(oServant, "MASTER", oPC);
	SetLocalObject(oServant, "SLAVE_CONTROLLER", oItem);
	if (info != "")
		SetFirstName(oServant, info);
	ActionForceFollowObject(oPC, 2.0f);
}