import {BaseResponse} from './Response';

export interface SendSmsCaptchaResponse extends BaseResponse<SmsCaptcha> {};

export interface SmsCaptcha {
  captcha_key: string;
}