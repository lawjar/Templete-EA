# EA Template Project - Copilot Prompts Library
這個檔案儲存了此專案常用的複雜指令。
使用方法：在 Copilot Chat 中輸入 "@workspace 根據 prompts.md 的 [任務標題] 執行任務"。

---

## 任務：代碼審查 (Code Review)
**指令內容：**
作為 MQL5 Expert，請嚴格檢查當前開啟的檔案：
1. **安全性**：
   - 是否有 \`OrderSend\` / \`m_trade\` 呼叫缺少返回值檢查？
   - 是否有 \`Zero Divide\` 風險？
   - **下單前手數是否全部經過 \`VerifyVolume\` (或 \`NormalizeDouble\` 符合 \`SYMBOL_VOLUME_STEP\`) 的處理？** (確保 InitialLot 與後續加倉手數皆符合規範)
2. **規範**：變數命名是否符合 PascalCase？是否有足夠的繁體中文註釋？
3. **邏輯**：是否有潛在的邏輯漏洞（特別是 Zone Recovery 的層數計算、與歷史訂單同步的問題）？
4. **載入 .set 及重啟 MT5 的影響 (Reinit Safety Check)**：
   - **`static` 變數殘留**：搜尋所有 `static` 使用（尤其 helper 函式如 `IsNewBar()`）。確認 `OnInit()` 結尾有 reset 呼叫（如 `IsNewBar(true)`），避免 load .set 或重啟後跳過訊號或錯誤觸發。
   - **Indicator Handle 失效**：確認 `OnDeinit()` 有 `IndicatorRelease()`，`OnInit()` 有重新建立 handle。`CopyBuffer()` 必須檢查返回值 `> 0` 及 `handle != INVALID_HANDLE`，避免 crash 或錯誤數值。
   - **State Recovery**：重啟時若有持倉，確認 `OnInit()` 有條件呼叫 state recovery 函式，能正確重建關鍵狀態（如 zone levels）。若恢復失敗，有 guard 阻止錯誤操作。
   - **重啟後即刻操作風險**：避免 state 剛恢復時因舊條件觸發錯誤平倉或開倉。`EntryMode = ENTRY_ON_BAR_CLOSE` 時，確認 `IsNewBar()` 不會在未完結 bar 中途返回 `true`。
請以條列式列出改進建議。

---

## 任務：解釋策略邏輯
**指令內容：**
請用簡單的廣東話，向使用者解釋這段程式碼背後的交易邏輯。
重點解釋：進場條件為何？如何處理浮虧 (Drawdown)？Risk Management 是什麼？如果不止蝕，這個 EA 是如何透過 Zone Recovery 救回倉位的？

---

## 任務：編譯 EA (Compile EA)
**指令內容：**
這是在 MT5 環境下自動編譯指定 `.mq5` 檔案的流程：
1. **尋找編譯器**：
   - 預設使用路徑 `"C:\Program Files\Ming Tak MetaTrader 5 Terminal\metaeditor64.exe"`。
2. **執行編譯**：
   - 使用 PowerShell 的 `Start-Process` 執行編譯，必須使用嚴格的參數格式：
     `Start-Process -FilePath "C:\Program Files\Ming Tak MetaTrader 5 Terminal\metaeditor64.exe" -ArgumentList "/compile:e:\AlgoTrading\Lawjar-Algo\Templete-EA\{目標檔案}.mq5", "/log:e:\AlgoTrading\Lawjar-Algo\Templete-EA\log\compile.log" -Wait -NoNewWindow`
3. **檢查結果**：
   - 讀取 `log\compile.log` 檔案，確認是否有 Errors 或 Warnings。
   - 如果成功，確認 `.ex5` 檔案已生成。

---

## 任務：開新版本分支 (New Version)
**指令內容：**
這是開發新版本的初始化流程，按以下步驟執行：
1. **前置檢查 (Pre-check)**：
   - 執行 \`git status\` 確保工作區乾淨。
   - **檢查備份**：確認當前即將被替換的版本已經複製到 \`releases/\` 資料夾（\`.mq5\` 必須存在）。
2. **讀取當前版本號**：
   - 搜尋工作區根目錄最新的 \`EA_Template_v*.mq5\` 檔案，讀取 \`#property version\` 的數值 (e.g., \`"1.00"\`)。
3. **計算下一版本號**：
   - 將版本號最後兩位加 1 (e.g., \`1.00\` → \`1.01\`)。
4. **建立新 Git 分支**：
   - 執行 PowerShell：\`git checkout -b dev/v{新版本號}\` (e.g., \`git checkout -b dev/v1.01\`)。
5. **複製 .mq5 主程式碼檔案**：
   - 執行 PowerShell：\`Copy-Item EA_Template_v{舊版本號}.mq5 EA_Template_v{新版本號}.mq5\`。
6. **更新新檔案的版本號與 Metadata**：
   - 修改新 \`.mq5\` 檔案頭部的 \`#property version\` 為新版本號。
   - **同步修正 Metadata**：確保 \`OnInit()\` 中的 \`Print\` 語句、\`LogComment\` 的預設值均與新版本號一致。
7. **在 TODO.md 新增版本節點**：
   - 在 \`TODO.md\` 最頂部加入新的標題節 \`## ✅ Planned for v{新版本號}\` 並列出準備開發的功能。
8. **Git 初始提交**：
   - 執行 PowerShell：\`git add .\`，然後 \`git commit -m "chore: 初始化 v{新版本號} 開發分支"\`，最後 \`git push -u origin dev/v{新版本號}\`。
9. **完成提示**：
   - 告知用戶目前已在 \`dev/v{新版本號}\` 分支。

---

## 任務：合併版本分支 (Merge Version / Release)
**指令內容：**
這是將 dev 分支合併回 main 的正式發布流程，請嚴格按以下步驟執行：
1. **確認當前分支與狀態**：
   - 執行 \`git branch --show-current\` 確認目前在 \`dev/v*\` 分支。
   - 執行 \`git status\` 確保工作區乾淨。
2. **資料夾備份 (Mandatory Backup)**：
   - **第一優先**：必須先將目前的 \`.mq5\` 檔案複製到 \`releases/\` 資料夾。
   - 執行 PowerShell：\`Copy-Item EA_Template_v{版本號}.mq5 releases\EA_Template_v{版本號}.mq5 -Force\`。
   - ⚠️ 提醒用戶：請立即在 MetaEditor 編譯產生的 \`releases/EA_Template_v{版本號}.mq5\` 並將 \`.ex5\` 同步存入 \`releases/\`。
   - **自動編譯**：呼叫「任務：編譯 EA (Compile EA)」自動編譯 \`releases/EA_Template_v{版本號}.mq5\`。
3. **預發布文件檢查**：
   - 確認 \`README.md\` 的 Current Version 與 Change Log 已更新。
   - 確認 \`TODO.md\` 該版本的項目已移至 \`✅ Completed\`。
4. **最終 commit dev 分支**：
   - 執行 \`git add .\`，\`git commit -m "feat: 正式發布 v{版本號} - [簡述新功能]"\`。
   - 執行 \`git push\`。
5. **切換到 main 並合併**：
   - 執行 \`git checkout main\`。
   - 執行 \`git merge --no-ff dev/v{版本號} -m "chore: 合併 dev/v{版本號} 至 main"\`。
6. **打 Tag 與清理**：
   - 執行 \`git tag -a v{版本號} -m "Release v{版本號}"\`。
   - 執行 \`git push origin main --tags\`。
   - 詢問用戶是否刪除舊的 \`dev/v{版本號}\` 分支。
7. **完成提示**：
   - 告知用戶 v{版本號} 已正式歸檔至 \`main\` 及 \`releases/\`。

---

## 任務：快速發布 (Quick Release on Main)
**指令內容：**
這是在 main 分支直接進行小版本更新的流程：
1. **前置檢查 (Release Check)**：
   - 執行 \`git pull\` 確保同步，並檢查工作區是否有不相關改動。
   - **確認備份**：檢查 \`releases/\` 資料夾是否已有當前版本的副本。
2. **讀取版本號**：
   - 搜尋工作區最新的 \`EA_Template_v*.mq5\` 並讀取版本。
3. **更新文件**：同步更新 \`README.md\` (Version/Changes)、\`docs/PARAMETERS.md\` 及 \`TODO.md\`。
4. **導出至 Releases**：執行 PowerShell \`Copy-Item EA_Template_v{版本號}.mq5 releases\EA_Template_v{版本號}.mq5 -Force\`。
5. **自動編譯**：呼叫「任務：編譯 EA (Compile EA)」自動編譯 \`releases/EA_Template_v{版本號}.mq5\`。
6. **Git 發布**：執行 \`git add .\`, \`git commit -m "chore: 快速發布 v{版本號}"\`, \`git push\`。
7. **同步 Metadata**：確保 \`.mq5\` 檔案內的 \`#property version\`、\`LogComment\` 及 \`OnInit\` Print 版本號與 \`README.md\` 一致。
8. **提醒用戶**：確認 \`.ex5\` 已成功生成。

---

## 任務：同步版本 Metadata (Update Version Metadata)
**指令內容：**
當版本號發生小變動或需要全域同步時執行：
1. **讀取目標版本號**：從 \`README.md\` 或最新 \`.mq5\` 讀取。
2. **全域修正**：
   - 更新 \`.mq5\` 的 \`#property version\`。
   - 更新 \`LogComment\` 的預設字串 (e.g. \`LogComment = "EA{版本號}_..."\`)。
   - 更新 \`OnInit()\` 內 \`Print\` 顯示的版本號。
   - 更新 \`TODO.md\` 對應章節標題。
3. **自動編譯**：呼叫「任務：編譯 EA (Compile EA)」驗證修改。
4. **驗證**：確保代碼能通過編譯且 Metadata 統一。
1. **讀取目標版本號**：從 \`README.md\` 或最新 \`.mq5\` 讀取。
2. **全域修正**：
   - 更新 \`.mq5\` 的 \`#property version\`。
   - 更新 \`OrderComment\` (若有) 的字串 (e.g. \`OrderComment = "TemplateEA_v{版本號}..."\`)。
   - 更新 \`OnInit()\` 內 \`Print\` 顯示的版本號。
   - 更新 \`TODO.md\` 對應章節標題。
3. **驗證**：確保代碼能通過編譯且 Metadata 統一。
