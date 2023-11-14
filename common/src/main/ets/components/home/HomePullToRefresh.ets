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

import { PullToRefresh } from '@ohos/pulltorefresh'

@Component
export struct HomePullToRefresh {
  @StorageLink("searchBarPosY") searchBarPosY: number = 0;
  @StorageLink("searchBarHeight") searchBarHeight: number = 0;
  private startPosY: number = 0;
  private startBarPosY: number = 0;

  @Link data: any;
  scroller: Scroller;
  @BuilderParam customList: (onItemClick: (item: any, index: number) => void,
                             onListStatus: (isListStart: boolean, isListEnd: boolean) => void) => void;
  mWidth?: Length = '100%';
  mHeight?: Length = '100%';
  onRefresh?: () => Promise<string> = () => {
    return new Promise<string>((resolve, reject) => {
      setTimeout(() => {
        resolve('刷新失败');
      }, 1000);
    });
  };
  onLoadMore?: () => Promise<string> = () => {
    return new Promise<string>((resolve, reject) => {
      setTimeout(() => {
        resolve('');
      }, 1000);
    });
  };

  @BuilderParam customRefresh?: () => void;
  @BuilderParam customLoad?: () => void;

  build() {
    PullToRefresh({
      data: $data,
      scroller: this.scroller,
      customList: this.customList,
      onRefresh: this.onRefresh,
      onLoadMore: this.onLoadMore,
      customLoad: this.customLoad,
      customRefresh: this.customRefresh,
    }).width(this.mWidth === undefined ? '100%' : this.mWidth)
      .height(this.mHeight === undefined ? '100%' : this.mHeight)
      .onTouch((event: TouchEvent) => {
      switch (event.type) {
        case TouchType.Down:
          this.startPosY = event.touches[0].y;
          this.startBarPosY = this.searchBarPosY;
          break;
        case TouchType.Up:
          if (this.searchBarPosY < -(this.searchBarHeight / 2)) {
            this.searchBarPosY = -this.searchBarHeight;
          } else {
            this.searchBarPosY = 0;
          }
          break;
        case TouchType.Move:
          let offsetY = (event.touches[0].y - this.startPosY) / 2;
          if (this.startBarPosY == 0 && offsetY < -10) {
            this.searchBarPosY = offsetY;
          } else if (this.startBarPosY < 0 && offsetY > 10) {
            this.searchBarPosY = this.startBarPosY + offsetY;
          }
          break;
      }
    })
  }
}