/*
 *   SPDX-FileCopyrightText: 2012 Marco Martin <mart@kde.org>
 *
 *   SPDX-License-Identifier: BSD
 */

import QtQuick
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid

import "qt6"

WallpaperItem {
    id: root

	Scenic {
	}

	Component.onCompleted: {
		console.log("yo wtf" + root.configuration.VideoSourceFoldersDos[0])
	}
}
