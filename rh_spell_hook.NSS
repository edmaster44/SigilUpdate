/*Created by Shaughn
for the Risen Hero Campaign
http://neverwinter.nexusmods.com/mods/10
3/3/2013
*/
/*
Spellhooking only works for PCs, unless the variable X2_L_WILD_MAGIC is set to 1 on each area 
where NPCs are to use the spellhook system. 
To circumvent this and allow NPCs to always use the spellhook script, the function 
X2PreSpellCastCode must be edited. This function is found in the file x2_inc_spellhook. 
*/



#include "x2_inc_spellhook"
#include "x2_inc_switches"
#include "nwn2_inc_spells"

int SwarmCheck(object oTarget,int nSpellID);

void main()
{
	int nSpellID	=	GetSpellId();	
//	int nSchool 	= 	SpellSchool(nSpellID);
	int nClass		=	GetLastSpellCastClass();
	object oTarget	=	GetSpellTargetObject();
	object oItem 	= 	GetSpellCastItem();
	string sTag 	= 	GetStringLowerCase(GetTag(oItem));	
	
	
/*---------------------------------------------------------------------------------------------------------------------------------------------------	
	//Prevents single target spells from inuring swarms
---------------------------------------------------------------------------------------------------------------------------------------------------*/
	//debug
	SendMessageToPC(OBJECT_SELF,"check for swarm");
	
	if(GetStringLeft(GetTag(oTarget),8) == "rh_swarm" && SwarmCheck(oTarget,nSpellID) == TRUE)
	{
		//Stop Spell
		FloatingTextStringOnCreature("The spell fails: You are unable to target an individual in the swarm!",OBJECT_SELF);
		SetModuleOverrideSpellScriptFinished();
	}

}



int SwarmCheck(object oTarget,int nSpellID)
{
	string	sTarget		=	Get2DAString("spells","TargetType",nSpellID);
	string  sCategory	= 	Get2DAString("spells","Category",nSpellID);	
	int breturn = FALSE;
	
	
	if(sCategory != "1" || sCategory != "11")
	{
		//degbug
		SendMessageToPC(OBJECT_SELF,"Not category 1 or 11");
		if(GetStringLeft(sTarget,3) == "0x2" || GetStringLeft(sTarget,4) == "0x02")
		{	
			SendMessageToPC(OBJECT_SELF,"swarm");
			breturn = TRUE;
		}
	}
	//debug
	SendMessageToPC(OBJECT_SELF,"script fired not a Single-Target spell");	
	return breturn;
}