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

import router from '@ohos.router'
import { ImageKnifeComponent, ImageKnifeOption, ScaleType,
  ImageKnifeDrawFactory } from '@ohos/imageknife'
import { RichString, RichStringType, StringUtil } from './../../utils/StringUtil'
import { BaseVideo } from './../../model/response/Response'

@Component
export struct PopularItemView {
  private item: BaseVideo
  private isReplaceUrl: boolean = false;

  build() {
    Row() {
      /*ImageKnifeComponent({ imageKnifeOption: this.getImageKnifeOption()})
        .width('50%')
        .aspectRatio(16 / 9)
        .margin({ right: 8 })*/

      Stack({alignContent: Alignment.BottomEnd}){
        Image(this.item.pic ? this.item.pic : $r('app.media.bg_default_show'))
          .width('100%')
          .aspectRatio(16 / 9)
          .borderRadius(4)
          .zIndex(1)
        Text(typeof(this.item.duration) == "number" ? StringUtil.parseSecondToVideoDuration(this.item.duration) : this.item.duration)
          .fontColor(Color.White)
          .fontSize(12)
          .backgroundColor("#c4434343")
          .borderRadius(2).zIndex(2).margin(6).padding(2)
      }.width('50%').padding({ right: 12 })

      Column() {
        Text(){
          ForEach(StringUtil.parseEmString(this.item.title),
            (item: RichString) => {
              if (item.type == RichStringType.EM) {
                Span(item.text).fontSize(16)
                  .fontColor(Color.Blue)
                  .fontWeight(FontWeight.Regular)
              } else {
                Span(item.text).fontSize(16)
                  .fontColor('#333333')
                  .fontWeight(FontWeight.Regular)
              }
            },
            item => item.text)
        }
        .width('100%')
        .textAlign(TextAlign.Start)
        .align(Alignment.Top)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        Blank()
        Row() {
          Image($r('app.media.music_icon_playlist_upper'))
            .width(16)
            .height(16)
            .margin({ right: 4 })
          Text(this.item.owner.name)
            .maxLines(1)
            .fontSize(12)
            .fontColor('#aaaaaa')
            .height(20)
            .width('100%')
        }.width('100%')

        Row() {
          Image($r('app.media.ic_play_count'))
            .width(16)
            .height(16)
            .margin({ right: 4 })
          Text($r('app.string.view_num', StringUtil.generateCN(this.item.stat.view)))
            .fontSize(12)
            .fontColor('#aaaaaa')
            .height(20)
            .maxLines(1)
          Text("·")
            .fontSize(12)
            .fontColor('#aaaaaa')
            .height(20)
            .margin({ left: 4, right: 4 })
          Text(StringUtil.timeStampToAgoDate(this.item.pubdate))
            .fontSize(12)
            .fontColor('#aaaaaa')
            .height(20)
            .width('100%')
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
      }.width('50%').aspectRatio(16 / 9)
    }
    .onClick(() => {
      if (this.isReplaceUrl) {
        router.replaceUrl({ url: 'pages/Video', params: { vInfo: this.item } });
      } else {
        router.pushUrl({ url: 'pages/Video', params: { vInfo: this.item } });
      }
    })
    .margin({ top: 8, bottom: 8 })
  }

  private getImageKnifeOption(): ImageKnifeOption {
    let imageKnifeOption: ImageKnifeOption =
      {
        loadSrc: this.item.pic ? this.item.pic : $r('app.media.bg_default_show'),
        mainScaleType: ScaleType.CENTER_CROP,
        placeholderSrc: $r('app.media.bg_default_show'),
        placeholderScaleType: ScaleType.CENTER_CROP,
        errorholderSrc: $r('app.media.img_load_fail_place_holder'),
        errorholderSrcScaleType: ScaleType.CENTER_CROP,
        drawLifeCycle:ImageKnifeDrawFactory.createRoundLifeCycle(0, "#ffffff", 4)
      };
    return imageKnifeOption;
  }
}