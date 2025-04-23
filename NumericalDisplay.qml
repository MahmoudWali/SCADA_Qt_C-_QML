import QtQuick
import QtQuick.Layouts

Rectangle {
    id: rectId
    width: 200
    height: 75
    color: "aquamarine"
    border.color: "light gray"
    antialiasing: true
    radius: 5

    property string title : "*"
    property real value : 000.00
    property color titleColor: "black"
    property color valueColor: "black"

    ColumnLayout {
        anchors.fill: parent
        spacing: 5

        Text {
            id: titleId
            text: title
            font.pixelSize: 16
            font.family: "Helvetica"
            color: titleColor
            padding: 3
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            id: valueId
            text: {
                var formattedNumber = ("000000" + Math.abs(value).toFixed(0).toString()).slice(-6);
                return formattedNumber;
            }
            color: valueColor
            font.pixelSize: 20
            font.family: "Consolas"
            padding: 3
            Layout.alignment: Qt.AlignHCenter
            clip: true
        }
    }
}
