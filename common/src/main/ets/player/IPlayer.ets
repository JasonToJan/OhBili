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

import { OnTimeUpdateCallback, OnTimeStrUpdateCallback,
    OnStateChangeCallback, OnSizeChangeCallback } from './IPlayerCallback';

export abstract class IPlayer {
    protected mOnTimeUpdateCallback: OnTimeUpdateCallback;
    protected mOnTimeStrUpdateCallback: OnTimeStrUpdateCallback;
    protected mOnStateChangeCallback: OnStateChangeCallback;
    protected mOnSizeChangeCallback: OnSizeChangeCallback;

    setOnTimeUpdateCallback(callback: OnTimeUpdateCallback) {
        this.mOnTimeUpdateCallback = callback;
    }

    setOnTimeStrUpdateCallback(callback: OnTimeStrUpdateCallback) {
        this.mOnTimeStrUpdateCallback = callback;
    }

    setOnStateChangeCallback(callback: OnStateChangeCallback) {
        this.mOnStateChangeCallback = callback;
    }

    setOnSizeChangeCallback(callback: OnSizeChangeCallback) {
        this.mOnSizeChangeCallback = callback;
    }

    abstract initPlay(context: object): Promise<void>

    abstract controller(): XComponentController

    abstract libraryName(): string

    abstract id(): string

    abstract setDataSource(url: string, headers?:Map<string,string>): void

    abstract play(): void

    abstract pause(): void

    abstract stop(): void

    abstract seekTo(value: number): void

    abstract setScreenOn(on: boolean): void

    abstract getDuration(): number

    abstract setPlayId(playId: string)

    abstract getPlayId(): string
}