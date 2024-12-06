import Service from 'resource:///com/github/Aylur/ags/service.js';
import { registerGObject } from 'resource:///com/github/Aylur/ags/utils/gobject.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js'
import Gio from 'gi://Gio?version=2.0'
import GObject from 'gi://GObject?version=2.0'

let time = 0;

export class CustomService extends Service {
    /**
     * @param { new (...args: any[]) => GObject.Object } service
     * @param { { [signal: string]: import('types/utils/gobject').PspecType[]; } } signals
     * @param { { [prop: string]: [type?: import('types/utils/gobject').PspecType, handle?: import('types/utils/gobject').PspecFlag] } } properties
     * @override
     */
    static register(service, signals, properties) {
        registerGObject(service, {
            signals,
            properties,
            typename: `${service.name}_${time}`,
        });
    }
}

// /** @param { (...args: any[]) => typeof GObject.Object } service */
// /** @param { { [signal: string]: import('types/utils/gobject').PspecFlag; } } signals */
// /** @param { { [prop: string]: [type?: import('types/utils/gobject').PspecType, handle?: import('types/utils/gobject').PspecFlag] } } properties */
// export function customRegister(service, signals, properties) {
//     registerGObject(service, {
//             signals,
//             properties,
//             typename: `${service.name}_${time}`,
//         });
// }

/**
 * @param {string[]} directories
 * @param {(root: string) => Promise<void>} onReload
 */
export function watchDirs(directories, onReload) {
    async function onChange() {
        try {
            time++;
            await onReload('/tmp/ags/js' + time);
        } catch (e) {
            console.error(e);
        }
    }

    function listenRecursively(path) {
        Gio.FILE_ATTRIBUTE_STANDARD_NAME
        const file = Gio.File.new_for_path(path)
        const enumerator = file.enumerate_children(
            Gio.FILE_ATTRIBUTE_STANDARD_NAME + ',' + Gio.FILE_ATTRIBUTE_STANDARD_TYPE,
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
        )

    }

    directories.forEach(dir => listenRecursively(`${App.configDir}/${dir}`));
    onChange();

    App.config({
        windows: []
    })
}
