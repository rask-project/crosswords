import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

ToolTip {
    id: control

    required property string verse

    x: parent ? (parent.width - implicitWidth) / 2 : 0
    y: -implicitHeight - 24

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset ,
                             contentHeight + topPadding + bottomPadding)

    margins: 12
    padding: 8
    bottomPadding: showVerseTipButton.height * 1.5 + padding
    horizontalPadding: padding + 8

    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
                 | Popup.CloseOnReleaseOutsideParent

    Material.theme: Material.Dark
    popupType: Popup.Item

    enter: Transition {
        NumberAnimation {
            property: "opacity"
            from: 0.0
            to: 1.0
            easing.type: Easing.OutQuad
            duration: 500
        }
    }

    exit: Transition {
        NumberAnimation {
            property: "opacity"
            from: 1.0
            to: 0.0
            easing.type: Easing.InQuad
            duration: 500
        }
    }

    contentItem: Text {
        text: control.text
        font: control.font
        wrapMode: Text.Wrap
        color: control.Material.foreground
    }

    ShowVerseButton {
        id: showVerseTipButton

        x: parent.width - width
        y: parent.height + height / 2

        verse: control.verse
    }

    background: Rectangle {
        implicitHeight: control.Material.tooltipHeight
        color: control.Material.tooltipColor
        opacity: 0.9
        radius: Material.SmallScale

        border.width: 1
        border.color: Material.dividerColor
    }

    onClosed: showVerseTipButton.showVerseTip = false
}
