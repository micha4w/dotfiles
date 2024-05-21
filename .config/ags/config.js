import { watchDirs } from './auto_reload.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import GLib from 'gi://GLib?version=2.0';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';


// /** @param {string} name */
// function removeWindowIfExist(name) {
//     if (App.windows.find((window) => window.name === name))
//         App.removeWindow(name);
// }


// Hyprland.connect("monitor-added", (self, name) => {
//     const monitor = self.monitors.find((monitor) => {
//         monitor.name == name;
//     })

//     App.addWindow(bar.Bar(monitor.id));
// })

watchDirs(['src/bar', 'bar/widgets', 'bar/services'], async (root) => {
    const bar = (await import(`file://${root}/bar/bar.js`))
    // const notifications = (await import(`file://${root}/notifications/notifications.js`))
    // const keys = (await import(`file://${root}/keys/keys.js`))

    const scss = `${root}/style.scss`;
    const css = `${root}/style.css`;
    const [_, __, err] = GLib.spawn_command_line_sync(`sass ${scss} ${css}`);

    App.resetCss()
    App.applyCss(css);

    [...App.windows].forEach(App.removeWindow);

    for (const monitor of Hyprland.monitors) {
        App.addWindow(bar.Bar(monitor.id));
        // App.addWindow(await notifications.NotificationPopup(monitor.id));
    }
    Hyprland.connect("monitor-added", (self, name) => {
        const monitor = Hyprland.monitors.find(monitor => monitor.name === name);
        // console.log(name, monitor);
        if (monitor && !App.windows.some((window) => window.name === `bar${monitor.id}`))
            App.addWindow(bar.Bar(monitor.id));
    })

    if (App.windows.find((window) => window.name === 'settings')) {
        let visible = App.getWindow('settings')?.visible;
        App.removeWindow('settings');

        if (visible) {
            const settings = (await import(`file://${root}/settings/settings.js`))
            App.addWindow(settings.Settings(0));
        }
    }
});
