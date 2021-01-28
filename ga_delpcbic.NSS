#include "nwnx_character"
#include "ps_inc_functions"
#include "aaa_constants"
#include "nwnx_sql"

void SetXPPools(object oPC,int nAmount)
{
	SendMessageToPC(oPC, "Adding "+FloatToString(nAmount*0.25f)+" to your RP and DM exp pools");
	object oItem = GetItemPossessedBy(oPC,"ps_essence");
	if (oItem == OBJECT_INVALID) return;
	
	string sID = IntToString(GetLocalInt(oItem,"ID"));
	SQLExecDirect("SELECT dm_pool,rp_pool FROM characterdata WHERE id=" + sID);
	if (SQLFetch() == SQL_ERROR) return;

	//int dm_pool = StringToInt(SQLGetData(1)) + FloatToInt(nAmount * 0.25);
	//int rp_pool = StringToInt(SQLGetData(2)) + FloatToInt(nAmount * 0.25);
	int dm_pool = StringToInt(SQLGetData(1)) + nAmount; //krampus value
	int rp_pool = StringToInt(SQLGetData(2)); //krampus value
	SQLExecDirect("UPDATE characterdata SET dm_pool=" + IntToString(dm_pool) + ",rp_pool=" + IntToString(rp_pool) + " WHERE id=" + sID);		
	SQLExecDirect("INSERT INTO logging (account,name,event,type) VALUES ('" + GetPCPlayerName(oPC) + "','" + GetName(oPC) + "','Player lost ALL levels to Styx, increased pools with: " + FloatToString(nAmount * 0.25) + ",107)");
}

void main()
{
	object oPC=GetPCSpeaker();
	int xp = GetXP(oPC);
	
	SetXPPools(oPC, xp);
	
	DelayCommand(0.2f, ArchiveCharacter(oPC));
	
}