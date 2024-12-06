import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import { Bar } from './bar/bar';
import { Settings } from './settings/settings';
import * as Notifications from './notifications/notifications';
// const notifications = (await import(`file://${root}/notifications/notifications.js`))
// const keys = (await import(`file://${root}/keys/keys.js`))


let settings_was_open = App.windows.find((window) => window.name === 'settings')?.visible ?? false;

[...App.windows].forEach(App.removeWindow);

for (const monitor of Hyprland.monitors) {
    App.addWindow(Bar(monitor.id));
    // App.addWindow(await notifications.NotificationPopup(monitor.id));
}
Hyprland.connect("monitor-added", (self, name) => {
    const monitor = Hyprland.monitors.find(monitor => monitor.name === name);

    if (monitor && !App.windows.some((window) => window.name === `bar${monitor.id}`))
        App.addWindow(Bar(monitor.id));
})

if (settings_was_open) {
    App.addWindow(Settings(0));
}

// App.addWindow(Notifications.NotificationPopup(0));