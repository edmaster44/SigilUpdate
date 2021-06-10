
//Runs sScript on the lua engine, returns the first result as a string if any
//use GetLastLuaError to determine if there was an error
string RunLuaString(string sScript);

//Run a function by name from the lua global environment
//use GetLastLuaError to determine if there was an error
void RunLuaFunction(string sFunction, string sParam1, int nParam2, string sValue);

//Retrives the last error, this is "" if there was no error from the last RunLuaString
string GetLastLuaError();

string RunLuaString(string sScript)
{
	return NWNXGetString("LUA","RunString",sScript,0);
}

void RunLuaFunction(string sFunction, string sParam1, int nParam2, string sValue){
	NWNXSetString("LUA",sFunction,sParam1,nParam2,sValue);
}

string GetLastLuaError()
{
	return NWNXGetString("LUA","LastError","",0);
}