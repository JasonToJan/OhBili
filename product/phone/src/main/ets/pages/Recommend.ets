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

import { ApiManager } from '@ohos/common'
import { RecommendItem } from '@ohos/common';
import { DataSourceManager } from '@ohos/common';
import { RecommendItemView } from '@ohos/common';
import { HomePullToRefresh } from '@ohos/common';

@Component
export struct RecommendView {
  private scroller: Scroller = new Scroller();
  @State isRefreshing: boolean = false
  @State freshIdx: number = 1;
  @State data: any[] = [];

  build() {
    Column() {
      HomePullToRefresh({
        // 必传项，列表组件所绑定的数据
        data: $data,
        // 必传项，需绑定传入主体布局内的列表或宫格组件
        scroller: this.scroller,
        // 必传项，自定义主体布局，内部有列表或宫格组件
        customList: this.getListView,
        // 可选项，下拉刷新回调
        onRefresh: () => {
          return new Promise<string>((resolve, reject) => {
            this.freshIdx++;
            ApiManager.getInstance().requestRecommend(this.freshIdx, true).then((resp: boolean) => {
              resolve('');
            });
          });
        },
        // 可选项，上拉加载更多回调
        onLoadMore: () => {
          return new Promise<string>((resolve, reject) => {
            this.freshIdx++;
            ApiManager.getInstance().requestRecommend(this.freshIdx, false).then((resp: boolean) => {
              resolve('');
            });
          });
        },
        customLoad: null,
        customRefresh: null,
      })
    }.backgroundColor('#eeeeee')
  }

  @Builder
  private getListView(_, onListStatus: (isListStart: boolean, isListEnd: boolean) => void) {

    List({ scroller: this.scroller }) {
      LazyForEach(DataSourceManager.getRecommendSource(), (item: RecommendItem, index: number) => {
        if (index % 2 == 0) {
          ListItem() {
            Row() {
              Flex() {
                RecommendItemView({ item: item })
              }.layoutWeight(1)
              Flex().width(8).height(8)
              Flex() {
                if (index + 1 < DataSourceManager.getRecommendSource().totalCount() ){
                  RecommendItemView({ item: DataSourceManager.getRecommendSource().getData(index + 1) })
                }
              }.layoutWeight(1)
            }
          }
        } else {
          ListItem() {
            Flex().width('100%').height(8)
          }
        }
      }, item => item.bvid)
    }
    .width('100%')
    .padding({ top: 8, left: 16, right: 16 })
    .edgeEffect(EdgeEffect.None)
    .onScrollIndex((start, end) => {
      onListStatus(start == 0,
        end == DataSourceManager.getRecommendSource().totalCount() - 1)
    })
  }
}
