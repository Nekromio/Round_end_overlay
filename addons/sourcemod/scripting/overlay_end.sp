#pragma semicolon 1
#pragma newdecls required

#include <sdktools_stringtables>
#include <smartdm>

ConVar
	cvOverlay[2];
char
	sOverlay[2][256];
	
public Plugin myinfo =
{
	name = "Round end overlay",
	author = "dataviruset (rewritten by Nek.'a 2x2 | ggwp.site )",
	description = "Оверлей в конце раунда",
	version = "1.2.3",
	url = "https://ggwp.site/"
};

public void OnPluginStart()
{
	cvOverlay[0] = CreateConVar("sm_roundend_overlay_t", "overlays/game77seven/t_win", "Оверлей победы террористов");
	
	cvOverlay[1] = CreateConVar("sm_roundend_overlay_ct", "overlays/game77seven/ct_win", "Оверлей победы контр-террористов");

	HookEvent("round_start", Event_RoundStart);
	HookEvent("round_end", Event_RoundEnd);
	
	AutoExecConfig(true, "overlay_end");
}

public void OnMapStart()
{
	char sBuffer[256];
	for(int i = 0; i < 2; i++)
	{
		cvOverlay[i].GetString(sBuffer, sizeof(sBuffer));
		if(sBuffer[0])
		{
			sOverlay[i] = sBuffer;
			PrecacheModel(sBuffer, true);
			Format(sBuffer, sizeof(sBuffer), "materials/%s.vmt", sOverlay[i]);
			Downloader_AddFileToDownloadsTable(sBuffer); 
		}
	}
}

void ShowOverlayToAll(const char[] sOverlayAll)
{
	for(int i = 1; i <= MaxClients; i++) if(IsClientInGame(i) && !IsFakeClient(i)) ShowOverlayToClient(i, sOverlayAll);
}

void Event_RoundEnd(Handle hEvent, const char[] sName, bool bDontBroadcast)
{
	int iWinTeam = GetEventInt(hEvent, "winner");

	if(iWinTeam == 2 & sOverlay[0][0]) ShowOverlayToAll(sOverlay[0]);
	else if(iWinTeam == 3 & sOverlay[1][0]) ShowOverlayToAll(sOverlay[1]);
}

void ShowOverlayToClient(int iClient, const char[] sOverlayAll)
{
	ClientCommand(iClient, "r_screenoverlay \"%s\"", sOverlayAll);
}

void Event_RoundStart(Handle hEvent, const char[] sName, bool bDontBroadcast)
{
	ShowOverlayToAll("");
}