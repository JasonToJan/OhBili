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
export struct SettingTextItem {
  private title: string;
  @Link value: string;
  private arr: string[] = [];
  private callback: () => void = () => {
    if (this.arr.length > 0) {
      TextPickerDialog.show({
        range: this.arr,
        selected: this.arr.indexOf(this.value),
        onAccept: (value: TextPickerResult) => {
          this.value = this.arr[value.index]
        } })
    }
  }

  build() {
    Row() {
      Text(this.title).fontSize(14).fontColor('#333333')
      Blank()
      Text(this.value).fontSize(14).fontColor('#888888').onClick(this.callback)
    }.width('100%').height(50)
  }
}