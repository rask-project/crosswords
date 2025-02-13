import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

ToolBar {
    id: control

    required property string title

    property Item icon: null
    property Item leftAction: null
    property list<Item> actions: []

    height: 72
    padding: 0
    clip: true

    background: Rectangle {
        color: Material.backgroundColor
    }

    contentItem: RowLayout {
        anchors.topMargin: 8
        anchors.bottomMargin: 8
        spacing: 4

        Item {
            visible: !!control.icon
            Layout.leftMargin: 16
            Layout.rightMargin: 8
            Layout.preferredWidth: !!control.icon ? control.icon.width : 0
            Layout.preferredHeight: !!control.icon ? control.icon.height : 0

            children: [ control.icon ]
        }

        Item {
            visible: !!control.leftAction && !control.icon
            Layout.preferredWidth: !!control.leftAction ? control.leftAction.width : 0
            Layout.preferredHeight: !!control.leftAction ? control.leftAction.height : 0

            children: [ control.leftAction ]
        }

        Label {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Layout.leftMargin: !!control.leftAction || !!control.icon ? 0 : 10

            text: control.title
            elide: Label.ElideRight
            wrapMode: Label.WordWrap
            verticalAlignment: Label.AlignVCenter

            font.pixelSize: 22
            font.weight: Font.Medium
        }

        Row {
            children: control.actions
        }
    }

    Material.elevation: 0
    Material.foreground: Material.windowText
}
