/*
    SPDX-FileCopyrightText: 2023 Donald <d@chaos-reins.com>

    SPDX-License-Identifier: BSD
*/

import QtCore
import QtQuick
import QtQuick.Dialogs as QtDialogs

Loader {
    id: dialogLoader

    asynchronous: true
    sourceComponent: addFolderDialog

    Connections {
        target: dialogLoader.item
        function onAccepted() {
			let folderName = dialogLoader.item.selectedFolder;
			console.log("Adding" + folderName + "to the fray")
            slideshowComponent.cfg_VideoSourceFolders.push(folderName)
			console.log(slideshowComponent.cfg_VideoSourceFolders)
			slidePathsView.model = slideshowComponent.cfg_VideoSourceFolders
            dialogLoader.destroy();
        }
        function onRejected() {
            dialogLoader.destroy();
        }
    }

    Component {
        id: addFolderDialog

        QtDialogs.FolderDialog {
            id: folderDialog
            visible: dialogLoader.status === Loader.Ready
            currentFolder: StandardPaths.standardLocations(StandardPaths.HomeLocation)[0];
            options: QtDialogs.FolderDialog.ReadOnly
            title: i18nc("@title:window", "Directory with the videos to play")
        }
    }
}
