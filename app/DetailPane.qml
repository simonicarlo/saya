import QtQuick
import saya

Item {
    id: pane

    property var file: null

    visible: file !== null

    implicitWidth: dump.implicitWidth
    implicitHeight: col.implicitHeight

    Column {
        id: col
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        spacing: Theme.sm

        Text {
            text: pane.file ? pane.file.type : ""
            color: Theme.ink
            font.pixelSize: Theme.titleSize
            font.weight: Font.Medium
        }

        Text {
            text: pane.file
                  ? Fmt.bytes(pane.file.bytes) + " at " + Fmt.hex(pane.file.offset)
                  : ""
            color: Theme.inkMuted
            font.pixelSize: Theme.bodySize
        }

        // Honest about what the engine does not know.
        Text {
            text: "Ends without a footer, so the size is a cap rather than a measurement."
            color: Theme.sunset
            font.pixelSize: Theme.smallSize
            wrapMode: Text.WordWrap
            width: pane.width
            visible: pane.file && pane.file.truncated
        }

        Item { width: 1; height: Theme.sm }

        Text {
            text: "First " + (dump.rowCount * dump.bytesPerRow) + " bytes"
            color: Theme.inkMuted
            font.pixelSize: Theme.smallSize
        }

        Flickable {
            width: pane.width
            height: dump.implicitHeight
            clip: true

            contentWidth: dump.implicitWidth
            contentHeight: dump.implicitHeight
            flickableDirection: Flickable.HorizontalFlick
            boundsBehavior: Flickable.StopAtBounds

            HexDump {
                id: dump
                type: pane.file ? pane.file.type : "JPEG"
                baseOffset: pane.file ? pane.file.offset : 0
            }
        }
    }
}
