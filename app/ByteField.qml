// The disk image drawn as a grid of cells, row-major, the way a hex editor
// wraps a binary. One cell is one chunk of the image.
//
// Drawn on a Canvas rather than built from a Repeater: a field this size is
// well over a thousand cells, and a thousand QML items with live bindings would
// cost far more than one paint pass. This is also close to how the real version
// will work, once DiskMapModel supplies the buckets from C++.
import QtQuick
import saya

Canvas {
    id: field

    property var files: []
    property real imageBytes: 1
    property real progress: 1          // 0..1; cells past the head are unscanned
    property real selectedOffset: -1

    readonly property int cell:  9
    readonly property int pitch: 11

    readonly property int cols: Math.max(1, Math.floor(width / pitch))
    readonly property int rows: Math.max(1, Math.floor(height / pitch))

    onProgressChanged: requestPaint()
    onSelectedOffsetChanged: requestPaint()
    onFilesChanged: requestPaint()
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()

    Connections {
        target: Theme
        function onDarkChanged() { field.requestPaint() }
    }

    // Stable per-cell texture so empty regions look like data rather than like
    // a blank grid, and never shimmer between frames.
    function noise(i) {
        var x = Math.sin((i + 1) * 12.9898) * 43758.5453
        return x - Math.floor(x)
    }

    onPaint: {
        var ctx = getContext("2d")
        ctx.reset()

        var total = cols * rows
        var bytesPerCell = imageBytes / total

        // Which file, if any, owns each cell.
        var owner = new Array(total)
        var selected = new Array(total)
        for (var f = 0; f < files.length; ++f) {
            var file = files[f]
            var from = Math.floor(file.offset / bytesPerCell)
            var to = Math.floor((file.offset + file.bytes - 1) / bytesPerCell)
            var isSel = selectedOffset === file.offset
            for (var c = from; c <= to && c < total; ++c) {
                owner[c] = file.type
                if (isSel) selected[c] = true
            }
        }

        var head = Math.floor(progress * total)

        for (var i = 0; i < total; ++i) {
            if (i > head) break                    // not scanned yet

            var x = (i % cols) * pitch
            var y = Math.floor(i / cols) * pitch

            if (selected[i]) {
                ctx.fillStyle = Theme.sunset
            } else if (owner[i] !== undefined) {
                ctx.fillStyle = Theme.fade(Theme.colorFor(owner[i]), 0.9)
            } else {
                ctx.fillStyle = Theme.fade(Theme.ink, 0.035 + noise(i) * 0.05)
            }
            ctx.fillRect(x, y, cell, cell)
        }

        // The read head, with a short trail behind it, so a scan in progress
        // reads as movement rather than as a partly drawn grid.
        if (progress < 1) {
            for (var t = 0; t < 14; ++t) {
                var hi = head - t
                if (hi < 0) break
                ctx.fillStyle = Theme.fade(Theme.sunset, 0.9 * (1 - t / 14))
                ctx.fillRect((hi % cols) * pitch, Math.floor(hi / cols) * pitch,
                             cell, cell)
            }
        }
    }
}
