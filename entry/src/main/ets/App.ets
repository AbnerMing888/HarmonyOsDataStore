import { DataKvUtil, DbUtil, DataStoreUtil, DataPreferences } from '@abner/datastore'
import { AbilityStage } from '@kit.AbilityKit'

export default class App extends AbilityStage {
  onCreate() {
    DataStoreUtil.init(this.context, ["ming"]);

    DataKvUtil.getInstance().init(this.context, "com.gwm.tool")

    //初始化关系型数据库
    DbUtil.getInstance().init(this.context)
  }
}