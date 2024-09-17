/*
 *   SPDX-FileCopyrightText: 2025 Donald Carr <d@chaos-reins.com>
 *
 *   SPDX-License-Identifier: BSD
 */

import QtQuick
import QtCore
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid

import "qt6"

WallpaperItem {
    id: root

    readonly property string defaultVideoFolder: {
        let videoPaths = StandardPaths.standardLocations(StandardPaths.MoviesLocation);
        if (videoPaths.length > 0) {
            return "file://" + videoPaths[0];
        }
        // Fallback to home directory if Videos doesn't exist
        let homePaths = StandardPaths.standardLocations(StandardPaths.HomeLocation);
        if (homePaths.length > 0) {
            return "file://" + homePaths[0] + "/Videos";
        }
        return "";
    }

	Scenic {
		videoSourceFolder: {
			var configPath = root.configuration.videoSourceFolder;
			return (configPath && configPath !== "") ? configPath : root.defaultVideoFolder;
		}
	}
}
