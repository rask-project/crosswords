pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl
import QtQuick.Layouts

ItemDelegate {
    id: control

    required property string title
    required property string subTitle

    Material.roundedScale: Material.LargeScale
    Material.elevation: 2

    highlighted: false

    contentItem: ColumnLayout {
        Label {
            Layout.fillWidth: true
            Layout.fillHeight: true

            text: control.title

            font.bold: true
            font.pixelSize: 18

            elide: Label.ElideRight
            wrapMode: Label.WordWrap
            verticalAlignment: Text.AlignBottom
            horizontalAlignment: Text.AlignHCenter
        }

        Label {
            Layout.fillWidth: true
            Layout.fillHeight: true

            text: control.subTitle

            elide: Label.ElideRight
            wrapMode: Label.WordWrap
            verticalAlignment: Text.AlignTop
            horizontalAlignment: Text.AlignHCenter
        }
    }

    background: Rectangle {
        id: backgroundRect

        color: control.highlighted || control.down ? control.Material.highlightedRippleColor : control.Material.dialogColor
        radius: control.Material.roundedScale === Material.FullScale ? height / 2 : control.Material.roundedScale
        border.color: control.Material.dividerColor

        Ripple {
            width: parent.width
            height: parent.height

            clip: true
            clipRadius: parent.radius

            pressed: control.pressed
            anchor: control
            active: enabled && (control.down || control.visualFocus || control.hovered)
            color: control.highlighted ? control.Material.highlightedRippleColor : control.Material.rippleColor
        }
    }
}
