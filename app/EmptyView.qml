import QtQuick
import saya

Item {
    id: view

    signal chooseRequested

    // Content sits left and above centre. Emptiness off-centre rather than
    // balanced evenly around the text.
    Column {
        x: Theme.xxl
        y: view.height * 0.34
        width: Math.min(420, view.width - Theme.xxl * 2)
        spacing: Theme.md

        Text {
            text: "Drop a disk image here"
            color: Theme.ink
            font.pixelSize: Theme.displaySize
            font.weight: Font.Light
        }

        Text {
            width: parent.width
            text: "Saya reads raw images — .img, .dd and .bin — and never writes to them."
            color: Theme.inkMuted
            font.pixelSize: Theme.bodySize
            lineHeight: 1.35
            wrapMode: Text.WordWrap
        }

        Item { width: 1; height: Theme.sm }

        FilledButton {
            text: "Choose image"
            onClicked: view.chooseRequested()
        }
    }

    // Responds to a drag so the invitation is not a bluff.
    Rectangle {
        anchors.fill: parent
        anchors.margins: Theme.md
        color: "transparent"
        radius: Theme.radiusPanel
        border.width: Theme.hair * 2
        border.color: Theme.sunset
        opacity: drop.containsDrag ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 120 } }
    }

    DropArea {
        id: drop
        anchors.fill: parent
        keys: ["text/uri-list"]
    }
}
