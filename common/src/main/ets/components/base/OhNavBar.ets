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
import router from '@ohos.router';

@Component
export struct OhNavBar {
  private isTitleCenter = false;
  private isBack = true;
  private title: string;
  private bgColor: ResourceColor = Color.White;
  private shadowRadius: number = 0;
  build() {
    Stack() {
      Row() {
        if (this.isBack) {
          Image($r('app.media.ic_page_back'))
            .width(42).height(42)
            .margin({left: 16})
            .objectFit(ImageFit.Contain).padding(12)
            .onClick(() => {
              router.back();
            })
        }
        if (!this.isTitleCenter) {
          Text(this.title)
            .fontSize(16)
            .fontColor(Color.Black)
            .fontWeight(FontWeight.Medium)
            .padding({ left: 12, right: 12 })
        }
        Blank()
      }.width('100%').height('100%')
      if (this.isTitleCenter) {
        Row() {
          Text(this.title)
            .width('100%')
            .fontSize(20)
            .fontColor(Color.Black)
            .fontWeight(FontWeight.Medium)
            .textAlign(TextAlign.Center)
        }.width('100%').height('100%')
      }
    }.width('100%').height(48)
    .border({width: {bottom: 0.5}, color: '#cccccc'})
    .backgroundColor(this.bgColor)
    .shadow({radius: this.shadowRadius, color: Color.Gray})
  }
}