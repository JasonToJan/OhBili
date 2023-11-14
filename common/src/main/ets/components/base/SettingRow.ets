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
export struct SettingRow {
  icon?: string | PixelMap | Resource
  title: string
  info?: string | Resource
  clickHandler?: (event?: ClickEvent) => void
  showRightArrow?: boolean = true

  build() {
    Row() {
      Image(this.icon).width(26).height(26).borderRadius(13).margin({ left: 14 })
      Column() {
        Text(this.title).fontSize(16).fontColor('#333333')
          .alignSelf(ItemAlign.Start)
          .margin({ top: 4 })
        Text(this.info)
          .fontSize(12)
          .fontColor('#888888')
          .maxLines(2)
          .alignSelf(ItemAlign.Start)
          .margin({ top: 4, bottom: 4 })
      }.padding({ left: 14, right: 14 })
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Center)

      Blank();
      if (this.showRightArrow) {
        Image($r('app.media.ic_arrow_right'))
          .width(12).height(24)
          .objectFit(ImageFit.Contain).margin({ right: 14 })
      }
    }
    .width('100%')
    .onClick(this.clickHandler)
    .margin({ top: 5, bottom: 5 })
  }
}