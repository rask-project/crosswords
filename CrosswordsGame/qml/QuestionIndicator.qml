import QtQuick
import QtQuick.Controls.Material

Item {
    id: root

    enum Flow {
        Horizontal,
        Vertical
    }

    required property int flow
    required property var question

    readonly property bool isDark: Material.theme === Material.Dark
    property bool enabledToolTip: true

    signal clicked

    visible: enabled
    width: parent.width
    height: width

    states: [
        State {
            name: "horizontal"
            when: root.flow === QuestionIndicator.Horizontal

            PropertyChanges {
                background {
                    rotation: 45
                    x: (root.width * 0.33)
                    y: -(root.height * 0.67)

                    color: privateData.bgColorHorizontal
                }

                questionNumber {
                    anchors.right: root.right
                    anchors.rightMargin: 2
                    text: root.question.number + '→'
                }
            }
        },
        State {
            name: "vertical"
            when: root.flow === QuestionIndicator.Vertical

            PropertyChanges {
                background {
                    rotation: 45
                    x: -(root.width * 0.67)
                    y: (root.height * 0.33)

                    color: privateData.bgColorVertical
                }

                questionNumber {
                    anchors.bottom: root.bottom
                    anchors.left: root.left
                    anchors.leftMargin: 2
                    text: root.question.number + '↓'
                }
            }
        }
    ]

    Text {
        id: questionNumber

        z: 1
        font.pixelSize: parent.height * 0.26
        color: Material.foreground
    }

    Rectangle {
        id: background

        z: 0
        width: parent.width * 1.40
        height: width

        MouseArea {
            anchors.fill: parent
            onClicked: root.clicked()
        }
    }

    QuestionTip {
        id: toolTip

        verse: root.question.verse
        text: {
            const orientation = '<b>' + (root.flow === QuestionIndicator.Horizontal ? '→' : '↓')
            let t = orientation + ' ' + root.question.number + "</b> - " + root.question.question
            return t
        }
    }

    onClicked: if (root.enabledToolTip)
                   toolTip.open()

    onEnabledToolTipChanged: toolTip.close()

    QtObject {
        id: privateData

        readonly property color bgColorHorizontal: {
            let color = root.isDark ? Qt.lighter(Material.background, 0.8) :
                                 Qt.darker(Material.background, 1.15)
            color.a = root.isDark ? 0.1 : 0.3
            return color
        }
        readonly property color bgColorVertical: {
            let color = root.isDark ? Qt.lighter(Material.background, 0.5) :
                                 Qt.darker(Material.background, 1.1)
            color.a = root.isDark ? 0.1 : 0.3
            return color
        }
    }
}
