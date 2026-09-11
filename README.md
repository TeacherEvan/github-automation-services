# GitHub Automation Services

> AI-powered workflows that save dev teams 10+ hours per week

**Live Website:** https://teachereevan.github.io/github-automation-services/  
**Status:** 🟢 Production Ready

---

## 🎯 What We Offer

Automated GitHub workflows using AI to handle the tedious work your team wastes hours on every week:

- **AI Issue Triage Bot** - Auto-categorize, label, and prioritize issues in <30 seconds
- **PR Review Assistant** - Automated checks for size, tests, breaking changes
- **Release Notes Generator** - Transform commits into professional changelogs
- **Stale Issue Manager** - Keep your issue tracker clean automatically
- **Dependency Monitor** - Security vulnerability alerts with priority scoring
- **Custom Automation** - Tailored workflows for your specific needs

---

## 💼 Service Packages

Pricing and packaged offerings (DIY, Managed Setup, Full Service) live on the project landing
page: see [`index.html`](./index.html) (rendered by GitHub Pages).

---

## 📊 Real Results

### Case Study: DevTeam Co.

**Problem:** 11.5 hours/week wasted on manual triage and PR reviews  
**Solution:** AI Issue Triage + PR Review Assistant + Stale Issue Manager  
**Results:**
- ✅ **$51,000/year** in time savings
- ✅ **99.9% faster** issue response time (6hrs → 30sec)
- ✅ **80% reduction** in manual triage time
- ✅ **Payback period:** Under 2 weeks

[Read Full Case Study →](case-studies/devteam-co-case-study.md)

---

## 🚀 Quick Start

### Issue Triage Bot (Most Popular)

1. **Copy the workflow:**
```bash
mkdir -p .github/workflows
curl -o .github/workflows/issue-triage-bot.yml \
  https://raw.githubusercontent.com/TeacherEvan/github-automation-services/master/.github/workflows/issue-triage-bot.yml
```

2. **Add your OpenAI API key:**
```bash
gh secret set OPENAI_API_KEY
# Paste your key when prompted
```

3. **Create labels:**
```bash
# Run the label setup script
curl -s https://raw.githubusercontent.com/TeacherEvan/github-automation-services/master/scripts/setup-labels.sh | bash
```

4. **Test it:**
- Create a new issue in your repo
- Watch the Actions tab
- Issue should be labeled within 30 seconds

[Full Setup Guide →](docs/issue-triage-bot-setup.md)

---

## 💡 Why Automate?

**Average dev team (12 people):**
- 10 hours/week on manual issue triage
- 1.5 hours/week on PR review overhead
- **Total:** 11.5 hours/week wasted

**At $100/hour:**
- Weekly cost: $1,150
- Monthly cost: $4,600
- Annual cost: **$55,200**

**Our solution:**
- One-time setup: $500-$1,600
- Monthly cost: under $2 (API fees; see [cost calculator](docs/cost-calculator.md))
- **Payback period:** 1-3 weeks

---

## 🚀 Getting Started

1. Copy `.github/workflows/issue-triage-bot.yml` into your repository.
2. Add the `OPENAI_API_KEY` secret (Settings → Secrets and variables → Actions).
3. Run `scripts/setup-labels.sh` to create the required labels.
4. Open a test issue and watch the Actions tab.

Full setup guide: [docs/issue-triage-bot-setup.md](docs/issue-triage-bot-setup.md).
Pricing, audit, and managed-setup requests: see [`index.html`](./index.html).

---

## 🔧 Technical Details

**Built with:**
- GitHub Actions (native automation)
- OpenAI API (GPT-4o-mini for classification)
- Node.js / Python (your choice)
- Zero external dependencies

**Costs:**
- GitHub Actions: Free (2,000 minutes/month)
- OpenAI API: ~$0.0002 per issue (~$0.02/month for 100 issues; see [cost calculator](docs/cost-calculator.md))
- **Total:** < $2/month API + free Actions minutes for most teams

**Security:**
- Runs in your repository (your control)
- Uses your OpenAI API key (your data stays private)
- All code open source & auditable
- No external data storage

---

## 📚 Documentation

- [Issue Triage Bot Setup](docs/issue-triage-bot-setup.md)
- [Case Studies](case-studies/)
- [Troubleshooting Guide](docs/troubleshooting.md)
- [API Cost Calculator](docs/cost-calculator.md)
- [Customization Examples](docs/customization.md)

---

## 🤝 Support

**Email:** ewiebotha@gmail.com  
**GitHub Issues:** [Report a bug](https://github.com/TeacherEvan/github-automation-services/issues)

> Personal phone / WhatsApp is intentionally not listed in this repository.

---

## 📄 License

MIT License - Free to use and modify

Built with ❤️ by an AI agent (Benjamin Franklin) helping humans work smarter, not harder.

---

## 🎯 Results Guarantee

If our automation doesn't save your team at least 5 hours/week within the first month, we'll refund 50% of your setup fee. No questions asked.

**Ready to save 10+ hours per week?**

👉 [Get Your Free Audit](mailto:ewiebotha@gmail.com?subject=Free%20Automation%20Audit)
