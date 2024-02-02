import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Brightness from '../../services/brightness.js';


/** @param {number} monitor */
export default (monitor) => Widget.Slider({
    class_name: 'brightness',
    hexpand: true,
    draw_value: false,
    min: 0,
    max: 100,
    value: Brightness.bind('screen_value'),
    step: 1,

    on_change: ({ value }) => Brightness.screen_value = value,
});
