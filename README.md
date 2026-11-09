# ClientBank

> 用户-银行管理系统课程设计

## 项目简介

ClientBank 是一个基于 B/S 架构的银行管理系统，采用前后端分离的设计模式。前端使用 Vue.js 构建用户界面，后端使用 Java（Spring Boot）提供 RESTful API 服务，实现用户管理、账户管理、转账、交易流水查询等核心银行业务功能。

## 项目特点

- **前后端分离**：前端 Vue + 后端 Spring Boot 独立开发、独立部署
- **RESTful API**：后端采用标准的 RESTful 接口设计规范
- **课程实践**：涵盖数据库设计、接口开发、前端交互等完整开发流程
- **版本管理**：使用 Git 进行代码版本控制，团队协作友好

## 技术栈

| 层级     | 技术               | 说明                   |
| -------- | ------------------ | ---------------------- |
| 前端     | Vue.js             | 渐进式 JavaScript 框架 |
| 后端     | Java / Spring Boot | 企业级 Java 应用框架   |
| 数据库   | MySQL              | 关系型数据库           |
| 版本控制 | Git                | 分布式版本控制系统     |
| 接口通信 | HTTP / REST        | 前后端数据交互协议     |

## 项目结构

```
ClientBank/
├── ClientBank-java/          # 后端项目（Spring Boot）
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/         # Java 源代码
│   │   │   └── resources/    # 配置文件
│   │   └── test/             # 测试代码
│   └── pom.xml               # Maven 依赖配置
├── ClientBank-vue/           # 前端项目（Vue.js）
│   ├── src/
│   │   ├── components/       # 组件
│   │   ├── views/            # 页面
│   │   ├── api/              # 接口请求
│   │   └── router/           # 路由配置
│   └── package.json          # 项目依赖配置
└── README.md                 # 项目说明文档
```

## 运行步骤

### 1. 克隆项目

在本地创建项目文件夹，打开 Git Bash，执行以下命令克隆项目：

```bash
git clone https://github.com/ouyehei/ClientBank.git
cd ClientBank
```

### 2. 启动后端（Java）

1. 进入后端项目目录：`cd ClientBank-java`
2. 使用 IDEA 打开项目，等待 Maven 依赖加载完成
3. 配置好数据库连接信息（`application.yml` 或 `application.properties`）
4. 运行主启动类

### 3. 启动前端（Vue）

1. 进入前端项目目录：`cd ClientBank-vue`
2. 安装依赖：`npm install`
3. 启动开发服务器：`npm run dev`
4. 浏览器访问 `http://localhost:6137`

## 功能模块

| 角色     | 模块     | 功能说明                           |
| -------- | -------- | ---------------------------------- |
| 普通用户 | 信息管理 | 用户注册、登录、个人信息查看与修改 |
|          | 账户管理 | 账户开户、销户、账户信息查询       |
|          | 转账功能 | 账户间转账、余额查询，借贷还款     |
|          | 交易流水 | 查看历史交易记录、流水明细         |

## 关于作者

- **项目地址**：https://github.com/ouyehei/ClientBank
- **项目类型**：课程设计
