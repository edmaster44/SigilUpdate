/*Created by Shaughn
for the Risen Hero Campaign
http://neverwinter.nexusmods.com/mods/10
3/3/2013
*/

#include "NW_I0_GENERIC"
#include "ginc_event_handlers"
#include "ginc_math"

void main()
{
	
	
	string sEffect	=	GetLocalString(OBJECT_SELF,"swarm_vfx");
	effect eVisual	=	SupernaturalEffect(EffectNWN2SpecialEffectFile(sEffect));
	
	string sTag		=	GetTag(OBJECT_SELF);
	string sSize	=	GetStringRight(sTag,3);
	int nRange;
	
	if(sSize == "les")nRange =74; //Radius 3 meters
	else if(sSize == "grt")nRange = 76; //Radius 10 meters
	else nRange = 75; //Radius 5 Meters
	
	effect eAura	=	SupernaturalEffect(EffectAreaOfEffect(nRange,"rh_swarm_aoe_in","rh_swarm_aoe_hb","rh_swarm_aoe_out"));
	
	//effect eLink	=	EffectLinkEffects(eVisual,eAura);
	
	ApplyEffectToObject(DURATION_TYPE_PERMANENT,eVisual,OBJECT_SELF);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT,eAura,OBJECT_SELF);
	
	ExecuteScript(SCRIPT_DEFAULT_SPAWN, OBJECT_SELF);
}