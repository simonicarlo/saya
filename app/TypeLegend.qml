// Doubles as a legend for the byte field and as the count of what was found.
// It exists because the field uses colour to mean something; without it the
// colour would be decoration.
pragma ComponentBehavior: Bound

import QtQuick
import saya

Column {
    spacing: Theme.sm

    Repeater {
        model: MockData.typeOrder

        Row {
            id: entry
            required property string modelData

            readonly property int count: MockData.countOf(entry.modelData)

            visible: entry.count > 0
            spacing: Theme.sm

            Rectangle {
                width: 8; height: 8
                anchors.verticalCenter: parent.verticalCenter
                color: Theme.colorFor(entry.modelData)
            }

            Text {
                width: 42
                text: entry.modelData
                color: Theme.ink
                font.pixelSize: Theme.bodySize
            }

            Text {
                text: entry.count
                color: Theme.inkMuted
                font.pixelSize: Theme.bodySize
            }
        }
    }
}
