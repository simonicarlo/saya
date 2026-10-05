// The primary action. Sunset is "here, now", so at most one of these is
// prominent on screen at a time.
import QtQuick
import saya

Rectangle {
    id: control

    property alias text: label.text
    signal clicked

    implicitWidth: label.implicitWidth + Theme.lg * 2
    implicitHeight: 34
    radius: Theme.radiusControl

    color: mouse.pressed ? Qt.darker(Theme.sunset, 1.15)
         : mouse.containsMouse ? Qt.lighter(Theme.sunset, 1.08)
         : Theme.sunset

    activeFocusOnTab: true
    border.width: activeFocus ? Theme.hair * 2 : 0
    border.color: Theme.ink

    Text {
        id: label
        anchors.centerIn: parent
        color: "#FFF9F5"
        font.pixelSize: Theme.bodySize
        font.weight: Font.Medium
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
