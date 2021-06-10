#include "nwnx_backend"
#include "ServerExts"
#include "nwnx_lua_playerlist"

object GetTargetPC(string sTargetAct)
{
	object oTarget = GetFirstPC();
	while(GetIsObjectValid(oTarget))
	{
		if(GetPCPlayerName(oTarget) == sTargetAct) return oTarget;
		oTarget = GetNextPC();	
	}

	return OBJECT_INVALID;
}

void DoFakeTell()
{
    string sSenderAct = GetLastBackendData("TellSender");
    string sTargetAct = GetLastBackendData("TellTarget");
    string sMsg = GetLastBackendData("TellMessage");

	int iSenderID = GetPlayerIDForPlayer(sSenderAct);
	object oTarget = GetTargetPC(sTargetAct);
		
	ServerExts_SendTellFromSyntheticPlayer(oTarget,iSenderID,sMsg);
}

void DoSynthetics()
{
	ServerExts_SetExtendedTellScriptName("gui_cmnsee_sendtell");
	PopulateSyntheticList();
}

void main(){

	//This is the type of event that fired the script
	int nAction = GetLastBackendActionType();
	//This will be what the remote side sParameter in a SendMessageToServer
	string sParameter = GetLastBackendParameter();
	//This is the serverid of the remote side that is sending to you
	string sSender = GetLastBackendSender();
	
	string OPPOSITESERVER;
	if(GetLocalInt(GetModule(),"ServerNum") == 1) OPPOSITESERVER = SERVER2;
	else OPPOSITESERVER = SERVER1;
	
	WriteTimestampedLogEntry("Executing backend action: "+IntToString(nAction)+" , parameter: "+sParameter+" from "+sSender);
	
	//Example we received a message
	if(nAction == SRV_ACTION_MESSAGE)
	{
		if(sParameter == "TELL") DoFakeTell();
		else if(sParameter == "PURGE") PurgeSyntheticPlayerList();
		else if(sParameter == "REMOVE") RemoveSyntheticPlayer();
		else if(sParameter == "ADD") AddSyntheticPlayer();		
	}
	else if(nAction == SRV_ACTION_CLIENTSCONNECTEDUPDATE && GetServerIsConnected(OPPOSITESERVER)=="") PurgeSyntheticPlayerList();
	else if(nAction == SRV_ACTION_CLIENTSCONNECTEDUPDATE && GetServerIsConnected(OPPOSITESERVER)!="") PopulateSyntheticList();
//	else if(nAction == SRV_ACTION_CONNECTED) PopulateSyntheticList();
	else if(nAction == SRV_ACTION_DISCONNECTED) PurgeSyntheticPlayerList();	
}