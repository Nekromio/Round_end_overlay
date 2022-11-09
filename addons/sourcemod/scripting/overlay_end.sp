#pragma semicolon 1
#pragma newdecls required

#include <sdktools_stringtables>
#include <cstrike>
#include <smartdm>

char sOverlay[2][256];
	
public Plugin myinfo =
{
	name = "Round end overlay",
	author = "dataviruset (rewritten by Nek.'a 2x2 | ggwp.site )",
	description = "Оверлей в конце раунда",
	version = "1.2.2",
	url = "http://www.sourcemod.net/"
};

public void OnPluginStart()
{
	ConVar cvar;
	cvar = CreateConVar("sm_roundend_overlay_t", "overlays/game77seven/t_win", "Оверлей победы террористов");
	GetConVarString(cvar, sOverlay[0], sizeof(sOverlay[]));
	HookConVarChange(cvar, OnConVarChanges_OverlayT);
	
	cvar = CreateConVar("sm_roundend_overlay_ct", "overlays/game77seven/ct_win", "Оверлей победы контр-террористов");
	GetConVarString(cvar, sOverlay[1], sizeof(sOverlay[]));
	HookConVarChange(cvar, OnConVarChanges_OverlayCT);
	
	HookEvent("round_start", Event_RoundStart);
	HookEvent("round_end", Event_RoundEnd);
	
	AutoExecConfig(true, "overlay_end");
}

public void OnConVarChanges_OverlayT(ConVar cvar, const char[] oldValue, const char[] newValue)
{
	GetConVarString(cvar, sOverlay[0], sizeof(sOverlay[]));
}

public void OnConVarChanges_OverlayCT(ConVar cvar, const char[] oldValue, const char[] newValue)
{
	GetConVarString(cvar, sOverlay[1], sizeof(sOverlay[]));
}

public void OnMapStart()
{
	char sBuffer[2][256];
	
	Format(sBuffer[0], sizeof(sBuffer[]), "materials/%s.vmt", sOverlay[0]);
	Downloader_AddFileToDownloadsTable(sBuffer[0]);

	FormatEx(sBuffer[1], sizeof(sBuffer[]), "materials/%s.vmt", sOverlay[1]);
	Downloader_AddFileToDownloadsTable(sBuffer[1]);
}

void ShowOverlayToAll(const char[] sOverlayAll)
{
	for(int i = 1; i <= MaxClients; i++) if (IsClientInGame(i) && !IsFakeClient(i)) ShowOverlayToClient(i, sOverlayAll);
}

public void Event_RoundEnd(Handle hEvent, const char[] sName, bool bDontBroadcast)
{
	int iWinTeam = GetEventInt(hEvent, "winner");

	if(iWinTeam == CS_TEAM_T) ShowOverlayToAll(sOverlay[0]);
	else if(iWinTeam == CS_TEAM_CT) ShowOverlayToAll(sOverlay[1]);
}

void ShowOverlayToClient(int iClient, const char[] sOverlayAll)
{
	ClientCommand(iClient, "r_screenoverlay \"%s\"", sOverlayAll);
}

public void Event_RoundStart(Handle hEvent, const char[] sName, bool bDontBroadcast)
{
	ShowOverlayToAll("");
}