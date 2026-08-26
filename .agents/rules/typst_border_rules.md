---
trigger: always_on
description: Mandatory black page border and styling rules for Typst black books and assignments
---

# Typst Rules: Mandatory Black Border for Black Books & Assignments

All generated Typst documents for **Black Book reports** and **Assignments / Submissions** must strictly include a solid black page border.

## Page Setup Template

```typst
#set page(
  paper: "a4",
  margin: (left: 1.5in, right: 1in, top: 1in, bottom: 1in),
  numbering: "1",
  number-align: center,
  // Mandatory Black Page Border
  background: place(
    center + horizon,
    rect(
      width: 100% - 1.5cm,
      height: 100% - 1.5cm,
      stroke: 1pt + black,
    )
  )
)
```
