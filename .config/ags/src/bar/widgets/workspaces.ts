import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import type { Workspace } from 'types/service/hyprland';
import Gtk from "gi://Gtk?version=3.0";
import { Monitor } from 'types/@girs/gdk-3.0/gdk-3.0.cjs';


function getClasses(workspace : Workspace | undefined, activeWorkspaceID : number | undefined, monitorID: number) {
    const classes = ['workspace'];
    if (workspace?.monitorID != monitorID)
        classes.push('empty')
    else if (workspace?.id === activeWorkspaceID)
        classes.push('active')
    else if (workspace === undefined || workspace.windows === 0)
        classes.push('empty')

    return classes;
}


export default (monitor: number) => {
    let i = 1;
    const activeWorkspace = Hyprland.getMonitor(monitor)?.activeWorkspace.id;
    return Widget.Box({
        vpack: 'start',
        hpack: 'fill',
        class_names: ['widget', 'workspaces'],
        orientation: Gtk.Orientation.VERTICAL,
        children: Array.from({ length: 5 }, e => [undefined, undefined]).map(row => {
            return Widget.Box({
                hpack: 'center',
                children: row.map(_ => {
                    const id = i++;
                    return Widget.Button({
                        class_names: getClasses(Hyprland.getWorkspace(id), activeWorkspace, monitor),
                        on_clicked: () => Hyprland.sendMessage(`dispatch workspace ${id}`),
                    })
                })
            });
        }),
    }).hook(Hyprland, (self) => {
        const activeWorkspace = Hyprland.getMonitor(monitor)?.activeWorkspace.id;
        for (let i = 0; i < 10; i++) {
            const widget = self.children[Math.floor(i / 2)].children[i % 2];
            const urgent = widget.class_names.includes('urgent');
            widget.class_names = getClasses(Hyprland.getWorkspace(i + 1), activeWorkspace, monitor);
            if (urgent && activeWorkspace != i + 1) widget.class_names = [...widget.class_names, 'urgent'];
        }
    }).hook(Hyprland, (self, addr) => {
        const client = Hyprland.getClient(addr);
        if (client?.monitor === monitor) {
            const i = client.workspace.id - 1;
            const widget = self.children[Math.floor(i / 2)].children[i % 2];

            widget.class_names = [...widget.class_names, 'urgent'];
        }
    }, 'urgent-window');
}

// export default (monitor) => Widget.Label({
//     label: 'asd',
// })
