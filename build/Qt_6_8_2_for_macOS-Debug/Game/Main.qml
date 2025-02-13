import QtCore
import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

import "controls" as Controls
import "pages" as Pages

import Native

ApplicationWindow {
    id: appWindow

    visible: true

    width: 1024
    height: 834

    title: qsTr("Palavras Cruzadas Bíblicas")

    Settings {
        id: settings

        category: "theme"

        property int theme: Material.System
    }

    Material.theme: settings.theme
    Material.onThemeChanged: {
        Android.setStatusBarColor(Material.backgroundColor)
        Android.setNavigationBarColor(Material.backgroundColor)
    }

    StackView {
        id: stack

        anchors.fill: parent
        initialItem: Pages.CrosswordsListPage {
            stackView: stack
            header: Controls.HeaderBar {
                icon: Image {
                    source: "qrc:/resources/logo.png"
                    width: Material.buttonHeight
                    height: Material.buttonHeight

                    sourceSize.width: width * 2
                    sourceSize.height: height * 2
                    fillMode: Image.PreserveAspectFit
                }

                title: appWindow.title
                actions: [
                    Controls.ButtonAction {
                        icon.name: Material.theme === Material.Light ? "brightness-4" : "brightness-7"
                        highlighted: true
                        onClicked: settings.theme = Material.theme === Material.Light ? Material.Dark : Material.Light
                    }
                ]
            }
        }

        Keys.onBackPressed: function (event) {
            if (stack.depth > 1) {
                stack.pop()
                return
            }
            event.accepted = false
        }
    }

    Component.onCompleted: Android.hideSplashScreen(1500)
}
