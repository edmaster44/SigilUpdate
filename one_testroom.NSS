#include "nwnx_sql"
void main () {

	object oPC = GetEnteringObject();
	object oModule = GetModule();
	
	string sVersion = GetLocalString(oModule, "serverVersion");
	if (sVersion != "")
		return;

	string sQuery = "SELECT version FROM server_version WHERE row_id = 1";
	
	SQLExecDirect(sQuery);
	
	if (SQLFetch() != SQL_ERROR) { //Fetch sql id's and store it
		string version = SQLGetData(1);
		SetLocalString(oModule, "serverVersion", version);
		
		//Test server! open the testing room
		if (version == "Testing") {
			if (GetObjectByTag("testing_portal_out") == OBJECT_INVALID) {
				object oWP = GetWaypointByTag("wp_testing_portal_in");
				CreateObject(OBJECT_TYPE_PLACEABLE, "testing_portal_out", GetLocation(oWP));
			}
		}
	}

}