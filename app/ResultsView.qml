import QtQuick
import saya

import QtQuick.Layouts

Item {
    id: view

    property int selectedIndex: 0
    readonly property var selectedFile: MockData.files[selectedIndex]

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // Left: the field, with its legend beneath it.
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumWidth: 360
            Layout.margins: Theme.lg

            ByteField {
                anchors { top: parent.top; left: parent.left
                          right: parent.right; bottom: legend.top
                          bottomMargin: Theme.lg }
                files: MockData.files
                imageBytes: MockData.imageBytes
                selectedOffset: view.selectedFile ? view.selectedFile.offset : -1
            }

            TypeLegend {
                id: legend
                anchors.bottom: parent.bottom
                anchors.left: parent.left
            }
        }

        // Divider
        Rectangle {
            Layout.preferredWidth: Theme.hair
            Layout.fillHeight: true
            color: Theme.hairline
        }

        // Right: what was found, and a closer look at one of them.
        ColumnLayout {
            Layout.fillWidth: true
            Layout.preferredWidth: detail.implicitWidth + 2 * Theme.md
            Layout.maximumWidth: detail.implicitWidth + 2 * Theme.md
            Layout.minimumWidth: 320        // never crushed below this
            Layout.fillHeight: true
            spacing: 0
            clip: true

            ResultTable {
                Layout.fillWidth: true
                Layout.preferredHeight: 264
                Layout.minimumHeight: 120
                Layout.topMargin: Theme.md
                selectedIndex: view.selectedIndex
                onSelectedIndexChanged: view.selectedIndex = selectedIndex
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: Theme.hair
                color: Theme.hairline
            }

            DetailPane {
                id: detail
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.margins: Theme.md
                file: view.selectedFile
            }
        }
    }
}
