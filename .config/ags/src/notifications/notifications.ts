import { dump } from "../utils.js";
import type { Notification } from 'types/service/notifications.js';
import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js';
import Network from '../services/network';

const NotificationIcon = ({ app_entry, app_icon, image }: Notification) => {
    if (image) {
        return Widget.Box({
            css: `
                background-image: url("${image}");
                background-size: contain;
                background-repeat: no-repeat;
                background-position: center;
            `,
        });
    }

    let icon = 'dialog-information-symbolic';
    if (Utils.lookUpIcon(app_icon))
        icon = app_icon;

    if (app_entry && Utils.lookUpIcon(app_entry))
        icon = app_entry;

    return Widget.Icon(icon);
};

export const NotificationWidget = (n: Notification) => {
    // console.log(n);
    // const icon = Widget.Box({
    //     vpack: 'start',
    //     class_name: 'icon',
    //     child: NotificationIcon(n),
    // });

    // const notifications = await Service.import("notifications")
    // notifications.popupTimeout = 3000;
    // notifications.forceTimeout = false;
    // notifications.cacheActions = false;
    // notifications.clearDelay = 100;

    const title = Widget.Label({
        class_name: 'title',
        xalign: 0,
        justification: 'left',
        hexpand: true,
        max_width_chars: 24,
        truncate: 'end',
        wrap: true,
        label: n.summary,
        use_markup: true,
    });

    const body = Widget.Label({
        class_name: 'body',
        hexpand: true,
        use_markup: true,
        xalign: 0,
        justification: 'left',
        label: n.body,
        wrap: true,
    });

    const actions = Widget.Box({
        class_name: 'actions',
        children: n.actions.map(({ id, label }) => Widget.Button({
            class_name: 'action-button',
            on_clicked: () => n.invoke(id),
            hexpand: true,
            child: Widget.Label(label),
        })),
    });

    return Widget.EventBox({
        on_primary_click: () => n.dismiss(),
        child: Widget.Box({
            class_name: `notification ${n.urgency}`,
            vertical: true,
            children: [
                Widget.Box({
                    children: [
                        // icon,
                        Widget.Box({
                            vertical: true,
                            children: [
                                title,
                                body,
                            ],
                        }),
                    ],
                }),
                actions,
            ],
        }),
    });
};

export const NotificationPopup = (monitor: number) => {
    // notifications.popupTimeout = 3000;
    // notifications.forceTimeout = false;
    // notifications.cacheActions = false;
    // notifications.clearDelay = 100;

    return Widget.Window({
        name: `notifications${monitor}`,
        monitor: monitor,
        anchor: ['bottom', 'left'],
        child: Widget.Box({
            css: "background-color: red",
            children: [
                // Widget.Label('asdf'),
                Widget.Label({
                    // label: "asfd"
                    // label: Notifications.bind('')
                    use_markup: false,
                    // label: Network.wifi.bind('icon_name'),
                    label: Notifications.bind("popups").as(n => {
                        print(dump(n.length));
                        print(dump(n.filter(n => n.popup)))
                        return `there are ${n.length} notifications`;
                    })
                })
            ]
        })
        // child: Widget.Box({
        //     class_name: 'notifications',
        //     css: 'background-color: red;',
        //     vertical: true,
        //     children: [Widget.Label('hello world')]
        //     // Notifications.bind('popups').as(popups => {
        //     //     popups.map((popup) => console.log(popup.body));
        //     //     return [Widget.Label('hello world')];
        //     //     // popups.map(NotificationWidget)
        //     // }),
        //     // children: [Widget.Label({
        //     //     label: 'hello world'
        //     // })],
        //     // children: [],
        // }).hook(Notifications, (self) => {
        //     // const x = [
        //     //     Widget.Label({
        //     //         label: 'hello someone'
        //     //     }),
        //     //     // Widget.Label({
        //     //     //     label: 'wow' + Notifications.popups[0].body
        //     //     // }),
        //     // ];
        //     // x.push(Widget.Label("wow"));
        //     // self.children = x;

        //     // const x = [];:
        //     dump(Notifications.popups)
        //     // print(self.children);

        //     const notifications = [];
        //     for (const popup of Notifications.popups) {
        //         print("body " + popup.body);
        //         notifications.push(Widget.Label({ label: popup.body }));
        //     }
        //     dump(notifications);
        //     self.children = notifications;
        //     // print(self.children);

        //     self.children[0].visible = true
        // }),
    })
    // .hook(Notifications, (self) => {
    //     // const notifications = [];
    //     // for (const popup of Notifications.popups) {
    //     //     print("body " + popup.body);
    //     //     notifications.push(Widget.Label({ label: popup.body }));
    //     // }
    //     // print(dump(notifications))

    //     self.child = Widget.Box({
    //         class_name: 'notifications',
    //         css: 'background-color: red;',
    //         vertical: true,
    //         // children: [Widget.Label('hello world')]
    //         // children: Notifications.bind('popups').as(popups => {
    //         //     popups.map((popup) => console.log(popup.body));
    //         //     return [Widget.Label(popups[0].body)];
    //         //     popups.map(NotificationWidget)
    //         // }),
    //         // children: notifications,
    //         // children: [Widget.Label(dump(Notifications.popups))]
    //         children: Notifications.popups.map(popup => Widget.Label())
    //         // children: [Widget.Label({
    //         //     label: 'hello world'
    //         // })],
    //     })

    //     print(dump(self.child))
    // });

};