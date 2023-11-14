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
import fs from '@ohos.file.fs';
import { OhNavBar } from '@ohos/common';
@Entry
@Component
struct LogDetail {
  private logFilePath: string = router.getParams()['logFilePath'];
  @State logStr: string = ""

  aboutToAppear() {
    this.logStr = fs.readTextSync(this.logFilePath)
  }

  build() {
    Column() {
      OhNavBar({ title: '日志详情' })
      Scroll() {
        Text(this.logStr).fontSize(14).width('100%').padding(8)
      }.layoutWeight(1)
      .align(Alignment.Top)
      .edgeEffect(EdgeEffect.Fade)
    }.width('100%').height('100%')
  }
}