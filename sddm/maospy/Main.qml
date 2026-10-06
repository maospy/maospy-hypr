import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root
    width: 1366
    height: 768
    color: "#2e3440"

    property int sessionIndex: sessionModel.lastIndex
    property var esLocale: Qt.locale("es_ES")

    // Fondo
    Image {
        anchors.fill: parent
        source: config.background
        fillMode: Image.PreserveAspectCrop
    }
    Rectangle { anchors.fill: parent; color: "#2e3440"; opacity: 0.25 }

    // Reloj y fecha
    Text {
        id: clock
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height * 0.06
        color: "#eceff4"
        font.family: config.font
        font.pixelSize: 60
        font.bold: true
        text: Qt.formatTime(new Date(), "HH:mm")
    }
    Text {
        id: dateText
        anchors.top: clock.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#d8dee9"
        font.family: config.font
        font.pixelSize: 18
        text: new Date().toLocaleDateString(root.esLocale, "dddd d 'de' MMMM")
    }
    Timer {
        interval: 1000; running: true; repeat: true
        onTriggered: {
            clock.text = Qt.formatTime(new Date(), "HH:mm")
            dateText.text = new Date().toLocaleDateString(root.esLocale, "dddd d 'de' MMMM")
        }
    }

    // Cuadro de login
    Rectangle {
        id: box
        width: 340
        height: 200
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height * 0.07
        radius: 14
        color: "#d92e3440"
        border.color: "#6688c0d0"
        border.width: 1

        Column {
            anchors.centerIn: parent
            spacing: 12
            width: parent.width - 40

            TextField {
                id: userField
                width: parent.width
                height: 40
                text: userModel.lastUser
                placeholderText: "Usuario"
                placeholderTextColor: "#81a1c1"
                color: "#eceff4"
                font.family: config.font
                font.pixelSize: 14
                leftPadding: 12
                background: Rectangle {
                    radius: 8
                    color: "#3b4252"
                    border.color: userField.activeFocus ? "#88c0d0" : "#4c566a"
                }
                KeyNavigation.tab: passField
            }

            TextField {
                id: passField
                width: parent.width
                height: 40
                echoMode: TextInput.Password
                placeholderText: "Contraseña"
                placeholderTextColor: "#81a1c1"
                color: "#eceff4"
                font.family: config.font
                font.pixelSize: 14
                leftPadding: 12
                background: Rectangle {
                    radius: 8
                    color: "#3b4252"
                    border.color: passField.activeFocus ? "#88c0d0" : "#4c566a"
                }
                onAccepted: sddm.login(userField.text, passField.text, root.sessionIndex)
                KeyNavigation.tab: userField
            }

            Rectangle {
                width: parent.width
                height: 40
                radius: 8
                color: loginMouse.containsMouse ? "#8fbcbb" : "#88c0d0"
                Text {
                    anchors.centerIn: parent
                    text: "Ingresar"
                    color: "#2e3440"
                    font.family: config.font
                    font.pixelSize: 14
                    font.bold: true
                }
                MouseArea {
                    id: loginMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: sddm.login(userField.text, passField.text, root.sessionIndex)
                }
            }
        }
    }

    Text {
        id: errorText
        anchors.top: box.bottom
        anchors.topMargin: 8
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#bf616a"
        font.family: config.font
        font.pixelSize: 14
        text: ""
    }

    // Botones de energia
    Row {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 20
        spacing: 18

        Text {
            text: "\uf01e"
            color: rebootMouse.containsMouse ? "#ebcb8b" : "#d8dee9"
            font.family: config.font
            font.pixelSize: 24
            MouseArea { id: rebootMouse; anchors.fill: parent; hoverEnabled: true; onClicked: sddm.reboot() }
        }
        Text {
            text: "\uf011"
            color: powerMouse.containsMouse ? "#bf616a" : "#d8dee9"
            font.family: config.font
            font.pixelSize: 24
            MouseArea { id: powerMouse; anchors.fill: parent; hoverEnabled: true; onClicked: sddm.powerOff() }
        }
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            errorText.text = "Contraseña incorrecta"
            passField.text = ""
            passField.forceActiveFocus()
        }
    }

    Component.onCompleted: passField.forceActiveFocus()
}
