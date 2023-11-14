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
import { RankingItem } from '@ohos/common';

@Entry
@Component
struct TopSearchPage {
  private rankings: Array<RankingItem> = router.getParams()['rankings']

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_page_back'))
          .objectFit(ImageFit.Auto)
          .width(18)
          .height(18)
          .margin({ left: 16 })
          .onClick(() => {
            router.back();
          })
        Text("bilibili热搜")
          .fontSize(32)
          .fontWeight(FontWeight.Bold)
          .fontColor("#1698CE")
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
        Flex().width(18)
          .height(18)
          .margin({ right: 16 })
      }.margin({ top: 12, bottom: 24 })

      Flex().width('100%').height(1)
        .backgroundColor('#ffeeeeee')
      List() {
        ForEach(this.rankings, (item: RankingItem) => {
          ListItem() {
            Flex({ direction: FlexDirection.Row }) {
              Text(item.position + "")
                .maxLines(1)
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.Gray)
                .width(30)
              Text(item.keyword).maxLines(1)
                .fontSize(16)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
              if (item.icon != undefined && item.icon != "") {
                Image(item.icon)
                  .height(16)
                  .margin({ left: 4 })
              }
              // Blank()
              Image($r('app.media.ic_arrow_right'))
                .objectFit(ImageFit.Auto)
                .width(18)
                .height(18)
                .margin({ left: 16 })
            }.width('100%').padding({ top: 12, bottom: 12 })
          }.onClick(() => {
            router.pushUrl({ url: "pages/SearchResult", params: { keyword: item.keyword } })
          })
        }, (item: RankingItem) => item.keyword)
      }
      .width('100%')
      .padding({ left: 20, right: 20 })
      .divider(({ strokeWidth: 1, color: '#ffeeeeee' }))
      .layoutWeight(1)
    }.height('100%')
  }
}