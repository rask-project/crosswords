import QtQuick.Controls

Button {
    id: control

    required property string verse
    property bool showVerseTip: false

    height: 44

    text: (!control.showVerseTip) ? qsTr("Mostrar versículo") : control.verse
    flat: true
    highlighted: control.showVerseTip

    onClicked: {
        if (!control.showVerseTip) {
            control.showVerseTip = true
            return
        }

        Qt.openUrlExternally("https://wol.jw.org/pt/wol/l/r5/lp-t?q=" + control.verse)
    }
}
