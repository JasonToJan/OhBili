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
export struct UserStateView {
  build() {
    Row() {
      Column() {
        Text("-")
          .fontSize(14)
          .fontColor('#333333')
        Text($r('app.string.dynamic_state'))
          .fontSize(12)
          .fontColor('#888888')
          .margin({ top: 4 })
      }.layoutWeight(1)

      Flex().width(1).height(20).backgroundColor("#eeeeee")

      Column() {
        Text("-")
          .fontSize(14)
          .fontColor('#333333')
        Text($r('app.string.attention'))
          .fontSize(12)
          .fontColor('#888888')
          .margin({ top: 4 })
      }.layoutWeight(1)

      Flex().width(1).height(20).backgroundColor("#eeeeee")

      Column() {
        Text("-")
          .fontSize(14)
          .fontColor('#333333')
        Text($r('app.string.fans'))
          .fontSize(12)
          .fontColor('#888888')
          .margin({ top: 4 })
      }.layoutWeight(1)
    }.width('100%').margin({ bottom: 16 })
  }
}