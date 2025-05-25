

//*********************************************
//BOSS EVENT
// Mimi Fearthegn
// 6/21/19
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
//ps_bossevent_insectswarms variables
//InsectSwarm_Anim = The animation name to play - Defaults to mjr_cast
//InsectSwarm_DC = Fortitude DC for lessened effect - REQUIRED
//InsectSwarm_Dice = the number of d6's to roll for damage per round of swarm effect - REQUIRED
//InsectSwarm_Radius = the radius to effect with swarms - REQUIRED
//InsectSwarm_VFX = The vfx to play for the swarm - Optional
//InsectSwarm_Message = The optional message to broadcast about the attack - Optional
//*********************************************
//Effect: Boss summons swarms of insects which may infect anyone within the radius
//Fort save against being dazed for a round, followed by several rounds of biting insects
void SwarmAttack(object oTarget, int nDice);

void main () {

	float fRadius = GetLocalFloat(OBJECT_SELF, "InsectSwarm_Radius");
	string sAnim = GetLocalString(OBJECT_SELF, "InsectSwarm_Anim");
	if (sAnim == "")
		sAnim = "mjr_cast";
		
	int nDC = GetLocalInt(OBJECT_SELF, "InsectSwarm_DC");
	int nDice = GetLocalInt(OBJECT_SELF, "InsectSwarm_Dice");
	int nDamType = DAMAGE_TYPE_MAGICAL;
	string sVFX = GetLocalString(OBJECT_SELF, "InsectSwarm_VFX");
	string sMessage = GetLocalString(OBJECT_SELF, "InsectSwarm_Message");
	
	ClearAllActions();
	
	if (sMessage != "") {
		SpeakString(sMessage);
	}
	
	PlayCustomAnimation(OBJECT_SELF, sAnim, FALSE, 1.0f);
	
	if (sVFX == "") {
		sVFX = "rh_swarm_fly_black_3";
	}
	
	object oObj = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(OBJECT_SELF));
	while (GetIsObjectValid(oObj)) {
	
		effect eVFX = EffectNWN2SpecialEffectFile(sVFX);
	
		if (GetIsEnemy(oObj, OBJECT_SELF)) {
			
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oObj, 18.0f);
			
			effect eDaze = EffectDazed();
			if (!FortitudeSave(oObj, nDC, SAVING_THROW_TYPE_DISEASE)) {
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDaze, oObj, 6.0f);
			}
			
			SwarmAttack(oObj, nDice);
			DelayCommand(6.0f, SwarmAttack(oObj, nDice));
			DelayCommand(12.0f, SwarmAttack(oObj, nDice/2));
			DelayCommand(18.0f, SwarmAttack(oObj, nDice/2));
		
		}
	
		oObj = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(OBJECT_SELF));
	}

}

//The swarm attacks this target!
void SwarmAttack(object oTarget, int nDice) {
	int nDamage = d6(nDice);
	int nDamType = DAMAGE_TYPE_MAGICAL;
	if (TouchAttackMelee(oTarget, FALSE)) {
		SendMessageToPC(oTarget, "<i>The swarm of biting insects gets past your defenses.</i>");
		effect eDam = EffectDamage(nDamage, nDamType);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
	} else {
		SendMessageToPC(oTarget, "<i>You manage to fend off the swarm of biting insects for the moment.</i>");
	}
}