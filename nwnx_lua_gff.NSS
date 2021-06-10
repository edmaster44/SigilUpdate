#include "nwnx_lua"
#include "nwnx_sql"

//Start a timer
void TimerStart(string ID);

//Get time in miliseconds since TimerStart was called
float TimerElapsed(string ID);

//Remove the timer from memory
void TimerDelete(string ID);

void TimerStart(string ID)
{
    RunLuaString("local ID=[["+ID+"]];NWSCRIPT_TIMER=NWSCRIPT_TIMER or {};local tim=Timer.New();tim:Start();NWSCRIPT_TIMER[ID]=tim;");
}

float TimerElapsed(string ID)
{
    return StringToFloat(RunLuaString("local ID=[["+ID+"]];if NWSCRIPT_TIMER==nil then return 0;end local tim=NWSCRIPT_TIMER[ID];if tim == nil then return 0; else return tim:Elapsed() end"));
}

void TimerDelete(string ID)
{
    RunLuaString("local ID=[["+ID+"]];NWSCRIPT_TIMER=NWSCRIPT_TIMER or {};NWSCRIPT_TIMER[ID]=nil;");
}

//Fetches the last modified bicfile from an account
//Returns filename + extension ie "blabla.bic"
//string GetBic(string act);
string GetBic(object oPC);

//Return a bic file from an account, index starts at 1
//Returns filename + extension ie "blabla.bic" or empty string
string GetBics(string act, int index);

//Returns a value from the bic-file provided for the account
//File should be a filename with extension ie "blabla.bic"
string GetBicData(string act, string file, string roadmap);

//Return a value based on the roadmap, database key is the gff to fetch from the database
//If the first character is a "%" then it'll be followed by an error message
string GFFGetValue(string roadmap, string name, string act);

//Set a value at roadmap from a gff loaded by database key
//returns true on success
//If nodbupdate is true the new values won't be written to the database
//useful if more then one value is edited at once, the last call should have this as false
int GFFSetValue(string roadmap, string name, string act, string value, string itemtag, string itemname, int nodbupdate=FALSE);

//Returns true if the roadmap exists
int GFFGetExists(string roadmap, string name, string act);

void DeleteBicData(string act, string file, string roadmap, string field);

//Clears the cached gff's and sets the CacheSize
//CacheSize is how many gffs are stored
//Set to 0 will disable the cache and the database will be used everytime
void GFFClearCache(int CacheSize);

//Unache if it exists
void GFFRemoveFromCache(string name, string act);

//This loads the initial scripts and stores the lua functions on the global environment
//Only needs to run once before any other GFF function is used
//String is "" if everything is ok, otherwise it contains an error message
string GFFStart();

//Opens a file as a gff and reads a field from the roadmap
//Files should be full or relative path from nwn2server.exe. Paths should use forwards slashes:
//Example file = "C:/private/pics/nudes/obiwanhellothere.png"
string GetGffData(string file, string roadmap);

void LuaFixTailTint(string act, string file);

string GetGffData(string file, string roadmap){
	return RunLuaString("return XP:GetGffData([["+file+"]],[["+roadmap+"]]);");
}

void GFFRemoveFromCache(string name, string act){
	RunLuaString("XP:Uncache([["+name+"]],[["+act+"]]);");
}

string GFFStart(){
	string result = RunLuaString("XP = dofile('xp_craft.lua'); return 1;");
	if(result == "1")
		return "";
	return result;
}

void GFFClearCache(int CacheSize){
	RunLuaString("XP.CacheMax="+IntToString(CacheSize)+";XP.CacheSize=0;XP.Cache={};");
}

int GFFGetExists(string roadmap, string name, string act){
	return StringToInt(RunLuaString("return XP:NWExists([["+roadmap+"]],[["+name+"]],[["+act+"]])"));
}

int GFFSetValue(string roadmap, string name, string act, string value, string itemtag, string itemname, int nodbupdate=FALSE){
	return RunLuaString("XP:NWSetValue([["+roadmap+"]],[["+name+"]],[["+act+"]],[=["+value+"]=],[["+itemtag+"]],[["+itemname+"]],"+(nodbupdate?"true":"false")+"); return 1;") == "1";
}

string GFFGetValue(string roadmap, string name, string act){
	return RunLuaString("return XP:NWGetValue([["+roadmap+"]],[["+name+"]],[["+act+"]]);");
}

string GFFGetStorageValue(string roadmap, string storageid, string itemid){
	return RunLuaString("return XP:NWGetStorageValue([["+roadmap+"]],[["+storageid+"]],[["+itemid+"]]);");
}

string GFFAddBelt(string roadmap, string name, string act, string itemtag, string itemname){
	return RunLuaString("local beltstruct = CreateStruct(0);local belt = CreateField('Belt',14,beltstruct);local variationfield = CreateField('Variation',0,1);AddFieldToStruct(beltstruct,variationfield);XP:AddFieldToStruct([["+roadmap+"]], [["+name+"]], [["+act+"]], [["+itemtag+"]], [["+itemname+"]], belt);");
}

string GFFRemoveBelt(string roadmap, string name, string act, string itemtag, string itemname){
	return RunLuaString("XP:RemoveFieldFromStruct([["+roadmap+"]], [["+name+"]], [["+act+"]], [["+itemtag+"]], [["+itemname+"]], [[Belt]])");
}

//VFX

int VFXExists(string roadmap, string name, string act){
	return StringToInt(RunLuaString("return XP:VFXExists([["+roadmap+"]],[["+name+"]],[["+act+"]])"));
}

int NWSetVFXValue(string roadmap, string name, string act, string value, string itemtag, string itemname, int nodbupdate=FALSE){
	return RunLuaString("XP:NWSetVFXValue([["+roadmap+"]],[["+name+"]],[["+act+"]],[["+value+"]],[["+itemtag+"]],[["+itemname+"]],"+(nodbupdate?"true":"false")+"); return 1;") == "1";
}

string NWGetVFXValue(string roadmap, string name, string act){
	return RunLuaString("return XP:NWGetVFXValue([["+roadmap+"]],[["+name+"]],[["+act+"]]);");
}

//BICS

void SetBicData(string act, string file, string roadmap, string newvalue){
	RunLuaString("return XP:SetBicData([["+act+"]],[["+file+"]],[["+roadmap+"]],[["+newvalue+"]]);");
}

string GetBicData(string act, string file, string roadmap){
	return RunLuaString("return XP:GetBicData([["+act+"]],[["+file+"]],[["+roadmap+"]]);");
}

string GFFGetClassListData(string act, string file, string roadmap){
	return RunLuaString("return XP:GFFGetClassListData([["+act+"]],[["+file+"]],[["+roadmap+"]]);");
}

string GetBics(string act, int index){
	return RunLuaString("return XP:GetBic([["+act+"]],"+IntToString(index)+");");
}

string GetMemoryUsage()
{
	return RunLuaString("PROCESS = PROCESS or Process.Open(); return PROCESS :GetRAM()");
}



//string GetBic(string act){
//	return RunLuaString("XP:GetBic([["+act+"]]);");
//}

string GetBic(object oPC)
{	
	if(!GetIsObjectValid(oPC) || !GetIsPC(oPC) || GetIsPossessedFamiliar(oPC) || GetIsDMPossessed(oPC) || GetIsDM(oPC)
	|| GetObjectType(oPC) != OBJECT_TYPE_CREATURE || GetPCPlayerName(oPC) == "") return "";

	SQLExecDirect("SELECT SUBSTRING_INDEX('"+SQLEncodeSpecialChars(GetBicFileName(oPC))+".bic',(SELECT CHAR(92)),-1);");
	SQLFetch(); 
	return SQLGetData(1);
}

//TAIL FIXING
void LuaFixTailTint(string act, string file){
	RunLuaString("XP:FixTint([["+act+"]],[["+file+"]])");
}

void DeleteBicData(string act, string file, string roadmap, string field){
    RunLuaString("return XP:DeleteBicData([["+act+"]],[["+file+"]],[["+roadmap+"]],[["+field+"]]);");
}

void DebugLua(object oPC, string sAccount)
{
	int nNth = 0;
	string file = RunLuaString("return XP:GetBic([["+sAccount+"]],[["+IntToString((nNth))+"]]);");
	while(file != ""){
	SendMessageToPC(oPC, file);
	file = RunLuaString("return XP:GetBic([["+sAccount+"]],[["+IntToString(nNth++)+"]]);");}
}

//NPC Generator

int NWSetNPCValue(string roadmap, string race, string class, string gender, string value, int nodbupdate=FALSE){
	return RunLuaString("XP:NWSetNPCValue([["+roadmap+"]],[["+race+"]],[["+class+"]],[["+gender+"]],[["+value+"]],"+(nodbupdate?"true":"false")+"); return 1;") == "1";
}

string NWGetNPCValue(string roadmap, string race, string class, string gender){
	return RunLuaString("return XP:NWGetNPCValue([["+roadmap+"]],[["+race+"]],[["+class+"]],[["+gender+"]]);");
}

//Set & Get Creature Scripts
string GetCreatureScript(object oCreature, int nScriptEventType){
    return RunLuaString("return NWN.SetGetCreatureScript('"+ObjectToString(oCreature)+"', "+IntToString(nScriptEventType)+");");
}

void SetCreatureScript(object oCreature, int nScriptEventType, string newScript){
    RunLuaString("NWN.SetGetCreatureScript('"+ObjectToString(oCreature)+"', "+IntToString(nScriptEventType)+", '"+newScript+"');");
}

int GetTempHP(object oCreature){
    return StringToInt(RunLuaString("return NWN.GetTempHP('"+ObjectToString(oCreature)+"');"));
}