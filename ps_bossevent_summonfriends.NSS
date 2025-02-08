#include "ff_safevar"

//*********************************************
//BOSS EVENT
// Mimi Fearthegn
// 6/30/19
//*********************************************
//The boss event system runs off the onDamage script
//nw_cs_default6. At 90%, 70%, 50%, 30%, and 10% of the 
//monsters HP events can be called. They are assigned as
//variables on the monster blueprint - 
//BossEvent_1 - fires at 90% HP
//BossEvent_2 - fires at 70% HP
//BossEvent_3 - fires at 50% HP
//BossEvent_4 - fires at 30% HP
//BossEvent_5 - fires at 10% HP
//Not all events need be assigned. Any ps_bossevent_* script will work.
//Individual ps_bossevent_* scripts will have their own required variables
//*********************************************
//ps_bossevent_damageburst variables
//SummonFriends_Anim = The animation name to play - Defaults to taunt
//SummonFriends_ResRef = The resref of the creatures to summon
//SummonFriends_Number = The number of creatures to summon
//SummonFriends_VFX = The vfx to play for the friend summoning (at each location) - Optional
//SummonFriends_Message = The optional message to broadcast about the attack - Optional
//*********************************************
//Effect: Boss summons the specified number of creatures at random locations around 
//itself.
#include "x0_i0_position" 

void SummonFriends(object oSelf) {

	string sFriend = PS_GetLocalString(oSelf, "SummonFriends_ResRef");
	int nNumber = PS_GetLocalInt(oSelf, "SummonFriends_Number");
	string sVFX = PS_GetLocalString(oSelf, "SummonFriends_VFX");
	float fRadius = 8.0f;
	
	int n;
	for (n = 0; n < nNumber; n++) {
		
		location summonLocation = GetRandomLocation(GetArea(oSelf), oSelf, fRadius);
		if (sVFX != "") {
			effect eVFX = EffectNWN2SpecialEffectFile(sVFX);
			ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVFX, summonLocation);
		}
		object oFriend = CreateObject(OBJECT_TYPE_CREATURE, sFriend, summonLocation, TRUE);
	
	}
}

void main () {

	string sAnim = PS_GetLocalString(OBJECT_SELF, "SummonFriends_Anim");
	if (sAnim == "")
		sAnim = "taunt";
		
	string sMessage = PS_GetLocalString(OBJECT_SELF, "SummonFriends_Message");
	
	ClearAllActions();
	
	if (sMessage != "") {
		SpeakString(sMessage);
	}
	
	PlayCustomAnimation(OBJECT_SELF, sAnim, FALSE, 1.0f);
	
	DelayCommand(0.3f, SummonFriends(OBJECT_SELF));

}