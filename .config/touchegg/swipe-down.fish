#!/usr/bin/fish

set -l effects (qdbus org.kde.KWin /Effects org.kde.kwin.Effects.activeEffects)

if test (xdotool getactivewindow getwindowname) = 'Plasma'
	qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.activateLauncherMenu
	qdbus org.kde.kglobalaccel /component/kwin invokeShortcut 'Overview'
else if contains 'overview' $effects
	qdbus org.kde.kglobalaccel /component/kwin invokeShortcut 'Overview'
else
	qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.setDashboardShown true
end
