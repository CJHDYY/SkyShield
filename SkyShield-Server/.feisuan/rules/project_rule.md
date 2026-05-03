# SkyShield 项目规范指引

为保证项目结构清晰、便于维护，后续开发请遵循以下约定。

## 项目信息

- 项目名称：天穹之盾管理系统（SkyShield）
- 后端根包：`com.skyshield`
- Maven 模块：`skyshield-admin`、`skyshield-common`、`skyshield-framework`、`skyshield-generator`、`skyshield-quartz`、`skyshield-system`
- 前端模块：`skyshield-ui`
- 数据库脚本：`sql/skyshield_20250522.sql`

## 分层约定

- Controller 仅处理 HTTP 入参、权限注解和响应封装。
- Service 承载业务逻辑，接口与实现保持分离，实现在 `impl` 子包中。
- Mapper 只处理持久化访问，复杂 SQL 放在对应 XML 中。
- Domain/Entity 映射数据结构，避免直接承载过重业务逻辑。

## 命名约定

- Java 包名统一使用 `com.skyshield`。
- 类名使用 UpperCamelCase，方法和变量使用 lowerCamelCase。
- 常量使用 UPPER_SNAKE_CASE。
- 新增模块、脚本、配置和注释中统一使用 SkyShield / 天穹之盾，不再使用旧品牌名。

## 开发约定

- 新增配置优先放入现有配置体系，避免重复造配置入口。
- 新增公共能力优先放入 `skyshield-common` 或 `skyshield-framework` 的既有职责范围内。
- 涉及用户、角色、菜单、定时任务等系统能力时，同步检查后端、前端、Mapper XML 和初始化 SQL。
