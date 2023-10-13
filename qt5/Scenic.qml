/*
    I work against Qt 6 and backport to Qt 5, hence the commented out Qt5-isms
    Now I grok why Lot was not meant to look back; barf
 */

import Qt.labs.folderlistmodel 2.15
import QtMultimedia 5.15
import QtQuick 2.15

Rectangle {
    color: "black"
    anchors.fill: parent

    LoggingCategory {
        //defaultLogLevel: LoggingCategory.Warning

        id: category

        name: "com.spudd.category"
        defaultLogLevel: LoggingCategory.Debug
    }

    QtObject {
        id: d

        property bool fsReady: false
        property string currentPlayingUrl
        property variant shownIndexes: []
        property int displayIndex: -1

        function advance() {
            if ((shownIndexes.length != 0) && (displayIndex < shownIndexes.length - 1)) {
                displayIndex = displayIndex + 1;
            } else {
                var newIndex = Math.floor(Math.random() * folderModel.count);
                shownIndexes.push(newIndex);
                displayIndex = shownIndexes.length - 1;
            }
        }

        function retreat() {
            if (displayIndex > 0)
                displayIndex = displayIndex - 1;

        }

        onDisplayIndexChanged: {
            var index = shownIndexes[displayIndex];
            currentPlayingUrl = folderModel.get(index, "fileUrl");
        }
        onFsReadyChanged: {
            advance();
            console.log("collection has ", folderModel.count, " items");
        }
    }

    FolderListModel {
        id: folderModel

        showDirs: false
        folder: "file:///blackhole/media/aerial/sdr"
        onStatusChanged: {
            if (status == FolderListModel.Ready) {
                if (count == 0) {
                    console.log("no media found, bailing");
                    Qt.quit();
                } else {
                    d.fsReady = true;
                }
            }
        }
    }

    MediaPlayer {
        id: player

        autoPlay: true
        source: d.currentPlayingUrl
        videoOutput: videoOutput
    }

    VideoOutput {
        id: videoOutput

        anchors.fill: parent
        focus: true
        Keys.onPressed: (event) => {
            switch (event.key) {
            case Qt.Key_Right:
                {
                    d.advance();
                    event.accepted = true;
                    break;
                };
            case Qt.Key_Left:
                {
                    d.retreat();
                    event.accepted = true;
                    break;
                };
            case Qt.Key_Escape:
                {
                    Qt.quit();
                    break;
                };
            }
        }
    }

}
