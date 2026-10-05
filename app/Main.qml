import QtQuick
import saya

Window {
    id: window

    width: 1060
    height: 720
    minimumWidth: 820
    minimumHeight: 560
    visible: true
    title: "Saya"
    color: Theme.ground

    // 0 = empty, 1 = scanning, 2 = results. CarveController will own this.
    property int appState: 0

    // Set from main.cpp when SAYA_SHOT is used, so a capture can choose a
    // state and a theme. -1 means "not set", so ordinary runs are untouched.
    property int devState: -1
    property int devTheme: -1
    onDevStateChanged: if (devState >= 0) appState = devState
    onDevThemeChanged: if (devTheme >= 0) Theme.appearance = devTheme

    // Screen is an attached property, so it cannot be read from inside the
    // Theme singleton. One physical pixel, resolved once here.
    Component.onCompleted: Theme.hair = 1 / Screen.devicePixelRatio

    TopBar {
        id: topBar
        anchors { top: parent.top; left: parent.left; right: parent.right }
        imageName: window.appState === 0 ? "" : MockData.imageName
        imageBytes: MockData.imageBytes

        FilledButton {
            text: "Export 22 files"
            visible: window.appState === 2
            onClicked: {}
        }
    }

    Rectangle {
        id: topRule
        anchors { top: topBar.bottom; left: parent.left; right: parent.right }
        height: Theme.hair
        color: Theme.hairline
    }

    Item {
        id: content
        anchors { top: topRule.bottom; left: parent.left
                  right: parent.right; bottom: bottomRule.top }

        // Motion here says "the view changed", and nothing else.
        EmptyView {
            anchors.fill: parent
            opacity: window.appState === 0 ? 1 : 0
            visible: opacity > 0
            onChooseRequested: window.appState = 1
            Behavior on opacity { NumberAnimation { duration: 160 } }
        }

        ScanView {
            anchors.fill: parent
            opacity: window.appState === 1 ? 1 : 0
            visible: opacity > 0
            onStopRequested: window.appState = 2
            Behavior on opacity { NumberAnimation { duration: 160 } }
        }

        ResultsView {
            anchors.fill: parent
            opacity: window.appState === 2 ? 1 : 0
            visible: opacity > 0
            Behavior on opacity { NumberAnimation { duration: 160 } }
        }
    }

    Rectangle {
        id: bottomRule
        anchors { left: parent.left; right: parent.right; bottom: devStrip.top }
        height: Theme.hair
        color: Theme.hairline
    }

    DevStrip {
        id: devStrip
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
        appState: window.appState
        onStateRequested: (index) => window.appState = index
    }
}
