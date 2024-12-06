import { watchDirs } from './auto_reload.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import GLib from 'gi://GLib?version=2.0';

watchDirs(['src'], async (root) => {
    console.log('Typescript files changed, rebuilding...');

    const scss = `${App.configDir}/src/style.scss`;
    const css = `${root}/style.css`;
    let [_, __, err] = GLib.spawn_command_line_sync(`sass ${scss} ${css}`);
    if (err.length > 0) {
        console.error('Failed to compile CSS\n' + String.fromCodePoint(...err))
        return;
    }

    App.resetCss()
    App.applyCss(css);

    [_, __, err] = GLib.spawn_command_line_sync(
        `bun build ${App.configDir}/src/main.ts \
            --outdir ${root} \
            --external resource://* \
            --external gi://* \
            --external file://*`
    );
    if (err.length > 0) {
        console.error('Failed to compile TS\n' + String.fromCodePoint(...err))
    }
    await import(`file://${root}/main.js`)

    console.log('Success');
});
