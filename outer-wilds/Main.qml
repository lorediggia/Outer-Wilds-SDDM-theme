import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtMultimedia 5.15
import QtGraphicalEffects 1.15

Rectangle {
    id: root
    anchors.fill: parent
    color: "#030405"

    MediaPlayer {
        id: bgVideo
        source: config.backgroundVideo
        autoPlay: true
        loops: MediaPlayer.Infinite
    }

    VideoOutput {
        anchors.fill: parent
        source: bgVideo
        fillMode: VideoOutput.PreserveAspectCrop
    }

    RadialGradient {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.3; color: "transparent" }
            GradientStop { position: 1.2; color: "#D9000000" }
        }
    }

    Rectangle {
        id: loginPanel
        width: Math.min(460, parent.width * 0.9)
        anchors.centerIn: parent
        color: "#8C0A0E12"
        radius: 20
        border.color: "#14FFFFFF"
        border.width: 1
        height: contentColumn.implicitHeight + 100

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            color: "#E6000000"
            radius: 80
            samples: 65
            verticalOffset: 25
        }

        ColumnLayout {
            id: contentColumn
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: 50
            }
            spacing: 24

            Item { Layout.preferredHeight: 8 }

            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 2

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: "OUTER WILDS VENTURES"
                    color: "#66FFFFFF"
                    font.pointSize: 9
                    font.letterSpacing: 6
                    font.weight: Font.DemiBold
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: Qt.formatTime(new Date(), "hh:mm")
                    color: "#FFFFFF"
                    font.pointSize: 68
                    font.weight: Font.Thin
                    font.letterSpacing: -3

                    layer.enabled: true
                    layer.effect: Glow {
                        color: "#33FFFFFF"
                        radius: 10
                        samples: 21
                    }
                }
            }

            Item { Layout.preferredHeight: 8 }

            ColumnLayout {
                spacing: 6
                Layout.fillWidth: true

                Text {
                    text: "ASTRONAUT ID"
                    color: "#4DFFFFFF"
                    font.pointSize: 8
                    font.letterSpacing: 2
                    font.weight: Font.Bold
                }

                ComboBox {
                    id: userCombo
                    Layout.fillWidth: true
                    model: userModel
                    textRole: "name"
                    currentIndex: userModel.lastIndex
                    font.pointSize: 15
                    font.family: "Monospace"

                    contentItem: Text {
                        text: userCombo.currentText
                        color: "#FFFFFF"
                        font: userCombo.font
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        color: "transparent"
                        Rectangle {
                            width: parent.width; height: 1; anchors.bottom: parent.bottom
                            color: "#26FFFFFF"
                        }
                    }

                    delegate: ItemDelegate {
                        width: userCombo.width
                        contentItem: Text {
                            text: model.name
                            color: highlighted ? config.accentColor : "#FFFFFF"
                            font: userCombo.font
                        }
                        background: Rectangle {
                            color: highlighted ? "#0DFFFFFF" : "transparent"
                            radius: 4
                        }
                    }

                    popup: Popup {
                        y: userCombo.height + 4; width: userCombo.width; padding: 4
                        contentItem: ListView {
                            clip: true; implicitHeight: contentHeight
                            model: userCombo.popup.visible ? userCombo.delegateModel : null
                            currentIndex: userCombo.highlightedIndex
                        }
                        background: Rectangle {
                            color: "#F2080C10"
                            border.color: "#1AFFFFFF"
                            border.width: 1; radius: 8
                        }
                    }
                }
            }

            ColumnLayout {
                spacing: 6
                Layout.fillWidth: true

                Text {
                    text: "INSERT LAUNCH CODES"
                    color: password.activeFocus ? config.accentColor : "#4DFFFFFF"
                    font.pointSize: 8
                    font.letterSpacing: 2
                    font.weight: Font.Bold
                    Behavior on color { ColorAnimation { duration: 400; easing.type: Easing.OutExpo } }
                }

                TextField {
                    id: password
                    Layout.fillWidth: true
                    color: "transparent"
                    selectionColor: "transparent"
                    selectedTextColor: "transparent"
                    font.pointSize: 18
                    font.letterSpacing: 4
                    font.family: "Monospace"

                    function getPatternMask(len) {
                        let pattern = "--|-..|-.";
                        let result = "";
                        while (result.length < len) result += pattern;
                        return result.substring(0, len);
                    }

                    Text {
                        text: password.getPatternMask(password.text.length)
                        color: config.accentColor
                        font: password.font
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    background: Rectangle {
                        color: "transparent"
                        Rectangle {
                            width: parent.width; height: password.activeFocus ? 2 : 1; anchors.bottom: parent.bottom
                            color: password.activeFocus ? config.accentColor : "#26FFFFFF"
                            Behavior on color { ColorAnimation { duration: 400; easing.type: Easing.OutExpo } }
                        }
                        layer.enabled: password.activeFocus
                        layer.effect: Glow {
                            transparentBorder: true
                            color: "#4DD95C14"
                            radius: 20; samples: 41
                        }
                    }

                    onAccepted: sddm.login(userCombo.currentText, password.text, sessionCombo.currentIndex)
                }
            }

            ColumnLayout {
                spacing: 6
                Layout.fillWidth: true

                Text {
                    text: "ENVIRONMENT"
                    color: "#4DFFFFFF"
                    font.pointSize: 8
                    font.letterSpacing: 2
                    font.weight: Font.Bold
                }

                ComboBox {
                    id: sessionCombo
                    Layout.fillWidth: true
                    model: sessionModel
                    textRole: "name"
                    currentIndex: sessionModel.lastIndex
                    font.pointSize: 12
                    font.letterSpacing: 1

                    contentItem: Text {
                        text: sessionCombo.currentText.toUpperCase()
                        color: "#99FFFFFF"
                        font: sessionCombo.font
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        color: "transparent"
                        Rectangle {
                            width: parent.width; height: 1; anchors.bottom: parent.bottom
                            color: "#26FFFFFF"
                        }
                    }

                    delegate: ItemDelegate {
                        width: sessionCombo.width
                        contentItem: Text {
                            text: model.name.toUpperCase()
                            color: highlighted ? config.accentColor : "#99FFFFFF"
                            font: sessionCombo.font
                        }
                        background: Rectangle {
                            color: highlighted ? "#0DFFFFFF" : "transparent"
                            radius: 4
                        }
                    }

                    popup: Popup {
                        y: sessionCombo.height + 4; width: sessionCombo.width; padding: 4
                        contentItem: ListView {
                            clip: true; implicitHeight: contentHeight
                            model: sessionCombo.popup.visible ? sessionCombo.delegateModel : null
                            currentIndex: sessionCombo.highlightedIndex
                        }
                        background: Rectangle {
                            color: "#F2080C10"
                            border.color: "#0DFFFFFF"
                            border.width: 1; radius: 8
                        }
                    }
                }
            }

            Item { Layout.preferredHeight: 8 }

            Button {
                id: loginButton
                Layout.fillWidth: true
                Layout.preferredHeight: 58
                scale: loginButton.hovered ? 1.02 : 1.0
                Behavior on scale { NumberAnimation { duration: 300; easing.type: Easing.OutExpo } }

                contentItem: Text {
                    text: "IGNITION"
                    color: loginButton.hovered ? "#FFFFFF" : "#B3FFFFFF"
                    font.bold: true
                    font.letterSpacing: loginButton.hovered ? 6 : 4
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    Behavior on font.letterSpacing { NumberAnimation { duration: 300; easing.type: Easing.OutExpo } }
                    Behavior on color { ColorAnimation { duration: 300 } }
                }

                background: Rectangle {
                    radius: 12
                    color: loginButton.hovered ? "#26D95C14" : "transparent"
                    border.color: loginButton.hovered ? config.accentColor : "#1AFFFFFF"
                    border.width: 1
                    Behavior on color { ColorAnimation { duration: 300; easing.type: Easing.OutExpo } }
                    Behavior on border.color { ColorAnimation { duration: 300; easing.type: Easing.OutExpo } }

                    layer.enabled: loginButton.hovered
                    layer.effect: Glow {
                        transparentBorder: true
                        color: "#66D95C14"
                        radius: 15; samples: 31
                    }
                }

                onClicked: sddm.login(userCombo.currentText, password.text, sessionCombo.currentIndex)
            }

            Item { Layout.preferredHeight: 8 }
        }
    }
}