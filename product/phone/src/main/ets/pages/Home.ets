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

import { RecommendView } from './Recommend'
import { PopularView } from './Popular'
import { BingeWatchView } from './BingeWatch';
import { HomeSearchBar } from '@ohos/common'
import { ApiManager } from '@ohos/common';

@Component
export struct HomeView {
  @State currentIndex: number = 0;
  @StorageLink("isShowPage") isShowPage: boolean = true;
  @StorageLink("searchDefault") searchDefault: string = "";
  @StorageLink("searchBarPosY") @Watch('onPosYUpdated') searchBarPosY: number = 0;
  @State offsetY: number = 0;
  @StorageLink("searchBarHeight") searchBarHeight: number = 0;
  @StorageLink("netIsAvailable") netIsAvailable: boolean = true;

  aboutToAppear() {
    ApiManager.getInstance().requestSearchDefault().then((name) => {
      this.searchDefault = name;
    })
  }

  aboutToDisappear() {
  }

  onPosYUpdated(propName: string): void {
    if (this.searchBarPosY > 0) {
      this.searchBarPosY = 0;
    } else if (this.searchBarPosY < -this.searchBarHeight) {
      this.searchBarPosY = -this.searchBarHeight;
    } else {
      this.offsetY = this.searchBarPosY;
    }
  }

  @Builder TabBuilder(title: string | Resource, targetIndex: number) {
    Column() {
      Text(title)
        .maxLines(1)
        .fontSize(16)
        .fontColor(this.currentIndex === targetIndex ? '#1698CE' : '#6B6B6B')
        .border({width: {bottom: this.currentIndex === targetIndex ? 2 : 0}, color: '#1698CE'})
        .height('100%')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .border({width: {bottom: 0.5}, color: '#cccccc'})
  }

  build() {
    Column() {
      HomeSearchBar().padding({ top: 16 })
        .margin({left: 16, right: 16, bottom: 8})
        .onAreaChange((oldValue: Area, newValue: Area) => {
          if (newValue.height as number) {
            this.searchBarHeight = newValue.height as number
          }
        })
      if (!this.netIsAvailable) {
        Text('网络不给力，请检查网络设置。')
          .width('100%')
          .fontSize(14).textAlign(TextAlign.Center)
          .padding({ top: 16, bottom: 16 })
          .backgroundColor("#ffe1df")
      }
      Tabs() {
        TabContent() {
          RecommendView()
        }
        .tabBar(this.TabBuilder($r('app.string.home_recommend'), 0))

        TabContent() {
          PopularView()
        }
        .tabBar(this.TabBuilder($r('app.string.home_hot'), 1))

        /*TabContent() {
          BingeWatchView()
        }
        .tabBar(this.TabBuilder($r('app.string.home_animation'), 2))

        TabContent() {
          Text($r('app.string.func_develop')).fontSize(16)
        }
        .tabBar(this.TabBuilder($r('app.string.home_movie'), 3))*/
      }.onChange((index) => {
        this.currentIndex = index
      }).barWidth('80%').barHeight(40)
    }
    .width('100%')
    .height('100%')
    .offset({ y: this.offsetY })
  }
}