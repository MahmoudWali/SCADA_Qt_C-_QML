import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtCharts
import QtQuick.Controls.Material
import QtQuick.Shapes
import SLMPWorkerThreadAPI 1.0

ApplicationWindow {
    width: 650
    height: 600
    visible: true
    //visibility: "Maximized"
    title: qsTr("SLMP SCADA")

    Material.theme: Material.Light
    Material.accent: Material.Orange
    Material.background: Material.BlueGrey

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

    Dialog {
        id: inputDialog
        title: (source < 4) ? "Enter D address" : " Enter Start Address of D"
        modal: true
        standardButtons: Dialog.Ok | Dialog.Cancel
        anchors.centerIn: parent
        font.pixelSize: 20


        property alias inputText: inputField.text
        property int source: 1
        property var listOfRandomAddress: []
        property var listOfBatchAddress: []

        contentItem: Column {
            spacing: 10
            padding: 20

            TextField {
                id: inputField
                placeholderText: "Type Numeric Address for D Register"
                width: parent.width
                color: "white"

                validator: IntValidator {
                    bottom: 0   // optional: minimum allowed value
                    top: 999   // optional: maximum allowed value
                }
            }
        }

        onOpened: {
            inputField.text = ""   // <-- Clear TextField when Dialog opens
            inputField.forceActiveFocus()  // (optional) focus the input automatically
        }

        onAccepted: {
            console.log("User input:", inputText)
            // You can do anything with inputText here!
            if (source == 1)
            {
                address1Id.text = "D" + inputText
            }
            else if (source == 2)
            {
                address2Id.text = "D" + inputText
            }
            else if (source == 3)
            {
                address3Id.text = "D" + inputText
            }
            else if (source == 4)
            {
                var number = parseInt(inputText)  // or parseFloat(inputText)
                address4Id.text = "D" + number
                address5Id.text = "D" + (number + 1)
                address6Id.text = "D" + (number + 2)
            }

            listOfRandomAddress = [address1Id.text, address2Id.text, address3Id.text]
            listOfBatchAddress = [address4Id.text, address5Id.text, address6Id.text]

            slmpWorkerThreadId.listOfRandomAddress(listOfRandomAddress);
            slmpWorkerThreadId.listOfBatchAddress(listOfBatchAddress);

        }
        onRejected: {
            console.log("User canceled input.")
        }
    }


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


        GroupBox {
            id: randomReadingId
            Layout.columnSpan: 2
            title: "Random Reading"
            Layout.alignment: Qt.AlignCenter
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.margins: 5
            font.bold: true
            font.pixelSize: 20
            label: Label {
                text: parent.title
                color: "navy"    // <-- Set your custom title color here
                font.bold: true
            }

            RowLayout {
                Rectangle {
                    id: circularLabel1Id
                    width: 200
                    height: 100
                    color: "peachpuff"
                    border.color: "powderblue"
                    border.width: 2
                    // Layout.fillHeight: true
                    // Layout.fillWidth: true
                    radius: 5
                    Layout.alignment: Qt.AlignCenter
                    Layout.minimumHeight: 50
                    Layout.minimumWidth: 100

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            console.log("Hely")
                            inputDialog.source = 1
                            inputDialog.open()
                        }
                    }

                    Text {
                        id: address1Id
                        Layout.alignment: Qt.AlignVCenter
                        text: "D12"
                        color: "Blue"
                        font.bold: true
                        font.pointSize: 24
                        padding: 2
                    }

                    Text {
                        id: text1Id
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "0"
                        color: "purple"
                        font.bold: true
                        font.pointSize: 24
                    }
                }


                Rectangle {
                    id: circularLabel2Id
                    width: 200
                    height: 100
                    color: "peachpuff"
                    border.color: "powderblue"
                    border.width: 2
                    // Layout.fillHeight: true
                    // Layout.fillWidth: true
                    radius: 5
                    Layout.alignment: Qt.AlignCenter
                    Layout.minimumHeight: 100
                    Layout.minimumWidth: 100

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            console.log("Hely")
                            inputDialog.source = 2
                            inputDialog.open()
                        }
                    }

                    Text {
                        id: address2Id
                        Layout.alignment: Qt.AlignVCenter
                        text: "D13"
                        color: "Blue"
                        font.bold: true
                        font.pointSize: 24
                        padding: 2
                    }

                    Text {
                        id: text2Id
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "0"
                        color: "purple"
                        font.bold: true
                        font.pointSize: 24
                    }
                }

                Rectangle {
                    id: circularLabel3Id
                    width: 200
                    height: 100
                    color: "peachpuff"
                    border.color: "powderblue"
                    border.width: 2
                    // Layout.fillHeight: true
                    // Layout.fillWidth: true
                    radius: 5
                    Layout.alignment: Qt.AlignCenter
                    Layout.minimumHeight: 100
                    Layout.minimumWidth: 100

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            console.log("Hely")
                            inputDialog.source = 3
                            inputDialog.open()
                        }
                    }

                    Text {
                        id: address3Id
                        Layout.alignment: Qt.AlignVCenter
                        text: "D14"
                        color: "Blue"
                        font.bold: true
                        font.pointSize: 24
                        padding: 2
                    }

                    Text {
                        id: text3Id
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "0"
                        color: "purple"
                        font.bold: true
                        font.pointSize: 24
                    }
                }


            }
        }


        GroupBox {
            id: batchReadingId
            Layout.columnSpan: 2
            title: "Consecutive Reading"
            Layout.margins: 5
            font.bold: true
            font.pixelSize: 20

            Layout.alignment: Qt.AlignHCenter
            Layout.fillHeight: true
            Layout.fillWidth: true
            label: Label {
                text: parent.title
                color: "navy"    // <-- Set your custom title color here
                font.bold: true
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                Layout.fillHeight: true
                Layout.fillWidth: true

                Rectangle {
                    id: circularLabel4Id
                    width: 200
                    height: 100
                    color: "orange"
                    border.color: "black"
                    border.width: 2
                    radius: 5

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            console.log("Hely")
                            inputDialog.source = 4
                            inputDialog.open()
                        }
                    }

                    Text {
                        id: address4Id
                        Layout.alignment: Qt.AlignVCenter
                        text: "D12"
                        color: "Blue"
                        font.bold: true
                        font.pointSize: 24
                        padding: 2
                    }

                    Text {
                        id: text4Id
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "0"
                        color: "white"
                        font.bold: true
                        font.pointSize: 24
                    }
                }


                Rectangle {
                    id: circularLabel5Id
                    width: 200
                    height: 100
                    color: "orange"
                    border.color: "black"
                    border.width: 2
                    // Layout.fillHeight: true
                    // Layout.fillWidth: true
                    radius: 5

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            console.log("Hely")
                            inputDialog.source = 4
                            inputDialog.open()
                        }
                    }

                    Text {
                        id: address5Id
                        Layout.alignment: Qt.AlignVCenter
                        text: "D13"
                        color: "Blue"
                        font.bold: true
                        font.pointSize: 24
                        padding: 2
                    }

                    Text {
                        id: text5Id
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "0"
                        color: "white"
                        font.bold: true
                        font.pointSize: 24
                    }
                }

                Rectangle {
                    id: circularLabel6Id
                    width: 200
                    height: 100
                    color: "orange"
                    border.color: "black"
                    border.width: 2
                    // Layout.fillHeight: true
                    // Layout.fillWidth: true
                    radius: 5

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            console.log("Hely")
                            inputDialog.source = 4
                            inputDialog.open()
                        }
                    }

                    Text {
                        id: address6Id
                        Layout.alignment: Qt.AlignVCenter
                        text: "D14"
                        color: "Blue"
                        font.bold: true
                        font.pointSize: 24
                        padding: 2
                    }

                    Text {
                        id: text6Id
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "0"
                        color: "white"
                        font.bold: true
                        font.pointSize: 24
                    }
                }

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

        // ChartView {
        //     id: chartId
        //     title: "Reading from PLC via SLMP Protocol"
        //     Layout.fillHeight: true
        //     Layout.fillWidth: true
        //     Layout.minimumHeight: 400
        //     Layout.minimumWidth: 250
        //     Layout.columnSpan: 2
        //     antialiasing: true

        //     LineSeries {
        //         id: series1Id
        //         name: "D12"
        //         axisX: xAxisId
        //         axisY: yAxisId
        //     }

        //     LineSeries {
        //         id: series2Id
        //         name: "D22"
        //         axisX: xAxisId
        //         axisY: yAxisId
        //     }

        //     ValuesAxis {
        //         id: xAxisId
        //         min: 0
        //         max: 50000
        //         tickCount: 10
        //     }

        //     ValuesAxis {
        //         id: yAxisId
        //         min: 0
        //         max: 50000
        //         tickCount: 10
        //     }

        // }


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
