// Design tokens for the whole app. See DESIGN.md for the reasoning.
//
// Every component reads colours, sizes and spacing from here and never writes a
// literal. That is what makes light and dark cost almost nothing: one file
// decides, and every binding downstream updates itself.
pragma Singleton
import QtQuick

QtObject {
    id: theme

    // 0 = follow the system, 1 = force light, 2 = force dark.
    // The override exists so we can compare both themes while designing.
    property int appearance: 0

    readonly property bool dark: appearance === 0
                                 ? Application.styleHints.colorScheme === Qt.Dark
                                 : appearance === 2

    // ---- palette -----------------------------------------------------------
    // Roles, not colours. Every hex lives in Colors.qml; this block says only
    // what each colour is for, which is why it can be read in one pass.
    readonly property color ground:   dark ? Colors.sumi       : Colors.kinari
    readonly property color surface:  dark ? Colors.sumiRaised : Colors.shironeri
    readonly property color ink:      dark ? Colors.kinari     : Colors.sumi
    readonly property color inkMuted: dark ? Colors.usuzumi    : Colors.nezumi
    readonly property color hairline: dark ? Colors.tetsu      : Colors.shironezumi

    // Sunset: active, here, now.   Sakura: present but passive.
    readonly property color sunset:   dark ? Colors.shuLit     : Colors.shu
    readonly property color sakura:   dark ? Colors.sakuraDeep : Colors.sakura

    // File-type colours for the byte field.
    readonly property var typeColor: ({
        "JPEG": dark ? Colors.dokiLit     : Colors.doki,
        "PNG":  dark ? Colors.matsubaLit  : Colors.matsuba,
        "PDF":  dark ? Colors.ainezumiLit : Colors.ainezumi,
        "ZIP":  dark ? Colors.oudoLit     : Colors.oudo
    })

    function colorFor(type) {
        return typeColor[type] !== undefined ? typeColor[type] : inkMuted
    }

    // Mix towards transparency without depending on Qt.alpha's availability.
    function fade(c, a) { return Qt.rgba(c.r, c.g, c.b, a) }

    // ---- space (8pt grid, 4 half-step) -------------------------------------
    readonly property int xs:  4
    readonly property int sm:  8
    readonly property int md:  16
    readonly property int lg:  24
    readonly property int xl:  40
    readonly property int xxl: 64

    // ---- type --------------------------------------------------------------
    // No family is set for text: Qt already uses the platform system font,
    // which is exactly what we want. Only the mono face is named.
    // QML's font value type exposes only font.family, a single name -- there is
    // no font.families to hand it a fallback list. So we resolve the fallback
    // chain ourselves, once, against the families actually installed.
    readonly property string monoFamily: pickFirstAvailable(
        ["SF Mono", "Menlo", "Monaco", "Courier New"], "monospace")

    function pickFirstAvailable(wanted, fallback) {
        var installed = Qt.fontFamilies()
        for (var i = 0; i < wanted.length; ++i)
            if (installed.indexOf(wanted[i]) !== -1) return wanted[i]
        return fallback
    }

    readonly property int displaySize: 26
    readonly property int titleSize:   17
    readonly property int bodySize:    13
    readonly property int smallSize:   11
    readonly property real monoSize:   11.5

    // ---- line and shape ----------------------------------------------------
    // One physical pixel. Main.qml sets this once from Screen.devicePixelRatio;
    // Screen is an attached property and is not available inside a singleton.
    property real hair: 1

    readonly property int radiusControl: 4
    readonly property int radiusPanel:   8
}
