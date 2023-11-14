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

import { PullToRefresh, PullToRefreshOpt } from '@ohos/pulltorefresh';
import { BaseVideo } from './../../model/response/Response';
import { DataSourceManager } from './../../model/DataSourceManager';
import { ReplyItemView } from './ReplyItem';
import { ReplyItem } from './../../model/response/ReplyResponse';
import { ApiManager } from './../../network/ApiManager';
import { ReplyPage } from './../../model/response/ReplyDetailResponse';

@Component
export struct ReplyDetailView {
  private vInfo: BaseVideo;
  @StorageLink('replyItem') replyItem: ReplyItem = null;
  scroller: Scroller = new Scroller();
  @State data: any[] = [];
  private refreshOpt = new PullToRefreshOpt();
  @State isEnd: boolean = false;
  @State pn: number = 1;
  @State isLoading: boolean = false;

  aboutToAppear() {
    this.isLoading = true;
    DataSourceManager.getReplyDetailSource().setData([this.replyItem])
    ApiManager.getInstance()
      .requestReplyDetail(this.vInfo.bvid, this.replyItem.rpid, this.pn, 1)
      .then((cursor: ReplyPage) => {
        let isEnd = cursor.num * cursor.size >= cursor.count;
        this.refreshOpt.enableLoadMore = !isEnd;
        this.isEnd = isEnd;
        this.isLoading = false;
      });
  }

  build() {
    Column() {
      Row() {
        Text("评论详情").fontSize(16).fontColor("#333333")
          .fontWeight(FontWeight.Medium)
          .padding({ left: 16, right: 16 })
        Blank()
        Image($r('app.media.ic_close'))
          .width(48).height(48)
          .padding(12)
          .onClick(() => {
            this.replyItem = null;
          })
      }.width('100%').border({ width: { bottom: 0.5 }, color: '#cccccc' })

      if (this.isLoading) {
        Text('数据加载中···')
          .width('100%').layoutWeight(1)
          .fontSize(14).textAlign(TextAlign.Center)
      } else {
        PullToRefresh({
          // 必传项，列表组件所绑定的数据
          data: $data,
          // 必传项，需绑定传入主体布局内的列表或宫格组件
          scroller: this.scroller,
          refreshOpt: this.refreshOpt,
          // 必传项，自定义主体布局，内部有列表或宫格组件
          customList: this.getListView,
          // 可选项，下拉刷新回调
          onRefresh: () => {
            return new Promise<string>((resolve) => {
              this.pn = 1;
              DataSourceManager.getReplyDetailSource().setData([this.replyItem]);
              ApiManager.getInstance()
                .requestReplyDetail(this.vInfo.bvid, this.replyItem.rpid, this.pn, 1)
                .then((cursor: ReplyPage) => {
                  let isEnd = cursor.num * cursor.size >= cursor.count;
                  this.refreshOpt.enableLoadMore = !isEnd;
                  this.isEnd = isEnd;
                  resolve('');
                });
            });
          },
          // 可选项，上拉加载更多回调
          onLoadMore: () => {
            return new Promise<string>((resolve) => {
              this.pn++;
              ApiManager.getInstance()
                .requestReplyDetail(this.vInfo.bvid, this.replyItem.rpid, this.pn, 1)
                .then((cursor: ReplyPage) => {
                  // BLog.i("requestReplyDetail: pn=" + this.pn + ", cursor=" + JSON.stringify(cursor));
                  let isEnd = cursor.num * cursor.size >= cursor.count;
                  this.refreshOpt.enableLoadMore = !isEnd;
                  this.isEnd = isEnd;
                  resolve('');
                });
            });
          },
          customLoad: null,
          customRefresh: null,
        }).layoutWeight(1)
      }
    }.width('100%').height('100%')
  }

  @Builder
  private getListView(_, onListStatus: (isListStart: boolean, isListEnd: boolean) => void) {
    List({ scroller: this.scroller }) {
      LazyForEach(DataSourceManager.getReplyDetailSource(), (item: ReplyItem, index: number) => {
        ListItem() {
          if (index == 0) {
            Column() {
              ReplyItemView({ item: item }).padding({ left: 16, right: 16 })
              Flex().width('100%').height(16).backgroundColor("#eeeeee")
              Row() {
                Text("相关回复共" + item.rcount + "条")
                  .fontSize(14).fontColor("#888888")
                Blank()
              }.width('100%').padding({ left: 16, right: 16, top: 8, bottom: 8 })
            }
          } else {
            Column() {
              ReplyItemView({ item: item }).padding({ left: 16, right: 16 })
              Flex().width('100%').height(0.5)
                .backgroundColor('#ffeeeeee')
              if (index == DataSourceManager.getReplyDetailSource().getData(0).rcount) {
                Row() {
                  Text("已经到尽头了")
                    .fontSize(14).fontColor("#888888")
                    .width('100%').textAlign(TextAlign.Center)
                }.width('100%').padding({ left: 16, right: 16, top: 8, bottom: 8 })
              }
            }
          }
        }
      }, item => item.rpid + "")
    }
    .width('100%')
    .height('100%')
    .divider({ strokeWidth: 1, color: '#ffeeeeee' })
    .edgeEffect(EdgeEffect.None)
    .onScrollIndex((start, end) => {
      onListStatus(start == 0,
        end == DataSourceManager.getReplyDetailSource().totalCount() - 1)
    })
  }
}