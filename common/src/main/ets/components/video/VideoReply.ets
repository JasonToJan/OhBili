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

import { PullToRefresh, PullToRefreshOpt } from '@ohos/pulltorefresh'
import { ApiManager } from './../../network/ApiManager';
import { BLog } from './../../utils/BLog';
import { ReplyCursor, ReplyItem } from './../../model/response/ReplyResponse';
import { BaseVideo } from './../../model/response/Response';
import { ReplyItemView } from './ReplyItem';
import { DataSourceManager } from './../../model/DataSourceManager';

@Component
export struct VideoReply {
  private scroller: Scroller = new Scroller();
  private vInfo: BaseVideo;
  private type: number = 1;
  private sort: number = 0;
  @State data: any[] = [];
  @State next: number = 0;
  @StorageLink('replyCount') replyCount: number = 0;
  @StorageLink('replyItem') replyItem: ReplyItem = null;
  private refreshOpt = new PullToRefreshOpt();
  @State isEnd: boolean = false;

  build() {
    Column() {
      PullToRefresh({
        // 必传项，列表组件所绑定的数据
        data: $data,
        // 必传项，需绑定传入主体布局内的列表或宫格组件
        scroller: this.scroller,
        refreshOpt: this.refreshOpt,
        // 必传项，自定义主体布局，内部有列表或宫格组件
        customList: this.getListView,
        onItemClick: (item: any, index: number) => {
          BLog.i('IjkPlayer onItemClick index: ' + index);
          this.replyItem = item;
        },
        // 可选项，下拉刷新回调
        onRefresh: () => {
          return new Promise<string>((resolve) => {
            this.next = 0;
            ApiManager.getInstance()
              .requestReply(this.vInfo.bvid, this.next, this.type, this.sort)
              .then((cursor: ReplyCursor) => {
                this.replyCount = cursor.all_count;
                this.refreshOpt.enableLoadMore = !cursor.is_end;
                this.isEnd = cursor.is_end;
                resolve('');
              });
          });
        },
        // 可选项，上拉加载更多回调
        onLoadMore: () => {
          return new Promise<string>((resolve) => {
            this.next++;
            ApiManager.getInstance()
              .requestReply(this.vInfo.bvid, this.next, this.type, this.sort)
              .then((cursor: ReplyCursor) => {
                BLog.i("requestReply: pn=" + this.next + ", cursor=" + JSON.stringify(cursor));
                this.replyCount = cursor.all_count;
                this.refreshOpt.enableLoadMore = !cursor.is_end;
                this.isEnd = cursor.is_end;
                resolve('');
              });
          });
        },
        customLoad: null,
        customRefresh: null,
      })
    }.height('100%')
    .backgroundColor('#ffffff')
  }

  @Builder
  private getListView(onItemClick: (item: any, index: number) => void,
                      onListStatus: (isListStart: boolean, isListEnd: boolean) => void) {
    List({ scroller: this.scroller }) {
      LazyForEach(DataSourceManager.getReplySource(AppStorage.Get('bvid')), (item: ReplyItem, index: number) => {
        ListItem() {
          ReplyItemView({ item: item, isShowReply: true, onItemClick: () => {
            onItemClick(item, index);
          } })
        }
      }, item => item)
    }
    .width('100%')
    .height('100%')
    .padding({ left: 16, right: 16 })
    .divider({ strokeWidth: 1, color: '#ffeeeeee' })
    .edgeEffect(EdgeEffect.None)
    .onScrollIndex((start, end) => {
      onListStatus(start == 0,
        end == DataSourceManager.getReplySource(AppStorage.Get('bvid')).totalCount() - 1)
    })
  }
}