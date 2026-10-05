// Secondary action: a hairline outline, no fill until hovered.
import QtQuick
import saya

Rectangle {
    id: control

    property alias text: label.text
    signal clicked

    implicitWidth: label.implicitWidth + Theme.md * 2
    implicitHeight: 30
    radius: Theme.radiusControl

    color: mouse.containsMouse ? Theme.surface : "transparent"
    border.width: activeFocus ? Theme.hair * 2 : Theme.hair
    border.color: activeFocus ? Theme.sunset : Theme.hairline
    activeFocusOnTab: true

    Text {
        id: label
        anchors.centerIn: parent
        color: Theme.ink
        font.pixelSize: Theme.bodySize
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: control.clicked()
    }

    Keys.onReturnPressed: control.clicked()
    Keys.onSpacePressed: control.clicked()
}
