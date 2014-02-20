/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0
import QZXing 2.3
import Sailfish.Media 1.0

Page {
    id: page

    property string imagePath: dataPath + "/" + "tempqr.jpg"

    property QZXing barcode: QZXing {
        onDecodingFinished: {
            console.log("decoding finished");
        }

        onTagFound: {
            console.log(tag);
            pageStack.push(Qt.resolvedUrl("TagPage.qml"), { qrtag: tag });
        }
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: "About"
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
        }

        // Tell SilicaFlickable the height of its content.
        //contentHeight: column.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.

        Camera {
            id: camera
            flash.mode: Camera.FlashOff
            captureMode: Camera.CaptureStillImage
            focus.focusMode: Camera.FocusContinuous
            imageCapture {
                resolution: "800x600"
                onImageSaved: {
                    console.warn("image saved");
                    console.log(imagePath);
                    var message = {"imagePath": imagePath, "barcode": barcode};
                    var ret = barcode.decodeImageFromFile(imagePath);
                    if (ret)
                    {
                        messageLabel.text = ret;
                    }
                    else
                    {
                        messageLabel.text = "no tag found";
                    }
                }
                onCaptureFailed: {
                    console.error("error: " + camera.imageCapture.errorString);
                }
                onImageCaptured: { // does not work: missing SailfishOS feature
                    console.log("Image captured");
                }
            }
            onError: {
                console.error("error: " + camera.errorString);
            }
        }

        PageHeader {
            anchors.top: parent.top
            id: cameraHeader
            title: "Camera"
        }
        GStreamerVideoOutput {
            id: videoPreview
            anchors.centerIn: parent
            source: camera
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("capturing");
                    messageLabel.text = "";
                    camera.imageCapture.captureToLocation(imagePath);
                }
            }
        }
        Label {
            id: messageLabel
            anchors.top: videoPreview.bottom
            anchors.topMargin: 10
            color: Theme.primaryColor
        }

        Button {
            id: captureButton
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Capture"
            onClicked: {
                console.log("capturing");
                messageLabel.text = "";
                camera.imageCapture.captureToLocation(imagePath);
            }
        }
    }
}


