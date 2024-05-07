import { ListView } from '@abner/refresh';
import { DataKvUtil } from '@abner/datastore';
import promptAction from '@ohos.promptAction';

/**
 * AUTHOR:AbnerMing
 * DATE:2024/4/18
 * INTRODUCE:键值数据库操作
 * */
@Entry
@Component
struct DataKvPage {
  @State textContent: string = ""
  private mItems = [
    "存储", "获取", "删除", "修改"
  ];

  @Builder
  itemLayout(_this: DataKvPage, item: Object, index: number) {
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
      case 0: //存储
        if (content == undefined || content == "") {
          this.toast("请输入要存储的内容")
        } else {
          DataKvUtil.getInstance().put("abner_key", content);
        }
        break;
      case 1: //获取
        DataKvUtil.getInstance().get("abner_key", (data) => {
          this.toast(data.toString())
        })
        break;
      case 2: //删除
        DataKvUtil.getInstance().deletePromise("abner_key")
        break;
      case 3: //修改
        DataKvUtil.getInstance().put("abner_key", "修改")
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