import * as Utils from 'resource:///com/github/Aylur/ags/utils.js';
import { CustomService as Service } from 'file:///home/micha4w/.config/ags/auto_reload.js'

import Gio from 'gi://Gio?version=2.0'

class Device extends Service {
    static {
        Service.register(
            this,
            {},
            { 'brightness': ['float', 'rw'], },
        );
    }

    #device: string;
    #brightness = 0;

    constructor(device: string) {
        super();

        this.#device = device;

        Utils.monitorFile(
            `/sys/class/backlight/${this.#device}/brightness`,
            () => this.#onChange()
        );

        this.#onChange();
    }


    get brightness() {
        return this.#brightness;
    }

    set brightness(percent) {
        if (percent < 0)
            percent = 0;

        if (percent > 100)
            percent = 100;

        Utils.execAsync(`brightnessctl set -d ${this.#device} ${percent}% -q`).then(() => {
            this.#brightness = percent;

            this.notify('brightness');
            this.emit('changed');
        }).catch(console.error);
    }

    #onChange() {
        // const brightness = +Utils.readFile(`/sys/class/backlight/${this.#device}/brightness`);
        this.#brightness = +Utils.exec(`brightnessctl get -m -P -d ${this.#device}`);

        this.notify('brightness');
        this.emit('changed');
    }
}

class BrightnessService extends Service {
    static {
        Service.register(
            this,
            {},
            { 'devices': ['jsobject'], },
        )
    }

    #device_paths: string[];
    #devices: string[];

    constructor() {
        super();

        this.#device_paths = Utils.exec(`bash -c 'realpath /sys/class/backlight/*'`).split('\n');
        this.#devices = this.#device_paths.map(path => path.split('/').at(-1)!);
        // this.#devices = Utils.exec('brightnessctl -m -l -c backlight').split('\n');
    }

    get devices(): string[] {
        return this.#devices;
    }

    getDevice(connector: string): Device | undefined {
        const devices = Utils.exec(`bash -c 'realpath /sys/class/drm/*${connector}/*'`).split('\n');
        const path = this.#device_paths.find(path => devices.includes(path));
        let device = connector;
        if (path) {
            device = path.split('/').at(-1)!;
        } else {
            const match = Utils
                .exec(`bash -c 'basename \$(realpath /sys/class/drm/*${connector}/ddc)'`)
                .match(/i2c-(\d+)$/);
            if (match) {
                const ddc_id = match[1];
                device = `ddcci${ddc_id}`;
            } else {
                const match = Utils
                    .exec(`bash -c 'basename \$(realpath /sys/class/drm/*${connector}/ddc)'`)
                    .match(/i2c-(\d+)$/);
                if (match) {
                    const ddc_id = match[1];
                    device = `ddcci${ddc_id}`;
                }
            }
        }

        const exists = Utils.exec(`bash -c '[[ -f /sys/class/backlight/${device}/brightness ]] && echo exists'`)
        if (exists !== 'exists') {
            console.warn(`Failed to find Backlight ${device}`);
            return undefined
        }

        return new Device(device);
    }
}


const service = new BrightnessService;
export default service;