/**
 * Copyright (c) 2023 Wathinst <wxz@xkzhineng.com>
 * OhBili is licensed under Mulan PSL v2.
 * You can use this software according to the terms and conditions of the Mulan PSL v2.
 * You may obtain a copy of Mulan PSL v2 at:
 * http://license.coscl.org.cn/MulanPSL2
 * THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
 * EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
 * MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
 * See the Mulan PSL v2 for more details.
 */

import window from '@ohos.window';

/**
 * 应用窗口工具
 */
export class WindowManager {
    static STATUS_BAR_HEIGHT = 36;

    static COLOR_WHITE = '#ffffff';
    static COLOR_BLACK = '#000000';
    static COLOR_TRANSPARENT = '#00000000';

    /**
     * 全屏，不显示导航栏、状态栏
     * @param windowStage
     */
    static setFullScreen(isFullScreen: boolean) {
        if (globalThis.windowStage != undefined) {
            // 1.获取应用主窗口
            globalThis.windowStage.getMainWindow((err, data) => {
                if (err.code) {
                    console.error('Failed to obtain the main window. Cause: ' + JSON.stringify(err));
                    return;
                }
                let windowClass = data;
                console.info('Succeeded in obtaining the main window. Data: ' + JSON.stringify(data));

                // 2.实现沉浸式效果。方式一：设置导航栏、状态栏不显示。
                let names = isFullScreen ? ['status', 'navigation'] : [];
                windowClass.setWindowSystemBarEnable(names, (err) => {
                    if (err.code) {
                        console.error('Failed to set the system bar to be visible. Cause:' + JSON.stringify(err));
                        return;
                    }
                    console.info('Succeeded in setting the system bar to be visible.');
                });
            })
        }
    }

    /**
     * 全屏，更改导航栏、状态栏配色
     * @param windowStage
     * @param sBarColor
     * @param sBarContentColor
     */
    static setLayoutFullScreen(isFullScreen: boolean, statusBarColor: string, statusBarContentColor: string, navigationBarColor: string, navigationBarContentColor: string) {
        if (globalThis.windowStage != undefined) {
            // 1.获取应用主窗口
            globalThis.windowStage.getMainWindow((err, data) => {
                if (err.code) {
                    console.error('Failed to obtain the main window. Cause: ' + JSON.stringify(err));
                    return;
                }
                let windowClass = data;
                console.info('Succeeded in obtaining the main window. Data: ' + JSON.stringify(data));

                // 2.实现沉浸式效果。方式二：设置窗口为全屏布局，配合设置导航栏、状态栏的透明度、背景/文字颜色及高亮图标等属性，与主窗口显示保持协调一致。
                // let isFullScreen = false;
                windowClass.setWindowLayoutFullScreen(isFullScreen, (err) => {
                    if (err.code) {
                        console.error('Failed to set the window layout to full-screen mode. Cause:' + JSON.stringify(err));
                        return;
                    }
                    console.info('Succeeded in setting the window layout to full-screen mode.');
                });
                let sysBarProps = {
                    statusBarColor: statusBarColor,
                    statusBarContentColor: statusBarContentColor, // API8+
                    navigationBarColor: navigationBarColor,
                    navigationBarContentColor: navigationBarContentColor // API8+
                };
                windowClass.setWindowSystemBarProperties(sysBarProps, (err) => {
                    if (err.code) {
                        console.error('Failed to set the system bar properties. Cause: ' + JSON.stringify(err));
                        return;
                    }
                    console.info('Succeeded in setting the system bar properties.');
                });
            })
        }
    }

    static changeWindowDirection(orientation: window.Orientation) {
        if (globalThis.windowStage != undefined) {
            globalThis.windowStage.getMainWindow((err, data) => {
                if (err.code) {
                    console.error('IjkPlayer changeWindowDirection Failed to change the window: ' + JSON.stringify(err))
                    return
                }
                data.setPreferredOrientation(orientation);
            })
        }
    }
}