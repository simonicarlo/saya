import QtQuick
import saya

Item {
    id: bar

    // Anything placed inside a TopBar lands in the action row on the right.
    default property alias actionItems: actions.data

    property string imageName: ""
    property real imageBytes: 0

    implicitHeight: 56

    Row {
        x: Theme.xl
        anchors.verticalCenter: parent.verticalCenter
        spacing: Theme.sm

        Text {
            text: "saya"
            color: Theme.ink
            font.pixelSize: Theme.titleSize
            font.weight: Font.Light
            font.letterSpacing: 0.5
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: "鞘"
            color: Theme.fade(Theme.inkMuted, 0.55)
            font.pixelSize: Theme.bodySize
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    Row {
        anchors.right: parent.right
        anchors.rightMargin: Theme.xl
        anchors.verticalCenter: parent.verticalCenter
        spacing: Theme.lg

        Row {
            spacing: Theme.sm
            anchors.verticalCenter: parent.verticalCenter
            visible: bar.imageName !== ""

            Text {
                text: bar.imageName
                color: Theme.ink
                font.pixelSize: Theme.bodySize
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                text: Fmt.bytes(bar.imageBytes)
                color: Theme.inkMuted
                font.pixelSize: Theme.bodySize
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Row {
            id: actions
            spacing: Theme.sm
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
