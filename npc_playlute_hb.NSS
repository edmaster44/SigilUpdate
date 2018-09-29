// f100_bard_hb
/*
	Bards play the lute indefinitely
*/
// TDE 9/18/08

void main()
{
	int nRandom=Random(5);
	if (nRandom==0)
	{
		PlayCustomAnimation(OBJECT_SELF,"idlefidgetguitar", 1);
		SoundObjectStop(GetObjectByTag("0_snd_lute_1"));
	}
	else if (nRandom==1)
	{
		PlayCustomAnimation(OBJECT_SELF,"idleguitar", 1);
		SoundObjectStop(GetObjectByTag("0_snd_lute_1"));
	}
	else
	{
		PlayCustomAnimation(OBJECT_SELF,"playguitar", 1);
		SoundObjectPlay(GetObjectByTag("0_snd_lute_1"));
	}
}