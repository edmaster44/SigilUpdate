/*Created by Shaughn
for the Risen Hero Campaign
http://neverwinter.nexusmods.com/mods/10
3/3/2013
*/

void main()
{
	object oCaster = GetAreaOfEffectCreator();
	object oTarget = GetExitingObject();
	
	effect eRemove	=	GetFirstEffect(oTarget);
	
	if (oTarget == oCaster)return;
	
	while(GetIsEffectValid(eRemove))
	{
		if(GetEffectCreator(eRemove) == oCaster)
		{
			RemoveEffect(oTarget,eRemove);
		}
		eRemove	=	GetNextEffect(oTarget);
	}
}