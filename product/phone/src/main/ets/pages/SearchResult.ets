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

import router from '@ohos.router';
import { SearchBar } from '@ohos/common';
import { SearchVideo, SearchVideoToBaseVideo } from '@ohos/common';
import { HomePullToRefresh } from '@ohos/common';
import { DataSourceManager } from '@ohos/common';
import { PopularItemView } from '@ohos/common';
import { ApiManager } from '@ohos/common';
import { BLog } from '@ohos/common';

@Entry
@Component
struct SearchResultPage {
  @State data: SearchVideo[] = [];
  private keyword: string = router.getParams()['keyword'];
  private scroller: Scroller = new Scroller();
  @State pn: number = 1;
  @State isLoading: boolean = false;

  aboutToAppear() {
    BLog.i("SearchResultPage keyword:" + this.keyword);
    this.isLoading = true;
    ApiManager.getInstance().requestSearch(this.keyword, this.pn).then(result => {
      this.isLoading = false;
    })
  }

  aboutToDisappear() {
    DataSourceManager.getSearchSource().setData([]);
  }

  build() {
    Column() {
      SearchBar({keyword: this.keyword})

      if (this.isLoading) {
        Text('数据加载中···')
          .width('100%').layoutWeight(1)
          .fontSize(14).textAlign(TextAlign.Center)
      } else {
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
              this.pn = 1;
              ApiManager.getInstance().requestSearch(this.keyword, this.pn).then((videos: boolean) => {
                resolve('');
              });
            });
          },
          // 可选项，上拉加载更多回调
          onLoadMore: () => {
            return new Promise<string>((resolve, reject) => {
              this.pn++;
              ApiManager.getInstance().requestSearch(this.keyword, this.pn).then((videos: boolean) => {
                resolve('');
              });
            });
          },
          customLoad: null,
          customRefresh: null,
        }).layoutWeight(1)
      }
    }
  }

  @Builder
  private getListView() {
    List({ scroller: this.scroller }) {
      LazyForEach(DataSourceManager.getSearchSource(), (item: SearchVideo, index: number) => {
        ListItem() {
          PopularItemView({ item: SearchVideoToBaseVideo(item) })
        }
      }, item => item.bvid)
    }
    .backgroundColor('#ffffff')
    .width('100%')
    .padding({ left: 16, right: 16 })
    .divider({ strokeWidth: 1, color: '#ffeeeeee' })
    .edgeEffect(EdgeEffect.None)
  }

}