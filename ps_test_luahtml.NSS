#include "nwnx_lua"
#include "ServerExts"
#include "nwnx_sql"
#include "nwnx_lua_gff"

void TellMeTime(object oPC) {
	
	float fTime = TimerElapsed("LUA_TEST");
	
	SendMessageToPC(oPC, "Time elapsed: "+FloatToString(fTime));
}

void main() {

	object oPC = GetLastUsedBy();
	
	TimerStart("LUA_TEST");
	
	SendMessageToPC(oPC, "You clicked!");
	
	string sResult = RunLuaString("print('Hello World')");
	
	SendMessageToPC(oPC, "testing print: "+sResult);
	
	string sErrors = GetLastLuaError();
	
	SendMessageToPC(oPC, "found errors? "+sErrors);
	
	sResult = RunLuaString("local req=Http.Start('GET', [[http://sigiltest.miriamrauschert.com/dataFetch/htmlTest.php]], nil, nil); req:SetTimeout(2000); return req:GetResult()");
	
	SendMessageToPC(oPC, "result: "+sResult);
	
	sErrors = GetLastLuaError();
	
	SendMessageToPC(oPC, "found errors? "+sErrors);
	
	DelayCommand(1.0f, TellMeTime(oPC));
	
	DelayCommand(1.5f, TimerDelete("LUA_TEST"));
	
}