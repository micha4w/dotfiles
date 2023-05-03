#!/usr/bin/fish

set -l effects (qdbus org.kde.KWin /Effects org.kde.kwin.Effects.activeEffects)

if test (xdotool getactivewindow getwindowname) = 'Plasma'
	# Do nothing
else if contains 'overview' $effects	
	qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.activateLauncherMenu
	qdbus org.kde.kglobalaccel /component/kwin invokeShortcut 'Overview'
else if test (qdbus org.kde.KWin /KWin org.kde.KWin.showingDesktop) = 'false'
	qdbus org.kde.kglobalaccel /component/kwin invokeShortcut 'Overview'
else
	qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.setDashboardShown false
end
