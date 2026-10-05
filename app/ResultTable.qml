// ComponentBehavior: Bound makes the compiler reject anything resolved by
// walking up the scope chain at runtime. Delegates must then name what they
// use -- hence the id on the row and the required properties. Slower to write,
// but the compiler can check it, and it cannot silently bind to the wrong thing.
pragma ComponentBehavior: Bound

import QtQuick
import saya

Item {
    id: table

    property int selectedIndex: 0

    // Column headers: structural, and they carry information the values alone
    // do not -- which number is an address and which is a length.
    Row {
        id: header
        x: Theme.md
        height: 26
        spacing: Theme.md

        Text {
            width: 84
            text: "Offset"
            color: Theme.inkMuted
            font.pixelSize: Theme.smallSize
            anchors.verticalCenter: parent.verticalCenter
        }
        Text {
            width: 48
            text: "Type"
            color: Theme.inkMuted
            font.pixelSize: Theme.smallSize
            anchors.verticalCenter: parent.verticalCenter
        }
        Text {
            text: "Size"
            color: Theme.inkMuted
            font.pixelSize: Theme.smallSize
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    Rectangle {
        id: headerRule
        anchors { top: header.bottom; left: parent.left; right: parent.right }
        height: Theme.hair
        color: Theme.hairline
    }

    ListView {
        anchors { top: headerRule.bottom; left: parent.left
                  right: parent.right; bottom: parent.bottom }
        clip: true
        model: MockData.files
        currentIndex: table.selectedIndex

        delegate: Rectangle {
            id: row

            required property var modelData
            required property int index

            width: ListView.view.width
            height: 30
            color: row.index === table.selectedIndex ? Theme.surface
                 : rowMouse.containsMouse ? Theme.fade(Theme.sakura, 0.14)
                 : "transparent"

            // Sunset marks the one you are looking at.
            Rectangle {
                width: 2
                height: row.height
                color: Theme.sunset
                visible: row.index === table.selectedIndex
            }

            Row {
                x: Theme.md
                anchors.verticalCenter: row.verticalCenter
                spacing: Theme.md

                Text {
                    width: 84
                    text: Fmt.hex(row.modelData.offset)
                    color: Theme.ink
                    font.family: Theme.monoFamily
                    font.pixelSize: Theme.monoSize
                }

                Row {
                    width: 48
                    spacing: Theme.xs
                    Rectangle {
                        width: 6; height: 6
                        anchors.verticalCenter: parent.verticalCenter
                        color: Theme.colorFor(row.modelData.type)
                    }
                    Text {
                        text: row.modelData.type
                        color: Theme.ink
                        font.pixelSize: Theme.bodySize
                    }
                }

                Text {
                    text: Fmt.bytes(row.modelData.bytes)
                    color: Theme.ink
                    font.pixelSize: Theme.bodySize
                }

                Text {
                    text: "no footer"
                    color: Theme.inkMuted
                    font.pixelSize: Theme.smallSize
                    visible: row.modelData.truncated
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            MouseArea {
                id: rowMouse
                anchors.fill: row
                hoverEnabled: true
                onClicked: table.selectedIndex = row.index
            }
        }
    }
}
