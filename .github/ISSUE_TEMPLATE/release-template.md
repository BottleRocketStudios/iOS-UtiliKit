---
name: Release template
about: Basic release checklist.
title: Version [version_number]
labels: ''
assignees: ''

---

Release checklist:
- [ ] Create release branch
- [ ] Update version number for all targets
- [ ] Update version number in `Podspec`
- [ ] Validate `README.md` is still current
- [ ] Update `CHANGELOG.md` for the new release
- [ ] Create pull request into `master`
- [ ] Create version number tag in Git
- [ ] Publish release on GitHub
- [ ] Publish release on Cocoapods trunk
