import { ListView } from '@abner/refresh';
import { DbTableFieldType, DbUtil } from '@abner/datastore';
import promptAction from '@ohos.promptAction';
import { DbDataBean } from '../bean/DbDataBean';

/**
 * AUTHOR:AbnerMing
 * DATE:2024/4/18
 * INTRODUCE:关系型数据库对象操作
 * */
@Entry
@Component
struct DataDbBeanPage {
  private mItems = [
    "创建表", "修改表字段", "存储", "获取全部", "获取单个", "删除", "修改", "升级版本"
  ];

  @Builder
  itemLayout(_this: DataDbBeanPage, item: Object, index: number) {
    Button(item.toString())
      .width("60%")
      .height(40)
      .border({ width: 1, color: Color.Pink, radius: 5 })
      .margin({ left: "20%", top: 10 })
      .onClick(() => {
        //点击
        _this.clickItem(index);
      })
  }

  private clickItem(index: number) {
    switch (index) {
      case 0: //创建数据库表

        DbUtil.getInstance().createTable("abner_ming", {
          "id": { type: DbTableFieldType.INTEGER, isPrimaryKey: true, isAutoIncrement: true },
          "name": { type: DbTableFieldType.VARCHAR, length: 120 },
          "age": { type: DbTableFieldType.INT, length: 30 }
        })
        break;

      case 1: //修改表结构
        DbUtil.getInstance().updateTable("abner_ming", {
          "addres": { type: DbTableFieldType.VARCHAR, length: 100 },
          "phone": { type: DbTableFieldType.VARCHAR, length: 50 },
        })
        break;
      case 2: //存储
        let bean = new DbDataBean()
        bean.name = "AbnerMing"
        bean.age = 18
        DbUtil.getInstance().insertBean("abner_ming", bean)
        break;
      case 3: //获取全部对象
        DbUtil.getInstance()
          .queryAllBean<DbDataBean>("abner_ming", (data) => {
            console.log("====" + JSON.stringify(data))
          })
        break;
      case 4: //获取单个对象

        DbUtil.getInstance()
          .filterRdbPredicates({ equalTo: { "id": 1 } })
          .queryBean<DbDataBean>("abner_ming", (data) => {
            console.log("====" + JSON.stringify(data))
          }, () => {
            console.log("==============发生了错误")
          })

        break;
      case 5: //删除

        DbUtil.getInstance()
          .filterRdbPredicates({ equalTo: { "id": 2 } })
          .deleteBean("abner_ming")


        break;
      case 6: //修改

        let uBean = new DbDataBean()
        uBean.name = "Ming"
        uBean.age = 20

        DbUtil.getInstance()
          .filterRdbPredicates({ equalTo: { "id": 2 } })
          .updateBean("abner_ming", uBean)

        break;
      case 7: //升级版本
        let version = DbUtil.getInstance().getRdbStore()?.version
        if (version != undefined) {
          DbUtil.getInstance().setDbVersion(version + 1)
        }
        break;
    }
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