import Variable from 'resource:///com/github/Aylur/ags/variable.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Workspaces from './widgets/workspaces.js'
import Player from './widgets/player.js'
import SystemInfo from './widgets/systeminfo.js'
import Tray from './widgets/tray.js'
import Gtk from "gi://Gtk?version=3.0";


const time = Variable('', {
    poll: [1000, function() {
        const date = new Date();
        return [
            date.getHours(),
            date.getMinutes(),
            date.getSeconds(),
        ].map(num => num.toString().padStart(2, '0'))
         .join('\n');
    }],
});

const date = Variable('', {
    poll: [1000, function() {
        const date = new Date();
        return [
            date.toLocaleDateString("en-US", { weekday: "short" }),
            date.getDate(),
            date.toLocaleDateString("en-US", { month: "short" }),
        ].map(num => num.toString().padStart(2, '0'))
         .join('\n');
    }],
});


export const Bar = (monitor: number) => Widget.Window({
    monitor,
    name: `bar${monitor}`,
    anchor: ['left', 'top', 'bottom'],
    exclusivity: 'exclusive',
    expand: true,
    child: Widget.CenterBox({
        orientation: Gtk.Orientation.VERTICAL,
        class_names: ['window', 'bar'],

        start_widget: Workspaces(monitor),
        center_widget: Widget.Box({
            class_names: ['widget'],
            orientation: Gtk.Orientation.VERTICAL,
            children: [
                Widget.Label({
                    justification: 'center',
                    label: time.bind(),
                    class_names: ['time']
                }),
                Widget.Label('-'),
                Widget.Label({
                    justification: 'center',
                    label: date.bind(),
                    class_names: ['date'],
                }),
            ],
        }),
        end_widget: Widget.Box({
            vpack: 'end',
            spacing: 1,
            orientation: Gtk.Orientation.VERTICAL,
            children: [
                Tray(monitor),
                Player(monitor),
                SystemInfo(monitor),
            ],
        })
    })
});
