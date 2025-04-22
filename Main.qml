import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtCharts
import QtQuick.Controls.Material
import QtQuick.Shapes


ApplicationWindow {
    width: 1200
    height: 700
    visible: true
    title: qsTr("SLMP SCADA")

    Material.theme: Material.Light
    // Material.accent: Material.Orange
    // Material.background: Material.Purple

    GridLayout {
        rows: 2
        columns: 4
        anchors.fill: parent


        Rectangle {
            id: circularLabel
            width: 100
            height: 100
            color: "orange"
            border.color: "black"
            border.width: 2
            // Layout.fillHeight: true
            // Layout.fillWidth: true
            radius: width / 2
            Layout.alignment: Qt.AlignCenter
            Layout.minimumHeight: 100
            Layout.minimumWidth: 100

            Text {
                anchors.centerIn: parent
                text: SLMP.readData1
                color: "white"
                font.bold: true
                font.pointSize: 24
            }
        }


        NumericalDisplay {
            id: label2Id
            title: "Pressure"
            titleColor: "black"
            valueColor: "black"
            value: SLMP.readData2

            // layout alignment
            Layout.fillHeight: false
            Layout.fillWidth: false
        }

        RoundButton {
            id: startId
            width: 200
            height: 200
            // layout alignment
            Layout.alignment: Qt.AlignHCenter
            Layout.margins: 50


            text: "Start"
            font.bold: true
            font.pixelSize: 25
            // background: Rectangle {
            //     color: "yellow"
            //     implicitHeight: 50
            //     implicitWidth: 50
            //     radius: 360
            // }


            Layout.minimumHeight: 150
            Layout.minimumWidth: 150
            Layout.fillHeight: false
            Layout.fillWidth: false

            onClicked: {
                SLMP.startReading();
            }
        }

        RoundButton {
            id: resetBtnId
            width: 200
            height: 200
            // layout alignment
            Layout.alignment: Qt.AlignHCenter
            Layout.margins: 50


            text: "Reset"
            font.bold: true
            font.pixelSize: 25
            // background: Rectangle {
            //     color: "yellow"
            //     implicitHeight: 50
            //     implicitWidth: 50
            //     radius: 360
            // }


            Layout.minimumHeight: 150
            Layout.minimumWidth: 150
            Layout.fillHeight: false
            Layout.fillWidth: false

            onClicked: {
                SLMP.resetPLC();
            }
        }


        // Gauge {
        //     id: guageId
        //     customValue: SLMP.readData1
        //     Layout.margins: 5
        // }

        Speed {
            width: 400
            height: 400
            Layout.margins: 10
            value: Math.min(SLMP.readData1, 280)
        }

        CustomDial {
            id: dial
            Layout.alignment: Qt.AlignCenter
            width: 200
            height: 200
            value: SLMP.readData1
        }



        ChartView {
            id: chartId
            title: "Reading from PLC via SLMP Protocol"
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.minimumHeight: 250
            Layout.minimumWidth: 250
            Layout.columnSpan: 2
            antialiasing: true

            LineSeries {
                id: seriesId
                name: "D12"
                axisX: xAxisId
                axisY: yAxisId
            }

            ValuesAxis {
                id: xAxisId
                min: 0
                max: 500
                tickCount: 10
            }

            ValuesAxis {
                id: yAxisId
                min: 0
                max: 500
                tickCount: 10
            }

        }


        // GraphsView {
        //     id: chartId
        //     Layout.fillHeight: true
        //     Layout.fillWidth: true
        //     Layout.minimumHeight: 250
        //     Layout.minimumWidth: 250
        //     antialiasing: true

        //     LineSeries {
        //         id: seriesId
        //         name: "D12"
        //     }

        //     ValuesAxis {
        //         min: 0
        //         max: 1000
        //         tickCount: 10
        //     }

        //     ValuesAxis {
        //         min: 0
        //         max: 1000
        //         tickCount: 10
        //     }
        // }

        Component.onCompleted: {
            SLMP.setSeries(seriesId);
        }

    }

}
