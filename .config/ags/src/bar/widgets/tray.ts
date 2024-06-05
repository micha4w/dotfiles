import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import SystemTray, { TrayItem } from 'resource:///com/github/Aylur/ags/service/systemtray.js';
// import SystemTray, { TrayItem } from '../../services/systemtray.js';
import Gtk from "gi://Gtk?version=3.0";


export default (monitor: number) => {
    return Widget.Revealer({
        reveal_child: SystemTray.bind('items').as(items => items.length > 0),
        transition: 'slide_up',
        transition_duration: 500,
        expand: true,
        child: Widget.Box({
            orientation: Gtk.Orientation.VERTICAL,
            css: 'padding: 8px 0',

            spacing: 6,
            class_names: ['widget', 'tray'],
            children: SystemTray.bind('items').transform((items) => items.map((/** @type {TrayItem} */ item: TrayItem) =>
                Widget.Button({
                    class_names: ['tray-item'],
                    on_primary_click: (_, event) => item.menu || item.is_menu ? item.openMenu(event) : item.activate(event),
                    on_secondary_click: (_, event) => item.secondaryActivate(event),
                    on_scroll_down: (_, event) => item.scroll(event as any),
                    on_scroll_up: (_, event) => item.scroll(event as any),

                    tooltip_markup: item.bind('tooltip_markup'),
                    child: Widget.Icon({
                        size: 20,
                        icon: item.bind('icon'),
                    }),
                })
            )),
        }),
    });
}