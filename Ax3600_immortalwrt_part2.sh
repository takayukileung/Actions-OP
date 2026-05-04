#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# 修改默认 IP
#sed -i 's/192.168.1.1/192.168.88.1/g' package/base-files/files/bin/config_generate

# 删除 sysupgrade
sed -i "/attendedsysupgrade/d" $(find ./feeds/luci/collections/ -type f -name "Makefile")

# 修改 zerotier
sed -i 's/8056c2e21c000001/9f77fc393e758059/g' feeds/packages/net/zerotier/files/etc/config/zerotier

#rm -rf feeds/packages/net/geoview
#mkdir package/geoview
#wget -O package/geoview/Makefile https://raw.githubusercontent.com/xiaorouji/openwrt-passwall-packages/refs/heads/main/geoview/Makefile

# 添加 luci-app-tailscale-community
git clone https://github.com/Tokisaki-Galaxy/luci-app-tailscale-community.git package/luci-app-tailscale-community

# 添加 luci-theme-aurora 和 luci-app-aurora-config 并替换默认主题和修改样式
git clone https://github.com/eamonxg/luci-theme-aurora.git package/luci-theme-aurora
git clone https://github.com/eamonxg/luci-app-aurora-config.git package/luci-app-aurora-config
sed -i "s/luci-theme-bootstrap/luci-theme-aurora/g" $(find ./feeds/luci/collections/ -type f -name "Makefile")
sed -i "s/nav_submenu_type '.*'/nav_submenu_type 'boxed-dropdown'/g" $(find ./package/luci-app-aurora-config/root/usr/share/aurora/ -type f -name "*.template")

# 修改qca-nss-drv启动顺序
sed -i 's/START=.*/START=85/g' feeds/nss_packages/qca-nss-drv/files/qca-nss-drv.init
# 修改qca-nss-pbuf启动顺序
sed -i 's/START=.*/START=86/g' package/kernel/mac80211/files/qca-nss-pbuf.init

# 添加 luci-app-lucky
git clone https://github.com/gdy666/luci-app-lucky.git package/lucky

# 添加 luci-app-timecontrol
git clone https://github.com/sirpdboy/luci-app-timecontrol.git package/luci-app-timecontrol

# 添加 luci-app-taskplan
git clone https://github.com/sirpdboy/luci-app-taskplan.git package/luci-app-taskplan

echo 'refresh feeds'
./scripts/feeds update -a
./scripts/feeds install -a

