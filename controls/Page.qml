import QtQuick
import QtQuick.Controls

Page {
    id: page

    property int contentPadding: 0

    clip: true
    background: Item {}

    onVisibleChanged: page.forceActiveFocus()
}
