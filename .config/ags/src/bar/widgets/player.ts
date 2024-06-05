import Widget from "resource:///com/github/Aylur/ags/widget.js"
import Mpris, { MprisPlayer } from 'resource:///com/github/Aylur/ags/service/mpris.js';
import Gtk from "gi://Gtk?version=3.0";

export default (monitor: number) => {
    /** @param {MprisPlayer} player */
    const Player = player => Widget.Button({
        class_names: ['widget', 'music'],
        css: player.bind('track_cover_url').transform(path => `background-image: url("${path}");`),
        on_clicked: () => player.playPause(),
        on_middle_click: () => player.stop(),
        child: Widget.Box({
            orientation: Gtk.Orientation.VERTICAL,
            vpack: 'center',
            children: [
                Widget.Label({
                    // css: 'font-size: 1.2rem',
                    class_names: ['play-button'],
                    label: player.bind('play_back_status').transform(
                        /** @returns {string} */
                        status => status === 'Playing' ? '⏸' : '▶'
                    ),
                })
            ],
        })
    });

    let _playerctld;
    return Widget.Revealer({
        transition: 'slide_up',
        transition_duration: 500,
        reveal_child: false,
        expand: true,
        child: Widget.Box(),
    }).hook(Mpris, (self) => {
        const playerctld = Mpris.getPlayer('playerctld');
        // console.log('player', playerctld, (!playerctld || playerctld.play_back_status === null || playerctld.play_back_status === 'Stopped'));

        if (!playerctld || playerctld.play_back_status === null || playerctld.play_back_status === 'Stopped') {
            self.reveal_child = false
            // self.child.visible = false
            _playerctld == undefined;
        } else {
            if (_playerctld !== playerctld) {
                // @ts-ignore
                self.child = Player(playerctld)

                _playerctld = playerctld;
            }

            self.child.visible = true
            self.reveal_child = true
        }
    });
}