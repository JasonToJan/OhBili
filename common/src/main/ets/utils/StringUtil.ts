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
import cryptoFramework from '@ohos.security.cryptoFramework';

export class StringUtil {
    public static replaceJsonStr(data: any): string {
        var resultStr = JSON.stringify(data).replace(/\\\\/g, '\\');
        resultStr = resultStr.replace(/\\"/g, '"');
        resultStr = resultStr.replace(/"{/g, '{');
        resultStr = resultStr.replace(/}"/g, '}');
        resultStr = resultStr.replace(/\\"/g, '"');
        return resultStr;
    }

    private static completionNum(num: any): any {
        if (num < 10) {
            return '0' + num;
        } else {
            return num;
        }
    }

    public static stringForTime(timeMs: any): string {
        let totalSeconds = (timeMs / 1000);
        let seconds = totalSeconds % 60;
        let minutes = (totalSeconds / 60) % 60;
        let hours = totalSeconds / 3600;
        console.info("stringForTime hours:" + hours + ",minutes:" + minutes + ",seconds:" + seconds);
        hours = this.completionNum(Math.floor(Math.floor(hours * 100) / 100));
        minutes = this.completionNum(Math.floor(Math.floor(minutes * 100) / 100));
        seconds = this.completionNum(Math.floor(Math.floor(seconds * 100) / 100));
        if (hours > 0) {
            return hours + ":" + minutes + ":" + seconds;
        } else {
            return minutes + ":" + seconds;
        }
    }

    public static generateCN(numVal: number): string {
        if (numVal < 10000) {
            return numVal + "";
        } else if (numVal >= 100000000) {
            return (numVal / 100000000).toFixed(1) + "亿";
        } else {
            return (numVal / 10000).toFixed(1) + "万";
        }
    }

    public static stringToUint8Array(input: string): Uint8Array {
        let arr: number[] = [];
        for(let i = 0, j = input.length; i < j; ++i) {
            arr.push(input.charCodeAt(i));
        }
        return new Uint8Array(arr);
    }

    public static md5(input: string): Promise<string> {
        return new Promise<string>((resolve, reject) => {
            const dataBlob = {
                data: this.stringToUint8Array(input)
            };
            const encryptor = cryptoFramework.createMd("MD5");
            encryptor.update(dataBlob)
                .then(() => {
                    return encryptor.digest()
                })
                .then(out => {
                    resolve(out.data.toString());
                });
        });
    }

    public static async generateBuvid(): Promise<string> {
        var mac: string[] = [];
        for(let i = 0; i < 6; i++) {
            const min = Math.min(0, 0xff);
            const max = Math.max(0, 0xff);
            const num = parseInt((Math.random() * (min - max + 1) + max).toString()).toString(16);
            mac.push(num);
        }
        const md5 = await this.md5(mac.join(":"));
        const mdArr = md5.split("");
        return `XY${mdArr[2]}${mdArr[12]}${mdArr[22]}${md5}`;
    }

    public static generateSizeStr(numVal: number): string {
        if (numVal < 1024) {
            return numVal + "B";
        } else if (numVal < 1024 * 1024) {
            return (numVal / 1024).toFixed(1) + "KB";
        } else if (numVal < 1024 * 1024 * 1024) {
            return (numVal / (1024 * 1024)).toFixed(1) + "MB";
        } else {
            return (numVal / (1024 * 1024 * 1024)).toFixed(1) + "GB";
        }
    }

    public static timeStampToAgoDate(timeStamp: number): string {
        let timeMs = timeStamp * 1000;
        var dateNow = new Date();
        var dateUp = new Date(timeMs);
        if (dateNow.getTime() - timeMs < 60 * 1000) {
            return "刚刚";
        } else if (dateNow.getTime() - timeMs < 60 * 60 * 1000) {
            return ((dateNow.getTime() - timeMs) / (60 * 1000)).toFixed() + "分钟前";
        } else if (dateNow.getTime() - timeMs < 24 * 60 * 60 * 1000) {
            return ((dateNow.getTime() - timeMs) / (60 * 60 * 1000)).toFixed() + "小时前";
        } else if (dateNow.getTime() - timeMs < 360 * 24 * 60 * 60 * 1000) {
            return this.dateFormat(dateUp, "MM月dd日");
        } else {
            return this.dateFormat(dateUp, "yyyy-MM-dd");
        }
    }

    public static parseSecondToVideoDuration(seconds: number): string {
        // toFixed会四舍五入，导致计算出错，所以自定义方法取整数部分
        const getInteger = (input: number): string => {
            return input.toString().split('.')[0];
        }
        const hours = getInteger(seconds/3600).padStart(2, '0');
        const minutes = getInteger((seconds - parseInt(hours) * 3600) / 60).padStart(2,'0');
        const _seconds = getInteger(seconds-parseInt(hours)*3600-parseInt(minutes)*60).padStart(2,'0');
        return `${hours=="00"?"":hours+":"}${minutes}:${_seconds}`;
    }

    public static dateFormat(date?: any, format?: string): string {
        //无参数
        if (date == undefined) {
            date = new Date();
        } else if (typeof (date) == "string") {
            date = new Date(date.replace(/-/, '/'));
        } else if (typeof (date) == "number") {
            date = new Date(date);
        } else if (typeof (date) !== "object") {//如果date是object，则在上下文就是Date对象，不需要进行new Date()操作。这导致了时间显示错误。
            date = new Date();
        }

        if (format === undefined) {
            format = "yyyy-MM-dd HH:mm:ss.fff";
        }
        else { }
        //没有分隔符的特殊处理

        var map = {
            "y": date.getFullYear() + "",//年份
            "M": date.getMonth() + 1 + "", //月份
            "d": date.getDate() + "", //日
            "H": date.getHours(), //小时 24
            "m": date.getMinutes() + "", //分
            "s": date.getSeconds() + "", //秒
            "q": Math.floor((date.getMonth() + 3) / 3) + "", //季度
            "f": date.getMilliseconds() + "" //毫秒
        };
        //小时 12
        if (map["H"] > 12) { map["h"] = map["H"] - 12 + ""; }
        else { map["h"] = map["H"] + ""; }
        map["H"] += "";

        var reg = "yMdHhmsqf";
        var all = "", str = "";
        for (var i = 0, n = 0; i < reg.length; i++) {
            n = format.indexOf(reg[i]);
            if (n < 0) { continue; }
            all = "";
            for (; n < format.length; n++) {
                if (format[n] != reg[i]) {
                    break;
                }
                all += reg[i];
            }
            if (all.length > 0) {
                if (all.length == map[reg[i]].length) {
                    str = map[reg[i]];
                }
                else if (all.length > map[reg[i]].length) {
                    if (reg[i] == "f") {
                        str = map[reg[i]] + this.charString("0", all.length - map[reg[i]].length);
                    }
                    else {
                        str = this.charString("0", all.length - map[reg[i]].length) + map[reg[i]];
                    }
                }
                else {
                    switch (reg[i]) {
                        case "y": str = map[reg[i]].substr(map[reg[i]].length - all.length); break;
                        case "f": str = map[reg[i]].substr(0, all.length); break;
                        default: str = map[reg[i]]; break;
                    }
                }
                format = format.replace(all, str);
            }
        }
        return format;
    }


    public static charString(char: string, count: number): string {
        var str: string = "";
        while (count--) {
            str += char;
        }
        return str;
    }

    public static parseEmString(value: string): RichString[] {
        let regExp : RegExp = /<em class=(.*?)>(.*?)<\/em>/g;
        return this.parseRichString(regExp, RichStringType.EM, value);
    }

    public static parseRichString(regExp : RegExp, type: RichStringType, value: string): RichString[] {
        var strArr: RichString[] = [];
        var expArr;
        var startIndex = 0;
        while ((expArr = regExp.exec(value)) !== null) {
            let richStr = new RichString(value.slice(startIndex, expArr.index));
            strArr.push(richStr);
            let matchStr = new RichString(expArr[2], type, expArr[1]);
            strArr.push(matchStr);
            startIndex = regExp.lastIndex;
        }
        let richStr = new RichString(value.slice(startIndex, value.length));
        strArr.push(richStr);
        return strArr;
    }

}

export class RichString {
    text: string
    type: RichStringType = RichStringType.TEXT;
    classKey: string = '';

    constructor(text: string, type?: RichStringType, classKey?: string) {
        if (type != null) {
            this.type = type;
        }
        if (classKey != null) {
            this.classKey = classKey;
        }
        this.text = text;
    }
}

export enum RichStringType {
    TEXT,
    EM
}