// import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';
import Network from 'resource:///com/github/Aylur/ags/service/network.js';
import Battery from 'resource:///com/github/Aylur/ags/service/battery.js';
import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import { Settings } from '../../settings/settings.js';
import Gtk from "gi://Gtk?version=3.0";
import type { Stream } from 'types/service/audio.js';

const icons: [number, string][] = [
    [1.01, 'overamplified'],
    [.75, 'high'],
    [.40, 'medium'],
    [.10, 'low'],
];

const get_icon = (stream: Stream) => {
    let icon = '';
    if (stream.is_muted)
        icon = 'volume-muted';
    else if (stream.stream!.form_factor === 'headset')
        icon = 'headphones';
    else
        icon = 'volume-' + icons.find(([threshold], ..._) => (threshold as number) <= stream.volume)![1];

    return `audio-${icon}-symbolic`;
}

export default (monitor: number) => {
    // Network.wifi.connect("changed", console.log);
    return Widget.Button({
        class_names: ['widget'],
        on_clicked: () => {
            if (App.windows.find((window) => window.name === 'settings'))
                App.removeWindow('settings');
            else
                App.addWindow(Settings(monitor));
        },

        child: Widget.Box({
            orientation: Gtk.Orientation.VERTICAL,
            css: 'padding: 3px 0',
            spacing: 6,
            children: [
                Widget.Icon({
                    size: 20,
                }).hook(Audio, self => {
                    if (!Audio.speaker)
                        return;

                    self.hook(Audio.speaker, (self) => {
                        if (!Audio.speaker.stream) return;

                        self.icon = get_icon(Audio.speaker);
                        self.tooltip_text = `${Math.round(Audio.speaker.volume * 100)}%`;
                    });

                }, 'speaker-changed'),
                // Widget.Label({
                //     label: Brightness.bind('screen_value').transform((brightness) => brightness + '%'),
                // }),
                Widget.Icon({
                    icon: Network.wifi.bind('icon_name'), //.transform((icon) => { console.log(icon); return icon }),
                    tooltip_text: Network.wifi.bind('strength').transform(() => `${Network.wifi.ssid} ${Network.wifi.strength}%`),
                    size: 20,
                }),
                // Widget.CircularProgress({
                Widget.Icon({
                    icon: Battery.bind('icon_name'),
                    tooltip_text: Battery.bind('percent').transform((bat) => `${bat}%`),
                    // icon: Battery.bind('icon_name').transform(name =>  {
                    //     return Utils.lookUpIcon(name)?.load_icon().rotate_simple(GdkPixbuf.PixbufRotation.CLOCKWISE);
                    // }),
                    size: 20,
                }),
            ]
        })
    })
};

