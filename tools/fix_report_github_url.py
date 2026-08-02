from pathlib import Path
from docx import Document

path = Path(r"C:\Cybersecurity\Blue team Broni\reports\CY376-Blue-Team-Report.docx")
doc = Document(str(path))
old = "https://github.com/cy-vokyere3623-hash/blue-team-stored-procedure-audit"
new = "https://github.com/cy-vokyere3623-hash/CY376-Blue-Team-Stored-Procedure-Audit"
count = 0
for p in doc.paragraphs:
    if old in p.text:
        for run in p.runs:
            if old in run.text:
                run.text = run.text.replace(old, new)
                count += 1
doc.save(str(path))
print(f"replaced={count}")
