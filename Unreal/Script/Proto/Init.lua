-----------------------------------------------------------------------------
-- Author: i0gan
-- Email : l418894113@gmail.com
-- Date  : 2023-01-02
-- Description: Proto 文件，enum.lua 和 code.lua 由服务端工具自动生成提供
-----------------------------------------------------------------------------


pb = require "pb"
protoc = require "protoc"
require "Proto.enum"
require "Proto.code"

assert(protoc:load(proto_code))
