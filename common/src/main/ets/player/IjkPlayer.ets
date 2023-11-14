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

import { IPlayer } from './IPlayer';
import { IPlayStatus } from './IPlayStatus';
import {
  IjkMediaPlayer,
  OnPreparedListener,
  OnVideoSizeChangedListener,
  OnCompletionListener,
  OnBufferingUpdateListener,
  OnErrorListener,
  OnInfoListener,
  OnSeekCompleteListener
} from "@ohos/ijkplayer";
import { StringUtil } from '../utils/StringUtil';

let mIjkMediaPlayer = IjkMediaPlayer.getInstance();
let updateProgressTimer;

export class IjkPlayer extends IPlayer {
  private mState: IPlayStatus = IPlayStatus.INIT;
  private mUrl: string;
  private mHeaders: Map<string, string>
  private mContext: object = null;

  public initPlay(context: object): Promise<void> {
    this.mContext = context;
    var promise = new Promise<void>(function (resolve, reject) {
      resolve();
    });
    return promise;
  }

  private initStart() {
    let thisClass = this;
    mIjkMediaPlayer.setContext(this.mContext);
    mIjkMediaPlayer.reset();

    //设置debug模式
    mIjkMediaPlayer.setDebug(true);
    //初始化配置
    mIjkMediaPlayer.native_setup();

    mIjkMediaPlayer.setDataSource(this.mUrl, this.mHeaders);
    //mIjkMediaPlayer.setDataSource(this.mUrl);

    //使用精确寻帧 例如，拖动播放后，会寻找最近的关键帧进行播放，很有可能关键帧的位置不是拖动后的位置，而是较前的位置.可以设置这个参数来解决问题
    mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "enable-accurate-seek", "1");
    //预读数据的缓冲区大小
    mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "max-buffer-size", "102400");
    //停止预读的最小帧数
    mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "min-frames", "100");
    //启动预加载
    mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "start-on-prepared", "1");
    // 设置无缓冲，这是播放器的缓冲区，有数据就播放
    mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "packet-buffering", "0");
    //跳帧处理,放CPU处理较慢时，进行跳帧处理，保证播放流程，画面和声音同步
    mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "framedrop", "5");
    // 最大缓冲cache是3s， 有时候网络波动，会突然在短时间内收到好几秒的数据
    // 因此需要播放器丢包，才不会累积延时
    // 这个和第三个参数packet-buffering无关。
    mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "max_cached_duration", "3000");
    // 无限制收流
    mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "infbuf", "1");

    mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "opensles", "1");

    // 屏幕常亮
    mIjkMediaPlayer.setScreenOnWhilePlaying(true);
    // 设置超时
    mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_FORMAT, "timeout", "10000000");
    mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_FORMAT, "connect_timeout", "10000000");
    mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_FORMAT, "addrinfo_timeout", "10000000");
    mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_FORMAT, "dns_cache_timeout", "10000000");
    // 设置音量
    // mIjkMediaPlayer.setVolume("0.5", "0.5");
    // 变速播放
    // mIjkMediaPlayer.setOption(IjkMediaPlayer.OPT_CATEGORY_PLAYER, "soundtouch", "1");
    // mIjkMediaPlayer.setSpeed("2f");

    let mOnVideoSizeChangedListener: OnVideoSizeChangedListener = {
      onVideoSizeChanged(width: number, height: number, sar_num: number, sar_den: number) {
        // that.aspRatio = width / height;
        console.info("IjkPlayer onVideoSizeChanged");
        if (thisClass.mOnSizeChangeCallback) {
          thisClass.mOnSizeChangeCallback.OnSizeChange(width, height);
        }
      }
    }
    mIjkMediaPlayer.setOnVideoSizeChangedListener(mOnVideoSizeChangedListener);

    let mOnPreparedListener: OnPreparedListener = {
      onPrepared() {
        console.info("IjkPlayer updateState");
        thisClass.updateState(IPlayStatus.PREPARED);
        thisClass.updateState(IPlayStatus.PLAY);
        // thisClass.play();
      }
    }
    mIjkMediaPlayer.setOnPreparedListener(mOnPreparedListener);

    let mOnCompletionListener: OnCompletionListener = {
      onCompletion() {
        console.info("IjkPlayer onCompletion");
        thisClass.updateState(IPlayStatus.DONE);
        thisClass.stopProgressTask();
        thisClass.stop();
      }
    }
    mIjkMediaPlayer.setOnCompletionListener(mOnCompletionListener);

    let mOnBufferingUpdateListener: OnBufferingUpdateListener = {
      onBufferingUpdate(percent: number) {
        console.info("IjkPlayer onBufferingUpdate");
      }
    }
    mIjkMediaPlayer.setOnBufferingUpdateListener(mOnBufferingUpdateListener);

    let mOnSeekCompleteListener: OnSeekCompleteListener = {
      onSeekComplete() {
        console.info("IjkPlayer onSeekComplete");
        thisClass.play();
      }
    }
    mIjkMediaPlayer.setOnSeekCompleteListener(mOnSeekCompleteListener);

    let mOnInfoListener: OnInfoListener = {
      onInfo(what: number, extra: number) {
      }
    }
    mIjkMediaPlayer.setOnInfoListener(mOnInfoListener);

    let mOnErrorListener: OnErrorListener = {
      onError(what: number, extra: number) {
        console.info("IjkPlayer onError");
        thisClass.updateState(IPlayStatus.ERROR);
      }
    }
    mIjkMediaPlayer.setOnErrorListener(mOnErrorListener);

    mIjkMediaPlayer.setMessageListener();

    mIjkMediaPlayer.prepareAsync();

    mIjkMediaPlayer.start();
  }

  public controller(): XComponentController {
    return null;
  }

  public libraryName(): string {
    return "ijkplayer_napi";
  }

  public id(): string {
    return "xcomponentId";
  }

  public setDataSource(url: string, headers?: Map<string, string>) {
    this.mUrl = url;
    this.mHeaders = headers;
    this.updateState(IPlayStatus.INIT);
    this.play();
  }

  public play() {
    if (this.mUrl == null) {
      this.updateState(IPlayStatus.ERROR);
      return;
    }
    if (this.mState == IPlayStatus.INIT ||
    this.mState == IPlayStatus.DONE ||
    this.mState == IPlayStatus.ERROR) {
      this.stopProgressTask();
      this.startProgressTask();
      this.initStart();
    } else if (this.mState == IPlayStatus.PAUSE) {
      this.stopProgressTask();
      this.startProgressTask();
      mIjkMediaPlayer.start();
      this.updateState(IPlayStatus.PLAY);
    }
  }

  public pause() {
    if (mIjkMediaPlayer.isPlaying()) {
      mIjkMediaPlayer.pause();
      this.updateState(IPlayStatus.PAUSE);
      this.stopProgressTask();
    }
  }

  public stop() {
    this.updateState(IPlayStatus.DONE);
    mIjkMediaPlayer.stop();
    mIjkMediaPlayer.release();
    this.stopProgressTask();
  }

  public seekTo(value: number) {
    mIjkMediaPlayer.seekTo(Math.floor(value) + "");
  }

  public setScreenOn(on: boolean) {
    mIjkMediaPlayer.setScreenOnWhilePlaying(on);
  }

  public getDuration(): number {
    return mIjkMediaPlayer.getDuration();
  }

  public setPlayId(playId: string) {
    mIjkMediaPlayer.setPlayId(playId);
  }

  public getPlayId(): string {
    return mIjkMediaPlayer.getPlayId();
  }

  private updateState(state: IPlayStatus) {
    console.info("IjkPlayer updateState state:" + state);
    this.mState = state;
    if (this.mOnStateChangeCallback) {
      this.mOnStateChangeCallback.OnStateChange(state);
    }
  }

  private setProgress() {
    let position = mIjkMediaPlayer.getCurrentPosition();
    let duration = mIjkMediaPlayer.getDuration();

    if (this.mOnTimeUpdateCallback) {
      this.mOnTimeUpdateCallback.onTimeUpdate(position, duration)
    }

    let totalTime = StringUtil.stringForTime(duration);
    if (position > duration) {
      position = duration;
    }
    let currentTime = StringUtil.stringForTime(position);

    /*console.info("IjkPlayer setProgress position:" + position + ", duration:" +
    duration + ", progressValue:" + pos + ", currentTime:" + currentTime + ", totalTime:" + totalTime);*/

    if (this.mOnTimeStrUpdateCallback) {
      this.mOnTimeStrUpdateCallback.onTimeStrUpdate(currentTime, totalTime)
    }

  }

  private startProgressTask() {
    let thisClass = this;
    console.info("IjkPlayer startProgressTask");
    updateProgressTimer = setInterval(function () {
      thisClass.setProgress();
    }, 1000);
  }

  private stopProgressTask() {
    console.info("IjkPlayer stopProgressTask");
    clearInterval(updateProgressTimer);
  }
}