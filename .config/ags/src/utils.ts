import { Stream } from "resource:///com/github/Aylur/ags/service/audio.js";

export function dump(obj : any) {
    return JSON.stringify(obj, function(key, val) {
        return (typeof val === 'function') ? '' + val : val;
    })
}

const icons: [number, string][] = [
    [1.01, 'overamplified'],
    [.75, 'high'],
    [.40, 'medium'],
    [.10, 'low'],
];

export function get_audio_icon (stream: Stream) {
    let icon = '';
    if (stream.stream!.form_factor === 'headset')
        icon = stream.is_muted ?  'volume-muted-headphones' : 'headphones';
    else if (stream.is_muted)
        icon = 'volume-muted';
    else
        icon = 'volume-' + icons.find(([threshold], ..._) => (threshold as number) <= stream.volume)![1];

    return `audio-${icon}-symbolic`;
}