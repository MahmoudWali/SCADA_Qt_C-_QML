import QtQuick
import QtQuick.Timeline

Rectangle {
    width: 400
    height: 400
    color: "#000000"
    radius: 20

    // Custom value property (e.g., 0 to 160)
    property real customValue: 0

    Rectangle {
        id: rectangle1
        x: 56
        y: 60
        width: 314
        height: 313
        antialiasing: true
        color: "transparent"
        radius: 150
        border.color: "#ffffff"
        border.width: 3
    }

    Text {
        id: text1
        x: 175
        y: 207
        width: 78
        height: 44
        color: "red"
        text: Math.round(customValue) // Bind to customValue
        font.pixelSize: 24
        horizontalAlignment: Text.AlignHCenter
        font.family: "Verdana"
    }

    Item {
        x: 51
        y: 65

        // Tick marks (same positions, adjusted rotations for 0-200 range)
        Rectangle { id: tick01; x: 5; y: 156; width: 10; height: 1; color: "#ffffff" }
        Rectangle { id: tick1; x: 24; y: 222; width: 10; height: 1; color: "#ffffff"; rotation: -26.704 }
        Rectangle { id: tick2; x: 20; y: 86; width: 10; height: 1; color: "#ffffff"; rotation: -331.74 }
        Rectangle { id: tick3; x: 68; y: 29; width: 10; height: 1; color: "#ffffff"; rotation: -304.254 }
        Rectangle { id: tick4; x: 158; y: 0; width: 10; height: 1; color: "#ffffff"; rotation: 90 }
        Rectangle { id: tick5; x: 246; y: 28; width: 10; height: 1; color: "#ffffff"; rotation: -230.142 }
        Rectangle { id: tick6; x: 294; y: 87; width: 10; height: 1; color: "#ffffff"; rotation: -27.702 }
        Rectangle { id: tick7; x: 309; y: 151; width: 10; height: 1; color: "#ffffff" }
        Rectangle { id: tick8; x: 294; y: 215; width: 10; height: 1; color: "#ffffff"; rotation: -330.232 }

        Text { id: text2; x: 40; y: 196; color: "#ffffff"; text: "0"; font.pixelSize: 16 }
        Text { id: text3; x: 21; y: 141; color: "#ffffff"; text: "25"; font.pixelSize: 16 }
        Text { id: text4; x: 36; y: 76; color: "#ffffff"; text: "50"; font.pixelSize: 16 }
        Text { id: text5; x: 75; y: 35; color: "#ffffff"; text: "75"; font.pixelSize: 16 }
        Text { id: text6; x: 151; y: 8; color: "#ffffff"; text: "100"; font.pixelSize: 16 }
        Text { id: text7; x: 204; y: 28; color: "#ffffff"; text: "125"; font.pixelSize: 16 }
        Text { id: text8; x: 252; y: 81; color: "#ffffff"; text: "150"; font.pixelSize: 16 }
        Text { id: text9; x: 266; y: 137; color: "#ffffff"; text: "175"; font.pixelSize: 16 }
        Text { id: text10; x: 248; y: 191; color: "#ffffff"; text: "200"; font.pixelSize: 16 }
    }

    Item {
        id: rot
        x: 111
        y: 117
        width: 200
        height: 200
        rotation: -120.0 + (customValue / 200.0) * 239.0 // Map 0-160 to -120 to 119 degrees

        Rectangle {
            id: arrow
            x: 98
            y: -55
            width: 4
            height: 100
            antialiasing: true
            gradient: Gradient {
                GradientStop { position: 0; color: "red" }
                GradientStop { position: 0.99784; color: "#ffffff" }
            }
        }
    }
}
