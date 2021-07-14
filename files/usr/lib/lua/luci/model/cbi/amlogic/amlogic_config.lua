local fs = require "luci.fs"
local http = require "luci.http"
local DISP = require "luci.dispatcher"
local m, b

--Set Default value
default_firmware_repo="cocokfeng/n1-rom"
local amlogic_firmware_repo = luci.sys.exec("uci get amlogic.config.amlogic_firmware_repo 2>/dev/null") or default_firmware_repo

default_firmware_tag="n1_lede"
local amlogic_firmware_tag = luci.sys.exec("uci get amlogic.config.amlogic_firmware_tag 2>/dev/null") or default_firmware_tag

default_firmware_suffix=".img.gz"
local amlogic_firmware_suffix = luci.sys.exec("uci get amlogic.config.amlogic_firmware_suffix 2>/dev/null") or default_firmware_suffix

default_kernel_path="n1/kernel"
local amlogic_kernel_path = luci.sys.exec("uci get amlogic.config.amlogic_kernel_path 2>/dev/null") or default_kernel_path

--SimpleForm for nil
m = SimpleForm("", "", nil)
m.reset = false
m.submit = false

--SimpleForm for Config Source
b = SimpleForm("amlogic_check", translate("在线更新设置"), nil)
b.description = translate("设置【在线下载更新】功能需要的固件地址资源相关信息，如果在线升级速度慢，你可以下载后上传升级，也可以尝试挂梯子升级.")
b.reset = false
b.submit = false
s = b:section(SimpleSection, "", "")


--1.Set OpenWrt Firmware Repository
o = s:option(Value, "firmware_repo", translate("固件仓库地址:"))
o.rmempty = true
o.default = amlogic_firmware_repo
o.write = function(self, key, value)
	if value == "" then
        --self.description = translate("Invalid value.")
        amlogic_firmware_repo = default_firmware_repo
	else
        --self.description = translate("OpenWrt Firmware Repository:") .. value
        amlogic_firmware_repo = value
	end
end

--2.Set OpenWrt Releases Tag Keywords
o = s:option(Value, "firmware_tag", translate("固件标签关键字:"))
o.rmempty = true
o.default = amlogic_firmware_tag
o.write = function(self, key, value)
	if value == "" then
        --self.description = translate("Invalid value.")
        amlogic_firmware_tag = default_firmware_tag
	else
        --self.description = translate("OpenWrt Releases Tag Keywords:") .. value
        amlogic_firmware_tag = value
	end
end



--3.Set OpenWrt Kernel DownLoad Path
o = s:option(Value, "kernel_repo", translate("固件内核路径:"))
o.rmempty = true
o.default = amlogic_kernel_path
o.write = function(self, key, value)
	if value == "" then
        --self.description = translate("Invalid value.")
        amlogic_kernel_path = default_kernel_path
	else
        --self.description = translate("OpenWrt Kernel DownLoad Path:") .. value
        amlogic_kernel_path = value
	end
end

--4.Save button
o = s:option(Button, "", translate("Save Config:"))
o.template = "amlogic/other_button"
o.render = function(self, section, scope)
	self.section = true
	scope.display = ""
	self.inputtitle = translate("Save")
	self.inputstyle = "apply"
	Button.render(self, section, scope)
end
o.write = function(self, section, scope)
	luci.sys.exec("uci set amlogic.config.amlogic_firmware_repo=" .. amlogic_firmware_repo .. " 2>/dev/null")
	luci.sys.exec("uci set amlogic.config.amlogic_firmware_tag=" .. amlogic_firmware_tag .. " 2>/dev/null")
	luci.sys.exec("uci set amlogic.config.amlogic_kernel_path=" .. amlogic_kernel_path .. " 2>/dev/null")
	luci.sys.exec("uci commit amlogic 2>/dev/null")
	http.redirect(DISP.build_url("admin", "system", "amlogic", "config"))
	--self.description = "amlogic_firmware_repo: " .. amlogic_firmware_repo
end


return m, b
