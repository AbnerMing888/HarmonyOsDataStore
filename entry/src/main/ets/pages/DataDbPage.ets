import { ListView } from '@abner/refresh';
import { DbUtil } from '@abner/datastore';
import promptAction from '@ohos.promptAction';
import { ValuesBucket } from '@ohos.data.ValuesBucket';
import relationalStore from '@ohos.data.relationalStore';

/**
 * AUTHOR:AbnerMing
 * DATE:2024/4/18
 * INTRODUCE:关系型数据库普通数据操作
 * */
@Entry
@Component
struct DataDbPage {
  private mItems = [
    "创建表", "存储", "获取", "删除", "修改"
  ];

  @Builder
  itemLayout(_this: DataDbPage, item: Object, index: number) {
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

        DbUtil.getInstance()
          .executeSql("CREATE TABLE abner_ta(id INTEGER PRIMARY KEY AUTOINCREMENT,name VARCHAR(50),age INT)")

        break;
      case 1: //存储
        const valueBucket1: ValuesBucket = {
          'name': "AbnerMing",
          'age': 18,
        };
        DbUtil.getInstance().insert("abner_ta", valueBucket1)
        break;
      case 2: //获取

        let predicates = new relationalStore.RdbPredicates("abner_ta");

        DbUtil.getInstance().query(predicates, (resultSet: relationalStore.ResultSet) => {
          // resultSet是一个数据集合的游标，默认指向第-1个记录，有效的数据从0开始。

          while (resultSet.goToNextRow()) {
            console.error("=========" + JSON.stringify(resultSet.getRow()))
            const id = resultSet.getLong(resultSet.getColumnIndex("id"));
            const name = resultSet.getString(resultSet.getColumnIndex("name"));
            const age = resultSet.getLong(resultSet.getColumnIndex("age"));
            console.error("========" + id + "=====" + name + "====" + age)
          }
        })

        break;
      case 3: //删除

        let deleteRdbPredicates = new relationalStore.RdbPredicates("abner_ta");
        deleteRdbPredicates.equalTo("id", 1);

        DbUtil.getInstance().delete(deleteRdbPredicates)

        break;
      case 4: //修改

        const valueBucket: ValuesBucket = {
          'name': "ming",
          'age': 28,
        };

        let upDataRdbPredicates = new relationalStore.RdbPredicates("abner_ta");
        upDataRdbPredicates.equalTo("id", 1);

        DbUtil.getInstance().update(upDataRdbPredicates, valueBucket)
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