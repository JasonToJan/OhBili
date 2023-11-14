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

@Component
export struct MineOptView {
  build() {
    Row() {
      Column() {
        Image($r('app.media.ic_mine_offline'))
          .width(24)
          .height(24)
        Text($r('app.string.offline_cache'))
          .fontSize(12)
          .fontColor('#333333')
          .margin({ top: 8 })
      }.layoutWeight(1)

      Column() {
        Image($r('app.media.ic_mine_history'))
          .width(24)
          .height(24)
        Text($r('app.string.history_record'))
          .fontSize(12)
          .fontColor('#333333')
          .margin({ top: 8 })
      }.layoutWeight(1)

      Column() {
        Image($r('app.media.ic_mine_favorite'))
          .width(24)
          .height(24)
        Text($r('app.string.my_favorite'))
          .fontSize(12)
          .fontColor('#333333')
          .margin({ top: 8 })
      }.layoutWeight(1)

      Column() {
        Image($r('app.media.ic_mine_watchlater'))
          .width(24)
          .height(24)
        Text($r('app.string.watch_later'))
          .fontSize(12)
          .fontColor('#333333')
          .margin({ top: 8 })
      }.layoutWeight(1)
    }.width('100%').margin({ top: 16, bottom: 16 })
  }
}