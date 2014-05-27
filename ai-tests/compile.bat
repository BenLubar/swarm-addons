@echo off

for /f %%G in ('dir /b mapsrc\*.vmf') do (
	"C:\Program Files (x86)\Steam\SteamApps\common\Alien Swarm\bin\vbsp" -alldetail -game "C:\Program Files (x86)\Steam\SteamApps\common\Alien Swarm\swarm" mapsrc\%%G
	"C:\Program Files (x86)\Steam\SteamApps\common\Alien Swarm\bin\vvis" -radius_override 2500 -game "C:\Program Files (x86)\Steam\SteamApps\common\Alien Swarm\swarm" mapsrc\%%G
	"C:\Program Files (x86)\Steam\SteamApps\common\Alien Swarm\bin\vrad" -final -textureshadows -StaticPropLighting -StaticPropPolys -game "C:\Program Files (x86)\Steam\SteamApps\common\Alien Swarm\swarm" mapsrc\%%G
)
copy /b "mapsrc\*.bsp" "maps\"
"C:\Program Files (x86)\Steam\SteamApps\common\Alien Swarm\bin\vpk" ..\ai-tests