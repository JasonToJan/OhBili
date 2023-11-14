import { ApiManager, OhNavBar } from '@ohos/common';
import { CountryItem, CountryList } from '@ohos/common/src/main/ets/model/response/GenericCountryListResponse';
import promptAction from '@ohos.promptAction';

@CustomDialog
struct CountryPicker {
  @Link countryList: CountryList;
  @Link selectedCountry: CountryItem;
  controller: CustomDialogController;
  build(){
    Column(){
      Text("地区选择")
        .fontSize(16)
        .height(48)
        .width('100%')
        .textAlign(TextAlign.Start)
        .padding({left: 36, top: 12})
        .border({
          width: {bottom: 1},
          color: Color.Gray
        })
      List(){
        ForEach(this.countryList.common, (country: CountryItem) => {
          ListItem(){
            Button({type: ButtonType.Normal}){
              Text(country.cname)
                .textAlign(TextAlign.Start)
                .width('100%')
            }.height(48).onClick(() => {
              this.selectedCountry = country;
              this.controller.close();
            }).padding({left: 36, top: 12, bottom: 12}).borderRadius(0).width('100%').backgroundColor(Color.Transparent)
          }
        })
      }
    }.justifyContent(FlexAlign.SpaceBetween)
  }
}

@Entry
@Component
struct Login {
  @State countryList: CountryList = {common: [], others: []};
  @State selectedCountry: CountryItem = {cname: "选择国家/地区", id: 0, country_id: "0"}
  @State phoneNumber: string = "";
  @State code: string = "";
  mBorderWidth: number = 0.5;
  countryPickerDialog: CustomDialogController =  new CustomDialogController({
    builder: CountryPicker({countryList: $countryList, selectedCountry: $selectedCountry }),
    autoCancel: true
  })
  aboutToAppear(){
    ApiManager.getInstance().requestGenericCountryList().then(list => {
      this.countryList = list;
      this.selectedCountry = list.common[0];
    })
  }
  build(){
    Column(){
      OhNavBar({title: "手机号登录注册", shadowRadius: 10})

      Button({type: ButtonType.Normal}){

        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }){
          // 显示当前选择国家
          Text(this.selectedCountry.cname)
            .fontSize(16)
            .width('50%')
            .textAlign(TextAlign.Start)
          Image($r("app.media.ic_arrow_right"))
            .width(16)
            .height(16)
        }.margin({top: 11, bottom: 11, left: 24, right: 24})

      }.width('100%').height(48).margin({top: 100})
      .backgroundColor(Color.Transparent).borderRadius(0)
      .border({
        width: {top: this.mBorderWidth, bottom: this.mBorderWidth},
        color: Color.Gray
      }).onClick(() => {
        this.countryPickerDialog.open();
      })

      Row(){
        Column(){
          Row(){
            Text(`+${this.selectedCountry.country_id}`).fontSize(14).textAlign(TextAlign.Start)
          }
        }.width('20%')
        Column(){
          Row(){
            TextInput({placeholder: "请输入手机号码"})
              .onChange(phoneNumber => {
                this.phoneNumber = phoneNumber;
              })
              .backgroundColor(Color.Transparent)
          }
        }.width('50%')

        Column(){
          Button({type: ButtonType.Normal}){
            Column(){
              Row(){
                Text("获取验证码").fontColor(Color.Gray)
              }.height('100%')
            }.width('100%')
          }.width('100%')
          .backgroundColor(Color.Transparent)
          .border({
            width: {left: this.mBorderWidth},
            color: Color.Gray
          })
        }.width('30%').padding({top: 12, bottom: 12})

      }.justifyContent(FlexAlign.SpaceBetween).height(48)

      Row(){

        Column(){
          Row(){
            Text("验证码").fontSize(14)
          }
        }.width('20%')

        Column(){
          Row(){
            TextInput({placeholder: "请输入验证码"})
              .onChange(code => {
                this.code = code;
              })
              .backgroundColor(Color.Transparent)
          }
        }.width('80%')

      }.justifyContent(FlexAlign.SpaceBetween).height(48).border({
        width: {top: this.mBorderWidth, bottom: this.mBorderWidth},
        color: Color.Gray
      })

      Row(){
        Button({type: ButtonType.Normal}){
          Column(){
            Row(){
              Text("验证登录").fontSize(18).fontColor(Color.White)
            }
          }
        }.borderRadius(2).width('100%').height(48).onClick(() => {
          promptAction.showToast({
            message: '登录功能暂未实现',
            duration: 2000
          });
        }).enabled(this.code != "")
      }.margin(24)
    }
  }
}