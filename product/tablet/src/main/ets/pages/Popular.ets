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

import { ApiManager } from '@ohos/common';
import { PopularItem } from '@ohos/common';
import { DataSourceManager } from '@ohos/common';
import { PopularItemView } from '@ohos/common';
import { PullToRefresh } from '@ohos/pulltorefresh';

@Component
export struct PopularView {
  private scroller: Scroller = new Scroller();
  @State data: any[] = [];
  @State pn: number = 1;

  build() {
    Column() {
      PullToRefresh({
        // 必传项，列表组件所绑定的数据
        data: $data,
        // 必传项，需绑定传入主体布局内的列表或宫格组件
        scroller: this.scroller,
        // 必传项，自定义主体布局，内部有列表或宫格组件
        customList: this.getListView,
        // 可选项，下拉刷新回调
        onRefresh: () => {
          return new Promise<string>((resolve, reject) => {
            this.pn = 1;
            ApiManager.getInstance().requestPopular(this.pn).then((resp: boolean) => {
              resolve('');
            });
          });
        },
        // 可选项，上拉加载更多回调
        onLoadMore: () => {
          return new Promise<string>((resolve, reject) => {
            this.pn++;
            ApiManager.getInstance().requestPopular(this.pn).then((resp: boolean) => {
              resolve('');
            });
          });
        },
        customLoad: null,
        customRefresh: null,
      })
    }.backgroundColor('#ffffff')
  }

  @Builder
  private getListView(_, onListStatus: (isListStart: boolean, isListEnd: boolean) => void) {
    List({ scroller: this.scroller }) {
      LazyForEach(DataSourceManager.getPopularSource(), (item: PopularItem, index: number) => {
        if (index % 2 == 0) {
          ListItem() {
            Row() {
              Flex() {
                PopularItemView({ item: item })
              }.layoutWeight(1)

              Flex().width(18).height(18)
              Flex() {
                if (index + 1 < DataSourceManager.getPopularSource().totalCount()) {
                  PopularItemView({ item: DataSourceManager.getPopularSource().getData(index + 1) })
                }
              }.layoutWeight(1)
            }
          }
        } else {
          ListItem() {
            Row() {
              Flex().height(1).layoutWeight(1)
                .backgroundColor('#ffeeeeee')
              Flex().width(18).height(1)
              Flex().height(1).layoutWeight(1)
                .backgroundColor('#ffeeeeee')
            }.width('100%')
            .margin({ top: 4, bottom: 4 })
          }
        }
      }, item => item.bvid)
    }
    .width('100%')
    .padding({ left: 16, right: 16, bottom: 4 })
    //.divider({ strokeWidth: 1, color: '#ffeeeeee' })
    .edgeEffect(EdgeEffect.None)
    .onScrollIndex((start, end) => {
      onListStatus(start == 0,
        end == DataSourceManager.getPopularSource().totalCount() - 1)
    })
  }
}
