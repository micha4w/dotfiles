import Service from 'resource:///com/github/Aylur/ags/service.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import { bulkConnect, bulkDisconnect } from 'resource:///com/github/Aylur/ags/utils.js';
import { customRegister } from 'file:///home/micha4w/.config/ags/auto_reload.js'



/** @type {import('gvc-1.0').Gvc} */
const Gvc = imports.gi.Gvc;

const _MIXER_CONTROL_STATE = {
    [Gvc.MixerControlState.CLOSED]: 'closed',
    [Gvc.MixerControlState.READY]: 'ready',
    [Gvc.MixerControlState.CONNECTING]: 'connecting',
    [Gvc.MixerControlState.FAILED]: 'failed',
};

export class Stream extends Service {
    static {
        customRegister(this, {
            'closed': [],
        }, {
            'application-id': ['string'],
            'description': ['string'],
            'is-muted': ['boolean'],
            'volume': ['float', 'rw'],
            'icon-name': ['string'],
            'id': ['int'],
            'state': ['string'],
            'form-factor': ['string'],
        });
    }

    /** @type { import('gvc-1.0').Gvc.MixerStream } */
    #stream;
    /** @type { number[] } */
    #ids;

    /** @param { import('gvc-1.0').Gvc.MixerStream } stream */
    constructor(stream) {
        super();

        this.#stream = stream;
        this.#ids = [
            'application-id',
            'description',
            'is-muted',
            'volume',
            'icon-name',
            'id',
            'state',
            'form-factor',
        ].map(prop => stream.connect(`notify::${prop}`, () => {
            this.changed(prop);
        }));
    }

    get application_id() { return this.#stream.application_id; }
    get stream() { return this.#stream; }
    get description() { return this.#stream.description; }
    get icon_name() { return this.#stream.icon_name; }
    get id() { return this.#stream.id; }
    get name() { return this.#stream.name; }
    get state() { return _MIXER_CONTROL_STATE[this.#stream.state]; }
    get form_factor() { return this.#stream.form_factor; }

    get is_muted() { return this.#stream.is_muted }
    set is_muted(/** @type {boolean} */ mute) {
        this.#stream.set_is_muted(mute);
    }

    get volume() {
        const max = audio.control.get_vol_max_norm();
        return this.#stream.volume / max;
    }

    set volume(value) {
        if (value > (App.config.maxStreamVolume))
            value = (App.config.maxStreamVolume);

        if (value < 0)
            value = 0;

        const max = audio.control.get_vol_max_norm();
        this.#stream.set_volume(value * max);
        // this.#stream.push_volume();
    }

    get_icon() {
        let icon = '';
        if (this.is_muted)
            icon = 'volume-muted';
        else if (this.form_factor === 'headset')
            icon = 'headphones';
        else
            icon = 'volume-' + (/** @type {string[]} */ ([
                [1.01, 'overamplified'],
                [.67, 'high'],
                [.34, 'medium'],
                [0, 'low'],
                /** @ts-ignore */
            ].find(([threshold]) => threshold <= this.volume)))[1];

        return `audio-${icon}-symbolic`;
    }

    close() {
        bulkDisconnect(this.#stream, this.#ids);
        this.emit('closed');
    }
}

export class Audio extends Service {
    static {
        customRegister(this, {
            'speaker-changed': [],
            'microphone-changed': [],
            'stream-added': ['int'],
            'stream-removed': ['int'],
        }, {
            'apps': ['jsobject'],
            'recorders': ['jsobject'],
            'speakers': ['jsobject'],
            'microphones': ['jsobject'],
            'speaker': ['jsobject', 'rw'],
            'microphone': ['jsobject', 'rw'],
        });
    }

    /** @type { import('gvc-1.0').Gvc.MixerControl } */
    #control;
    /** @type { Map<number, Stream> } */
    #streams;
    /** @type { Map<number, number> } */
    #streamBindings;

    /** @type { Record<string, { binding: number, stream: Stream }> } */
    #activeStreams = {};

    constructor() {
        super();

        this.#control = new Gvc.MixerControl({
            name: `${pkg.name} mixer control`,
        });

        this.#streams = new Map();
        this.#streamBindings = new Map();

        bulkConnect(this.#control, [
            ['default-sink-changed', (_c, id) => this.#defaultChanged(id, 'speaker')],
            ['default-source-changed', (_c, id) => this.#defaultChanged(id, 'microphone')],
            ['stream-added', this.#streamAdded.bind(this)],
            ['stream-removed', this.#streamRemoved.bind(this)],
        ]);

        this.#control.open();
    }

    get control() { return this.#control; }

    /** @returns {Stream | undefined} */
    get speaker() { return this.#activeStreams.speaker?.stream; }
    /** @param {Stream} stream */
    set speaker(stream) {
        this.#control.set_default_sink(stream.stream);
    }

    /** @returns {Stream | undefined} */
    get microphone() { return this.#activeStreams.microphone?.stream; }
    /** @param {Stream} stream */
    set microphone(stream) {
        this.#control.set_default_source(stream.stream);
    }

    get microphones() { return this.#getStreams(Gvc.MixerSource); }
    get speakers() { return this.#getStreams(Gvc.MixerSink); }
    get apps() { return this.#getStreams(Gvc.MixerSinkInput); }
    get recorders() { return this.#getStreams(Gvc.MixerSourceOutput); }

    /** @param {number} id */
    getStream(id) { return this.#streams.get(id); }

    /** @param {number} id */
    /** @param {'speaker' | 'microphone'} type */
    #defaultChanged(id, type) {
        this.#activeStreams[type]?.stream.disconnect(this.#activeStreams[type].binding)

        const stream = this.#streams.get(id);
        if (!stream) {
            delete this.#activeStreams[type];
            return;
        }

        this.#activeStreams[type] = {
            binding: stream.connect('changed', () => this.emit(`${type}-changed`)),
            stream,
        }
        this.emit(`${type}-changed`);
    }

    /** @param { import('gvc-1.0').Gvc.MixerControl } _c */
    /** @param {number} id */
    #streamAdded(_c, id) {
        if (this.#streams.has(id))
            return;

        const gvcstream = this.#control.lookup_stream_id(id);
        const stream = new Stream(gvcstream);
        const binding = stream.connect('changed', () => this.emit('changed'));

        this.#streams.set(id, stream);
        this.#streamBindings.set(id, binding);

        this.#notifyStreams(stream);
        this.emit('stream-added', id);
        this.emit('changed');
    }

    /** @param { import('gvc-1.0').Gvc.MixerControl } _c */
    /** @param {number} id */
    #streamRemoved(_c, id) {
        const stream = this.#streams.get(id);
        if (!stream)
            return;

        stream.disconnect(this.#streamBindings.get(id));
        stream.close();

        this.#streams.delete(id);
        this.#streamBindings.delete(id);
        this.emit('stream-removed', id);

        this.#notifyStreams(stream);
        this.emit('changed');
    }

    /** @param { { new(): import('gvc-1.0').Gvc.MixerControl } } filter */
    #getStreams(filter) {
        const list = [];
        for (const [, stream] of this.#streams) {
            if (stream.stream instanceof filter)
                list.push(stream);
        }
        return list;
    }

    /** @param {Stream} stream */
    #notifyStreams(stream) {
        if (stream.stream instanceof Gvc.MixerSource)
            this.notify('microphones');

        if (stream.stream instanceof Gvc.MixerSink)
            this.notify('speakers');

        if (stream.stream instanceof Gvc.MixerSinkInput)
            this.notify('apps');

        if (stream.stream instanceof Gvc.MixerSourceOutput)
            this.notify('recorders');
    }
}

const audio = new Audio;
export default audio;