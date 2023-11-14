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

import promptAction from '@ohos.promptAction'
import router from '@ohos.router';

@Component
export struct UserHeadView {
  @StorageLink('isOhBiliLoggedIn') loginState: boolean = false;
  build() {
    Row() {
      Image($r("app.media.ic_live_no_face_dark"))
        .width(64)
        .height(64)
        .borderRadius(32)
        .margin({ left: 16, right: 16 })

      if(!this.loginState)
      {
        Text($r('app.string.click_login'))
          .fontSize(18)
          .fontColor('#333333')
          .fontWeight(FontWeight.Medium)
          .maxLines(1)
      }

      Blank()

      Image($r('app.media.ic_arrow_right'))
        .objectFit(ImageFit.Auto)
        .width(20)
        .height(20)
        .margin({ left: 16, right: 16 })

    }.margin({ top: 32, bottom: 32 }).width('100%')
    .justifyContent(FlexAlign.Start)
    .onClick(() => {
      if(!this.loginState){
        router.pushUrl({url: "pages/Login"})
        return;
      }
    })
  }
}