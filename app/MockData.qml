// Stand-in for the engine, so the interface can be designed and looked at
// before any carving exists. Everything here is shaped exactly like what
// CarveController will expose later, so swapping it out is a rename.
pragma Singleton
import QtQuick

QtObject {
    readonly property string imageName: "sdcard.img"
    readonly property real imageBytes: 536870912   // 512 MiB

    // Offsets cluster the way they do on a real card: photographs written in
    // bursts, with long stretches of nothing in between.
    readonly property var files: [
        { offset: 0x00412000, type: "JPEG", bytes:  253952, truncated: false },
        { offset: 0x00455000, type: "JPEG", bytes:  184320, truncated: false },
        { offset: 0x004A1000, type: "JPEG", bytes:   98304, truncated: false },
        { offset: 0x004C8000, type: "PNG",  bytes:   12288, truncated: false },
        { offset: 0x00512000, type: "JPEG", bytes: 2097152, truncated: false },
        { offset: 0x00780000, type: "PDF",  bytes: 1153434, truncated: false },
        { offset: 0x01A40000, type: "JPEG", bytes:  311296, truncated: false },
        { offset: 0x01A98000, type: "JPEG", bytes:  421888, truncated: true  },
        { offset: 0x02C00000, type: "ZIP",  bytes: 4194304, truncated: false },
        { offset: 0x03880000, type: "PNG",  bytes:   45056, truncated: false },
        { offset: 0x04120000, type: "JPEG", bytes:  167936, truncated: false },
        { offset: 0x05A00000, type: "JPEG", bytes: 3145728, truncated: false },
        { offset: 0x07C40000, type: "PDF",  bytes:  262144, truncated: false },
        { offset: 0x08000000, type: "JPEG", bytes:  229376, truncated: false },
        { offset: 0x08042000, type: "JPEG", bytes:  208896, truncated: false },
        { offset: 0x08090000, type: "JPEG", bytes: 1048576, truncated: false },
        { offset: 0x0A400000, type: "PNG",  bytes:    8192, truncated: false },
        { offset: 0x0C800000, type: "ZIP",  bytes: 2621440, truncated: true  },
        { offset: 0x10200000, type: "JPEG", bytes:  524288, truncated: false },
        { offset: 0x14000000, type: "JPEG", bytes:  376832, truncated: false },
        { offset: 0x1A800000, type: "JPEG", bytes:  143360, truncated: false },
        { offset: 0x1F400000, type: "PNG",  bytes:   20480, truncated: false }
    ]

    // Ordered so the legend always lists types in the same sequence, however
    // many of each happen to be found.
    readonly property var typeOrder: ["JPEG", "PNG", "PDF", "ZIP"]

    function countOf(type) {
        var n = 0
        for (var i = 0; i < files.length; ++i)
            if (files[i].type === type) ++n
        return n
    }

    // Real magic bytes, so the hex dump shows something truthful.
    readonly property var headerBytes: ({
        "JPEG": [0xFF,0xD8,0xFF,0xE0,0x00,0x10,0x4A,0x46,0x49,0x46,0x00,0x01,0x01,0x00,0x00,0x48],
        "PNG":  [0x89,0x50,0x4E,0x47,0x0D,0x0A,0x1A,0x0A,0x00,0x00,0x00,0x0D,0x49,0x48,0x44,0x52],
        "PDF":  [0x25,0x50,0x44,0x46,0x2D,0x31,0x2E,0x34,0x0A,0x25,0xD0,0xD4,0xC5,0xD8,0x0A,0x31],
        "ZIP":  [0x50,0x4B,0x03,0x04,0x14,0x00,0x00,0x00,0x08,0x00,0x21,0x5C,0x8A,0x52,0x00,0x00]
    })

    // Deterministic filler so the dump looks like data and never flickers.
    function byteAt(type, i) {
        var head = headerBytes[type]
        if (head !== undefined && i < head.length) return head[i]
        var x = Math.sin((i + 1) * 127.1 + type.length * 31.7) * 43758.5453
        return Math.floor((x - Math.floor(x)) * 256)
    }
}
