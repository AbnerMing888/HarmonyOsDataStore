import { ListView } from '@abner/refresh';
import router from '@ohos.router';

@Entry
@Component
struct Index {
  private mItems = [
    "用户首选项", "分布式键值数据库", "关系型数据库", "关系型数据库对象操作"
  ];
  private mPages = [
    "pages/DataStorePage",
    "pages/DataKvPage",
    "pages/DataDbPage",
    "pages/DataDbBeanPage"
  ];

  @Builder
  itemLayout(_this: Index, item: Object, index: number) {
    Text(item.toString())
      .width("90%")
      .height(40)
      .border({ width: 1, color: Color.Pink, radius: 5 })
      .margin({ left: "5%", top: 10 })
      .textAlign(TextAlign.Center)
      .onClick(() => {
        //点击
        router.pushUrl({ url: _this.mPages[index] })
      })
  }

  build() {
    Column() {
      ListView({
        items: this.mItems,
        itemLayout: (item, index) => {
          this.itemLayout(this, item, index)
        }
      })
    }
  }
}