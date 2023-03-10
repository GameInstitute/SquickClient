# Squick UE4 SDK

## 介绍

基于Unlua，采用Lua编写的集成网络通信模块，支持客户端与专用服务器开发，目前专用服务器已接入。

将Script和Blueprints拷贝到工程项目中即可



## UE4插件

### Unlua

版本号：v2.3.2

[下载](https://img.shields.io/github/v/release/Tencent/UnLua)

#### 介绍

本项目集成了 Unlua 系列的插件，方便开发者使用lua脚本进行Protobuf + Socket的包自定义交互协议。

Lua与蓝图、C++互相调用，请参考：https://github.com/Tencent/UnLua

Unlua也接入了常使用的基本网络库，在Plugins/UnLuaExtensions/下，分别为 LuaProtobuf、LuaRapidjson、LuaSocket，但没有提供相关学习例子，我进行了部分整理，如下：

LuaProtobuf序列化反序列化如何使用，请参考： https://github.com/starwing/lua-protobuf

LuaSocket如何使用，请参考：https://github.com/lunarmodules/luasocket

LuaRapidjson如何使用，请参考：https://github.com/xpol/lua-rapidjson
