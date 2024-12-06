import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import Brightness from '../../services/brightness.js';


export default (monitor: number) => {
    const connector = Hyprland.getMonitor(monitor);
    if (!connector) return undefined;
    const device = Brightness.getDevice(connector.name);
    if (!device) return undefined;

    return Widget.Slider({
        class_name: 'brightness',
        hexpand: true,
        draw_value: false,
        min: 0,
        max: 100,
        value: device.bind('brightness'),
        step: 1,

        on_change: ({ value }) => device.brightness = value,
    });
};