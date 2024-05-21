import Widget from "resource:///com/github/Aylur/ags/widget.js"
import { dump } from "../utils.js";
import GLib from 'gi://GLib?version=2.0'
import Gio from 'gi://Gio?version=2.0'

/** @param {number} monitor */
export const KeyVisualizer = (monitor) => {
    let [res, pid, in_fd, out_fd, err_fd] = GLib.spawn_async_with_pipes(null,
        ['/home/micha4w/Code/Arch/wshowkeys/build/wshowkeys'], null, 0, null);
    print([res, pid, in_fd, out_fd, err_fd]);
    let out_reader = new Gio.DataInputStream({
        base_stream: new Gio.UnixInputStream({ fd: out_fd })
    });
    let err_reader = new Gio.DataInputStream({
        base_stream: new Gio.UnixInputStream({ fd: err_fd })
    });
    let out;
    const callback = (reader) => {
        print(out, reader);
        out = reader.read_line_async(0, null, callback);
    };
    callback(out_reader);
    callback(err_reader);

    return Widget.Window({
        name: 'key_visualizer',
        // layer: 'overlay',
        anchor: ['right'],
        child: Widget.Label({
            class_name: 'keyvisualizer',
            css: 'background-color: red;',
            label: "wow",
        }).on('key-press-event', (self, event) => {
            dump(event);
        }),
    });
};