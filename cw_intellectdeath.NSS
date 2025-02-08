#include "ff_safevar"

//Remove insanity
void main()
{
 object o=PS_GetLocalObject(OBJECT_SELF, "CW_INSANE");
 
 if(GetIsObjectValid(o))
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
  }
}