#include "nwnx_sql"
void OnSeverLoadPopulateFeatSQL(int iCount, int iMax)
{
	string sFeat;

	while(iMax > iCount)
	{	
		sFeat = Get2DAString("feat", "label", iCount);
		if(sFeat != "" && sFeat != "****")
		{
		SQLExecDirect("INSERT IGNORE INTO `featids` VALUES ('"+SQLEncodeSpecialChars(sFeat)+"','"+IntToString(iCount)+"');");
		}
		iCount++;
	}
	
	if(iMax == 2500) DelayCommand(10.0f,OnSeverLoadPopulateFeatSQL(2501,3000));
}