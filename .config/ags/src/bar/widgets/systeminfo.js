// import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';
import Network from 'resource:///com/github/Aylur/ags/service/network.js';
import Battery from 'resource:///com/github/Aylur/ags/service/battery.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import Audio from '../../services/audio.js';
import { Settings } from '../../settings/settings.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Gtk from "gi://Gtk?version=3.0";
import GdkPixbuf from "gi://GdkPixbuf?version=2.0";


/** @param {number} monitor */
export default (monitor) => {
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
                        if (!Audio.speaker) return;

                        self.icon = Audio.speaker.get_icon();
                        self.tooltip_text = `${Math.round(Audio.speaker.volume*100)}%`;
                    });

                }, 'speaker-changed'),
                // Widget.Label({
                //     label: Brightness.bind('screen_value').transform((brightness) => brightness + '%'),
                // }),
                Widget.Icon({
                    icon: Network.wifi.bind('icon_name'),
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

