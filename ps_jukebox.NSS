const string SONGS = "248|022|023|024|056|077|090|110|104|130|164|165|166|183|191|192|195|209";

void main()
{
object this_area = GetArea(OBJECT_SELF);
int nSongnr = GetLocalInt(OBJECT_SELF,"MUSIC");

int nMusic = StringToInt(GetSubString(SONGS, (nSongnr - 1) * 4, 3));

if(nMusic == 0)
{
nSongnr = 1;
nMusic = StringToInt(GetSubString(SONGS, 0, 3));
}

//Debug info, remove before we go live:
//SpeakString("Now playing song " + IntToString(nMusic) + " " + Get2DAString("ambientmusic", "Label", nMusic));

MusicBackgroundChangeDay(this_area, nMusic);
MusicBackgroundChangeNight(this_area, nMusic);

nSongnr += 1;
SetLocalInt(OBJECT_SELF,"MUSIC",nSongnr);
}