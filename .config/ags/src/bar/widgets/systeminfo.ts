// import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';
// import Network from 'resource:///com/github/Aylur/ags/service/network.js';
import Network from '../../services/network';
import Battery from 'resource:///com/github/Aylur/ags/service/battery.js';
import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import { Settings } from '../../settings/settings.js';
import Brightness from '../../services/brightness.js';
import Gtk from "gi://Gtk?version=3.0";
import type { Stream } from 'types/service/audio.js';
import { get_audio_icon } from 'src/utils';


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
                    self.hook(Audio.speaker, (self) => {
                        if (!Audio.speaker.stream) return;

                        self.icon = get_audio_icon(Audio.speaker);
                        self.tooltip_text = `${Math.round(Audio.speaker.volume * 100)}%`;
                    });
                }, 'speaker-changed'),
                // Widget.Label({
                //     label: Brightness.bind('screen_value').transform((brightness) => brightness + '%'),
                // }),
                Widget.Icon({
                    icon: Network.wifi.bind('icon_name'),
                    tooltip_text: Network.wifi.bind('tooltip'),
                    size: 20,
                }),
                Widget.Icon({
                    icon: Battery.bind('icon_name'),
                    tooltip_text: Battery.bind('percent').transform((bat) => `${bat}%`),
                    size: 20,
                }),
            ]
        })
    })
};

