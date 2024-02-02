import Variable from 'resource:///com/github/Aylur/ags/variable.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Workspaces from './widgets/workspaces.js'
import Player from './widgets/player.js'
import SystemInfo from './widgets/systeminfo.js'


/** @type {import('gtk-3.0').Gtk} */
const Gtk = imports.gi.Gtk;


const time = Variable('', {
    poll: [1000, function() {
        const date = new Date();
        return [date.getHours(), date.getMinutes(), date.getSeconds()]
            .map(num => num.toString().padStart(2, '0'))
            .join('\n');
    }],
});


/** @param {number} monitor */ 
export const Bar = (monitor) => Widget.Window({
    monitor,
    name: `bar`,
    // name: `bar${monitor}`,
    anchor: ['left', 'top', 'bottom'],
    exclusivity: 'exclusive',
    expand: true,
    child: Widget.CenterBox({
        orientation: Gtk.Orientation.VERTICAL,
        class_names: ['window', 'bar'],

        start_widget: Workspaces(0),
        center_widget: Widget.Label({
            justification: 'center',
            label: time.bind(),
            class_names: ['widget', 'time']
        }),
        end_widget: Widget.Box({
            vpack: 'end',
            orientation: Gtk.Orientation.VERTICAL,
            children: [
                Player(0),
                SystemInfo(0),
            ],
        })
    })
});