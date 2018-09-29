/*
ps_portalgenerator_multiuse_ex
by Dedic8ed 2/28/11

See ps_portalgenerator_multiuse_en for instructions.
*/
void main()
{
object oExit = GetExitingObject();
if (!GetIsPC(oExit)) return;

string sWaypt	= GetLocalString(OBJECT_SELF, "waypoint"); 	//portal waypoint tag
string sFx		= GetLocalString(OBJECT_SELF, "fx");		//portal visual effect
string sPortal	= GetLocalString(OBJECT_SELF, "portal");	//portal tag

string SPAWNED = "nSpawned";
if(GetLocalInt(OBJECT_SELF, SPAWNED))						//Determine the portal is existant
{
object oPortal=GetObjectByTag(sPortal);						//Select the portal object
SetPlotFlag(oPortal,FALSE);									//Mark the portal as non-plot
object oPortalEffect=GetNearestObjectByTag(sFx);			//Select the visual effect
DestroyObject(oPortalEffect,30.0f);							//Remove the visual effect
DestroyObject(oPortal,30.0f);								//Destroy the portal

SetLocalInt(OBJECT_SELF, SPAWNED, FALSE);					//Mark the portal as non-spawned
}
} 