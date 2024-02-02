import Service from 'resource:///com/github/Aylur/ags/service.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js';
import { customRegister } from 'file:///home/micha4w/.config/ags/auto_reload.js'

class BrightnessService extends Service {
    static {
        customRegister(
            this,
            { },
            { 'screen-value': ['float', 'rw'], },
        );
    }

    #interface = Utils.exec("sh -c 'ls -w1 /sys/class/backlight | head -1'");

    #screenValue = 0;
    #max = Number(Utils.exec('brightnessctl max'));

    get screen_value() {
        return this.#screenValue;
    }

    set screen_value(percent) {
        if (percent < 0)
            percent = 0;

        if (percent > 100)
            percent = 100;

        Utils.execAsync(`brightnessctl set ${percent}% -q`).then(() => {
            this.#screenValue = percent;

            this.notify('screen-value');
            this.emit('changed');
        });
    }

    constructor() {
        super();

        const brightness = `/sys/class/backlight/${this.#interface}/brightness`;
        Utils.monitorFile(brightness, () => this.#onChange());

        this.#onChange();
    }

    #onChange() {
        this.#screenValue = Math.round(Number(Utils.exec('brightnessctl get')) / this.#max * 100);

        this.notify('screen-value');
        this.emit('changed');
    }
}

const service = new BrightnessService;
export default service;