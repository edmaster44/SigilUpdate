#include "x2_inc_spellhook" 


//Remove insanity
void main(){
 object o=GetLocalObject(OBJECT_SELF, "CW_INSANE");
 
 if(GetIsObjectValid(o)) PS_RemoveEffects(o, NULL, EFFECT_TYPE_INSANE);
 
 /*
 {
   effect e=GetFirstEffect(o);
   
   while(GetIsEffectValid(e))
    {
	 if(GetEffectType(e)==EFFECT_TYPE_INSANE)
	  {
	   RemoveEffect(o, e);
	   return;
	  }
	 e=GetNextEffect(o);
	}
  }*/
}