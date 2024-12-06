import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';
import { get_audio_icon } from 'src/utils';


export default (monitor: number) => {
    const revealed = Variable(false);
    return Widget.Box({
        vertical: true,

        children: [
            Widget.Revealer({
                reveal_child: revealed.bind(),
                child: Widget.Label('very nice'),
            }),
            Widget.Box({
                children: [
                    Widget.Slider({
                        class_name: 'volume',
                        hexpand: true,
                        draw_value: false,
                        min: 0,
                        max: 100,
                        value: Audio.speaker.bind('volume'),
                        step: 1,

                        on_change: ({ value }) => { if (Audio.speaker) Audio.speaker.volume = value / 100 },
                    }).hook(Audio, self => {
                        self.bind('value', Audio.speaker, 'volume', (vol) => vol * 100)
                    }, 'speaker-changed'),
                    Widget.Button({
                        on_clicked: () => { Audio.speaker.is_muted = !Audio.speaker.is_muted },
                        child: Widget.Icon({
                            size: 20,
                            css: 'margin: 0 5px'
                        }).hook(Audio, self => {
                            self.hook(Audio.speaker, (self) => {
                                if (!Audio.speaker.stream) return;
                                self.icon = get_audio_icon(Audio.speaker);
                            });
                        }, 'speaker-changed'),
                    }),
                    Widget.Button({
                        on_clicked: () => {
                            revealed.value = !revealed.value;
                        },
                        child: Widget.Label('v'),
                    })
                ],
            }),
        ],
    });
};