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

@Component
export struct MoreServerView {
  build() {
    Column() {
      Text($r('app.string.more_service'))
        .fontSize(18)
        .fontColor('#333333')
        .fontWeight(FontWeight.Medium).margin({ left: 16, top: 24, right: 16, bottom: 24 })

      Row() {
        Image($r('app.media.ic_setting'))
          .width(24)
          .height(24)
        Text($r('app.string.setting'))
          .fontSize(16)
          .fontColor('#333333')
          .margin({ left: 16 })
        Blank()
        Image($r('app.media.ic_arrow_right'))
          .objectFit(ImageFit.Auto)
          .width(20)
          .height(20)
      }.width('100%')
      .padding({ left: 24, top: 16, right: 12, bottom: 16 })
      .onClick(() => {
        router.pushUrl({ url: "pages/Setting" });
      })

      Row() {
        Image($r('app.media.ic_feedback'))
          .width(24)
          .height(24)
        Text($r('app.string.problem_feedback'))
          .fontSize(16)
          .fontColor('#333333')
          .margin({ left: 16 })
        Blank()
        Image($r('app.media.ic_arrow_right'))
          .objectFit(ImageFit.Auto)
          .width(20)
          .height(20)
      }.width('100%')
      .padding({ left: 24, top: 16, right: 12, bottom: 16 })
      .onClick(() => {
        router.pushUrl({ url: "pages/Feedback" });
      })

      Row() {
        Image($r('app.media.ic_about'))
          .width(24)
          .height(24)
        Text($r('app.string.about'))
          .fontSize(16)
          .fontColor('#333333')
          .margin({ left: 16 })
        Blank()
        Image($r('app.media.ic_arrow_right'))
          .objectFit(ImageFit.Auto)
          .width(20)
          .height(20)
      }.width('100%')
      .padding({ left: 24, top: 16, right: 12, bottom: 16 })
      .onClick(() => {
        router.pushUrl({ url: "pages/About" });
      })

    }.width('100%')
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Start)
  }
}