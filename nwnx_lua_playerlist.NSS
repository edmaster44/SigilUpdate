#include "nwnx_lua"
#include "ServerExts"
#include "nwnx_sql"
#include "nwnx_backend"

//Run the following on module load:
//RunLuaString("dofile('syntheticplayerlist.lua');");

//Get a player ID for sAccountName to use, if sAccountName is already registered it'll return its current ID
//Returns -1 if no slots remain
int GetPlayerIDForPlayer(string sAccountName);

//Retrive the first synthetic ID in use
//Returns -1 on failure
int GetFirstSyntheticPlayerID();

//Retrive the next synthetic ID in use
//Returns -1 on failure or at the end of the iteration
int GetNextSyntheticPlayerID();

//Retrive the account name thats associated with a synthetic ID, returns "" if none is found
string GetAccountNameFromSyntheticID(int ID);

//Frees the synthetic ID so that it may be reused
void FreeSyntheticID(int ID);

//Returns TRUE if sAccountName has an ID
int GetPlayerHasID(string sAccountName);

int GetPlayerHasID(string sAccountName){
	
	return StringToInt(RunLuaString("return Env.Get('syntheticplayerlist'):GetSyntheticIDExists([=["+sAccountName+"]=]);"));
}

void FreeSyntheticID(int ID){
	
	RunLuaString("Env.Get('syntheticplayerlist'):Delete("+IntToString(ID)+");");
}

string GetAccountNameFromSyntheticID(int ID){

	return RunLuaString("return Env.Get('syntheticplayerlist'):GetName("+IntToString(ID)+");");
}

int GetPlayerIDForPlayer(string sAccountName){

	return StringToInt(RunLuaString("return Env.Get('syntheticplayerlist'):GetSyntheticID([=["+sAccountName+"]=]);"));
}

int GetFirstSyntheticPlayerID(){

	return StringToInt(RunLuaString("return Env.Get('syntheticplayerlist'):GetFirstNext(true);"));
}

int GetNextSyntheticPlayerID(){

	return StringToInt(RunLuaString("return Env.Get('syntheticplayerlist'):GetFirstNext(false);"));
}

void PurgeSyntheticPlayerList()
{
	WriteTimestampedLogEntry("Purging synthetics list.");

	int id = GetFirstSyntheticPlayerID();
	while(id != -1)
	{
	    FreeSyntheticID(id);
		ServerExts_DeleteSyntheticPlayer(id);
	    id = GetNextSyntheticPlayerID();
	}	
}

object CreatePlaceholderCreature(string Name, int Gender, int id)
{
    location SpawnLocation = GetLocation(GetWaypointByTag("wp_syntheticstorage"));
	object oSyntheticCat = GetObjectByTag("tell_"+IntToString(id)); object PlaceholderCreature;
	
	if(GetIsObjectValid(oSyntheticCat)) 
	{
	    SetGender(oSyntheticCat, Gender);
		SetFirstName(oSyntheticCat, Name);
		PlaceholderCreature = oSyntheticCat;
	}
	else
	{
    	PlaceholderCreature = CreateObject(OBJECT_TYPE_CREATURE, "c_cat", SpawnLocation,FALSE,"tell_"+IntToString(id));

    	if (PlaceholderCreature == OBJECT_INVALID)
    	{
        	// ... error handling/logging ...
			WriteTimestampedLogEntry("Failed to create our cat.");
        	return PlaceholderCreature;
    	}

    	SetFirstName(PlaceholderCreature, Name);
    	SetGender(PlaceholderCreature, Gender);
	}
//    SendCreatureToLimbo(PlaceholderCreature);

    return PlaceholderCreature;
}

void RemoveSyntheticPlayer(int purgecat = 0)
{
	string sRemovalAct = GetLastBackendData("RemovalTarget");
	int id = GetPlayerIDForPlayer(sRemovalAct);
	ServerExts_DeleteSyntheticPlayer(id);
	FreeSyntheticID(id);
	
	if(purgecat == 0) return;
	
	object oCatToDestroy = GetObjectByTag("tell_"+IntToString(id));
	if(GetIsObjectValid(oCatToDestroy)) DestroyObject(oCatToDestroy);
}

void AddSyntheticPlayer()
{
	string sAddName = GetLastBackendData("AddTargetName");	
	string sAddAct = GetLastBackendData("AddTargetAct");	
	int iDM = StringToInt(GetLastBackendData("AddTargetIsDM"));
	int id;
	
	if(GetPlayerHasID(sAddAct))
	{
		WriteTimestampedLogEntry("Found duplicate synthetic player for: "+sAddName+" ... purging it.");
		id = GetPlayerIDForPlayer(sAddAct);
		ServerExts_DeleteSyntheticPlayer(id);
		FreeSyntheticID(id);
	}
	
	id = GetPlayerIDForPlayer(sAddAct);
	
	object oSynthetic = CreatePlaceholderCreature(sAddName,0,id);
	if(GetIsObjectValid(oSynthetic)) ServerExts_CreateSyntheticPlayer(id,oSynthetic,iDM,sAddAct,"blank");
}

void PopulateSyntheticList()
{
	WriteTimestampedLogEntry("Populating synthetics list.");
	
	PurgeSyntheticPlayerList();
	object oSynthetic; string name; string act; int dm; int id;
	
	if(GetLocalInt(GetModule(),"ServerNum") == 1) SQLExecDirect("SELECT * FROM `PTRSCRY`;");
	else SQLExecDirect("SELECT `NAME`,`PLAYER`,`DM` FROM `KEMOSCRY` ORDER BY TOUCH DESC;");
	while(SQLFetch() == SQL_SUCCESS)
	{
		name = SQLGetData(1); act = SQLGetData(2); dm = StringToInt(SQLGetData(3));
		id = GetPlayerIDForPlayer(act);
		
		oSynthetic = CreatePlaceholderCreature(name,Random(1),id);
		if(GetIsObjectValid(oSynthetic)) ServerExts_CreateSyntheticPlayer(id,oSynthetic,dm,act,"blank");
	}
}

void DoTellConfirmation(object oPC, string sTargetAct, string sMsg)
{
	int id = GetPlayerIDForPlayer(sTargetAct);	
	object oSynthetic = GetObjectByTag("tell_"+IntToString(id));
	if(GetIsObjectValid(oSynthetic))
	{
		ServerExts_SendTellFromSyntheticPlayer(oPC,id,"<I>(Cross-realm tell sent):</I> "+sMsg);
	}
}