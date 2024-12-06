import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Audio from './widgets/audio.js';
import Brightness from './widgets/brightness.js'

export const Settings = (monitor: number) => Widget.Window({
    monitor,
    name: 'settings',
    // name: `settings${monitor}`,
    anchor: ['left', 'bottom'],
    // keymode: 'on-demand',
    keymode: 'exclusive',

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

                children: (() => {
                    const brightness = Brightness(monitor);
                    const children : any[] = [
                        Audio(monitor),
                        // children: drop down if monitor connected ddcutil
                    ];
                    if (brightness) children.push(brightness);
                    return children;
                })(),
            }),
            Widget.Label({
                label: 'battery, logout options',
                class_name: 'widget',
            }),
        ]
    })
}).keybind('Escape', () => App.closeWindow('settings'));