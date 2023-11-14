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
import fs from '@ohos.file.fs';
import router from '@ohos.router';
import { StringUtil } from '@ohos/common';

@Entry
@Component
struct Feedback {
  @State logArr: LogFile[] = []
  @StorageLink('appLogDebug') appLogDebug: string = '0';
  @StorageLink('appUuid') appUuid: string = 'undefined';

  aboutToAppear() {
  }

  getLogFiles() {
    fs.listFile(`${globalThis.filesDir}/log`).then(files => {
      files.forEach(file => {
        let path = `${globalThis.filesDir}/log/${file}`;
        let size = fs.statSync(path).size;
        this.logArr.push(new LogFile(file, path, size));
      });
    });
  }

  build() {
    Column() {
      OhNavBar({ title: '反馈' })
      Scroll() {
        Column() {
          Text("为了能更快的定位问题，我们需要您完成以下操作：\n\n")
            .fontSize(16)
            .fontColor("#333333")
            .padding({ top: 16, left: 16, right: 16 })
          Text("1. 开启Debug日志；\n\n" +
          "2. 重启应用，重复异常操作流程；\n\n" +
          "3. 导出Debug日志；\n\n" +
          "4. 打开项目gitee网页，提交相关issue；")
            .width('100%')
            .fontSize(16)
            .fontColor("#333333")
            .padding(16)
          Row() {
            Button(this.appLogDebug == '1' ? "关闭Debug日志" : "开启Debug日志")
              .onClick(() => {
                if (this.appLogDebug == '1') {
                  this.appLogDebug = '0';
                } else {
                  this.appLogDebug = '1';
                }
              })
            Button("查看Debug日志")
              .margin({ left: 20 })
              .onClick(() => {
                this.getLogFiles();
              })
          }.width('100%').justifyContent(FlexAlign.Center)
          .margin({ top: 36, bottom: 36 })
          ForEach(this.logArr, (item: LogFile) => {
            Row() {
              Text(item.name)
              Blank()
              Text(StringUtil.generateSizeStr(item.size))
            }.padding(20).width('100%').onClick(() => {
              router.pushUrl({ url: "pages/LogDetail",
                params: { logFilePath: item.path }
              });
            })
          }, item => item.name)
        }
      }.layoutWeight(1)
      .align(Alignment.Top)
      .edgeEffect(EdgeEffect.Fade)
    }.width('100%').height('100%')
  }
}

class LogFile {
  name: string;
  path: string;
  size: number;

  constructor(name: string, path: string, size: number) {
    this.name = name;
    this.path = path;
    this.size = size;
  }
}