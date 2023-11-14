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

import { BaseVideo } from './../../model/response/Response';
import { StringUtil } from './../../utils/StringUtil';

@Component
export struct VideoTopBar {
  @Link vInfo: BaseVideo;

  build() {
    Row() {
      Column() {
        Image($r('app.media.ic_topbar_like_bold'))
          .width(24)
          .height(24)
        Text(StringUtil.generateCN(this.vInfo.stat.like))
          .fontSize(12)
          .fontColor('#333333')
          .margin({ top: 8 })
      }.layoutWeight(1)

      Column() {
        Image($r('app.media.ic_topbar_dislike_bold'))
          .width(24)
          .height(24)
        Text($r('app.string.dislike'))
          .fontSize(12)
          .fontColor('#333333')
          .margin({ top: 8 })
      }.layoutWeight(1)

      Column() {
        Image($r('app.media.ic_topbar_coin_bold'))
          .width(24)
          .height(24)
        Text(StringUtil.generateCN(this.vInfo.stat.coin == undefined ? 0 : this.vInfo.stat.coin))
          .fontSize(12)
          .fontColor('#333333')
          .margin({ top: 8 })
      }.layoutWeight(1)

      Column() {
        Image($r('app.media.ic_topbar_favorite_bold'))
          .width(24)
          .height(24)
        Text(StringUtil.generateCN(this.vInfo.stat.favorite == undefined ? 0 : this.vInfo.stat.favorite))
          .fontSize(12)
          .fontColor('#333333')
          .margin({ top: 8 })
      }.layoutWeight(1)

      Column() {
        Image($r('app.media.ic_topbar_share_bold'))
          .width(24)
          .height(24)
        Text(StringUtil.generateCN(this.vInfo.stat.share == undefined ? 0 : this.vInfo.stat.share))
          .fontSize(12)
          .fontColor('#333333')
          .margin({ top: 8 })
      }.layoutWeight(1)
    }.width('100%').padding(16)
  }
}