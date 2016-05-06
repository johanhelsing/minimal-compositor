import QtQuick 2.6
import QtWayland.Compositor 1.0
import QtQuick.Window 2.2

WaylandCompositor {
    id: comp

    WaylandOutput {
        compositor: comp

        window: Window {
            width: 1280
            height: 720
            visible: true

            WaylandMouseTracker {
                id: mouseTracker
                anchors.fill: parent
                enableWSCursor: true

                Rectangle {
                    id: surfaceArea
                    color: "cyan"
                    anchors.fill: parent
                }

                WaylandCursorItem {
                    inputEventsEnabled: false
                    x: mouseTracker.mouseX - hotspotX
                    y: mouseTracker.mouseY - hotspotY
                    inputDevice: comp.defaultInputDevice
                }
            }
        }
    }

    extensions: [
        WlShell {
            onShellSurfaceCreated: {
                shellSurfaceItem.createObject(surfaceArea, { "shellSurface": shellSurface } );
            }
            Component {
                id: shellSurfaceItem
                WlShellSurfaceItem {
                    onSurfaceDestroyed: destroy();
                }
            }
        },
        XdgShell {
            onXdgSurfaceCreated: {
                xdgSurfaceItem.createObject(surfaceArea, { "xdgSurface": xdgSurface } );
            }
            Component {
                id: xdgSurfaceItem
                XdgSurfaceItem {
                    onSurfaceDestroyed: destroy();
                }
            }
        }
    ]
}
