#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate

# 更新golang包
golangdir="feeds/packages/lang/golang"
rm -rf "$golangdir"
mkdir -p "$golangdir"
GIT_CLONE_OUTPUT=$(git clone https://github.com/sbwml/packages_lang_golang -b 24.x "$golangdir" 2>&1)
CLONE_EXIT_CODE=$?
if [ $CLONE_EXIT_CODE -eq 0 ]; then
    echo -e "✅ golang 包更新成功"
else
    echo -e "❌ golang 包更新失败：$GIT_CLONE_OUTPUT"
    exit 1
fi

# 修改插件名字
# 参数1: 原名称
# 参数2: 新名称
update_name(){  
    local old_name=$1  
    local new_name=$2  
    if grep -r "$old_name" . > /dev/null; then  
        echo -e "✅ 找到 $old_name，开始替换为 $new_name"  
        grep -rl "$old_name" . | xargs -r sed -i "s?$old_name?$new_name?g"  
    else  
        echo -e "ℹ️ 未找到 $old_name，跳过替换"  
    fi  
}
# 替换插件名字
update_name "终端" "TTYD"
update_name "TTYD 终端" "TTYD"
update_name "网络存储" "NAS"
update_name "实时流量监测" "流量监测"
update_name "KMS 服务器" "KMS"
update_name "USB 打印服务器" "打印服务"
update_name "Web 管理" "Web管理"
# update_name "管理权" "账号管理"
update_name "带宽监控" "监控"

# 显示最终配置文件信息
echo "✅ diy-part2.sh 执行完成"
