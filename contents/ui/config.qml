/*
 *   SPDX-FileCopyrightText: 2025 Donald Carr <d@chaos-reins.com>
 *
 *   SPDX-License-Identifier: BSD
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
    id: root

    property var configDialog
    property var wallpaperConfiguration: wallpaper.configuration
    property var parentLayout
    property alias formLayout: root
    twinFormLayouts: parentLayout

    property alias cfg_videoSourceFolder: videoSourceFolderField.text

    RowLayout {
        Kirigami.FormData.label: i18n("Video Source Folder:")
        Layout.fillWidth: true

        TextField {
            id: videoSourceFolderField
            placeholderText: i18n("Enter path to folder containing video files")
            Layout.fillWidth: true
        }

        Button {
            icon.name: "folder-open"
            text: i18n("Browse...")
            onClicked: folderDialog.open()
        }
    }

    Label {
        Layout.fillWidth: true
        wrapMode: Text.WordWrap
        text: i18n("Select the folder containing video files to use as wallpaper. The plugin will randomly play videos from this folder.")
        font: Kirigami.Theme.smallFont
    }

    FolderDialog {
        id: folderDialog
        title: i18n("Select Video Source Folder")
        onAccepted: {
            if (selectedFolder) {
                videoSourceFolderField.text = selectedFolder.toString()
            }
        }
    }
}
