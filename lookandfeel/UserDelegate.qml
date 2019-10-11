/*
 *   Copyright 2014 David Edmundson <davidedmundson@kde.org>
 *   Copyright 2014 Aleix Pol Gonzalez <aleixpol@blue-systems.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2 or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 2.8
import QtGraphicalEffects 1.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    id: wrapper

    // If we're using software rendering, draw outlines instead of shadows
    // See https://bugs.kde.org/show_bug.cgi?id=398317
    readonly property bool softwareRendering: GraphicsInfo.api === GraphicsInfo.Software

    property bool isCurrent: true

    readonly property var m: model
    property string name
    property string userName
    property string avatarPath
    property string iconSource
    property bool constrainText: true
    property alias nameFontSize: usernameDelegate.font.pointSize
    property int fontSize: config.fontSize
    signal clicked()

    property real faceSize: Math.min(width, height - usernameDelegate.height - units.smallSpacing)

    opacity: isCurrent ? 1.0 : 0.5

    Behavior on opacity {
        OpacityAnimator {
            duration: units.longDuration
        }
    }

    // Draw a translucent background circle under the user picture
   // Rectangle {
   //     anchors.centerIn: imageSource
    //    width: imageSource.width - 2 // Subtract to prevent fringing
     //   height: width
        // radius: width / 2
     //   radius: 1000

        // color: PlasmaCore.ColorScope.backgroundColor
      //   color: "transparent"
      //  opacity: 0.6
   // }
   
   Rectangle {
            id: outline
            anchors.fill: parent
            // anchors.margins: -(config.AvatarOutlineWidth) || -2
            color: "transparent"
            border.width: config.AvatarOutlineWidth || 0
            // border.width: 0
            border.color: config.AvatarOutlineColor || "transparent"
            radius: 10
            // visible: config.AvatarOutline == "true" ? true : false
            visible: config.AvatarOutline == "false" ? true : false
        }
   

    Item {
        id: imageSource
        anchors {
            bottom: usernameDelegate.top
            bottomMargin: units.largeSpacing
            horizontalCenter: parent.horizontalCenter
        }
        Behavior on width { 
            PropertyAnimation {
                from: faceSize
                duration: units.longDuration * 2;
            }
        }
        width: 196
        height: 196

        //Image takes priority, taking a full path to a file, if that doesn't exist we show an icon
        Image {
            id: face
            source: wrapper.avatarPath
            // sourceSize: Qt.size(faceSize, faceSize)
            sourceSize: Qt.size(196, 196)
            // fillMode: Image.PreserveAspectCrop
            fillMode: Image.PreserveAspectFit
            smooth: true
            anchors.fill: parent
        }

        PlasmaCore.IconItem {
            id: faceIcon
            source: iconSource
            visible: (face.status == Image.Error || face.status == Image.Null)
            anchors.fill: parent
            anchors.margins: units.gridUnit * 0.5 // because mockup says so...
            colorGroup: PlasmaCore.ColorScope.colorGroup
        }
    }

    ShaderEffect {
        anchors {
            bottom: usernameDelegate.top
            bottomMargin: units.largeSpacing
            horizontalCenter: parent.horizontalCenter
        }

        width: imageSource.width
        height: imageSource.height

        supportsAtlasTextures: true

        property var source: ShaderEffectSource {
            sourceItem: imageSource
            // software rendering is just a fallback so we can accept not having a rounded avatar here
            hideSource: wrapper.GraphicsInfo.api !== GraphicsInfo.Software
            live: true // otherwise the user in focus will show a blurred avatar
        }

        property var colorBorder: PlasmaCore.ColorScope.textColor

        //draw a circle with an antialised border
        //innerRadius = size of the inner circle with contents
        //outerRadius = size of the border
        //blend = area to blend between two colours
        //all sizes are normalised so 0.5 == half the width of the texture

        //if copying into another project don't forget to connect themeChanged to update()
        //but in SDDM that's a bit pointless
        fragmentShader: "
                        varying highp vec2 qt_TexCoord0;
                        uniform highp float qt_Opacity;
                        uniform lowp sampler2D source;

                        uniform lowp vec4 colorBorder;
                        highp float blend = 0.01;
                        highp float innerRadius = 0.47;
                        highp float outerRadius = 0.49;
                        lowp vec4 colorEmpty = vec4(0.0, 0.0, 0.0, 0.0);

                        void main() {
                            lowp vec4 colorSource = texture2D(source, qt_TexCoord0.st);

                            highp vec2 m = qt_TexCoord0 - vec2(0.5, 0.5);
                            highp float dist = sqrt(m.x * m.x + m.y * m.y);

                            if (dist < innerRadius)
                                gl_FragColor = colorSource;
                            else if (dist < innerRadius + blend)
                                gl_FragColor = mix(colorSource, colorBorder, ((dist - innerRadius) / blend));
                            else if (dist < outerRadius)
                                gl_FragColor = colorBorder;
                            else if (dist < outerRadius + blend)
                                gl_FragColor = mix(colorBorder, colorEmpty, ((dist - outerRadius) / blend));
                            else
                                gl_FragColor = colorEmpty ;

                            gl_FragColor = gl_FragColor * qt_Opacity;
                    }
        "
    }

    PlasmaComponents.Label {
        id: usernameDelegate
        // font.pointSize: Math.max(fontSize + 2,theme.defaultFont.pointSize + 2)
        font.family: config.Font || "Roboto"
        // font.pointSize: config.FontPointSize ? config.FontPointSize * 1.2 : root.height / 80 * 1.2
        font.pointSize: 20
        font.bold: true
        renderType: Text.QtRendering
        font.capitalization: Font.Capitalize
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }
        height: implicitHeight // work around stupid bug in Plasma Components that sets the height
        // width: constrainText ? parent.width : implicitWidth
        text: wrapper.name
       //  style: softwareRendering ? Text.Outline : Text.Normal
        // styleColor: softwareRendering ? PlasmaCore.ColorScope.backgroundColor : "transparent" //no outline, doesn't matter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignHCenter
        //make an indication that this has active focus, this only happens when reached with keyboard navigation
        // font.underline: wrapper.activeFocus
    }

    
    DropShadow {
            id: usernameDelegateShadow
            anchors.fill: usernameDelegate
            source: usernameDelegate
            horizontalOffset: 1
            verticalOffset: 1
            radius: 12
            samples: 32
            spread: 0.4
            color: Qt.rgba(0, 0, 0, 1)
            Behavior on opacity {
                OpacityAnimator {
                    target: clock;
                    from: 1;
                    to: 0;
                    duration: 500
                    // easing.type: Easing.InOutQuad
                }
            }
        }
    
    
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onClicked: wrapper.clicked();
    }

    Accessible.name: name
    Accessible.role: Accessible.Button
    function accessiblePressAction() { wrapper.clicked() }
}
