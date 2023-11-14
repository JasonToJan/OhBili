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
import { BaseVideo } from './../../model/response/Response'
import { BLog } from './../../utils/BLog'
import { StringUtil } from './../../utils/StringUtil'

@Component
export struct RecommendItemView {
  private item: BaseVideo
  private ratio: number = 4/3

  build() {
    Column() {
      Stack() {
        /*ImageKnifeComponent({ imageKnifeOption: this.getImageKnifeOption()})
          .width('100%')
          .height('100%')*/
        Image(this.item.pic ? this.item.pic : $r('app.media.bg_default_show'))
          .width('100%')
          .height('100%')
          .borderRadius({ topLeft: 4, topRight: 4 })
        Row() {
          Image($r('app.media.ic_play_count_white'))
            .width(16)
            .height(16)
          Text(StringUtil.generateCN(this.item.stat.view))
            .fontSize(11)
            .fontColor(Color.White)
            .margin({ left: 4, right: 8 })
          Image($r('app.media.ic_danmakus_white'))
            .width(16)
            .height(16)
          Text(this.item.stat.danmaku + "")
            .fontSize(11)
            .fontColor(Color.White)
            .margin({ left: 4, right: 8 })
          Blank()
          Text(StringUtil.stringForTime(<number>this.item.duration * 1000))
            .fontSize(11)
            .fontColor(Color.White)
        }.width('100%').padding(4).linearGradient({
          colors: [["#00000000", 0.0], ["#aa000000", 1.0]]
        })
      }.width('100%')
      .aspectRatio(this.ratio)
      .alignContent(Alignment.BottomStart)

      Text(this.item.title)
        .fontSize(14)
        .fontColor('#333333')
        .fontWeight(FontWeight.Regular)
        .height(48)
        .width('100%')
        .textAlign(TextAlign.Start)
        .maxLines(2)
        .align(Alignment.Top)
        .padding({ left: 12, right: 12, top: 12 })
      Row() {
        Image($r('app.media.music_icon_playlist_upper'))
          .width(16)
          .height(16)
          .margin({ left: 12, right: 8 })
        Text(this.item.owner.name)
          .maxLines(1)
          .fontSize(12)
          .fontColor('#aaaaaa')
          .height(30)
          .width('100%')
      }
    }
    .onClick(() => {
      router.pushUrl({ url: 'pages/Video', params: { vInfo: this.item } });
    })
    .borderRadius(4)
    .backgroundColor('#ffffff')
    .shadow({radius: 3, color: "#ff6d6d6d"})
  }

  private getImageKnifeOption(): ImageKnifeOption {
    BLog.i("item.pic: " + this.item.pic);
    let imageKnifeOption: ImageKnifeOption =
      {
        loadSrc: this.item.pic ? this.item.pic : $r('app.media.bg_default_show'),
        mainScaleType: ScaleType.CENTER_CROP,
        placeholderSrc: $r('app.media.bg_default_show'),
        placeholderScaleType: ScaleType.CENTER_CROP,
        errorholderSrc: $r('app.media.img_load_fail_place_holder'),
        errorholderSrcScaleType: ScaleType.CENTER_CROP,
        drawLifeCycle:ImageKnifeDrawFactory.createRoundLifeCycle(0, "#ffffff", 8)
      };
    return imageKnifeOption;
  }
}