import { registerGObject } from 'resource:///com/github/Aylur/ags/utils/gobject.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js'

/** @type {import('@girs/gio-2.0').Gio} */
const Gio = imports.gi.Gio;

/** @type {import('@girs/gobject-2.0').GObject} */
const GObject = imports.gi.GObject;

let time = 0;

/** @param { (...args: any[]) => typeof GObject.Object } service */
/** @param { { [signal: string]: import('types/utils/gobject').PspecFlag; } } signals */
/** @param { { [prop: string]: [type?: import('types/utils/gobject').PspecType, handle?: import('types/utils/gobject').PspecFlag] } } properties */
export function customRegister(service, signals, properties) {
    registerGObject(service, {
            signals,
            properties,
            typename: `${service.name}_${time}`,
        });
}

/** @param {string[]} directories */
/** @param {(root: string) => Promise<void>} onReload */
export function watchDirs(directories, onReload) {
    async function onChange() {
        try {
            time++;
            const root = '/tmp/ags/js' + time;
            await Utils.execAsync(`rm -rf /tmp/ags/js*`);
            await Utils.execAsync(`mkdir -p ${root}`);
            await Utils.execAsync(`cp -R ${App.configDir}/src ${root}`);

            await onReload(`${root}/src`);
        } catch (/** @type {any} */ e) {
            console.error(e);
        }
    }
 
    async function listenRecursively(path) {
        Gio.FILE_ATTRIBUTE_STANDARD_NAME
        const file = Gio.File.new_for_path(path)
        const enumerator = file.enumerate_children(
            Gio.FILE_ATTRIBUTE_STANDARD_NAME+','+Gio.FILE_ATTRIBUTE_STANDARD_TYPE,
            Gio.FileQueryInfoFlags.NOFOLLOW_SYMLINKS,
            null
        );
        /** @type { import('@girs/gio-2.0').Gio.FileInfo | null } */
        let file_info;
        while ((file_info = enumerator.next_file(null)) != null) {
            if (file_info.get_file_type() === Gio.FileType.DIRECTORY)
                listenRecursively(`${path}/${file_info.get_name()}`);
        }

        Utils.monitorFile(
            path,
            function (file, event) {
                if ([Gio.FileMonitorEvent.CHANGES_DONE_HINT].includes(event)) onChange();
                else if (event === Gio.FileMonitorEvent.CREATED) {
                    if (file.query_info(Gio.FILE_ATTRIBUTE_STANDARD_TYPE, 0, null).get_file_type()
                        === Gio.FileType.DIRECTORY)
                        listenRecursively(file.get_path());
                }
            },
            'directory',
        )

    }

    listenRecursively(`${App.configDir}/src`);
    onChange();
}