#include "ff_safevar"

int nColoumns1 = 1;
int nColoumns2 = 1;
int nColoumns3 = 1;
int nColoumns4 = 1;
int nColoumns5 = 1;
int nColoumns6 = 1;
int nColoumns7 = 1;
int nColoumns8 = 1;
int nColoumns9 = 1;
string sSpellText;
string sSpellLevel;
string sSpellImage;
void AddSpellToList(int nRowID, int nFeatID, int nColoumn)
{
	if (GetHasFeat(nFeatID, OBJECT_SELF, TRUE) == 1)
	{
		sSpellText = GetStringByStrRef( StringToInt( Get2DAString( "feat", "FEAT", nFeatID))); //For tooltip
		sSpellLevel = IntToString(nRowID);
		sSpellImage = Get2DAString( "feat", "ICON", nFeatID)+".tga";
		AddListBoxRow(OBJECT_SELF, "SCREEN_SPELLS_QUICK_PSION", "QuickSpellListbox_Psi_"+IntToString(nRowID)+IntToString(nColoumn), "Feat"+IntToString(nRowID), "HEADER_BUTTON="+sSpellLevel, "SPELL_IMAGE="+sSpellImage, "5="+IntToString(nFeatID)+";6="+sSpellText, "");	
		//SendMessageToPC(OBJECT_SELF, "Adding Spell to QuickSpellListbox_Psi_"+IntToString(nRowID)+IntToString(nColoumn));
		switch (nRowID)
		{
			case 1:
				nColoumns1++;
			break;
			case 2:
				nColoumns2++;
			break;
			case 3:
				nColoumns3++;
			break;
			case 4:
				nColoumns4++;
			break;
			case 5:
				nColoumns5++;
			break;
			case 6:
				nColoumns6++;
			break;
			case 7:
				nColoumns7++;
			break;
			case 8:
				nColoumns8++;
			break;
			case 9:
				nColoumns9++;
			break;
			
		}
	}
}

void ClearSpells(int nSpellLvl)
{
	int n=1;
	while (n<=4)
	{
		ClearListBox(OBJECT_SELF, "SCREEN_SPELLS_QUICK_PSION", "QuickSpellListbox_Psi_"+IntToString(nSpellLvl)+IntToString(n));
		n++;
	}
}

void main()
{
if (PS_GetLocalInt(OBJECT_SELF, "PsionQuickCastUpdated") == 1) return;

//SendMessageToPC(OBJECT_SELF, "Updating... "+IntToString((PS_GetLocalInt(OBJECT_SELF, "PsionQuickCastUpdated"))));
int n;
nColoumns1 = 1;
nColoumns2 = 1;
nColoumns3 = 1;
nColoumns4 = 1;
nColoumns5 = 1;
nColoumns6 = 1;
nColoumns7 = 1;
nColoumns8 = 1;
nColoumns9 = 1;
	//SendMessageToPC(OBJECT_SELF, "Filling spellbook...");
	
	while (n<=9)
	{
		ClearSpells(n);
		n++;
	}
	


   
	//**Level_1_Psion_Powers**
	n = 21001;
	while (n<=21048)
	{
		AddSpellToList(1, n, nColoumns1);
		n++;
	}
		
	//**Level_2_Psion_Powers** 
	n = 21050;
	while (n<=21099)
	{
		AddSpellToList(2, n, nColoumns2);
		n++;
	}
	
	//**Level_3_Psion_Powers** 
	n = 21101;
	while (n<=21149)
	{
		AddSpellToList(3, n, nColoumns3);
		n++;
	}
	
	//**Level_4_Psion_Powers** 
	n = 21151;
	while (n<=21189)
	{
		AddSpellToList(4, n, nColoumns4);
		n++;
	}
	
	//**Level_5_Psion_Powers** 
	n = 21191;
	while (n<=21229)
	{
		AddSpellToList(5, n, nColoumns5);
		n++;
	}
	
	//**Level_6_Psion_Powers** 
	n = 21231;
	while (n<=21269)
	{
		AddSpellToList(6, n, nColoumns6);
		n++;
	}
	
	//**Level_7_Psion_Powers** 
	n = 21271;
	while (n<=21299)
	{
		AddSpellToList(7, n, nColoumns7);
		n++;
	}
	
	//**Level_8_Psion_Powers** 
	n = 21301;
	while (n<=21329)
	{
		AddSpellToList(8, n, nColoumns8);
		n++;
	}
	
	//**Level_9_Psion_Powers** 
	n = 21331;
	while (n<=21339)
	{
		AddSpellToList(9, n, nColoumns9);
		n++;
	}

}