import { watchDirs } from './auto_reload.js';
import App from 'resource:///com/github/Aylur/ags/app.js';

/** @type {import('@girs/glib-2.0').GLib} */
const GLib = imports.gi.GLib;

watchDirs(['src/bar', 'bar/widgets', 'bar/services'], async (root) => {
    const bar = (await import(`file://${root}/bar/bar.js`))

    const scss = `${root}/style.scss`;
    const css = `${root}/style.css`;
    const [_, __, err] = GLib.spawn_command_line_sync(`sass ${scss} ${css}`);
    const decoder = new TextDecoder();
    print(decoder.decode(err).trim());

    App.resetCss()
    App.applyCss(css);

    App.windows
    if (App.windows.find((window) => window.name === 'bar'))
        App.removeWindow('bar');

    App.addWindow(bar.Bar(0));

    if (App.windows.find((window) => window.name === 'settings')) {
        let visible = App.getWindow('settings')?.visible;
        App.removeWindow('settings');

        if (visible) {
            const settings = (await import(`file://${root}/settings/settings.js`))
            App.addWindow(settings.Settings(0));
        }
    }
});


export default {
    windows: []
}