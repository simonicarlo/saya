// Monospace earns its place here and nowhere else: the columns only read as
// columns because every glyph is the same width.
pragma ComponentBehavior: Bound

import QtQuick
import saya

Column {
    id: dump

    property string type: "JPEG"
    property real baseOffset: 0
    property int rowCount: 8
    property int bytesPerRow: 8

    spacing: 2

    function hexRow(row) {
        var s = ""
        for (var i = 0; i < dump.bytesPerRow; ++i) {
            s += Fmt.hex2(MockData.byteAt(dump.type, row * dump.bytesPerRow + i))
            s += (i === dump.bytesPerRow - 1) ? ""          // last byte: no separator
               : (i % 8 === 7)                ? "  "        // group boundary
                                              : " "
        }
        return s
    }

    function asciiRow(row) {
        var s = ""
        for (var i = 0; i < dump.bytesPerRow; ++i) {
            var b = MockData.byteAt(dump.type, row * dump.bytesPerRow + i)
            s += (b >= 32 && b < 127) ? String.fromCharCode(b) : "."
        }
        return s
    }

    Repeater {
        model: dump.rowCount

        Row {
            id: line
            required property int index

            spacing: Theme.md

            Text {
                text: Fmt.hex(dump.baseOffset + line.index * dump.bytesPerRow)
                color: Theme.inkMuted
                font.family: Theme.monoFamily
                font.pixelSize: Theme.monoSize
            }

            Text {
                text: dump.hexRow(line.index)
                color: Theme.ink
                font.family: Theme.monoFamily
                font.pixelSize: Theme.monoSize
            }

            Text {
                text: dump.asciiRow(line.index)
                color: Theme.inkMuted
                font.family: Theme.monoFamily
                font.pixelSize: Theme.monoSize
            }
        }
    }
}
