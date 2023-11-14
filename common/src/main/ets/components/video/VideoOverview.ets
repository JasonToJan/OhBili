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

import { VideoInfoView } from './VideoRelated';
import { VideoTopBar } from './VideoTopBar';
import { PopularItemView } from '../home/PopularItem';
import { BaseVideo } from './../../model/response/Response';
import { DataSourceManager } from './../../model/DataSourceManager';

@Component
export struct VideoOverview {
  @Link vInfo: BaseVideo;
  @Link isFollowing: boolean;
  @Link fansCount: number;
  @Link archiveCount: number;
  scroller: Scroller = new Scroller();
  @State dataList: BaseVideo[] = [];

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      List({ scroller: this.scroller }) {
        LazyForEach(DataSourceManager.getRelatedSource(this.vInfo.bvid), (item: BaseVideo, index: number) => {
          ListItem() {
            if (index == 0) {
              VideoInfoView({ vInfo: $vInfo, isFollowing: $isFollowing, fansCount: $fansCount, archiveCount: $archiveCount })
            } else if (index == 1) {
              VideoTopBar({ vInfo: $vInfo })
            } else {
              Column() {
                Flex().width('100%').height(1)
                  .backgroundColor('#ffeeeeee')
                PopularItemView({ item: item, isReplaceUrl: true })
              }.padding({ left: 16, right: 16 })
            }
          }
        }, item => item.bvid)
      }
    }.width('100%').height('100%')
  }
}