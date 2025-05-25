

/*Script by Ceremorph
This script is for single-use "home portal" items which will teleport the character using them to a
preset location, determined by the variable "waypoint" on the activated item.
*/

void main()
{
    object oPC = GetItemActivator();
	object oItem = GetItemActivated();
    object oTarget = oPC;
	string sWaypoint = GetLocalString(oItem,"waypoint");
	object oWaypoint;
	location lWaypoint;
    effect eVis = EffectNWN2SpecialEffectFile("fx_teleport");
	oWaypoint = GetObjectByTag(sWaypoint);
	lWaypoint= GetLocation(oWaypoint);

	if (GetIsInCombat(oPC)==FALSE)
		{
		if (GetAreaFromLocation(lWaypoint)==OBJECT_INVALID) 
			{
			SetNoticeText(oPC,"Waypoint Invalid");
			return;
			}
		
		AssignCommand(oPC, ClearAllActions());
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		AssignCommand(oPC, ActionJumpToLocation(lWaypoint));	
		}
	else
		{
		ActionGiveItem(oItem,oPC);
		SetNoticeText(oPC,"This item cannot be used during combat.");
		}
}