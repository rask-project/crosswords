import QtQuick
import QtQuick.Controls

import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl

Rectangle {
    id: root

    required property string title

    height: label.implicitHeight

    color: Material.color(Material.Yellow, Material.Shade50)
    radius: Material.MediumScale

    layer.enabled: true
    layer.effect: RoundedElevationEffect {
        elevation: 1
        roundedScale: Material.roundedScale
    }

    Text {
        id: label

        width: parent.width

        text: root.title

        font.pixelSize: 16
        padding: 16

        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
    }
}
