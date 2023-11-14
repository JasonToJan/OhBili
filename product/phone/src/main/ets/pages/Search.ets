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
import { RankingItem } from '@ohos/common';
import { ApiManager } from '@ohos/common';

@Entry
@Component
struct SearchPage {

  @State rankings: Array<RankingItem> = []
  private defaultKeyword = router.getParams()["defaultKeyword"]

  aboutToAppear() {
    ApiManager.getInstance().requestRanking().then((resp) => {
      this.rankings = resp.data.list;
    });
  }

  build() {
    Column() {
      SearchBar({placeholder: this.defaultKeyword})
      Row() {
        Text($r('app.string.bili_top_search'))
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
        Blank()
        Text("完整榜单").fontSize(14).fontColor("#888888").onClick(() => {
          router.pushUrl({ url: 'pages/TopSearch', params: { rankings: this.rankings } });
        })
      }.width('100%')
      .padding({ left: 16, right: 16, top: 16, bottom: 8 })
      Grid() {
        ForEach(this.rankings.slice(0, 10), (item: RankingItem) => {
          GridItem() {
            Flex({ direction: FlexDirection.Row }) {
              Text(item.keyword).maxLines(1)
                .fontSize(14)
                .textOverflow({overflow: TextOverflow.Ellipsis})
              if (item.icon != undefined && item.icon != "") {
                Image(item.icon)
                  .height(16)
                  .margin({left: 4})
              }
            }.width('100%').padding({ left: 16, right: 16, top: 8, bottom: 8 })
          }.onClick(() => {
            router.pushUrl({ url: "pages/SearchResult", params: { keyword: item.keyword } })
          })
        }, (item: RankingItem) => item.keyword)
      }.columnsTemplate('1fr 1fr')
      .width('100%')

    }.width('100%').alignItems(HorizontalAlign.Start)
  }
}