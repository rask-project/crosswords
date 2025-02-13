pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Material

import CrosswordsGame

Flickable {
    id: root

    required property Crosswords crosswords
    required property int columns
    required property int rows

    contentWidth: privateData.smallDisplay ? smallLayout.implicitWidth : largeLayout.implicitWidth
    contentHeight: privateData.smallDisplay ? smallLayout.implicitHeight : largeLayout.implicitHeight

    clip: true
    flickableDirection: Flickable.AutoFlickIfNeeded

    ScrollIndicator.vertical: ScrollIndicator {}
    ScrollIndicator.horizontal: ScrollIndicator {}

    CrosswordsResponse {
        id: crosswordsResponse

        awake: root.crosswords.awake
    }

    RowLayout {
        id: smallLayout

        visible: false
        width: root.width
        height: root.height

        LayoutItemProxy {
            Layout.alignment: Qt.AlignTop
            Layout.leftMargin: 32
            Layout.topMargin: 16
            Layout.bottomMargin: 32
            Layout.rightMargin: 32

            target: grid
        }
    }

    RowLayout {
        id: largeLayout

        visible: false
        width: root.width
        height: root.height
        spacing: 16

        LayoutItemProxy {
            Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
            Layout.maximumWidth: grid.implicitWidth
            Layout.fillWidth: true
            Layout.fillHeight: true

            Layout.leftMargin: 32
            Layout.topMargin: 16
            Layout.bottomMargin: 32
            Layout.rightMargin: 0

            target: grid
        }

        LayoutItemProxy {
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            Layout.maximumWidth: 500
            Layout.maximumHeight: root.height - 32
            Layout.fillWidth: true
            Layout.fillHeight: true

            Layout.leftMargin: 0
            Layout.topMargin: 16
            Layout.bottomMargin: 32
            Layout.rightMargin: 32

            target: largeQuestionsArea
        }
    }

    GridLayout {
        id: grid

        property int currentIndex: -1

        columns: root.columns
        rows: root.rows

        Repeater {
            model: privateData.dataParsed ? root.columns * root.rows : 0

            Letter {
                id: item

                required property int index
                readonly property int row: item.index / root.columns
                readonly property int column: item.index % root.columns
                readonly property var orientations: {
                    const v = privateData.getQuestionFromIndex(item.index)
                    if (v === undefined)
                    return []
                    return Object.values(v).map((v) => v["q"])
                }

                enabled: !!privateData.mappedLetterQuestion[item.index]
                letter: privateData.mappedLetterQuestion[item.index]
                response: crosswordsResponse.responses[item.index]
                highlighted: item.orientations.includes(privateData.focusedLetter)

                onClicked: {
                    const selected = privateData.getQuestionFromIndex(item.index)
                    const orientations = Object.keys(selected)
                    privateData.focusedLetter = selected[orientations[0]]["q"]
                    grid.currentIndex = item.index
                }

                onPreviousLetter: privateData.goToPreviousLetter(item.index)
                onNextLetter: privateData.goToNextLetter(item.index)

                onSaveResponse: function (response) {
                    crosswordsResponse.save(item.index, response)
                }

                Connections {
                    target: grid

                    function onCurrentIndexChanged() {
                        if (grid.currentIndex === item.index) {
                            item.letterFocused()
                        }
                    }
                }

                Loader {
                    id: loaderH

                    readonly property string key: item.index + "h"
                    readonly property bool question: !!root.crosswords.questions[key]

                    active: question
                    sourceComponent: QuestionIndicator {
                        z: 3
                        parent: item
                        question: root.crosswords.questions[loaderH.key]
                        flow: QuestionIndicator.Horizontal
                        enabledToolTip: privateData.smallDisplay

                        onClicked: {
                            privateData.focusedLetter = privateData.getQuestionFromIndex(item.index)["h"]["q"]
                            grid.currentIndex = item.index
                            Qt.inputMethod.show()
                        }
                    }
                }

                Loader {
                    id: loaderV

                    readonly property string key: item.index + "v"
                    readonly property var question: !!root.crosswords.questions[key]

                    active: question
                    sourceComponent: QuestionIndicator {
                        z: 3
                        parent: item
                        question: root.crosswords.questions[loaderV.key]
                        flow: QuestionIndicator.Vertical
                        enabledToolTip: privateData.smallDisplay

                        onClicked: {
                            privateData.focusedLetter = privateData.getQuestionFromIndex(item.index)["v"]["q"]
                            grid.currentIndex = item.index
                        }
                    }
                }
            }
        }
    }

    Loader {
        id: largeQuestionsArea

        active: !privateData.smallDisplay
        sourceComponent: QuestionsArea {
            crosswords: root.crosswords
            questionFocused: privateData.focusedLetter

            onQuestionSelected: function (index) {
                privateData.focusedLetter = index
            }
        }
    }

    function checkResults (): void {
        for (var item of grid.children) {
            if (!(item instanceof Letter))
                continue

            item.validateLetter()
        }
    }

    function reset (): void {
        crosswordsResponse.reset()
    }

    QtObject {
        id: privateData

        property string focusedLetter: ''
        property bool dataParsed: false

        readonly property bool smallDisplay: root.width < 1000
        onSmallDisplayChanged: privateData.updatLayout()

        readonly property var mappedLetterQuestion: {
            var parsed = {}

            for (var key in root.crosswords.questions) {
                const parts = key.split(/(\d+)([hv])/)
                const index = parseInt(parts[1])
                const orientation = parts[2]
                const letterSize = root.crosswords.questions[key].answer.length

                if (orientation === "h") {
                    const indexTo = index + letterSize
                    for (var i = index; i < indexTo; ++i) {
                        const letterIndex = i - index
                        const data = { "q": key }
                        const previous = i - 1
                        if (previous >= index) {
                            data["p"] = previous
                        }

                        const next = i + 1
                        if (next < indexTo) {
                            data["n"] = next
                        }

                        if (parsed[i] === undefined) {
                            parsed[i] = {
                                "h": data,
                                "value": root.crosswords.questions[key].answer[letterIndex],
                            }
                            continue
                        }

                        if (parsed[i]["h"] === undefined) {
                            parsed[i]["h"] = data
                        }
                    }
                } else {
                    const indexTo = index + (letterSize * root.columns)
                    for (var i = index; i < indexTo; i += root.columns) {
                        const letterIndex = (i - index) / root.columns
                        const data = { "q": key }

                        const previous = i - root.columns
                        if (previous >= index) {
                            data["p"] = previous
                        }

                        const next = i + root.columns
                        if (next < indexTo) {
                            data["n"] = next
                        }

                        if (parsed[i] === undefined) {
                            parsed[i] = {
                                "v": data,
                                "value": root.crosswords.questions[key].answer[letterIndex]
                            }
                            continue
                        }

                        if (parsed[i]["v"] === undefined) {
                            parsed[i]["v"] = data
                        }
                    }
                }
            }

            return parsed
        }

        onMappedLetterQuestionChanged: privateData.dataParsed = true

        function getQuestionFromIndex(index: int): var {
            return mappedLetterQuestion[index]
        }

        function getQuestionFromIndexAndOrientation(index: int, orientation: string): var {
            return mappedLetterQuestion[index][orientation]
        }

        function getOrientationFromLetterFocus(): string {
            const parts = privateData.focusedLetter.split(/(\d+)([hv])/)
            const orientation = parts[2]
            return orientation
        }

        function goToNextLetter(index: int): void {
            const orientation = privateData.getOrientationFromLetterFocus()
            const question = privateData.getQuestionFromIndexAndOrientation(index, orientation)
            if (question === undefined || question["n"] === undefined)
                return

            const next = question["n"]
            grid.currentIndex = next
        }

        function goToPreviousLetter(index: int): void {
            const orientation = privateData.getOrientationFromLetterFocus()
            const question = privateData.getQuestionFromIndexAndOrientation(index, orientation)
            if (question === undefined || question["p"] === undefined)
                return

            const previous = question["p"]
            grid.currentIndex = previous
        }

        function updatLayout () {
            if (privateData.smallDisplay) {
                smallLayout.visible = true
                largeLayout.visible = false
                return

            }

            smallLayout.visible = false
            largeLayout.visible = true
        }
    }
}
