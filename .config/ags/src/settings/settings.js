import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Audio from './widgets/audio.js';
import Brightness from './widgets/brightness.js'


/** @type {import('gtk-3.0').Gtk} */
const Gtk = imports.gi.Gtk;

/** @param {number} monitor */
export const Settings = (monitor) => Widget.Window({
    monitor,
    name: 'settings',
    // name: `settings${monitor}`,
    anchor: ['left', 'bottom'],
    keymode: 'on-demand',
    popup: true,

    child: Widget.Box({
        class_names: ['window', 'settings'],
        vertical: true,

        children: [
            Widget.Label({
                label: 'wifi | bluetooth | power',
                class_name: 'widget',
            }),
            Widget.Box({
                vertical: true,
                // label: 'volume',
                class_name: 'widget',

                children: [
                    Audio(monitor),
                    Brightness(monitor),
                ],
            }),
            Widget.Label({
                label: 'battery, logout options',
                class_name: 'widget',
                // children: drop down if monitor connected ddcutil
            }),
        ]
    })
});