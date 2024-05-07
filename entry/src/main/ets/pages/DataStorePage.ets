import { ListView } from '@abner/refresh'
import { AllPreferences, DataPreferences, DataStoreUtil } from '@abner/datastore';
import promptAction from '@ohos.promptAction';
import { BusinessError } from '@kit.BasicServicesKit';

/**
 * AUTHOR:AbnerMing
 * DATE:2024/4/18
 * INTRODUCE:用户首选项操作
 * */
@Entry
@Component
struct DataStorePage {
  @State textContent: string = ""
  private mItems = [
    "异步存储", "同步存储", "异步获取", "同步获取", "异步判断key是否存在"
    , "同步判断key是否存在", "异步删除", "同步删除", "异步清空所有", "同步清空所有"
    , "异步获取所有键值数据", "同步获取所有键值数据", "新实例存储", "新实例获取"
  ];

  @Builder
  itemLayout(_this: DataStorePage, item: Object, index: number) {
    Button(item.toString())
      .width("60%")
      .height(40)
      .border({ width: 1, color: Color.Pink, radius: 5 })
      .margin({ left: "20%", top: 10 })
      .onClick(() => {
        //点击
        _this.clickItem(index, _this.textContent);
      })
  }

  private clickItem(index: number, content: string) {
    switch (index) {
      case 0: //异步存储
        if (content == undefined || content == "") {
          this.toast("请输入要存储的内容")
        } else {
          DataStoreUtil.put("abner", content);
        }
        break;
      case 1: //同步存储
        if (content == undefined || content == "") {
          this.toast("请输入要存储的内容")
        } else {
          DataStoreUtil.putSync("abner", content);
        }
        break;
      case 2: //异步获取
        DataStoreUtil.get("abner").result<string>((data) => {
          if (!DataStoreUtil.hasSync("abner")) {
            this.toast("存储的key不存在")
          } else {
            this.toast(data)
          }
        })
        break;
      case 3: //同步获取
        let abner = DataStoreUtil.getSync<string>("abner")
        if (!DataStoreUtil.hasSync("abner")) {
          this.toast("存储的key不存在")
        } else {
          this.toast(abner)
        }

        break;
      case 4: //异步判断key是否存在
        DataStoreUtil.has("abner", (isSuccess: boolean) => {
          this.toast("" + isSuccess)
        })
        break;
      case 5: //同步判断key是否存在
        let isHave = DataStoreUtil.hasSync("abner")
        this.toast("" + isHave)
        break;
      case 6: //异步删除
        DataStoreUtil.delete("abner", (isSuccess: boolean) => {
          this.toast("" + isSuccess)
        })
        break;
      case 7: //同步删除
        DataStoreUtil.deleteSync("abner")
        break;
      case 8: //异步清空所有
        DataStoreUtil.clear(() => {
          //成功
          this.toast("清空成功");
        }, (err: BusinessError) => {
          //失败
        })
        break;
      case 9: //同步清空所有
        DataStoreUtil.clearSync()
        break;
      case 10: //异步获取所有键值数据
        DataStoreUtil.getAll((allPreferences?: AllPreferences) => {
          this.toast(JSON.stringify(allPreferences))
        })
        break;
      case 11: //同步获取所有键值数据
        let preferences = DataStoreUtil.getAllSync()
        this.toast(JSON.stringify(preferences))
        break;
      case 12: //新实例存储
        DataPreferences.getInstance().setPreferences("ming")
          .putSync("aa", "新实例存储")

        break;
      case 13: //新实例获取
        let aa = DataPreferences.getInstance().setPreferences("ming")
          .getSync<string>("aa")
        this.toast(aa)
        break;
    }
  }

  build() {
    Column() {

      TextInput({
        text: this.textContent,
        placeholder: "输入要存储的内容"
      }).onChange((value: string) => {
        this.textContent = value
      })

      ListView({
        items: this.mItems,
        itemLayout: (item, index) => {
          this.itemLayout(this, item, index)
        }
      })
    }
    .height("100%")
    .width('100%')
  }

  toast(msg: string) {
    if (msg == undefined) {
      return;
    }
    promptAction.showToast({
      message: msg,
    });
  }
}