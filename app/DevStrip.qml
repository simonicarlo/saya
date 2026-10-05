// Temporary scaffolding: lets us walk through the three states and compare
// both themes without an engine behind the interface. Delete once
// CarveController drives the state for real.
pragma ComponentBehavior: Bound

import QtQuick
import saya

Item {
    id: strip

    property int appState: 0
    signal stateRequested(int index)

    implicitHeight: 34

    Row {
        x: Theme.xl
        anchors.verticalCenter: parent.verticalCenter
        spacing: Theme.md

        Text {
            text: "design preview"
            color: Theme.fade(Theme.inkMuted, 0.7)
            font.pixelSize: Theme.smallSize
            anchors.verticalCenter: parent.verticalCenter
        }

        Repeater {
            model: ["Empty", "Scanning", "Results"]

            Text {
                id: stateLink
                required property string modelData
                required property int index

                text: stateLink.modelData
                color: stateLink.index === strip.appState ? Theme.sunset
                                                          : Theme.inkMuted
                font.pixelSize: Theme.smallSize
                anchors.verticalCenter: parent.verticalCenter

                MouseArea {
                    anchors.fill: stateLink
                    anchors.margins: -Theme.xs
                    cursorShape: Qt.PointingHandCursor
                    onClicked: strip.stateRequested(stateLink.index)
                }
            }
        }
    }

    Row {
        anchors.right: parent.right
        anchors.rightMargin: Theme.xl
        anchors.verticalCenter: parent.verticalCenter
        spacing: Theme.md

        Repeater {
            model: ["System", "Light", "Dark"]

            Text {
                id: themeLink
                required property string modelData
                required property int index

                text: themeLink.modelData
                color: themeLink.index === Theme.appearance ? Theme.sunset
                                                            : Theme.inkMuted
                font.pixelSize: Theme.smallSize
                anchors.verticalCenter: parent.verticalCenter

                MouseArea {
                    anchors.fill: themeLink
                    anchors.margins: -Theme.xs
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Theme.appearance = themeLink.index
                }
            }
        }
    }
}
