

#include "nw_i0_generic"
#include "cw_inc_intellect"

//Checks to see how the intellect devourer should merge
void main()
{
 //SendMessageToPC(GetFirstPC(), "RUNNING_1");
 object killer=GetLastKiller();
 string devourer="cw_intellectdevourer";//change this tag *IF* your intellect devourer tag is different
 float intellect_reach=3.5f;//How far they can get onto a dead creature
 
 if(GetLocalString(OBJECT_SELF, "DeathScript")=="cw_spawnintellect" ||
    GetTag(OBJECT_SELF)==devourer)//Check to make sure two guys don't enter the same skull
	 return;
	 
 //Now, check for racial types(construct, undead) and immunity to critical hits
 if(GetRacialType(OBJECT_SELF)==RACIAL_SUBTYPE_CONSTRUCT ||
    GetRacialType(OBJECT_SELF)==RACIAL_SUBTYPE_UNDEAD ||
	GetIsImmune(OBJECT_SELF, IMMUNITY_TYPE_CRITICAL_HIT))
	 return;
	 
 //Also, modders can make sure intellect devourers can't do anything via the variable "CW_NODEVOUR"
 if(GetLocalInt(OBJECT_SELF, "CW_NODEVOUR")==1)
  return;
  
 if(/*GetIsPC(OBJECT_SELF) || */
    GetAssociateType(OBJECT_SELF)==ASSOCIATE_TYPE_FAMILIAR ||
    GetAssociateType(OBJECT_SELF)==ASSOCIATE_TYPE_ANIMALCOMPANION ||
	GetAssociateType(OBJECT_SELF)==ASSOCIATE_TYPE_SUMMONED ||
	GetAssociateType(OBJECT_SELF)==ASSOCIATE_TYPE_HENCHMAN)//Self explanatory, really
  return;
 
 //Did a devourer kill me?
 if(!GetScriptHidden(killer) && GetTag(killer)==devourer)
  {   
   if(GetIsPC(GetFactionLeader(OBJECT_SELF)))
    CW_SpawnIntellect(killer, OBJECT_SELF, TRUE);
   else
    CW_SpawnIntellect(killer, OBJECT_SELF, FALSE);
   
   return;
  }
 else if(!GetScriptHidden(killer) &&
         !GetFactionEqual(OBJECT_SELF, GetNearestObjectByTag(devourer)))//Am I not a faction member of a devourer? Then, they might eat my brain(yikes!)
  {
   if(GetDistanceBetween(OBJECT_SELF, GetNearestObjectByTag(devourer))<=intellect_reach)
    {
	 if(GetIsPC(GetFactionLeader(OBJECT_SELF)))
      {CW_SpawnIntellect(killer, OBJECT_SELF, TRUE);}
     else
      {CW_SpawnIntellect(killer, OBJECT_SELF, FALSE);}
	 return;
	}
  }
}