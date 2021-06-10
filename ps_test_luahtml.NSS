#include "nwnx_lua"
#include "ServerExts"
#include "nwnx_sql"

void main() {

	object oPC = GetLastUsedBy();
	
	SendMessageToPC(oPC, "You clicked!");
	
	string sErrors = GetLastLuaError();
	
	SendMessageToPC(oPC, "found errors? "+sErrors);
	
	string sResult = RunLuaString("local req=Http.Start('GET', [[http://sigiltest.miriamrauschert.com/dataFetch/htmlTest.php]], nil, nil); req:SetTimeout(2000); return req:GetResult()");
	
	SendMessageToPC(oPC, "result: "+sResult);
	
	sErrors = GetLastLuaError();
	
	SendMessageToPC(oPC, "found errors? "+sErrors);
	
}