import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtCharts
import QtQuick.Controls.Material
import QtQuick.Shapes
import SLMPWorkerThreadAPI 1.0

ApplicationWindow {
    width: 1200
    height: 700
    visible: true
    visibility: "Maximized"
    title: qsTr("SLMP SCADA")

    Material.theme: Material.Light
    // Material.accent: Material.Orange
    // Material.background: Material.Purple

    SLMPWorkerThread {
        id: slmpWorkerThreadId
        onNewReading: (D12, D22) => {
                          text1Id.text = D12
                          text2Id.text = D22
                      }
    }

    // Connections {
    //     target:  slmpWorkerThreadId
    //     function onNewReading(D12, D22) {
    //         circularLabelTextId.text = D12
    //         numericLabelId.value = D22
    //     }
    // }

    GridLayout {
        rows: 4
        columns: 2
        anchors.fill: parent

        RoundButton {
            id: startId
            width: 200
            height: 200
            // layout alignment
            Layout.alignment: Qt.AlignHCenter
            Layout.margins: 10

            text: "Start"
            font.bold: true
            font.pixelSize: 25

            Layout.minimumHeight: 150
            Layout.minimumWidth: 150
            Layout.fillHeight: false
            Layout.fillWidth: false

            onClicked: {
                //SLMP.setSeries(seriesId)
                slmpWorkerThreadId.init()
                slmpWorkerThreadId.setSeries(series1Id, series2Id)
                slmpWorkerThreadId.start()
            }
        }

        RoundButton {
            id: stopBtnId
            width: 200
            height: 200
            // layout alignment
            Layout.alignment: Qt.AlignHCenter
            Layout.margins: 10

            text: "Stop"
            font.bold: true
            font.pixelSize: 25

            Layout.minimumHeight: 150
            Layout.minimumWidth: 150
            Layout.fillHeight: false
            Layout.fillWidth: false

            onClicked: {
                slmpWorkerThreadId.stopReading();
            }
        }


        Rectangle {
            id: circularLabel1Id
            width: 200
            height: 100
            color: "orange"
            border.color: "black"
            border.width: 2
            // Layout.fillHeight: true
            // Layout.fillWidth: true
            radius: 5
            Layout.alignment: Qt.AlignCenter
            Layout.minimumHeight: 100
            Layout.minimumWidth: 100

            Text {
                id: text1Id
                anchors.centerIn: parent
                text: "0"
                color: "white"
                font.bold: true
                font.pointSize: 24
            }
        }


        Rectangle {
            id: circularLabel2Id
            width: 200
            height: 100
            color: "orange"
            border.color: "black"
            border.width: 2
            // Layout.fillHeight: true
            // Layout.fillWidth: true
            radius: 5
            Layout.alignment: Qt.AlignCenter
            Layout.minimumHeight: 100
            Layout.minimumWidth: 100

            Text {
                id: text2Id
                anchors.centerIn: parent
                text: "0"
                color: "white"
                font.bold: true
                font.pointSize: 24
            }
        }

        // NumericalDisplay {
        //     id: numericLabe1lId
        //     title: "Pressure"
        //     titleColor: "black"
        //     valueColor: "black"
        //     value: SLMP.readData2

        //     // layout alignment
        //     Layout.alignment: Qt.AlignCenter
        //     Layout.fillHeight: false
        //     Layout.fillWidth: false
        // }

        // NumericalDisplay {
        //     id: numericLabe2lId
        //     title: "Pressure"
        //     titleColor: "black"
        //     valueColor: "black"
        //     value: SLMP.readData2

        //     // layout alignment
        //     Layout.alignment: Qt.AlignCenter
        //     Layout.fillHeight: false
        //     Layout.fillWidth: false
        // }

        // Speed {
        //     id: meter1Id
        //     width: 300
        //     height: 300
        //     Layout.margins: 10
        //     Layout.alignment: Qt.AlignCenter
        //     //value: Math.min(SLMP.readData1, 280)
        // }

        // Speed {
        //     id: meter2Id
        //     width: 300
        //     height: 300
        //     Layout.margins: 10
        //     Layout.alignment: Qt.AlignCenter
        //     //value: Math.min(SLMP.readData1, 280)
        // }

        ChartView {
            id: chartId
            title: "Reading from PLC via SLMP Protocol"
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.minimumHeight: 400
            Layout.minimumWidth: 250
            Layout.columnSpan: 2
            antialiasing: true

            LineSeries {
                id: series1Id
                name: "D12"
                axisX: xAxisId
                axisY: yAxisId
            }

            LineSeries {
                id: series2Id
                name: "D22"
                axisX: xAxisId
                axisY: yAxisId
            }

            ValuesAxis {
                id: xAxisId
                min: 0
                max: 50000
                tickCount: 10
            }

            ValuesAxis {
                id: yAxisId
                min: 0
                max: 50000
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
            // slmpWorkerThreadId.init()
            // slmpWorkerThreadId.setSeries(series1Id, series2Id)
        }

    }

}
