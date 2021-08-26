import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15

Window {
    visible: true
    //visibility: Window.FullScreen
    width: 1200
    minimumWidth: 700
    height: 800
    minimumHeight: 500

    Rectangle {
        id: root
        anchors.fill: parent

        GridLayout {
            anchors.fill: parent
            rows: 3
            columns: 3

            // 1 row
            Rectangle {
                id: rectRed
                // Layout.fillHeight: true
                // Layout.fillWidth: true
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                color: "red"
                Layout.preferredWidth: 150
                Layout.preferredHeight: 150

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        root.color = rectRed.color;
                    }
                }
            }
            Item {
                Layout.fillHeight: true
                Layout.fillWidth: true
            }
            Rectangle {
                id: rectBlue
                Layout.alignment: Qt.AlignRight | Qt.AlignTop
                color: "blue"
                Layout.preferredWidth: 150
                Layout.preferredHeight: 150
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        root.color = rectBlue.color;
                    }
                }
            }

            // 2 row
            Text {
                Layout.columnSpan: 3
                id: text
                text: qsTr("ololo")
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                font.pointSize: 64
            }

            // 3 row
            Rectangle {
                id: rectGreen
                Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                color: "green"
                Layout.preferredWidth: 150
                Layout.preferredHeight: 150
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        root.color = rectGreen.color;
                    }
                }
            }
            Item {
                Layout.fillHeight: true
                Layout.fillWidth: true
            }
            Rectangle {
                id: rectYellow
                Layout.alignment: Qt.AlignRight | Qt.AlignBottom
                color: "yellow"
                Layout.preferredWidth: 150
                Layout.preferredHeight: 150
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        root.color = rectYellow.color;
                    }
                }
            }
        }
    }
}
