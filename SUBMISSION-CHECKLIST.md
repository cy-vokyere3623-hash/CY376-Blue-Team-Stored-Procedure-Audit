# Submission checklist — Veronica Okyere (FCM.41,018.206.23)

## Monday 3 August — Report + GitHub

### Printed report
- [ ] Open `report/CY376-Blue-Team-Report.md` in Word
- [ ] Set Calibri/Arial/Times 11–12pt, 1.15–1.5 spacing, 1" margins
- [ ] Insert page numbers; add TOC page numbers
- [ ] Capture screenshots per `evidence/screenshots/README.md` and insert as Figures 2–5
- [ ] Draw/replace Figure 1 lab diagram
- [ ] Confirm body is **15+ pages** excluding cover/TOC/appendices
- [ ] Export PDF to `report/CY376-Blue-Team-Report.pdf`
- [ ] Print one bound/stapled copy
- [ ] Write GitHub URL on cover page
- [ ] Submit to course office before close of business

### GitHub
- [ ] Create repo named `CY376-Blue-Team-Stored-Procedure-Audit` under `cy-vokyere3623-hash`
- [ ] Push this project (see commands below)
- [ ] Confirm README shows your name and index number
- [ ] Confirm report Markdown/PDF is in `report/`
- [ ] If private: add instructor as collaborator
- [ ] Submit repo URL on any online form provided

```powershell
cd "C:\Cybersecurity\Blue team Broni"
gh repo create CY376-Blue-Team-Stored-Procedure-Audit --public --source=. --remote=origin --push
```

Or manually:
1. Create empty repo on GitHub
2. `git remote add origin https://github.com/cy-vokyere3623-hash/CY376-Blue-Team-Stored-Procedure-Audit.git`
3. `git push -u origin main`

## Tuesday 4 August onward — Presentation

- [ ] Convert `presentation/10-minute-slides.md` into PowerPoint/Google Slides
- [ ] Practice to **10 minutes**
- [ ] Arrive 15 minutes early with laptop/flash drive
- [ ] Keep repo open for interview walkthrough

## Interview readiness
Be able to explain:
- each finding F-001 to F-006
- why stored procedures are not automatically safe
- what each script `01`–`05` does
- how remediation was verified
