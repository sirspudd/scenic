import Qt.labs.folderlistmodel
import QtMultimedia
import QtQuick
import QtCore

Rectangle {
    color: "black"
    anchors.fill: parent

    Settings {
        id: settings
        property string videoSourceFolder: StandardPaths.writableLocation(StandardPaths.MoviesLocation)
    }

    property string videoSourceFolder: settings.videoSourceFolder

    LoggingCategory {
        //defaultLogLevel: LoggingCategory.Warning

        id: category

        name: "com.spudd.category"
        defaultLogLevel: LoggingCategory.Debug
    }

    QtObject {
        id: d

        property bool fsReady: false
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
            player.source = folderModel.get(index, "fileUrl");
            //console.log("source set to ", player.source);
        }
        onFsReadyChanged: {
            advance();
            //console.log("collection has ", folderModel.count, " items");
        }
    }

    FolderListModel {
        id: folderModel

        showDirs: false
        folder: videoSourceFolder
        onStatusChanged: {
            if (status == FolderListModel.Ready) {
                if (count == 0) {
                    console.log("no media found in", folder, ", bailing");
                    Qt.quit();
                } else {
                    d.fsReady = true;
                }
            }
        }
        onFolderChanged: {
            // Reset when folder changes
            d.fsReady = false;
            d.shownIndexes = [];
            d.displayIndex = -1;
        }
    }

    MediaPlayer {
        id: player

        // autoPlay: true
        videoOutput: videoOutput
        onSourceChanged: {
            player.play();
        }
        onPlayingChanged: {
            !player.playing ? d.advance() : undefined;
        }
    }

    VideoOutput {
        id: videoOutput

        anchors.fill: parent
        focus: true
        fillMode: VideoOutput.PreserveAspectCrop
        Keys.onPressed: (event) => {
            switch (event.key) {
            case Qt.Key_Right:
                {
                    d.advance();
                    event.accepted = true;
                    console.log("Advancing to next movie")
                    break;
                };
            case Qt.Key_Left:
                {
                    d.retreat();
                    event.accepted = true;
                    console.log("Retreating to prior movie")
                    break;
                };
            case Qt.Key_Escape:
                {
                    Qt.quit();
                    break;
                };
            }
        }

        MouseArea {
			      enabled: false
            anchors.fill: parent
            onClicked: {
                player.metaData.keys().forEach((key) => {
                    console.log(player.metaData.stringValue(key));
                });
            }
        }

    }

}
