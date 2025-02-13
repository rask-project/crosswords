pragma ComponentBehavior: Bound

import QtQuick

import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl

import CrosswordsGame

Item {
    id: root

    required property Crosswords crosswords
    property string questionFocused: ""

    signal questionSelected(string index)

    Material.elevation: 3
    Material.roundedScale:  Material.MediumScale

    Rectangle {
        id: background

        anchors.fill: parent
        color: Material.dialogColor
        radius: root.Material.roundedScale
        clip: true

        layer.enabled: root.Material.elevation > 0
        layer.effect: RoundedElevationEffect {
            elevation: root.Material.elevation
            roundedScale: root.Material.roundedScale
        }

        ListView {
            anchors.fill: parent
            anchors.topMargin: 5
            anchors.bottomMargin: 5

            model: privateData.questions
            highlightRangeMode: ListView.ApplyRange
            preferredHighlightBegin: 0

            currentIndex: privateData.questions.findIndex(q => q.questionIndex === root.questionFocused)

            clip: true
            delegate: ItemDelegate {
                id: item

                required property var modelData
                required property int index
                readonly property string orientation: modelData.orientation === "h" ? '→' : '↓'

                width: ListView.view.width
                height: column.implicitHeight + column.padding * 2
                highlighted: item.index === ListView.view.currentIndex

                contentItem: Column {
                    id: column

                    width: parent.width
                    spacing: 5
                    padding: 5

                    Label {
                        width: column.width - 32
                        text: item.orientation + ' <b>' + item.modelData.number + '</b> ' + item.modelData.question

                        wrapMode: Label.WordWrap
                    }

                    ShowVerseButton {
                        verse: item.modelData.verse
                        onClicked: item.click()
                    }
                }

                onClicked: root.questionSelected(item.modelData.questionIndex)

                Rectangle {
                    visible: item.index !== privateData.questions.length - 1
                    width: parent.width
                    height: 1
                    anchors.bottom: parent.bottom

                    color: Material.dividerColor
                }
            }
        }
    }

    QtObject {
        id: privateData

        property var questions: {
            let q = Array()

            for (let key in root.crosswords.questions) {
                const parts = key.split(/(\d+)([hv])/)
                const orientation = parts[2]

                const question = root.crosswords.questions[key]
                question["orientation"] = orientation
                question["questionIndex"] = key
                q.push(question)
            }

            q = q.sort((a, b) => a.number - b.number)
            return q
        }
    }
}
