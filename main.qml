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

    readonly property string defaultColor: "white"

    Rectangle {
        id: background
        anchors.fill: parent

        GridLayout {
            anchors.fill: parent
            rows: 3
            columns: 3

            // 1st row
            Rectangle {
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                color: "red"
                Layout.preferredWidth: background.width / 8
                Layout.preferredHeight: Layout.preferredWidth

                TapHandler {
                    onTapped: {
                        background.color = parent.color;
                    }
                }
            }
            Item {
                Layout.fillHeight: true
                Layout.fillWidth: true
            }
            Rectangle {
                Layout.alignment: Qt.AlignRight | Qt.AlignTop
                color: "blue"
                Layout.preferredWidth: background.width / 8
                Layout.preferredHeight: Layout.preferredWidth

                TapHandler {
                    onTapped: {
                        background.color = parent.color;
                    }
                }
            }

            // 2nd row
            Text {
                Layout.columnSpan: 3
                text: qsTr("ololo")
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                font.pointSize: 64

                TapHandler {
                    onTapped: {
                        background.color = defaultColor;
                    }
                }
            }

            // 3rd row
            Rectangle {
                Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                color: "green"
                Layout.preferredWidth: background.width / 8
                Layout.preferredHeight: Layout.preferredWidth

                TapHandler {
                    onTapped: {
                        background.color = parent.color;
                    }
                }
            }
            Item {
                Layout.fillHeight: true
                Layout.fillWidth: true
            }
            Rectangle {
                Layout.alignment: Qt.AlignRight | Qt.AlignBottom
                color: "yellow"
                Layout.preferredWidth: background.width / 8
                Layout.preferredHeight: Layout.preferredWidth

                TapHandler {
                    onTapped: {
                        background.color = parent.color;
                    }
                }
            }
        }
    }
}
