// Every colour Saya owns, and nothing about what they are for -- that is
// Theme.qml's job.
//
// Named Colors rather than Palette: QtQuick already defines a Palette type (it
// backs the `palette` property), and it would silently shadow this singleton. Keeping the two apart means this file can be read as a
// palette: one place to see, compare and adjust the actual colours.
//
// Names are traditional Japanese colour names, with the literal meaning in the
// comment. A "Lit" suffix is a lifted variant of the colour beside it, used so
// an accent keeps the same perceptual weight against a dark ground rather than
// the same hex value.
pragma Singleton
import QtQuick

QtObject {
    // ---- paper -------------------------------------------------------------
    readonly property color kinari:      "#F2EBDF"  // 生成り  raw, unbleached silk
    readonly property color shironeri:   "#FBF7EF"  // 白練    glossy white silk
    readonly property color shironezumi: "#DDD3C1"  // 白鼠    white mouse, palest grey

    // ---- ink ---------------------------------------------------------------
    // sumi is both the text on paper and the ground of the dark theme: the ink
    // becomes the field.
    readonly property color sumi:        "#1B1917"  // 墨      ink stick
    readonly property color sumiRaised:  "#232020"  //         sumi, lifted for panels
    readonly property color nezumi:      "#7A736B"  // 鼠      mouse grey
    readonly property color usuzumi:     "#A09890"  // 薄墨    thinned ink
    readonly property color tetsu:       "#332F2C"  // 鉄      iron

    // ---- accents -----------------------------------------------------------
    readonly property color shu:         "#C75B39"  // 朱      vermilion, seal ink
    readonly property color shuLit:      "#DB6B42"  //         shu, lifted for dark
    readonly property color sakura:      "#E9B8BC"  // 桜      cherry blossom
    readonly property color sakuraDeep:  "#E0A8AD"  //         sakura, deepened for dark

    // ---- file types --------------------------------------------------------
    // Muted and in the same warm family, so the byte field never turns into a
    // category chart.
    readonly property color doki:         "#B8875C"  // 土器    earthenware
    readonly property color dokiLit:      "#C08A5E"
    readonly property color matsuba:      "#7E9070"  // 松葉    pine needle
    readonly property color matsubaLit:   "#8A9A7B"
    readonly property color ainezumi:     "#83879C"  // 藍鼠    indigo grey
    readonly property color ainezumiLit:  "#8C8FA3"
    readonly property color oudo:         "#A89B76"  // 黄土    yellow ochre
    readonly property color oudoLit:      "#B5A882"
}
