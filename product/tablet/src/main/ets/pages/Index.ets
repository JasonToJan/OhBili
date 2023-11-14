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

import { HomeView } from './Home';
import { MineView } from './Mine';
import { WindowManager } from '@ohos/common';
import { MomentsView } from './Moments';

@Entry
@Component
struct Index {
  private tabsController: TabsController = new TabsController()
  @State currentIndex: number = 0;
  @StorageLink("isShowPage") isShowPage: boolean = true;

  @Builder TabBuilder(title: string | Resource, targetIndex: number, imgPath: Resource) {
    Column() {
      Image(imgPath)
        .fillColor(this.currentIndex === targetIndex ? '#1698CE' : '#6B6B6B')
        .size({ width: this.currentIndex === targetIndex ? 22 : 20,
          height: this.currentIndex === targetIndex ? 22 : 20 })
      Text(title)
        .margin({ top: 6 })
        .fontSize(this.currentIndex === targetIndex ? 14 : 12)
        .fontColor(this.currentIndex === targetIndex ? '#1698CE' : '#6B6B6B')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .border({width: {top: 0.5}, color: '#cccccc'})
  }

  onPageShow() {
    this.isShowPage = true;
    WindowManager.setLayoutFullScreen(false, WindowManager.COLOR_WHITE,
      WindowManager.COLOR_BLACK, WindowManager.COLOR_WHITE, WindowManager.COLOR_BLACK);
  }

  onPageHide() {
    this.isShowPage = false;
  }

  build() {
    Tabs({ barPosition: BarPosition.End, controller: this.tabsController }) {
      TabContent() {
        HomeView()
      }
      .tabBar(this.TabBuilder($r('app.string.home'), 0, $r('app.media.ic_tab_bar_home')))

      TabContent() {
        MomentsView()
      }
      .tabBar(this.TabBuilder($r('app.string.moments'), 1, $r('app.media.ic_tab_bar_moments')))

      /*TabContent() {
        Text($r('app.string.func_develop')).fontSize(16)
      }
      .tabBar(this.TabBuilder($r('app.string.live_stream'), 2, $r('app.media.ic_tab_bar_shopping')))*/

      TabContent() {
        MineView()
      }
      .tabBar(this.TabBuilder($r('app.string.mine'), 2, $r('app.media.ic_tab_bar_mine')))
    }.scrollable(false).barWidth('320')
    .barMode(BarMode.Fixed)
    .onChange((index) => {
      this.currentIndex = index
    })
  }
}