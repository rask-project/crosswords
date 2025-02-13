pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls.Material

import "."

Rectangle {
    id: root

    required property var letter

    readonly property bool isDark: Material.theme === Material.Dark
    readonly property color backgroundColor: root.isDark ? "#343238" : "#FAFAFA"
    readonly property color dividerColor: root.isDark ? "#6B686E" : "#CCCCCC"

    property bool highlighted: false
    property string response

    signal clicked
    signal letterFocused
    signal previousLetter
    signal nextLetter
    signal saveResponse(string response)

    width: 42
    height: 42

    color: privateData.isRight ?
               privateData.rightColor : root.highlighted ?
                   privateData.highlightColor : privateData.backgroundColor
    border.color: privateData.isRight ?
                      Qt.darker(privateData.rightColor, 1.1) : root.highlighted ?
                          Qt.darker(privateData.highlightColor, 1.1) : root.dividerColor
    border.width: root.enabled ? 1 : 0
    radius: Material.ExtraSmallScale
    clip: true

    onLetterFocused: input.forceActiveFocus()
    onResponseChanged: privateData.checkIsRight()

    TextInput {
        id: input

        enabled: root.enabled

        z: 0
        parent: root
        anchors.fill: parent
        padding: 0

        text: root.response
        color: Material.foreground

        font.pixelSize: parent.height * 0.45
        font.capitalization: Font.AllUppercase

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
        maximumLength: 1
        selectionColor: "transparent"
        selectedTextColor: Material.foreground
        cursorDelegate: Rectangle {
            id: cursor

            visible: input.focus
            implicitWidth: 1
            implicitHeight: input.height * 0.8
            color: Material.foreground

            SequentialAnimation on opacity {
                running: input.focus
                loops: Animation.Infinite

                NumberAnimation {
                    from: 1
                    to: 0
                    duration: 750
                }

                NumberAnimation {
                    from: 0
                    to: 1
                    duration: 750
                }
            }
        }

        onFocusChanged: {
            if (!input.focus)
                return

            input.selectAll()
        }

        onTextChanged: root.saveResponse(input.text)

        onTextEdited: {
            input.selectAll()
            if (input.text.length > 0) {
                root.nextLetter()
                return
            }
        }

        Keys.onPressed: function (event) {
            if (event.key === Qt.Key_Backspace) {
                if (input.text.length === 0) {
                    root.previousLetter()
                    event.accepted = true
                    return
                }
            }

            if (event.key === Qt.Key_Delete) {
                if (input.text.length === 0) {
                    root.nextLetter()
                    event.accepted = true
                    return
                }
            }

            if (event.key === Qt.Key_Tab) {
                root.nextLetter()
                event.accepted = true
                return
            }

            if (event.key === Qt.Key_Backtab) {
                root.previousLetter()
                event.accepted = true
                return
            }
        }
    }

    MouseArea {
        z: 2
        enabled: root.enabled
        propagateComposedEvents: false
        anchors.fill: parent

        onClicked: {
            root.clicked()
            input.forceActiveFocus(Qt.MouseFocusReason)
        }
    }

    function validateLetter(): void {
        if (!root.enabled)
            return

        if (privateData.validate()) {
            privateData.isRight = true
        }
    }

    QtObject {
        id: privateData

        readonly property color backgroundColor: root.enabled ? root.backgroundColor : "transparent"
        readonly property color highlightColor: root.isDark ?
                                                    Qt.darker(Material.accentColor, 2.0) :
                                                    Qt.lighter(Material.accentColor, 1.5)
        readonly property color rightColor: root.isDark ?
                                                Qt.darker(Material.primaryColor, 2.0) :
                                                Qt.lighter(Material.primaryColor, 1.1)

        property bool isRight: false

        function validate(): bool {
            return root.response.toUpperCase() === root.letter.value.toUpperCase()
        }

        function checkIsRight(): void {
            if (privateData.isRight) {
                privateData.isRight = privateData.validate()
                privateData.validate()
            }
        }
    }
}
