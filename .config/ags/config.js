import { watchDirs } from './auto_reload.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import GLib from 'gi://GLib?version=2.0';

watchDirs(['src'], async () => {
    const outdir = '/tmp/ags/build';

    const scss = `${App.configDir}/src/style.scss`;
    const css = `${outdir}/style.css`;
    const [_, __, err] = GLib.spawn_command_line_sync(`sass ${scss} ${css}`);
    if (err.length > 0) console.error(String.fromCodePoint(...err))

    App.resetCss()
    App.applyCss(css);
    
    await Utils.execAsync([
        'bun', 'build', `${App.configDir}/src/main.ts`,
        '--outdir', outdir,
        '--external', 'resource://*',
        '--external', 'gi://*',
        '--external', 'file://*',
    ])
    await import(`file://${outdir}/main.js`)
});
