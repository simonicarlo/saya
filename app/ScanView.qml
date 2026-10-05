import QtQuick
import saya

Item {
    id: view

    signal stopRequested

    property real progress: 0
    readonly property int foundSoFar: Math.floor(progress * MockData.files.length)

    // A single looping animation, standing in for a real scan so the view can
    // be looked at. The engine will drive this property for real.
    NumberAnimation on progress {
        running: view.visible
        from: 0; to: 1
        duration: 11000
        loops: Animation.Infinite
    }

    Item {
        id: status
        anchors {
            top: parent.top; topMargin: Theme.lg
            left: parent.left; leftMargin: Theme.xl
            right: parent.right; rightMargin: Theme.xl
        }
        height: 52

        Row {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            spacing: Theme.md

            Text {
                text: Math.round(view.progress * 100) + "%"
                color: Theme.ink
                font.pixelSize: Theme.displaySize
                font.weight: Font.Light
                anchors.baseline: found.baseline
            }

            Text {
                id: found
                text: view.foundSoFar === 1 ? "1 file found"
                                            : view.foundSoFar + " files found"
                color: Theme.inkMuted
                font.pixelSize: Theme.bodySize
            }
        }

        QuietButton {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            text: "Stop scan"
            onClicked: view.stopRequested()
        }
    }

    ByteField {
        anchors { top: status.bottom; topMargin: Theme.md
                  left: parent.left; leftMargin: Theme.xl
                  right: parent.right; rightMargin: Theme.xl
                  bottom: parent.bottom; bottomMargin: Theme.xl }
        files: MockData.files
        imageBytes: MockData.imageBytes
        progress: view.progress
    }
}
