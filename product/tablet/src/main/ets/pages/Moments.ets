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

import { OhNavBar } from '@ohos/common'
import promptAction from '@ohos.promptAction'

@Component
export struct MomentsView {
  build() {
    Column() {
      OhNavBar({ title: "动态", isBack: false, isTitleCenter: true })

      Text("你还未登录").fontSize(16).fontColor(Color.Black).fontWeight(FontWeight.Medium).margin({top: 48})
      Text("登录账号，查看你关注的UP主内容").fontSize(15).fontColor('#888888').margin({top: 16})
      Button("登录").width(240).margin({top: 16}).onClick(() => {
        promptAction.showToast({
          message: '登录功能暂未实现',
          duration: 2000
        });
      })
    }.width('100%').height('100%')
  }
}