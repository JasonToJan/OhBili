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
import { ReplyItem } from './../../model/response/ReplyResponse';
import { ResUtils } from './../../utils/ResUtils';
import { StringUtil } from './../../utils/StringUtil';


@Component
export struct ReplyItemView {
  private item: ReplyItem;
  private isShowReply: boolean = false;
  private onItemClick: () => void = () => {}

  build() {
    Row() {
      Image(this.item.member.avatar ? this.item.member.avatar : $r('app.media.icon'))
        .width(32)
        .height(32)
        .borderRadius(16)
        .margin({ right: 16 })
      Column() {
        Row() {
          Text(this.item.member.uname)
            .fontSize(14)
            .fontColor('#333333')
            .fontWeight(FontWeight.Regular)
            .maxLines(1)
          Image(ResUtils.getLevel(this.item.member.level_info.current_level))
            .height(12)
            .margin({ left: 6 })
        }.width('100%')
        .justifyContent(FlexAlign.Start)

        Row() {
          Text(StringUtil.timeStampToAgoDate(this.item.ctime))
            .fontSize(11)
            .fontColor('#aaaaaa')
            .height(20)
          Text("IP属地:")
            .fontSize(11)
            .fontColor('#aaaaaa')
            .height(20)
            .margin({ left: 6 })
        }.width('100%')
        .justifyContent(FlexAlign.Start)

        Text(this.item.content.message)
          .fontSize(16)
          .fontColor('#333333')
          .fontWeight(FontWeight.Regular)
          .width('100%')
          .textAlign(TextAlign.Start)
          .maxLines(this.item.content.max_line)
          .margin({ top: 12, bottom: 12 })

        Row() {
          Image($r('app.media.ic_upper_likes'))
            .height(20)
          Text(this.item.like + "")
            .fontSize(11)
            .fontColor('#aaaaaa')
            .height(20)
            .margin({ left: 6 })
          Image($r('app.media.ic_upper_dislike'))
            .height(20)
            .margin({ left: 16 })
          Image($r('app.media.ic_upper_shares'))
            .height(20)
            .margin({ left: 16 })
          Image($r('app.media.ic_upper_comments'))
            .height(20)
            .margin({ left: 16 })
        }.width('100%')
        .justifyContent(FlexAlign.Start)

        if (this.item.replies != null && this.isShowReply) {
          Column() {
            ForEach(this.item.replies,
              (item: ReplyItem) => {
                Column() {
                  Text(){
                    Span(item.member.uname + ' ').fontSize(14)
                      .fontColor(Color.Blue).padding({ right: 4 })
                    Span(item.content.message).fontSize(14)
                      .fontColor('#333333')
                  }.width('100%')
                  .textAlign(TextAlign.Start)
                  .maxLines(2)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                }.padding({ top: 12 })
              }, item => item.mid)

            if (this.item.replies.length >= 3) {
              Text("共" + this.item.rcount + "条回复 >")
                .fontSize(14)
                .fontColor(Color.Blue)
                .width('100%')
                .textAlign(TextAlign.Start)
                .margin({ top: 12 })
                .onClick(() => {
                  this.onItemClick();
                })
            }
          }
          .width('100%')
          .padding({ left: 8, right: 8, bottom: 12 })
          .margin({ top: 8 })
          .backgroundColor("#88eeeeee")
          .borderRadius(4)
        }

      }.layoutWeight(1).alignItems(HorizontalAlign.Start)
    }.width('100%')
    .justifyContent(FlexAlign.Start)
    .alignItems(VerticalAlign.Top)
    .margin({ top: 8, bottom: 8 })
  }
}