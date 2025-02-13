import QtQuick
import QtQuick.Controls

import "../controls" as Controls
import CrosswordsGame

Controls.Page {
    id: page

    required property StackView stackView
    required property var crosswords

    header: Controls.HeaderBar {
        title: page.title

        leftAction: Controls.ButtonAction {
            icon.name: "arrow-back"
            onClicked: page.stackView.pop()
        }

        actions: [
            Controls.ButtonAction {
                icon.name: "refresh"
                onClicked: resetPopup.open()
            },

            Controls.ButtonAction {
                icon.name: "check"
                onClicked: crosswordsGame.checkResults()
            }
        ]
    }

    Dialog {
        id: resetPopup

        anchors.centerIn: parent

        title: qsTr("Apagar respostas")
        standardButtons: Dialog.Yes | Dialog.No

        Label {
            anchors.fill: parent
            text: qsTr("Deseja mesmo apagar todas as respostas?")
        }

        onAccepted: crosswordsGame.reset()
    }

    CrosswordsGame {
        id: crosswordsGame

        columns: 15
        rows: 15

        width: parent.width
        height: parent.height
        /*[
            ['J', 'E', 'O', 'A', 'C', 'A', 'Z', ' ', 'H', 'A', 'R', 'B', 'O', 'N', 'A'],
            ['O', ' ', ' ', ' ', ' ', ' ', 'U', ' ', 'O', ' ', ' ', ' ', ' ', ' ', 'S'],
            ['A', ' ', 'A', 'I', 'S', 'A', 'R', ' ', 'R', 'E', 'G', 'A', 'R', ' ', 'S'],
            ['Q', ' ', 'R', ' ', 'I', ' ', ' ', ' ', ' ', ' ', 'E', ' ', 'A', ' ', 'I'],
            ['U', ' ', 'I', 'R', 'M', 'A', 'S', ' ', 'M', 'I', 'R', 'I', 'A', ' ', 'R'],
            ['I', ' ', 'E', ' ', 'E', ' ', 'I', ' ', 'A', ' ', 'A', ' ', 'B', ' ', 'I'],
            ['M', 'E', 'L', ' ', 'I', 'S', 'S', 'A', 'C', 'A', 'R', ' ', 'E', 'T', 'A'],
            [' ', ' ', ' ', ' ', ' ', ' ', 'A', ' ', 'P', ' ', ' ', ' ', ' ', ' ', ' '],
            ['A', 'N', 'A', ' ', 'M', 'A', 'Q', 'U', 'E', 'D', 'A', ' ', 'A', 'C', 'A'],
            ['N', ' ', 'L', ' ', 'O', ' ', 'U', ' ', 'L', ' ', 'C', ' ', 'B', ' ', 'Z'],
            ['A', ' ', 'M', 'O', 'R', 'T', 'E', ' ', 'A', 'M', 'A', 'S', 'A', ' ', 'A'],
            ['T', ' ', 'O', ' ', 'I', ' ', ' ', ' ', ' ', ' ', 'I', ' ', 'N', ' ', 'R'],
            ['O', ' ', 'M', 'O', 'A', 'B', 'E', ' ', 'A', 'G', 'A', 'T', 'A', ' ', 'I'],
            ['T', ' ', ' ', ' ', ' ', ' ', 'L', ' ', 'I', ' ', ' ', ' ', ' ', ' ', 'A'],
            ['E', 'L', 'I', 'S', 'E', 'B', 'A', ' ', 'O', 'B', 'A', 'D', 'I', 'A', 'S']
        ]*/

        /*[
            ['E', 'L', 'I', 'S', 'E', 'U', ' ', 'P', ' ', 'D', 'A', 'L', 'I', 'L', 'A'],
            ['R', ' ', ' ', 'A', ' ', ' ', 'C', 'A', 'S', ' ', ' ', 'E', ' ', ' ', 'Q'],
            ['A', ' ', ' ', 'B', ' ', ' ', ' ', 'D', ' ', ' ', ' ', 'V', ' ', ' ', 'U'],
            ['S', 'A', 'F', 'A', ' ', 'G', 'R', 'E', 'G', 'O', ' ', 'I', 'T', 'A', 'I'],
            ['T', ' ', ' ', ' ', ' ', ' ', ' ', 'I', ' ', ' ', ' ', ' ', ' ', ' ', 'L'],
            ['O', ' ', 'S', 'E', 'C', 'U', ' ', 'R', ' ', 'Z', 'E', 'U', 'S', ' ', 'A'],
            [' ', 'Z', ' ', 'F', ' ', ' ', ' ', 'O', ' ', ' ', ' ', ' ', ' ', 'S', ' '],
            ['F', 'I', 'N', 'E', 'I', 'A', 'S', ' ', 'J', 'O', 'E', 'I', 'R', 'A', 'R'],
            [' ', 'M', ' ', 'S', ' ', ' ', ' ', 'Q', ' ', ' ', ' ', ' ', ' ', 'L', ' '],
            ['J', ' ', 'J', 'O', 'E', 'L', ' ', 'U', ' ', 'B', 'A', 'L', 'L', ' ', 'H'],
            ['E', ' ', ' ', ' ', ' ', 'O', ' ', 'E', ' ', 'I', ' ', ' ', ' ', ' ', 'O'],
            ['R', 'O', 'L', 'O', ' ', 'B', 'E', 'T', 'E', 'L', ' ', 'Z', 'O', 'A', 'R'],
            ['I', ' ', ' ', 'N', ' ', 'O', ' ', 'U', ' ', 'A', ' ', 'I', ' ', ' ', 'E'],
            ['C', ' ', ' ', 'R', ' ', ' ', 'I', 'R', 'A', ' ', ' ', 'B', ' ', ' ', 'B'],
            ['O', 'T', 'N', 'I', 'E', 'L', ' ', 'A', ' ', 'I', 'S', 'A', 'Q', 'U', 'E'],
        ]*/

        /*[
            ['S', 'A', 'M', 'B', 'A', 'L', 'A', ' ', 'N', 'O', 'T', 'I', 'C', 'I', 'A'],
            ['A', ' ', 'A', ' ', ' ', ' ', 'L', ' ', 'E', ' ', ' ', ' ', 'A', ' ', 'S'],
            ['R', 'O', 'L', 'O', 'S', ' ', 'F', ' ', 'F', ' ', 'A', 'N', 'D', 'R', 'E'],
            ['A', ' ', 'O', ' ', 'E', ' ', 'O', ' ', 'E', ' ', 'P', ' ', 'E', ' ', 'N'],
            ['I', ' ', 'M', 'A', 'N', 'D', 'R', 'A', 'G', 'O', 'R', 'A', 'S', ' ', 'A'],
            ['V', ' ', ' ', ' ', 'A', ' ', 'G', ' ', 'U', ' ', 'O', ' ', ' ', ' ', 'T'],
            ['A', 'V', 'R', 'E', 'Q', 'U', 'E', ' ', 'E', 'N', 'X', 'O', 'F', 'R', 'E'],
            [' ', ' ', ' ', ' ', 'U', ' ', ' ', ' ', ' ', ' ', 'I', ' ', ' ', ' ', ' '],
            ['M', 'A', 'C', 'P', 'E', 'L', 'A', ' ', 'A', 'L', 'M', 'E', 'J', 'A', 'R'],
            ['A', ' ', ' ', ' ', 'R', ' ', 'B', ' ', 'L', ' ', 'A', ' ', ' ', ' ', 'O'],
            ['C', ' ', 'A', 'D', 'I', 'V', 'I', 'N', 'H', 'A', 'Ç', 'A', 'O', ' ', 'C'],
            ['A', ' ', 'C', ' ', 'B', ' ', 'A', ' ', 'E', ' ', 'A', ' ', 'M', ' ', 'H'],
            ['C', 'O', 'B', 'R', 'E', ' ', 'T', ' ', 'A', ' ', 'O', 'B', 'E', 'D', 'E'],
            ['O', ' ', 'O', ' ', ' ', ' ', 'A', ' ', 'D', ' ', ' ', ' ', 'G', ' ', 'D'],
            ['S', 'A', 'R', 'E', 'Z', 'E', 'R', ' ', 'O', 'L', 'I', 'B', 'A', 'N', 'O']
        ]*/

        crosswords: page.crosswords
    }
}
