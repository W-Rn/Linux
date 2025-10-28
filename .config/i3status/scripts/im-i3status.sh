fcitx_status() {
  # 合并检查与状态获取，仅调用一次 fcitx-remote
  if fcitx_output=$(fcitx-remote 2>/dev/null); then
    if [ "$fcitx_output" -eq 1 ]; then
      echo "EN"
    else
      echo "中"
    fi
  else
    echo "Fcitx未运行"
  fi
}

fcitx_status
