import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

//@ pragma AppId stark-launcher

ShellRoot {
    id: root

    // The launcher stays resident, so opening it does not require a QML cold start.
    property bool opened: false
    property string menuMode: "apps"
    property string searchText: ""
    property var selectedApp: null
    property var selectedAction: null
    // Apps belong exclusively to Super + Alt + Space. The command and system
    // menus search only their own actions.
    property var rootMenuItems: [
        { name: "System", icon: "", color: "#B56CFF", mode: "system" }
    ]
    property var systemMenuItems: [
        { name: "Lock", icon: "", color: "#00D9FF", command: ["omarchy", "system", "lock"] },
        { name: "Sleep", icon: "", color: "#B56CFF", command: ["systemctl", "suspend"] },
        { name: "Log out", icon: "󰍃", color: "#FFD700", command: ["hyprctl", "dispatch", "exit"] },
        { name: "Restart", icon: "󰜉", color: "#FF8A3D", command: ["systemctl", "reboot"] },
        { name: "Shut down", icon: "", color: "#FF1E32", command: ["systemctl", "poweroff"] }
    ]

    function showLauncher(mode: string): void {
        if (root.opened && root.menuMode === mode) {
            root.opened = false
            return
        }

        root.menuMode = mode
        root.opened = true

        searchInput.text = ""
        root.searchText = ""
        root.selectedApp = null
        root.selectedAction = null
        Qt.callLater(function() { searchInput.forceActiveFocus() })
    }

    IpcHandler {
        target: "stark-launcher"

        function toggle(): void {
            root.showLauncher("apps")
        }

        function open(mode: string): void {
            root.showLauncher(mode)
        }
    }

    PanelWindow {
        id: panel

        visible: root.opened

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        exclusiveZone: 0
        aboveWindows: true
        focusable: true

        color: "transparent"

        Rectangle {
            anchors.fill: parent

            color: "#000000"
            opacity: 0.62

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    root.opened = false
                }
            }
        }

        Item {
            id: reactor

            width: 720
            height: 720

            anchors.centerIn: parent

            // =====================================
            // OUTER STARK RINGS
            // =====================================

            Rectangle {
                anchors.centerIn: parent

                width: 700
                height: 700

                radius: width / 2

                color: "transparent"

                border.width: 2
                border.color: "#FF1E32"

                opacity: 0.8
            }

            Rectangle {
                anchors.centerIn: parent

                width: 670
                height: 670

                radius: width / 2

                color: "transparent"

                border.width: 1
                border.color: "#FF4555"

                opacity: 0.35
            }

            // =====================================
            // ROTATING TECH RING
            // =====================================

            Item {
                id: techRing

                anchors.centerIn: parent

                width: 620
                height: 620

                RotationAnimation {
                    target: techRing
                    from: 0
                    to: 360
                    duration: 30000
                    loops: Animation.Infinite
                    running: root.opened
                }

                Repeater {
                    model: 24

                    Rectangle {
                        required property int index

                        width: 4
                        height: 20

                        radius: 2

                        color: index % 2 === 0
                               ? "#FF1E32"
                               : "#46515C"

                        anchors.centerIn: parent

                        rotation: index * 15

                        y: -295
                    }
                }
            }

            // =====================================
            // INNER ARC REACTOR
            // =====================================

            Rectangle {
                id: core

                anchors.centerIn: parent

                width: 260
                height: 260

                radius: width / 2

                color: "#05090C"

                border.width: 4
                border.color: "#FF1E32"

                Rectangle {
                    anchors.centerIn: parent

                    width: 230
                    height: 230

                    radius: width / 2

                    color: "#071016"

                    border.width: 2
                    border.color: "#00D9FF"

                    Rectangle {
                        anchors.centerIn: parent

                        width: 190
                        height: 190

                        radius: width / 2

                        color: "#061820"

                        border.width: 3
                        border.color: "#00B8FF"

                        Rectangle {
                            anchors.centerIn: parent

                            width: 145
                            height: 145

                            radius: width / 2

                            color: "#00D9FF"

                            opacity: 0.10
                        }

                        // Reactor center
                        Rectangle {
                            anchors.centerIn: parent

                            width: 85
                            height: 85

                            rotation: 45

                            color: "#00D9FF"

                            border.width: 4
                            border.color: "#BFFFFF"

                            Rectangle {
                                anchors.centerIn: parent

                                width: 45
                                height: 45

                                rotation: -45

                                radius: 22

                                color: "#E8FFFF"
                            }
                        }
                    }
                }

                // Glow
                Rectangle {
                    anchors.centerIn: parent

                    width: 280
                    height: 280

                    radius: width / 2

                    color: "#00D9FF"

                    opacity: 0.04

                    z: -1
                }
            }

            // =====================================
            // STARK LABEL
            // =====================================

            Text {
                anchors.horizontalCenter: parent.horizontalCenter

                y: reactor.height / 2 + 145

                text: "S T A R K"

                color: "#FF1E32"

                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 13
                font.bold: true
            }

            // =====================================
            // TOP SEARCH CONSOLE
            // =====================================

            Rectangle {
                id: searchConsole

                visible: true

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 28

                width: 460
                height: 54
                radius: 8

                color: "#071016"
                border.width: 1
                border.color: searchInput.activeFocus ? "#00D9FF" : "#46515C"

                Rectangle {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 14
                    width: 5
                    height: 25
                    radius: 3
                    color: "#FF1E32"
                }

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 34
                    anchors.verticalCenter: parent.verticalCenter
                    text: "⌕"
                    color: "#00D9FF"
                    font.pixelSize: 25
                }

                TextInput {
                    id: searchInput

                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 68
                    anchors.rightMargin: 22

                    color: "#E6FFFF"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 14
                    clip: true
                    focus: true
                    activeFocusOnPress: true

                    onTextChanged: root.searchText = text
                    Keys.onEscapePressed: root.opened = false
                    Keys.onReturnPressed: {
                        if (root.menuMode === "apps" && root.selectedApp) {
                            root.selectedApp.execute()
                            root.opened = false
                        } else if (root.menuMode !== "apps" && root.selectedAction) {
                            if (root.selectedAction.mode)
                                root.showLauncher(root.selectedAction.mode)
                            else {
                                Quickshell.execDetached(root.selectedAction.command)
                                root.opened = false
                            }
                        }
                    }
                }

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 68
                    anchors.verticalCenter: parent.verticalCenter
                    visible: searchInput.text.length === 0
                    text: root.menuMode === "apps"
                          ? "SEARCH APPLICATIONS"
                          : root.menuMode === "system"
                            ? "SEARCH SYSTEM ACTIONS"
                            : "SEARCH COMMANDS"
                    color: "#73808A"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 14
                }

                MouseArea {
                    anchors.fill: parent
                    z: -1
                    onClicked: searchInput.forceActiveFocus()
                }
            }

            // =====================================
            // INITIAL APP ORBIT
            // =====================================

            Repeater {
                visible: root.menuMode === "apps"

                model: ScriptModel {
                    values: {
                        if (root.menuMode !== "apps")
                            return []

                        if (root.searchText.trim() !== "")
                            return []

                        let apps = [...DesktopEntries.applications.values]
                            .filter(app => app.name)
                        apps.sort((a, b) => a.name.localeCompare(b.name))
                        return apps.slice(0, 13)
                    }
                }

                delegate: Item {
                    required property var modelData
                    required property int index

                    visible: root.menuMode === "apps"
                    width: 84
                    height: 88
                    property real angle: (-90 + index * (360 / 13)) * Math.PI / 180
                    property real orbitRadius: 274

                    x: reactor.width / 2 + Math.cos(angle) * orbitRadius - width / 2
                    y: reactor.height / 2 + Math.sin(angle) * orbitRadius - height / 2

                    Rectangle {
                        id: orbitApp
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 58
                        height: 58
                        radius: width / 2
                        color: orbitMouse.containsMouse ? "#12303B" : "#070E13"
                        border.width: orbitMouse.containsMouse ? 3 : 2
                        border.color: orbitMouse.containsMouse ? "#E8FFFF" : "#FF1E32"
                        scale: orbitMouse.containsMouse ? 1.14 : 1.0

                        Behavior on scale {
                            NumberAnimation { duration: 110 }
                        }

                        Image {
                            anchors.centerIn: parent
                            width: 32
                            height: 32
                            source: Quickshell.iconPath(modelData.icon, true)
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                        }

                        MouseArea {
                            id: orbitMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                modelData.execute()
                                root.opened = false
                            }
                        }
                    }

                    Text {
                        anchors.top: orbitApp.bottom
                        anchors.topMargin: 5
                        anchors.horizontalCenter: orbitApp.horizontalCenter
                        width: 94
                        text: modelData.name
                        color: "#E6FFFF"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 10
                        horizontalAlignment: Text.AlignHCenter
                        elide: Text.ElideRight
                    }
                }
            }

            // =====================================
            // SEARCH TARGET IN REACTOR
            // =====================================

            Rectangle {
                id: appDisplay

                visible: root.menuMode === "apps"

                anchors.centerIn: parent
                width: 274
                height: 274
                radius: width / 2
                clip: true
                color: "#041116"
                border.width: 2
                border.color: "#00D9FF"

                Image {
                    anchors.fill: parent
                    source: Qt.resolvedUrl("assets/reactor.png")
                    fillMode: Image.PreserveAspectCrop
                    opacity: 0.62
                    smooth: true
                }

                Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    color: "#02080C"
                    opacity: 0.22
                }

                Repeater {
                    model: ScriptModel {
                        values: {
                            if (root.menuMode !== "apps") {
                                root.selectedApp = null
                                return []
                            }

                            const query = root.searchText.trim().toLowerCase()
                            let apps = [...DesktopEntries.applications.values]
                                .filter(app => app.name)

                            apps.sort((a, b) => a.name.localeCompare(b.name))

                            const matches = query === "" ? apps : apps.filter(app => {
                                const searchable = [
                                    app.name || "",
                                    app.genericName || "",
                                    app.comment || "",
                                    ...(app.keywords || [])
                                ].join(" ").toLowerCase()
                                return searchable.includes(query)
                            })

                            if (query === "") {
                                root.selectedApp = null
                                return []
                            }

                            root.selectedApp = matches.length > 0 ? matches[0] : null
                            return matches.slice(0, 1)
                        }
                    }

                    delegate: Rectangle {
                        required property var modelData

                        visible: root.menuMode === "apps"
                        anchors.centerIn: parent
                        width: 142
                        height: 142
                        radius: width / 2
                        color: appMouse.containsMouse ? "#12303B" : "#06171E"
                        opacity: 0.92
                        border.width: 2
                        border.color: appMouse.containsMouse ? "#E8FFFF" : "#00D9FF"
                        scale: appMouse.containsMouse ? 1.08 : 1.0

                        Behavior on scale {
                            NumberAnimation { duration: 110 }
                        }

                        Image {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.top
                            anchors.topMargin: 20
                            width: 54
                            height: 54
                            source: Quickshell.iconPath(modelData.icon, true)
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                        }

                        Text {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 22
                            anchors.leftMargin: 12
                            anchors.rightMargin: 12
                            text: modelData.name
                            color: "#E6FFFF"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 11
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            elide: Text.ElideRight
                        }

                        MouseArea {
                            id: appMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                modelData.execute()
                                root.opened = false
                            }
                        }
                    }
                }

                Text {
                    anchors.centerIn: parent
                    visible: searchInput.text.length > 0 && !root.selectedApp
                    text: "NO TARGET FOUND"
                    color: "#FF6675"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 11
                    font.bold: true
                }
            }

            // =====================================
            // ROOT + SYSTEM REACTOR MENUS
            // =====================================

            Item {
                id: actionMenu

                anchors.fill: parent
                visible: root.menuMode !== "apps"

                property var items: root.menuMode === "system"
                                    ? root.systemMenuItems
                                    : root.rootMenuItems

                Rectangle {
                    anchors.centerIn: parent
                    width: 220
                    height: 220
                    radius: width / 2
                    color: "#06141B"
                    opacity: 0.88
                    border.width: 2
                    border.color: root.menuMode === "system" ? "#FF1E32" : "#00D9FF"

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: -12
                        text: root.menuMode === "system" ? "S Y S T E M" : "C O M M A N D"
                        color: root.menuMode === "system" ? "#FF6675" : "#8BEFFF"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 13
                        font.bold: true
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.verticalCenter
                        anchors.topMargin: 13
                        text: root.menuMode === "system" ? "CONTROL CORE" : "STARK CONSOLE"
                        color: "#A8BBC5"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 9
                    }
                }

                Repeater {
                    model: ScriptModel {
                        values: {
                            const query = root.searchText.trim().toLowerCase()
                            const matches = query === "" ? actionMenu.items : actionMenu.items.filter(action =>
                                action.name.toLowerCase().includes(query)
                            )
                            root.selectedAction = query !== "" && matches.length > 0 ? matches[0] : null
                            return matches
                        }
                    }

                    delegate: Item {
                        required property var modelData
                        required property int index

                        width: 100
                        height: 106
                        property real angle: (-90 + index * (360 / actionMenu.items.length)) * Math.PI / 180
                        property real orbitRadius: 252

                        x: parent.width / 2 + Math.cos(angle) * orbitRadius - width / 2
                        y: parent.height / 2 + Math.sin(angle) * orbitRadius - height / 2

                        Rectangle {
                            id: actionButton
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: 68
                            height: 68
                            radius: width / 2
                            color: actionMouse.containsMouse ? "#172A33" : "#071016"
                            border.width: actionMouse.containsMouse ? 3 : 2
                            border.color: modelData.color
                            scale: actionMouse.containsMouse ? 1.15 : 1.0

                            Behavior on scale {
                                NumberAnimation { duration: 110 }
                            }

                            Text {
                                anchors.centerIn: parent
                                text: modelData.icon
                                color: modelData.color
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 28
                            }

                            MouseArea {
                                id: actionMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    if (modelData.mode) {
                                        root.showLauncher(modelData.mode)
                                    } else {
                                        Quickshell.execDetached(modelData.command)
                                        root.opened = false
                                    }
                                }
                            }
                        }

                        Text {
                            anchors.top: actionButton.bottom
                            anchors.topMargin: 8
                            anchors.horizontalCenter: actionButton.horizontalCenter
                            width: 110
                            text: modelData.name
                            color: "#E6FFFF"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 11
                            horizontalAlignment: Text.AlignHCenter
                            elide: Text.ElideRight
                        }
                    }
                }

                Text {
                    anchors.centerIn: parent
                    visible: root.searchText.trim().length > 0 && !root.selectedAction
                    text: "NO MENU ACTION FOUND"
                    color: "#FF6675"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 11
                    font.bold: true
                }
            }

            Component.onCompleted: searchInput.forceActiveFocus()

            // =====================================
            // ESC
            // =====================================

            Text {
                anchors.horizontalCenter:
                    parent.horizontalCenter

                anchors.bottom:
                    parent.bottom

                anchors.bottomMargin: 8

                text: "ESC  CLOSE"

                color: "#59636D"

                font.family:
                    "JetBrainsMono Nerd Font"

                font.pixelSize: 10
            }
        }
    }
}
