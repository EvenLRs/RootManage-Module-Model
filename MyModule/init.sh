MODDIR=${0%/*}
source $MODDIR/tools # 导入工具函数
url=$(extract_sub_url)
clean_old_logs

if [ "$url" = "订阅链接" ]; then
    status="请在${mihomo_config}或者env文件中修改订阅链接😶‍🌫️"
    url=$(grep '^url=' "$ENV_FILE" | cut -d '=' -f 2)
    if ["$url" != "订阅链接"]; then
        set_sub_url "$url"
        status="成功恢复订阅链接😊"
    fi
else
    status="已填写😊"
    echo "url=$url" > $MODDIR/env
fi

# 判断管理器类型并替换修改模块名称 
if [ "$KSU" = "true" ]; then
    sed -i "s/^name=.*/name=MagicNet_ksu/" "$MODULE_PROP"
elif [ "$APATCH" = "true" ]; then
    sed -i "s/^name=.*/name=MagicNet_apu/" "$MODULE_PROP"
else
    abort "你怎么安装上的?"
fi

if [ -x "${mihomo}" ]; then
    log INFO "mihomo内核已就绪"
else
    log Error "未找到/不可执行 ${mihomo}"
    exit 1
fi

sed -i "s/^description=.*/description=[时间]-$data\ [订阅状态]-$status\ [mihomo]-$(mihomo -v)/" "$MODULE_PROP"
