## Bililive Systemd Webhook
[BililiveRecorder](https://github.com/BililiveRecorder/BililiveRecorder) 的 Webhook 服务器

### 安装
1. 前置依赖 [jq](https://github.com/jqlang/jq)
2. [bililive-systemd-webhook.socket](systemd/user/bililive-systemd-webhook.socket)、[bililive-systemd-webhook@.service](systemd/user/bililive-systemd-webhook@.service) 放在 `$HOME/.config/systemd/user/`
3. 启用单元 `$ systemctl --user enable --now bililive-systemd-webhook.socket`
4. [bililive-systemd-webhook.sh](bin/bililive-systemd-webhook.sh) 放在 `$HOME/.local/bin/`
5. 创建配置目录`$ mkdir $HOME/.config/bililive-systemd-webhook/hooks/`
6. 在配置目录下按需根据 [事件类型](https://rec.danmuji.org/reference/webhook/) 创建子目录

`bililive-systemd-webhook.sh` 将依次调用配置目录和对应事件类型子目录的脚本，传递参数依次为 事件类型、主播名字、直播间标题、房间号 和 `BililiveRecorder` 原请求内容

### 测试
1. [main](hooks/main) 放入配置目录
2. 创建子目录 `StreamStarted` 放入 [00-notify](hooks/StreamStarted/00-notify)
3. 执行 [test.sh](test.sh)
4. 查看日志 `$ journalctl --user --unit bililive-systemd-webhook@*`
