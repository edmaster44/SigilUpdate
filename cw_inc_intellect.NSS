#include "ff_safevar"

/*
9-24-10
Intellect Devourer

Okay, these guys are pretty evil...so let's make them scary(I mean, walking brains! Wow, scary stuff)
I'm going to comment this thoroughly for individual mod makers so they can see how I'm doing this. Due to the nature of this creature, it might interfere
with many in-game systems. So, keep that in mind.

This script handles the "Body Thief" ability. Pasted here for posterity:

******************************************************************************************************************************************************************
Body Thief (Su)
When an intellect devourer overcomes a lone victim, it consumes the victim’s brain and enters the skull. 
As a full-round action that provokes attacks of opportunity, the devourer can merge its form with that of a helpless or dead creature of Small size or larger. 
The devourer cannot merge its body with that of a creature immune to extra damage from critical hits.

When an intellect devourer completes its merging, it psionically consumes the brain of the victim (which kills it if it is not already dead). 
The devourer can exit the body at any time as a standard action, bursting the victim’s skull and resuming its normal form.

After consuming its victim’s brain, an intellect devourer can instead choose to animate the body for up to seven days as if it were the victim’s original brain. 
The devourer retains its hit points, saving throws, and mental ability scores, as well as its psi-like abilities. 
It assumes the physical qualities and ability scores of the victim, as if it had used polymorph to assume the victim’s form. 
As long as the intellect devourer occupies the body, it knows the languages spoken by the victim and very basic information about the victim’s identity and personality, but none of the victim’s specific memories or knowledge.

******************************************************************************************************************************************************************

So, how do we implement this? "nw_c2_default7"--the death script--has a call for a death script "DeathScript". We can check to see if the last killer of the 
creature in question was an intellect devourer(we can't check to see if a creature is dead, as individual modders might make some creatures stay as corpses 
while others don't). If the intellect devourer kills a target, then it "merges" with that target. There are some checks for this, yadyadyada, so check below for 
the specifics

There's a failsafe, too, to check if the creature died and an intllect devourer is nearby(they're opportunistic, let's say).

Oh, yeah, to be specific, this is the script that's called *if* a creature is killed by a devourer
The other script, "cw_spawnintellect", is for a possessed creature
*/
#include "nw_i0_generic"
//For the chance of making a devourer spawn while keeping the body around
void CW_DelayedSpawn(object self)
{
 if(GetIsDead(self) || PS_GetLocalString(self, "DeathScript")!="cw_spawnintellect")
  return;

 ExecuteScript("cw_spawnintellect", self);
}

//Handles spawning the intellect devourer
void CW_SpawnIntellect(object killer, object self, int comp)
{
 ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectNWN2SpecialEffectFile("fx_blood_red1_L"), GetLocation(self));
 PS_SetLocalInt(self, "CW_NODEVOUR", 1);
 
 if(comp==FALSE)//Not a companion
  {
   ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), self);
   ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(self)), self);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_GLOW_PURPLE), self);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_GLOW_PURPLE), self);//Makes a better effect
   ChangeFaction(self, killer);
   AssignCommand(self, DetermineCombatRound());
   DestroyObject(killer);
   SetScriptHidden(killer, TRUE);
   //PS_SetLocalString(self, "CW_DeathScript", PS_GetLocalString(self, "DeathScript"));
   if(PS_GetLocalString(self, "CW_DeathScript")=="")
	PS_SetLocalString(self, "CW_DeathScript", PS_GetLocalString(self, "DeathScript"));

   PS_SetLocalString(self, "DeathScript", "cw_spawnintellect");
   //To change things up, sometimes the devourer will burst out *and* keep the host alive(the above implies it can)
   //But, it doesn't always happen, so let's say 40% is a good chance for that
   //Change if you see fit
   if(d10()<=4)
    DelayCommand(RoundsToSeconds(d3(2)), CW_DelayedSpawn(self));
  }
 else
  { 
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectInsane(), self, 60.0f);
   ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), self);
   ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(self)), self);
   PS_SetLocalObject(killer, "CW_INSANE", self);
  }
}

//void main(){}