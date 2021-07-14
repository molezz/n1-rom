local fs = require "luci.fs"
local http = require "luci.http"
local DISP = require "luci.dispatcher"
local b

--SimpleForm for Check
b = SimpleForm("amlogic", translate("在线下载更新"), nil)
b.description = translate("提供 OpenWrt 固件，内核和插件在线检查，下载和更新服务")
b.reset = false
b.submit = false
b:section(SimpleSection).template  = "amlogic/other_check"


return b

