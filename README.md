# HarmonyOsDataStore

HarmonyOsDataStore是一个用于数据存储的工具库，支持用户首选项存储、键值型数据库存储、支持关系型数据库操作，让数据存储使用变得更加的简单。

**主要功能点**

- **1、支持用户首选项(preferences)进行数据存储，支持持久化数据存储**
- **2、用户首选项支持多实例也就是多文件形式存储。**
- **3、支持键值型数据库(distributedKVStore)数据存储。**
- **4、键值型数据库支持多标识区分。**
- **5、支持关系型数据库操作(relationalStore )。**

## 开发环境

DevEco Studio NEXT Developer Beta1,Build Version: 5.0.3.100

Api版本：**11**

hvigorVersion：4.2.0

## 快速使用

目前有多种使用方式，比如远程依赖、本地静态共享包依赖,源码方式依赖，推荐使用**远程依赖**，方便快捷，有最新修改可以及时生效。

### 1、远程依赖方式使用【推荐】

方式一：在Terminal窗口中，执行如下命令安装三方包，DevEco Studio会自动在工程的oh-package.json5中自动添加三方包依赖。

**建议：在使用的模块路径下进行执行命令。**

```
ohpm install @abner/datastore
```

方式二：在工程的oh-package.json5中设置三方包依赖，配置示例如下：

```
"dependencies": { "@abner/datastore": "^1.0.0"}
```

<p align="center"><img src="https://vipandroid-image.oss-cn-beijing.aliyuncs.com/harmony/datastore/datastore_001.png" width="300"></p>

### 2、本地静态共享包har包使用【不推荐】

<p>首先，下载har包，<a href="https://vipandroid-image.oss-cn-beijing.aliyuncs.com/harmony/datastore/datastore-1.0.0.har">点击下载</a></p>
<p>下载之后，把har包复制项目中，目录自己创建，如下，我创建了一个libs目录，复制进去</p>
<p><img src="https://vipandroid-image.oss-cn-beijing.aliyuncs.com/harmony/datastore/datastore_002.png"></p>
<p>引入之后，进行同步项目，点击Sync Now即可，当然了你也可以，将鼠标放置在报错处会出现提示，在提示框中点击Run 'ohpm install'。</p>
<p>需要注意，<strong>@abner/datastore</strong>，是用来区分目录的，可以自己定义，比如@aa/bb等，关于静态共享包的创建和使用，请查看如下我的介绍，这里就不过多介绍</p>

[HarmonyOS开发：走进静态共享包的依赖与使用](https://juejin.cn/post/7274982412245876776)

### 3、查看是否引用成功

无论使用哪种方式进行依赖，最终都会在使用的模块中，生成一个oh_modules文件，并创建源代码文件，有则成功，无则失败，如下：

<p align="center"><img src="https://vipandroid-image.oss-cn-beijing.aliyuncs.com/harmony/datastore/datastore_003.png" width="300"></p>

## 首选项实现数据持久化

### 1、初始化

建议在AbilityStage里进行初始化，如果你要使用多个文件实例进行存储，可以传递第二个参数。

```typescript
    //使用用户首选项存储，此初始化必须
DataPreferences.getInstance().init(this.context)
```

#### 相关属性介绍

| 属性        | 类型       | 概述                  |
|-----------|----------|---------------------|
| context   | Context  | 上下文                 |
| nameArray | string[] | 文件实例，可选，不传使用默认，支持多个 |

### 2、数据存储

**实现方式有三种，callback异步回调形式，Promise异步回调和同步调用，任选一种方式即可！**

#### callback异步回调形式

支持任意类型数据存储

```typescript

DataPreferences.getInstance().put("key", "value")

```

回调查看判断成功和失败

```typescript

DataPreferences.getInstance().put("key", "value", (isSuccess: boolean, error) => {
  if (isSuccess) {
    console.log("存储成功")
  } else {
    console.log("存储失败" + error?.message)
  }
})

```

#### Promise异步回调

支持任意类型数据存储

```typescript

DataPreferences.getInstance().putPromise("key", "value")

```

回调查看判断成功和失败

```typescript
DataPreferences.getInstance().putPromise("key", "value", (isSuccess: boolean, error) => {
  if (isSuccess) {
    console.log("存储成功")
  } else {
    console.log("存储失败" + error?.message)
  }
})
```

#### 同步方式

支持任意类型数据存储

```typescript

DataPreferences.getInstance().putSync("key", "value")

```

**注意：以上的存储方式，默认均进行数据持久化，如果您不想进行持久化，可调用setFlush，设置false即可**

举例：

```typescript

DataPreferences.getInstance()
  .setFlush(false)//false 不使用持久化
  .putSync("key", "value")

```

### 3、数据获取

**实现方式有三种，callback异步形式，Promise异步和同步，任选一种方式即可！**

数据获取，第二个参数为默认值，为可选参数，不传，默认即为空。

#### callback异步回调形式

存储时是什么类型，其泛型就是什么类型。

**只有成功**

```typescript
DataPreferences.getInstance()
  .get("key")
  .result<string>((data:string) => {
    //data既是返回的数据
  })
```

**成功和失败**

```typescript
DataPreferences.getInstance()
  .get("key")
  .result<string>((data:string) => {
    //data既是返回的数据
  }, (err:BusinessError) => {
    //失败
  })
```

#### Promise回调获取数据

存储时是什么类型，其泛型就是什么类型。

```typescript

DataPreferences.getInstance()
  .getPromise<string>("key")
  .then((data) => {
    //成功
  }).catch((err: BusinessError) => {
  //失败
})

```

#### 同步方式

存储时是什么类型，其泛型就是什么类型。

```typescript

let key = DataPreferences.getInstance().getSync<string>("key")

```

### 4、是否包含给定Key的存储键值对

**实现方式有三种，callback异步形式，Promise异步和同步,任选一种方式即可！**

#### callback回调

```typescript
DataPreferences.getInstance().has("key", (isHave:boolean) => {

})
```

#### Promise回调

```typescript
DataPreferences.getInstance().hasPromise("key")
  .then((isHave) => {

  }).catch((err: BusinessError) => {

  })
```

#### 同步方式

```typescript
 let isHave = DataPreferences.getInstance().hasSync("key")
```

### 5、删除给定Key的存储键值对

**实现方式有三种，callback异步形式，Promise异步和同步,任选一种方式即可！**

#### callback回调

```typescript
DataPreferences.getInstance().delete("key")
```

带有成功和失败

```typescript
DataPreferences.getInstance().delete("key", (isSuccess: boolean) => {
  if (isSuccess) {
    //删除成功
  } else {
    //删除失败
  }
})
```

#### Promise回调

```typescript
DataPreferences.getInstance().deletePromise("key")
```

如果检查成功和失败，可如下操作：

```typescript
DataPreferences.getInstance().deletePromise("key")
  .then((isSuccess) => {

  }).catch((err: BusinessError) => {

  })
```

#### 同步方式

```typescript
DataPreferences.getInstance().deleteSync("key")
```

### 6、获取所有键值数据

**实现方式有三种，callback异步形式，Promise异步和同步,任选一种方式即可！**

#### callback回调

```typescript
 DataPreferences.getInstance().getAll((allPreferences?: AllPreferences) => {

})
```

#### Promise回调

```typescript
 DataPreferences.getInstance().getAll((allPreferences?: AllPreferences) => {

})
```

#### 同步方式

```typescript
let allPreferences = DataPreferences.getInstance().getAllSync()
```

### 7、刷新数据进行持久化存储

默认情况下已经是持久化存储，此方法可以不用调用。

**实现方式有两种，callback异步形式，Promise异步和同步,任选一种方式即可！**

#### callback回调

```typescript
DataPreferences.getInstance()
  .flush()
```

如果检查成功和失败，可如下操作：

```typescript
DataPreferences.getInstance()
  .flush((isSuccess:boolean) => {

  })
```

#### Promise回调

```typescript
DataPreferences.getInstance().flushPromise()
```

如果检查成功和失败，可如下操作：

```typescript
DataPreferences.getInstance().flushPromise()
  .then((isSuccess) => {

  }).catch((err: BusinessError) => {

  })
```

### 8、清除实例中的所有数据

**实现方式有三种，callback异步形式，Promise异步和同步,任选一种方式即可！**

#### callback回调

```typescript
 DataPreferences.getInstance().clear()
```

如果检查成功和失败，可如下操作：

```typescript
 DataPreferences.getInstance().clear(() => {
  //成功
}, (err: BusinessError) => {
  //失败
})
```

#### Promise回调

```typescript
DataPreferences.getInstance().clearPromise()
```

如果检查成功和失败，可如下操作：

```typescript
DataPreferences.getInstance().clearPromise()
  .then((isSuccess) => {

  }).catch((err: BusinessError) => {

  })
```

#### 同步方式

```typescript
DataPreferences.getInstance().clearSync()
```

### 9、订阅数据变更

```typescript
DataPreferences.getInstance().onChange((key) => {

})
```

多个进程持有同一个首选项文件时

```typescript
DataPreferences.getInstance().onMultiProcessChange((key) => {

})
```

### 10、取消订阅数据变更

```typescript
DataPreferences.getInstance()
  .onChangeOff((key) => {

  })
```

多个进程持有同一个首选项文件时

```typescript
DataPreferences.getInstance()
  .onMultiProcessChangeOff((key) => {

  })
```

## 分布式键值数据库

### 1、初始化

建议在AbilityStage里进行初始化，如果你要使用多个文件实例进行存储，可以传递第二个参数。

```typescript
DataKvUtil.getInstance().init(this.context, "com.gwm.tool")
```

#### 相关属性介绍

| 属性         | 类型                         | 概述            |
|------------|----------------------------|---------------|
| context    | Context                    | 上下文           |
| bundleName | string                     | 调用方的包名        |
| option     | distributedKVStore.Options | （可选参数）数据库配置信息 |

##### option相关参数

| 属性              | 类型            | 必填  | 说明                                             |
|-----------------|---------------|-----|------------------------------------------------|
| createIfMissing | boolean       | 否   | 当数据库文件不存在时是否创建数据库，默认为true，即创建。                 |
| encrypt         | boolean       | 否   | 设置数据库文件是否加密，封装默认为true，即不加密。                    |
| backup          | boolean       | 否   | 设置数据库文件是否备份，封装默认为true，即备份。                     |
| autoSync        | boolean       | 否   | 设置数据库文件是否自动同步。封装默认为true，即手动同步。                 |
| kvStoreType     | KVStoreType   | 否   | 设置要创建的数据库类型，默认为DEVICE_COLLABORATION，即多设备协同数据库。 |
| securityLevel   | SecurityLevel | 是   | 设置数据库安全级别。                                     |
| schema          | Schema        | 否   | 设置定义存储在数据库中的值，默认为undefined，即不使用Schema。         |

##### KVStoreType

```text

KVStoreType 分布式键值数据库类型枚举。

DEVICE_COLLABORATION

表示多设备协同数据库。

数据库特点： 数据以设备的维度管理，不存在冲突；支持按照设备的维度查询数据。

SINGLE_VERSION

表示单版本数据库。

数据库特点： 数据不分设备，设备之间修改相同的key会覆盖。

```

##### SecurityLevel

```text
数据库的安全级别枚举。

S1

表示数据库的安全级别为低级别，数据的泄露、篡改、破坏、销毁可能会给个人或组织导致有限的不利影响。

例如，性别、国籍，用户申请记录等。

S2

表示数据库的安全级别为中级别，数据的泄露、篡改、破坏、销毁可能会给个人或组织导致严重的不利影响。

例如，个人详细通信地址，姓名昵称等。

S3

表示数据库的安全级别为高级别，数据的泄露、篡改、破坏、销毁可能会给个人或组织导致严峻的不利影响。

例如，个人实时精确定位信息、运动轨迹等。

S4

表示数据库的安全级别为关键级别，业界法律法规中定义的特殊数据类型，涉及个人的最私密领域的信息或者一旦泄露、篡改、破坏、销毁可能会给个人或组织造成重大的不利影响数据。

例如，政治观点、宗教、和哲学信仰、工会成员资格、基因数据、生物信息、健康和性生活状况、性取向等或设备认证鉴权、个人的信用卡等财务信息。
```

### 2、存储数据

```typescript
DataKvUtil.getInstance().put("key", "value")
```

**监听是否存储成功**

```typescript
DataKvUtil.getInstance().put("key", "value", (isSuccess:boolean) => {

})
```

**监听是否存储成功和失败**

```typescript
DataKvUtil.getInstance().put("key", "value", (isSuccess:boolean, err:BusinessError) => {
  //当isSuccess 为false，err为报错信息
})
```

**使用Promise异步回调**

```typescript
let pPromise = DataKvUtil.getInstance().putPromise("key", "value")
//自己通过Promise 判断成功和失败
```

### 3、获取数据

```typescript
DataKvUtil.getInstance().get("key", (data) => {

})
```

**监听失败**

```typescript
DataKvUtil.getInstance().get("key", (data) => {

}, (err:BusinessError) => {

})
```

**使用Promise异步回调**

```typescript
let pPromise = DataKvUtil.getInstance().getPromise("key")
//自己通过Promise 获取数据，或判断失败
```

### 3、删除数据

```typescript
DataKvUtil.getInstance().delete("key")
```

**监听是否删除成功**

```typescript
DataKvUtil.getInstance().delete("key", (isSuccess: boolean) => {
  //isSuccess判断是否删除成功
})
```

**监听是否删除失败**

```typescript
DataKvUtil.getInstance().delete("key", (isSuccess: boolean, err?: BusinessError) => {
  //isSuccess为false err为错误信息
})
```

**使用Promise异步回调**

```typescript
let pPromise = DataKvUtil.getInstance().deletePromise("key")
//自己通过Promise判断成功或失败
```

### 4、修改数据

**修改同添加一致，数据会覆盖原有的key**

### 5、获取默认的StoreId

```typescript
DataKvUtil.getInstance().getStoreId()
```

### 6、删除指定的分布式键值数据库

```typescript
DataKvUtil.getInstance().deleteKVStore("storeId")
```

**监听是否删除成功**

```typescript
DataKvUtil.getInstance().deleteKVStore("storeId", (isSuccess: boolean) => {
  //isSuccess判断是否删除成功
})
```

**监听是否删除失败**

```typescript
DataKvUtil.getInstance().deleteKVStore("storeId", (isSuccess: boolean, err?: BusinessError) => {
  //isSuccess为false err为错误信息
})
```

### 7、创建一个新的并获取分布式键值数据库

默认会有一个，如果您打算再新建一个，可以调用此方法！

```typescript
DataKvUtil.getInstance().createKVStore("storeId")
```

### 8、新的数据库执行增删改查

先设置自己创建的数据库，也就是第7中的storeId

```typescript
DataKvUtil.getInstance().setKVStore("storeId") //和之前保持一致，执行各种的方法即可。
```

## 关系型数据库

### 1、初始化

建议在AbilityStage里进行初始化，如果你要配置数据库相关配置，可以传递第二个参数。

```typescript

DbUtil.getInstance().init(this.context)

```

#### 相关属性介绍

| 属性          | 类型                          | 概述      |
|-------------|-----------------------------|---------|
| context     | Context                     | 上下文     |
| storeConfig | relationalStore.StoreConfig | 数据库相关配置 |

##### storeConfig

| 属性                 | 类型            | 是否必填 | 说明                                                                                                                                   |
|--------------------|---------------|------|--------------------------------------------------------------------------------------------------------------------------------------|
| name               | string        | 是    | 数据库文件名，也是数据库唯一标识符。                                                                                                                   |
| securityLevel      | SecurityLevel | 是    | 设置数据库安全级别。                                                                                                                           |
| encrypt            | boolean       | 否    | 指定数据库是否加密，默认不加密。true:加密。false:非加密。                                                                                                   |
| dataGroupId        | string        | 否    | 应用组ID，需要向应用市场获取。模型约束： 此属性仅在Stage模型下可用。从API version 10开始，支持此可选参数。指定在此dataGroupId对应的沙箱路径下创建RdbStore实例，当此参数不填时，默认在本应用沙箱目录下创建RdbStore实例。 |
| customDir          | string        | 否    | 数据库自定义路径。使用约束： 数据库路径大小限制为128字节，如果超过该大小会开库失败，返回错误。                                                                                    |
| autoCleanDirtyData | boolean       | 否    | 指定是否自动清理云端删除后同步到本地的数据，true表示自动清理，false表示手动清理，默认自动清理。                                                                                 |

##### SecurityLevel

| 属性  | 值   | 概述                                                          |
|-----|-----|-------------------------------------------------------------|
| S1  | 1   | 表示数据库的安全级别为低级别，当数据泄露时会产生较低影响。例如，包含壁纸等系统数据的数据库。              |
| S2  | 2   | 表示数据库的安全级别为中级别，当数据泄露时会产生较大影响。例如，包含录音、视频等用户生成数据或通话记录等信息的数据库。 |
| S3  | 3   | 表示数据库的安全级别为高级别，当数据泄露时会产生重大影响。例如，包含用户运动、健康、位置等信息的数据库。        |
| S4  | 4   | 表示数据库的安全级别为关键级别，当数据泄露时会产生严重影响。例如，包含认证凭据、财务数据等信息的数据库。        |

### 2、创建数据库表

#### 【sql语句创建】

```typescript
DbUtil.getInstance().executeSql("")
```

**检查是否执行成功**

```typescript
DbUtil.getInstance().executeSql("sql语句", (isSuccess: boolean) => {
  //isSuccess判断是否执行成功
})
```

**失败**

```typescript
DbUtil.getInstance().executeSql("sql语句"
  , (isSuccess: boolean, error?: BusinessError) => {
    //isSuccess 为false error可获取
  })
```

#### 【对象形式创建】

```typescript
 DbUtil.getInstance().createTable("表名", {
  "id": { type: DbTableFieldType.INTEGER, isPrimaryKey: true, isAutoIncrement: true },
  "name": { type: DbTableFieldType.VARCHAR, length: 120 },
  "age": { type: DbTableFieldType.INT, length: 30 }
})
```

createTable有两个参数，第一个是表名，第二个是各个字段名，具体可看以上代码。

### 3、添加数据

#### 【原生Api形式添加】

```typescript
const valueBucket1: ValuesBucket = {
  'NAME': "value1",
  'AGE': 18,
  'SALARY': 100.8,
  'CODES': new Uint8Array([1, 2, 3, 4, 5]),
};

DbUtil.getInstance().insert("tableName", valueBucket1)
```

#### 【对象形式添加】

```typescript
        let bean = new DbDataBean()
bean.name = "AbnerMing"
bean.age = 18
DbUtil.getInstance().insertBean("表名", bean)
```

### 4、添加一组数据

```typescript
 const valueBucket1: ValuesBucket = {
  'NAME': "value1",
  'AGE': 18,
  'SALARY': 100.8,
  'CODES': new Uint8Array([1, 2, 3, 4, 5]),
};
const valueBucket2: ValuesBucket = {
  'NAME': "value1",
  'AGE': 18,
  'SALARY': 100.8,
  'CODES': new Uint8Array([1, 2, 3, 4, 5]),
};

DbUtil.getInstance().batchInsert("tableName", [valueBucket1, valueBucket2])
```

### 5、查询数据

#### 【sql语句查询】

```typescript
let predicates = new relationalStore.RdbPredicates("EMPLOYEE"); //数据库表名
predicates.equalTo("NAME", "Rose"); //查询条件

DbUtil.getInstance().query(predicates, (result: relationalStore.ResultSet) => {

  while (resultSet.goToNextRow()) {
    const id = resultSet.getLong(resultSet.getColumnIndex("ID"));
    const name = resultSet.getString(resultSet.getColumnIndex("NAME"));
    const age = resultSet.getLong(resultSet.getColumnIndex("AGE"));
    const salary = resultSet.getDouble(resultSet.getColumnIndex("SALARY"));
    console.info(`id=${id}, name=${name}, age=${age}, salary=${salary}`);
  }
})
```

#### 【对象形式查询】

**获取全部对象**

```typescript
DbUtil.getInstance()
  .queryAllBean<DbDataBean>("表名", (data) => {

  })
```

**获取单个对象**

```typescript
          DbUtil.getInstance()
  .filterRdbPredicates({ equalTo: { "id": 1 } })//过滤条件
  .queryBean<DbDataBean>("abner_ming", (data) => {
    console.log("====" + JSON.stringify(data))
  })
```

### 5、删除数据

#### 【系统Api形式删除】

```typescript
let predicates = new relationalStore.RdbPredicates("EMPLOYEE"); //数据库表名
predicates.equalTo("NAME", "Rose"); //查询条件
DbUtil.getInstance().delete(predicates)
```

**检查是否执行成功**

```typescript
let predicates = new relationalStore.RdbPredicates("EMPLOYEE"); //数据库表名
predicates.equalTo("NAME", "Rose"); //条件
DbUtil.getInstance().delete(predicates, (rows: number) => {
  //删除成功
})
```

**带有失败**

```typescript
 let predicates = new relationalStore.RdbPredicates("EMPLOYEE"); //数据库表名
predicates.equalTo("NAME", "Rose"); //条件
DbUtil.getInstance().delete(predicates, (rows: number) => {
  //删除成功
}, (err: BusinessError) => {
  //失败
})
```

#### 【对象形式删除】

```typescript
DbUtil.getInstance()
  .filterRdbPredicates({ equalTo: { "id": 1 } })//过滤条件
  .deleteBean("表名")
```

### 6、更新数据

#### 【系统Api形式更新】

```typescript
  const valueBucket1: ValuesBucket = {
  'NAME': "value1",
  'AGE': 18,
  'SALARY': 100.8,
  'CODES': new Uint8Array([1, 2, 3, 4, 5]),
};

let predicates = new relationalStore.RdbPredicates("EMPLOYEE"); //数据库表名
predicates.equalTo("NAME", "Rose"); //条件

DbUtil.getInstance().update(predicates, valueBucket1)
```

**检查是否执行成功**

```typescript
 const valueBucket1: ValuesBucket = {
  'NAME': "value1",
  'AGE': 18,
  'SALARY': 100.8,
  'CODES': new Uint8Array([1, 2, 3, 4, 5]),
};

let predicates = new relationalStore.RdbPredicates("EMPLOYEE"); //数据库表名
predicates.equalTo("NAME", "Rose"); //条件

DbUtil.getInstance().update(predicates, valueBucket1, (rowId: number) => {
  //更新成功回调
}, (err: BusinessError) => {
  //更新失败回调，
})
```

#### 【对象形式更新】

```typescript
 let uBean = new DbDataBean()
uBean.name = "Ming"
uBean.age = 20
DbUtil.getInstance()
  .filterRdbPredicates({ equalTo: { "id": 2 } })//过滤条件
  .updateBean("表名", uBean)
```

### 7、SQL语句查询数据

```typescript

DbUtil.getInstance().querySql("sql语句",
  (result: relationalStore.ResultSet) => {
    // resultSet是一个数据集合的游标，默认指向第-1个记录，有效的数据从0开始。
    while (resultSet.goToNextRow()) {
      const id = resultSet.getLong(resultSet.getColumnIndex("ID"));
      const name = resultSet.getString(resultSet.getColumnIndex("NAME"));
      const age = resultSet.getLong(resultSet.getColumnIndex("AGE"));
      const salary = resultSet.getDouble(resultSet.getColumnIndex("SALARY"));
      console.info(`id=${id}, name=${name}, age=${age}, salary=${salary}`);
    }
  })

```

## 关注公众号

鸿蒙先驱者，只分享精华的鸿蒙或者移动端技术文章，可微信扫码关注

<p><img src="https://vipandroid-image.oss-cn-beijing.aliyuncs.com/harmony/abner.jpg" width="150px" /></p>

[鸿蒙精华技术文章列表](https://juejin.cn/column/7269566781248389178)

## 一对一指导【收费】

每个人的时间都是宝贵的，做为开发者的我，已经做到了技术上的免费开源，但仍然有很多问题无法做到及时处理。
也考虑到，鸿蒙是一个新的系统，大家在使用上会遇到各种各样的问题，也为了能够及时的解决及回复问题，大家可以付费进行一对一指导。

### 开源库使用指导

<p><img src="https://vipandroid-image.oss-cn-beijing.aliyuncs.com/harmony/h_github_9.png" width="150px" /></p>

**重要信息：一定要在付款时备注您的微信号，我会主动加您！切记！切记！！切记！！！**
**诚信经营，来自一个北漂的老程序员心声！**

**一杯饮料的钱，您可以获取权益如下**

- 1、针对数据存储库使用1对1辅导使用，并跟踪相关问题排查。
- 2、针对我的所有鸿蒙开源库，1对1辅导使用，并跟踪相关问题排查。
- 3、涉及到我的开源库，您提的业务需求，率先第一时间满足，并及时针对性开发。
- 4、未来我的鸿蒙开源库，可先遣体验。
- 5、鸿蒙脚手架，正在研发中，可首批次体验使用。

## License

```
Copyright (C) AbnerMing, HarmonyOsDataStore Open Source Project

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
