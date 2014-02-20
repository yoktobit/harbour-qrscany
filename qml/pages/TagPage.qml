import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    property string qrtag: "Not found"

    function isHttpLink(url) {
        if (url.match("^https?://"))
        {
            return true;
        }
        return false;
    }

    SilicaFlickable {
        anchors.fill: parent
        PullDownMenu {
            visible: isHttpLink(qrtag)
            MenuItem {
                text: "Open URL"
                visible: isHttpLink(qrtag)
                onClicked: {
                    Qt.openUrlExternally(qrtag);
                }
            }
        }

        PageHeader {
            id: pageHeader
            title: "Tag found"
        }
        TextArea {
            id: textArea
            anchors.top: pageHeader.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            text: qrtag
        }
    }
}
