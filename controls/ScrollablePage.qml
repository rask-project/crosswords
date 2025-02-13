import QtQuick
import QtQuick.Controls

import "." as Controls

Controls.Page {
    id: page

    property alias content: pane.contentItem

    property int contentPadding: 16
    property int contentLeftPadding: page.contentPadding
    property int contentRightPadding: page.contentPadding
    property int contentTopPadding: page.contentPadding
    property int contentBottomPadding: page.contentPadding
    property bool horizontalFlickable: false
    property bool verticalFlickable: true

    Flickable {
        id: flickable

        anchors.fill: parent

        contentWidth: page.horizontalFlickable ? pane.implicitWidth : page.width
        contentHeight: page.verticalFlickable ? pane.implicitHeight : page.height
        flickableDirection: Flickable.AutoFlickIfNeeded

        Pane {
            id: pane

            width: parent.width
            leftPadding: page.contentLeftPadding
            rightPadding: page.contentRightPadding
            topPadding: page.contentTopPadding
            bottomPadding: page.contentBottomPadding

            background: Item {}
        }

        ScrollIndicator.horizontal: ScrollIndicator { }
        ScrollIndicator.vertical: ScrollIndicator { }
    }
}
