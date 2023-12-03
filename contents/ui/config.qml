/*
    SPDX-FileCopyrightText: 2013 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2014 Kai Uwe Broulik <kde@privat.broulik.de>
    SPDX-FileCopyrightText: 2019 David Redondo <kde@david-redondo.de>
    SPDX-FileCopyrightText: 2019 Donald Carr <d@chaos-reins.com>

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Layouts 1.15

import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami
import org.kde.plasma.wallpapers.image 2.0 as PlasmaWallpaper

ColumnLayout {
    id: slideshowComponent
    property var configuration: wallpaper.configuration
	property var cfg_VideoSourceFolders: []

    function openChooserDialog() {
        const dialogComponent = Qt.createComponent("AddFileDialog.qml");
        dialogComponent.createObject(root);
        dialogComponent.destroy();
    }

    QQC2.ScrollView {
            id: foldersScroll
            Layout.fillHeight: true
            Layout.preferredWidth: 0.35 * parent.width
            Layout.maximumWidth: Kirigami.Units.gridUnit * 16
            Component.onCompleted: foldersScroll.background.visible = true;

            ListView {
                id: slidePathsView
                headerPositioning: ListView.OverlayHeader
                header: Kirigami.InlineViewHeader {
                    width: slidePathsView.width
                    text: i18nd("plasma_wallpaper_org.kde.image", "Folders")
                    actions: [
                        Kirigami.Action {
                            icon.name: "folder-add-symbolic"
                            text: i18ndc("plasma_wallpaper_org.kde.image", "@action button the thing being added is a folder", "Add…")
                            onTriggered: slideshowComponent.openChooserDialog()
                        }
                    ]
                }
                model: slideshowComponent.configuration.VideoSourceFolders // slideshowComponent.cfg_VideoSourceFolders
                delegate: Kirigami.SubtitleDelegate {
                    id: baseListItem

                    width: slidePathsView.width
                    // Don't need a highlight or hover effects
                    hoverEnabled: false
                    down: false

                    text: {
						return modelData
                        var strippedPath
						strippedPath = strippedPath.replace(/\/+$/, "");
                        return strippedPath.split('/').pop()
                    }
                    // Subtitle: the path to the folder
                    subtitle: {
						return modelData
                        var strippedPath = modelData.replace(/\/+$/, "");
                        return strippedPath.replace(/\/[^\/]*$/, '');;
                    }

                    contentItem: RowLayout {
                        spacing: Kirigami.Units.smallSpacing

                        Kirigami.TitleSubtitle {
                            Layout.fillWidth: true
                            // Header: the folder
                            title: baseListItem.text
                            subtitle: baseListItem.subtitle
                        }

                        QQC2.ToolButton {
                            icon.name: "edit-delete-remove-symbolic"
                            text: i18nd("plasma_wallpaper_org.kde.image", "Remove Folder")
                            display: QQC2.Button.IconOnly
                            onClicked: imageWallpaper.removeSlidePath(modelData)

                            QQC2.ToolTip.visible: hovered
                            QQC2.ToolTip.text: text
                            QQC2.ToolTip.delay: Kirigami.Units.toolTipDelay
                        }

                        QQC2.ToolButton {
                            icon.name: "document-open-folder"
                            text: i18nd("plasma_wallpaper_org.kde.image", "Open Folder…")
                            display: QQC2.Button.IconOnly
                            onClicked: Qt.openUrlExternally(modelData)

                            QQC2.ToolTip.visible: hovered
                            QQC2.ToolTip.text: text
                            QQC2.ToolTip.delay: Kirigami.Units.toolTipDelay
                        }
                    }
                }

                Kirigami.PlaceholderMessage {
                    anchors.centerIn: parent
                    width: parent.width - (Kirigami.Units.largeSpacing * 4)
                    visible: slidePathsView.count === 0
                    text: i18nd("plasma_wallpaper_org.kde.image", "There are no wallpaper locations configured yo")
                }
            }
        }
}
