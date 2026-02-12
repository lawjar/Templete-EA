# EA Template - Copilot Prompts Library
這個檔案儲存了 MQL5 專案常用的複雜指令模板。
使用方法：在 Copilot Chat 中輸入 "task: [任務標題]" 或 "根據 prompts.md 的 [任務標題] 執行任務"。

---

## 任務：更新 README
**指令內容：**
請讀取目前的程式碼狀態（特別是版本號與最近的修改），對比 \concept/idea.md\ 與 \TODO.md\，幫我更新 \README.md\。
重點更新：
1. "Current Version" (當前版本)
2. "Technical Highlights" (技術亮點)
3. 確保功能列表與程式碼實際功能一致。
語氣：專業、量化交易開發者風格 (Professional Quant Developer)。

---

## 任務：代碼審查 (Code Review)
**指令內容：**
作為 MQL5 Expert，請嚴格檢查當前開啟的檔案：
1. **安全性**：是否有 \OrderSend\ 缺少返回值檢查？是否有 \Zero Divide\ 風險？Array 是否有 Out of Range 風險？
2. **規範**：變數命名是否符合 PascalCase？是否有足夠的繁體中文註釋？
3. **邏輯**：是否有潛在的邏輯漏洞？
請以條列式列出改進建議。

---

## 任務：準備發布 (Pre-Release Check)
**指令內容：**
我要發布新版本 .ex5。請幫我檢查：
1. \EA_Template.mq5\ (或其他主程式) 檔案頭部的 \#property version\ 是否已更新？
2. \OnInit\ 函數中是否有 Print 版本號的語句？
3. 產生一段適合貼在 Git Commit 或發布頻道的更新日誌 (Changelog)。

---

## 任務：解釋策略邏輯
**指令內容：**
請用簡單的廣東話，向使用者解釋這段程式碼背後的交易邏輯。
重點解釋：進場條件為何？如何處理浮虧 (Drawdown)？Risk Management 是什麼？

---

## 任務：版本更新全餐 (Update Version)
**指令內容：**
這是一個綜合流程，請按順序執行以下工作：
1. **預發布檢查 (Pre-Release Check)**：檢查主程式的 \#property version\ 確保版本號一致且已更新。
2. **更新文件**：更新 \README.md\ (新功能、版本號) 與 \TODO.md\ (將完成的項目移至已完成)。
3. **Git 發布**：
   - 根據改動產生對應的 Commit Message (遵循 Conventional Commits，且**內容主要使用繁體中文**)。
   - (若已設定 Git) 建議執行：\git add .\, \git commit\。
