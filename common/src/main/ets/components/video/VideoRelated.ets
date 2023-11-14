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
import { ApiManager } from '../../network/ApiManager';

import { BaseVideo } from './../../model/response/Response';
import { RichString, RichStringType, StringUtil } from './../../utils/StringUtil';

@Component
export struct VideoInfoView {
  @Link vInfo: BaseVideo;
  @State isShowMore: boolean = false;
  @Link isFollowing: boolean;
  @Link fansCount: number;
  @Link archiveCount: number;

  build() {
    Column() {
      Row() {
        Image(this.vInfo.owner.face)
          .objectFit(ImageFit.Auto)
          .width(32)
          .height(32)
          .borderRadius(16)
        Column() {
          Text(this.vInfo.owner.name).fontSize(14)
          Row() {
            Text(`${this.fansCount>10000?(this.fansCount/10000).toFixed(1):this.fansCount}`).fontSize(10).fontColor(Color.Gray)
            if(this.fansCount > 10000) {
              Text($r("app.string.unit_million")).fontSize(10).fontColor(Color.Gray)
            }
            Text($r("app.string.fans")).fontSize(10).fontColor(Color.Gray)
            Text(`${this.archiveCount>10000?(this.archiveCount/10000).toFixed(1):this.archiveCount}`).fontSize(10).margin({ left: 8 }).fontColor(Color.Gray)
            if(this.archiveCount > 10000) {
              Text($r("app.string.unit_million")).fontSize(10).fontColor(Color.Gray)
            }
            Text($r('app.string.video')).fontSize(10).fontColor(Color.Gray)
          }
        }.margin({ left: 12 }).alignItems(HorizontalAlign.Start)

        Blank()
        if(this.isFollowing){
          Button($r('app.string.subscribed')).height(24).fontSize(16).backgroundColor(Color.Gray);
        }else{
          Button($r('app.string.attention')).height(24).fontSize(16)
        }
      }.width('100%').justifyContent(FlexAlign.Start)

      Row() {
        Text() {
          ForEach(StringUtil.parseEmString(this.vInfo.title),
            (item: RichString) => {
              if (item.type == RichStringType.EM) {
                Span(item.text).fontSize(16)
                  .fontColor(Color.Blue)
                  .fontWeight(FontWeight.Medium)
              } else {
                Span(item.text).fontSize(16)
                  .fontColor('#333333')
                  .fontWeight(FontWeight.Medium)
              }
            },
            item => item.text)
        }
        .layoutWeight(1)
        .textAlign(TextAlign.Start)
        .align(Alignment.Top)
        .maxLines(this.isShowMore ? 3 : 1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

        Image(this.isShowMore ? $r('app.media.ic_arrow_up') :
        $r('app.media.ic_arrow_down'))
          .objectFit(ImageFit.Auto)
          .width(18)
          .height(18)
          .onClick(() => {
            this.isShowMore = !this.isShowMore;
          })
      }.width('100%')
      .justifyContent(FlexAlign.Start)
      .padding({ top: 8, bottom: 8 })

      Row() {
        Image($r('app.media.ic_play_count'))
          .width(16)
          .height(16)
        Text(StringUtil.generateCN(this.vInfo.stat.view))
          .fontSize(11)
          .fontColor("#888888")
          .margin({ left: 4, right: 8 })
        Image($r('app.media.ic_danmakus'))
          .width(16)
          .height(16)
        Text(StringUtil.generateCN(this.vInfo.stat.danmaku))
          .fontSize(11)
          .fontColor("#888888")
          .margin({ left: 4, right: 8 })
        Text(StringUtil.dateFormat(new Date(this.vInfo.pubdate * 1000), "yyyy年MM月dd日 HH:mm"))
          .fontSize(11)
          .fontColor("#888888")
      }.width('100%').justifyContent(FlexAlign.Start)

      if (this.isShowMore) {
        Column() {
          Row() {
            Text(this.vInfo.bvid)
              .fontSize(11)
              .fontColor("#888888")
          }.width('100%').justifyContent(FlexAlign.Start)
          .padding({ top: 8 })

          Text(this.vInfo.desc)
            .fontSize(11)
            .fontColor("#888888")
            .padding({ top: 8 })
        }
      }
    }.margin(12)
  }
}