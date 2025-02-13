pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl
import QtQuick.Layouts

import "../controls" as Controls
import CrosswordsGame

Controls.Page {
    id: page

    required property StackView stackView

    padding: 0

    CrosswordsModel {
        id: crosswordsModel
    }

    GridView {
        anchors.fill: parent

        topMargin: 16
        leftMargin: 16
        rightMargin: 16
        bottomMargin: 16

        header: Item {
            width: GridView.view.width - GridView.view.leftMargin - GridView.view.rightMargin
            height: textAlert.height + 32

            Controls.TextAlert {
                id: textAlert

                width: parent.width * 0.9
                anchors.centerIn: parent

                title: qsTr("Essas palavras cruzadas são de edições da revista <b>Despertai!</b>, publicada pelas <b>Testemunhas de Jeová</b>.") + "<br/>" +
                       qsTr("Todas as palavras cruzadas são de propriedade da © <i>Watch Tower Bible and Tract Society of Pennsylvania</i>.")
            }
        }

        model: crosswordsModel.model

        cellWidth: 180
        cellHeight: 180

        ScrollIndicator.vertical: ScrollIndicator { }

        delegate: Item {
            id: item

            required property Crosswords modelData

            width: GridView.view.cellWidth
            height: GridView.view.cellHeight

            Controls.CrosswordsItemDelegate {
                width: item.width - 16
                height: item.height - 16
                anchors.centerIn: parent

                title: item.modelData.label
                subTitle: item.modelData.awake

                onClicked: page.stackView.push(Qt.resolvedUrl("CrosswordsGamePage.qml"), {
                                                   "title": item.modelData.label + " (" + item.modelData.awake + ")",
                                                   "stackView": page.stackView,
                                                   "crosswords": item.modelData
                                               })
            }
        }
    }
}
