// Formatting helpers. Kept apart from Theme because these are about language,
// not appearance, and apart from MockData because they will outlive the mock.
pragma Singleton
import QtQuick

QtObject {
    // 0x0041A200 — always eight digits so columns of offsets align.
    function hex(n) {
        var s = Math.round(n).toString(16).toUpperCase()
        while (s.length < 8) s = "0" + s
        return "0x" + s
    }

    // Two hex digits, for byte values.
    function hex2(b) {
        var s = b.toString(16).toUpperCase()
        return s.length < 2 ? "0" + s : s
    }

    // "248 KB" — what a person reads, not what the struct holds.
    function bytes(n) {
        if (n < 1024) return n + " B"
        if (n < 1024 * 1024) return (n / 1024).toFixed(0) + " KB"
        if (n < 1024 * 1024 * 1024) return (n / (1024 * 1024)).toFixed(1) + " MB"
        return (n / (1024 * 1024 * 1024)).toFixed(1) + " GB"
    }
}
