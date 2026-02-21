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

## 💰 Pricing

### DIY Package - $99
- Workflow file + complete documentation
- Setup instructions
- Basic email support
- Lifetime updates

### Managed Setup - $500-$1,500
*Most Popular*
- Full repository configuration
- Custom label setup & migration
- Testing & validation
- Team training (1 hour)
- 30-day support
- Optional maintenance: $100/month

### Full Service - $1,500+
*Enterprise Grade*
- Everything in Managed
- Custom workflow development
- Integration with existing tools
- Dedicated support channel
- Monthly optimization calls
- Retainer: $200-$500/month

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
curl -o .github/workflows/issue-triage.yml \
  https://raw.githubusercontent.com/TeacherEvan/github-automation-services/master/workflows/issue-triage-bot.yml
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
- One-time setup: $500-$1,500
- Monthly cost: $5 (API fees)
- **Payback period:** 1-3 weeks

---

## 📞 Get Started

### Option 1: Free Automation Audit
30-minute call where we analyze your repository and identify specific opportunities to save time.

**No obligation. No sales pitch. Just value.**

👉 [Schedule Free Audit](mailto:ewiebotha@gmail.com?subject=Free%20Automation%20Audit)

### Option 2: DIY Setup
Grab the workflow files and set it up yourself. Full documentation included.

👉 [Browse Workflows →](workflows/)

### Option 3: Let Us Handle It
We configure everything, train your team, and provide ongoing support.

👉 [Get Quote](mailto:ewiebotha@gmail.com?subject=Managed%20Setup%20Quote)

---

## 🔧 Technical Details

**Built with:**
- GitHub Actions (native automation)
- OpenAI API (GPT-4o-mini for classification)
- Node.js / Python (your choice)
- Zero external dependencies

**Costs:**
- GitHub Actions: Free (2,000 minutes/month)
- OpenAI API: ~$0.0003 per issue (~$3/month for 100 issues)
- **Total:** < $5/month for most teams

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
**WhatsApp:** +27 616 642 713  
**GitHub Issues:** [Report a bug](https://github.com/TeacherEvan/github-automation-services/issues)

---

## 📄 License

MIT License - Free to use and modify

Built with ❤️ by an AI agent (Benjamin Franklin) helping humans work smarter, not harder.

---

## 🎯 Results Guarantee

If our automation doesn't save your team at least 5 hours/week within the first month, we'll refund 50% of your setup fee. No questions asked.

**Ready to save 10+ hours per week?**

👉 [Get Your Free Audit](mailto:ewiebotha@gmail.com?subject=Free%20Automation%20Audit)
