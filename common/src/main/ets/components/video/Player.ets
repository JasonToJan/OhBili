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

import prompt from '@ohos.prompt';
import router from '@ohos.router';
import window from '@ohos.window';
import { IPlayer } from '../../player/IPlayer';
import { AvPlayer } from '../../player/AvPlayer';
import { IjkPlayer } from '../../player/IjkPlayer';
import { IPlayStatus } from '../../player/IPlayStatus';

import {
  DanmakuView,
  IDanmakus,
  DanmakuContext,
  Proxy,
  BaseDanmaku,
  BaseDanmakuParser,
  DANMAKU_STYLE_STROKEN,
  SpannedCacheStuffer,
  Callback,
  OnDanmakuClickListener,
  IDanmakuView,
  DanmakuTimer
} from '@ohos/danmakuflamemaster'
import display from '@ohos.display';
import { ProtoSource } from '../../model/proto/ProtoSource';
import { DanmakuParser } from '../../model/proto/DanmakuParser';
import { BLog } from '../../utils/BLog';
import { WindowManager } from '../../utils/WindowManager';
import { ApiManager } from '../../network/ApiManager';
import { PlayUrlResponse } from '../../model/response/PlayUrlResponse';
import { VideoPartsResponse } from '../../model/response/VideoPartsResponse';
import { ApiConstants } from '../../network/ApiConstants';

let PROGRESS_MAX_VALUE: number = 100;
let DANMAKU_TIME: number = 360000;
let playerType = "IjkPlayer";

@Component
export struct PlayerView {
  private cid: number;
  private bvid: string;
  @StorageLink('isPortrait') isPortrait: boolean = true
  @Link @Watch('onPageStateUpdated') pageState: string;
  private player: IPlayer = (playerType == "IjkPlayer" ? new IjkPlayer() : new AvPlayer());
  @State progressValue: number = 0;
  @State currentTime: string = "00:00";
  @State totalTime: string = "00:00";
  @State loadingVisible: boolean = false;
  @State replayVisible: boolean = false;
  @State slideEnable: boolean = false;
  @State aspRatio: number = 16 / 9;
  @State mFirst: boolean = true;
  @State mState: IPlayStatus = IPlayStatus.INIT;
  @State mIsShowCtl: boolean = false;
  private fullScreenRatio: number = 16 / 9;
  @State mIsShowDanmaku: boolean = true;
  @State mDanmakuModel: DanmakuView.Model = new DanmakuView.Model();
  private mDanmakuContext: DanmakuContext;
  private mParser: BaseDanmakuParser;
  private mPlayUrl: string = "";
  private mPlayContext: object = null;
  private mCacheStufferAdapter: Proxy = new class extends Proxy {
    public prepareDrawing(danmaku: BaseDanmaku, fromWorkerThread: boolean): void {
    }

    public releaseResource(danmaku: BaseDanmaku): void {
      // TODO 重要:清理含有ImageSpan的text中的一些占用内存的资源 例如drawable
    }
  };
  @State @Watch('onDanmakuPnUpdated') danmakuPn: number = 1;

  private createParser(source: ProtoSource): BaseDanmakuParser {
    let parser: BaseDanmakuParser = new DanmakuParser();
    parser.load(source);
    return parser;
  }

  onPageStateUpdated(propName: string): void {
    BLog.i('BiliPlayer bvid:' + this.bvid + ', pageState:' + this.pageState);
    switch (this.pageState) {
      case "onPageShow":
        if (!this.mFirst) {
          if (this.bvid == this.player.getPlayId()) {
            BLog.i('BiliPlayer play');
            this.player.play();
          } else {
            BLog.i('BiliPlayer initPlay');
            this.player.setPlayId(this.bvid);
            this.player.initPlay(this.mPlayContext).then(_ => {
              this.initPlay(this.mPlayUrl);
            });
          }
        }
        break;
      case "onPageHide":
        this.player.pause();
        break;
      case "aboutToDisappear":
        if (this.bvid == this.player.getPlayId()) {
          BLog.i('BiliPlayer aboutToDisappear');
          this.player.setScreenOn(false);
          if (this.mState != IPlayStatus.INIT) {
            this.player.stop();
          }
        }
        if (!this.isPortrait) {
          WindowManager.changeWindowDirection(window.Orientation.PORTRAIT)
          this.isPortrait = true
          WindowManager.setFullScreen(this.isPortrait);
        }
        break;
      default:
        break;
    }
  }

  onDanmakuPnUpdated(propName: string): void {
    this.getDanmaku(false);
  }

  aboutToAppear() {
    let dis = display.getDefaultDisplaySync();
    if (dis != null) {
      var height = dis.height;
      dis.getCutoutInfo().then((info) => {
        info.boundingRects.forEach(rect => {
          height -= rect.height;
        });
        this.fullScreenRatio = height / dis.width;
      })
    }
    this.player.setPlayId(this.bvid);
    if (this.cid > 0) {
      this.getDanmaku(true);
    }
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      XComponent({
        id: this.player.id(),
        type: 'surface',
        libraryname: this.player.libraryName(),
        controller: this.player.controller()
      })
        .onLoad((context) => {
          this.mPlayContext = context;
          this.player.initPlay(this.mPlayContext).then(_ => {
            if (this.cid == 0) {
              this.getPageList(this.bvid);
            } else {
              this.getPlayUrl(this.bvid, this.cid);
            }
          });
        })
        .width('100%')
        .aspectRatio(this.aspRatio)

      if (!this.mIsShowCtl) {
        Column() {
          Blank()
          Progress({ value: this.progressValue, total: PROGRESS_MAX_VALUE,
            type: ProgressType.Linear })
            .color(Color.Red)
            .backgroundColor(Color.Transparent)
            .width('100%')
            .height(2)
        }.height('100%')
      }

      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center,
        justifyContent: FlexAlign.Center }) {
        DanmakuView({ model: $mDanmakuModel })
      }.width('100%')
      .height('100%')

      PlayerControlView({
        player: this.player,
        mDanmakuModel: this.mDanmakuModel,
        loadingVisible: $loadingVisible,
        replayVisible: $replayVisible,
        progressValue: $progressValue,
        currentTime: $currentTime,
        totalTime: $totalTime,
        slideEnable: $slideEnable,
        mState: $mState,
        mIsShowCtl: $mIsShowCtl,
        danmakuPn: $danmakuPn,
        mIsShowDanmaku: $mIsShowDanmaku
      })

      if (this.replayVisible){
        Column() {
          Image($r('app.media.icon_replay'))
            .objectFit(ImageFit.Auto)
            .width(48)
            .height(48)
            .border({ width: 0 })
            .borderStyle(BorderStyle.Dashed)
            .onClick(() => {
              this.showLoadIng();
              this.player.play();
            })
        }.width('100%').height('100%')
        .backgroundColor('#33000000')
        .justifyContent(FlexAlign.Center)
      }

      if (this.loadingVisible) {
        Column() {
          Image($r('app.media.icon_load'))
            .objectFit(ImageFit.Auto)
            .width(48)
            .height(48)
            .border({ width: 0 })
            .borderStyle(BorderStyle.Dashed)
        }.width('100%').height('100%')
        .backgroundColor('#33000000')
        .justifyContent(FlexAlign.Center)
      }

    }.width('100%')
    .aspectRatio(this.isPortrait ? 16 / 9 : this.fullScreenRatio)
    .backgroundColor(Color.Black)
  }

  private getPageList(bvid: string) {
    ApiManager.getInstance().requestPageList(bvid).then((resp: VideoPartsResponse) => {
      this.cid = resp.data[0].cid;
      this.getDanmaku(true);
      this.getPlayUrl(this.bvid, this.cid);
    });
  }

  private getDanmaku(isInit: boolean) {
    BLog.i("getDanmaku index: " + this.danmakuPn + ", isInit: " + isInit);
    ApiManager.getInstance().requestDmList(this.cid, 1, this.danmakuPn).then((source) => {
      if (isInit) {
        this.initDanmaku(source);
      } else {
        this.updateDanmaku(source);
      }
    });
  }

  private getPlayUrl(bvid: string, cid: number) {
    ApiManager.getInstance().requestPlayUrl(bvid, cid).then((resp: PlayUrlResponse) => {
      this.mPlayUrl = resp.data.durl[0].url.replace(/\\u0026/g, '&')
      BLog.i("requestPlayUrl Response Data url=" + this.mPlayUrl);
      this.initPlay(this.mPlayUrl);
    });
  }

  private showLoadIng() {
    this.loadingVisible = true;
    this.replayVisible = false;
  }

  private hideLoadIng() {
    this.loadingVisible = false;
    this.replayVisible = false;
  }

  private showRePlay() {
    this.loadingVisible = false;
    this.replayVisible = true;
  }

  private initPlay(url: string) {
    let thisClass = this;
    this.player.setOnTimeUpdateCallback({
      onTimeUpdate(current: number, total: number) {
        if (total > 0) {
          thisClass.slideEnable = true;
          let curPercent = current / total;
          let pos = curPercent * 100;
          thisClass.progressValue = pos;

          if (current != 0 && thisClass.danmakuPn * DANMAKU_TIME < current) {
            thisClass.danmakuPn = Math.floor(current / DANMAKU_TIME) + 1;
          }
        }
      }
    });
    this.player.setOnTimeStrUpdateCallback({
      onTimeStrUpdate(current: string, total: string) {
        thisClass.currentTime = current;
        thisClass.totalTime = total;
      }
    });
    this.player.setOnSizeChangeCallback({
      OnSizeChange(width: number, height: number) {
        thisClass.aspRatio = width / height;
      }
    });
    this.player.setOnStateChangeCallback({
      OnStateChange(status: IPlayStatus) {
        thisClass.mState = status;
        if (status == IPlayStatus.INIT) {
          thisClass.mFirst = true;
          thisClass.showLoadIng();
        } else if (status == IPlayStatus.PREPARED) {
          thisClass.mFirst = false;
          thisClass.hideLoadIng();
        } else if (status == IPlayStatus.PLAY) {
          thisClass.hideLoadIng();
          thisClass.mDanmakuModel.resume();
        } else if (status == IPlayStatus.PAUSE) {
          thisClass.hideLoadIng();
          thisClass.mDanmakuModel.pause();
        } else if (status == IPlayStatus.ERROR) {
          thisClass.hideLoadIng();
          prompt.showToast({
            message: "亲，视频播放异常，系统开小差咯"
          });
        } else if (status == IPlayStatus.DONE) {
          thisClass.showRePlay();
          thisClass.slideEnable = false;
        }
      }
    });
    this.showLoadIng();
    this.setDataSource(url);
  }

  private setDataSource(url: string) {
    let headers = new Map([
      ["User-Agent", ApiConstants.userAgent],
      ["Connection", "keep-alive"],
      ["Referer", ApiConstants.biliBase]
    ]);
    this.player.setDataSource(url, headers);
  }

  private initDanmaku(source: ProtoSource) {
    let maxLinesPair: Map<number, number> = new Map();
    maxLinesPair.set(BaseDanmaku.TYPE_SCROLL_RL, 20); // 滚动弹幕最大显示5行
    // 设置是否禁止重叠
    let overlappingEnablePair: Map<number, boolean> = new Map();
    overlappingEnablePair.set(BaseDanmaku.TYPE_SCROLL_RL, true);
    overlappingEnablePair.set(BaseDanmaku.TYPE_FIX_TOP, true);
    this.mDanmakuContext = DanmakuContext.create();
    this.mDanmakuContext.setDanmakuStyle(DANMAKU_STYLE_STROKEN, 3)
      .setDuplicateMergingEnabled(false)
      .setScrollSpeedFactor(1.2)
      .setScaleTextSize(1.2)
      .setCacheStuffer(new SpannedCacheStuffer(), this.mCacheStufferAdapter) // 图文混排使用SpannedCacheStuffer
      .setMaximumLines(maxLinesPair)
      .preventOverlapping(overlappingEnablePair)
      .setDanmakuMargin(40);
    let that = this
    if (this.mDanmakuModel != null) {
      this.mParser = this.createParser(source);
      this.mDanmakuModel.setCallback(new class implements Callback {
        public updateTimer(timer: DanmakuTimer): void {
        }

        public drawingFinished(): void {

        }

        public danmakuShown(danmaku: BaseDanmaku): void {
        }

        public prepared(): void {
          if (that.mState == IPlayStatus.PLAY) {
            that.mDanmakuModel.start();
          }
        }
      });

      this.mDanmakuModel.setOnDanmakuClickListener(new class implements OnDanmakuClickListener {
        onDanmakuClick(danmakus: IDanmakus): boolean {
          BLog.i('DFM onDanmakuClick: danmakus size:' + danmakus.size())
          let latest: BaseDanmaku = danmakus.last()
          if (null != latest) {
            BLog.i('DFM onDanmakuClick: text of latest danmaku:' + latest.text)
            return true
          }
          return false
        };

        onDanmakuLongClick(danmakus: IDanmakus): boolean {
          return false
        };

        onViewClick(view: IDanmakuView): boolean {
          return false
        };
      })
      this.mDanmakuModel.prepare(this.mParser, this.mDanmakuContext);
      this.mDanmakuModel.showFPS(false);
    }
  }

  private updateDanmaku(source: ProtoSource) {
    if (this.mDanmakuModel != null) {
      this.mParser = this.createParser(source);
      this.mDanmakuModel.prepare(this.mParser, this.mDanmakuContext);
    }
  }
}

@Component
struct PlayerControlView {
  private player: IPlayer;
  private mDanmakuModel: DanmakuView.Model;
  @StorageLink('isPortrait') isPortrait: boolean = true;
  @Link loadingVisible: boolean;
  @Link replayVisible: boolean;
  @Link progressValue: number;
  @Link currentTime: string;
  @Link totalTime: string;
  @Link slideEnable: boolean;
  @Link mState: IPlayStatus;
  @Link mIsShowCtl: boolean;
  @Link danmakuPn: number;
  @Link mIsShowDanmaku: boolean;

  build() {
    Column() {
      if (this.mIsShowCtl) {
        Row() {
          Image($r('app.media.ic_player_back_bold'))
            .width(24)
            .height(24)
            .onClick(_ => {
              if (this.isPortrait) {
                router.back();
              } else {
                WindowManager.changeWindowDirection(window.Orientation.PORTRAIT)
                this.isPortrait = true
              }
            })

          Blank()

          Image($r('app.media.ic_player_setting_bold'))
            .width(24)
            .height(24)
            .onClick(_ => {
            })
        }.padding(8)
        .width('100%')
        .linearGradient({
          colors: [["#aa000000", 0.0], ["#00000000", 1.0]]
        })
      }
      Blank()
      if (this.mIsShowCtl) {
        Row() {
          Image(this.mState == IPlayStatus.PLAY ? $r('app.media.ic_player_pause') :
          $r('app.media.ic_player_play'))
            .width(28)
            .height(28)
            .enabled(this.mState != IPlayStatus.INIT)
            .onClick(_ => {
              if (this.mState == IPlayStatus.PLAY) {
                this.player.pause();
              } else {
                this.player.play();
              }
            })
          Slider({
            value: this.progressValue,
            min: 0,
            max: PROGRESS_MAX_VALUE,
            step: 1,
            style: SliderStyle.OutSet
          })
            .width(this.isPortrait ? '40%' : '70%')
            .margin({ left: 12 })
            .blockColor(Color.White)
            .trackColor(Color.Gray)
            .trackThickness(2)
            .selectedColor(Color.Red)
            .showSteps(true)
            .showTips(true)
            .enabled(this.slideEnable)
            .onChange((value: number, mode: SliderChangeMode) => {
              this.player.pause();
              this.showLoadIng();
              let seekValue = value * (this.player.getDuration() / 100);
              this.player.seekTo(seekValue);
              if ((this.danmakuPn-1) * DANMAKU_TIME <= seekValue && this.danmakuPn * DANMAKU_TIME > seekValue ) {
                this.mDanmakuModel.seekTo(seekValue - (this.danmakuPn-1) * DANMAKU_TIME);
              } else {
                this.danmakuPn = Math.floor(seekValue / DANMAKU_TIME) + 1;
              }
            })
          Text(this.currentTime + "/" + this.totalTime)
            .fontSize(12)
            .margin({ left: 8, right: 8 })
            .fontColor(Color.White)

          Blank()

          Image(this.mIsShowDanmaku? $r("app.media.ic_danmaku_switch_on") : $r("app.media.ic_danmaku_switch_off"))
          .width(24)
          .height(24)
          .onClick(() => {
            this.mIsShowDanmaku = !this.mIsShowDanmaku;
            this.mDanmakuModel.setVisibility(this.mIsShowDanmaku);
          });

          if (this.isPortrait) {
            Image($r('app.media.ic_player_toggle_zoom'))
              .width(24)
              .height(24)
              .onClick(() => {
                WindowManager.changeWindowDirection(window.Orientation.LANDSCAPE)
                this.isPortrait = false
              })
          } else {
            Text('360P')
              .fontSize(14)
              .margin({ left: 16, right: 16 })
              .fontColor(Color.White)
          }
        }.padding({ left: 8, right: 8, top: 4, bottom: 4 })
        .width('100%')
        .linearGradient({
          colors: [["#00000000", 0.0], ["#aa000000", 1.0]]
        })
      }
    }.width('100%')
    .height('100%')
    .onClick(() => {
      this.mIsShowCtl = !this.mIsShowCtl
    })
  }

  private showLoadIng() {
    this.loadingVisible = true;
    this.replayVisible = false;
  }
}