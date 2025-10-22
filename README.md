# conbotics.github.io


This repository serves for deploying the documentation page for customer support of Conbotics.
It automatically tracks the changes of the cb_docs repository. The cb_docs repository is linked here as a submodule under the docs/ directory and updated automatically via Github Actions.

Currently, we only display the troubleshooting document (docs/cb_docs/support/troubleshooting.md), and upload the page whenever that document is updated.

If we want to track other documents as well, we must add these in the mkdocs.yml file. To add more documents/pages, we must add the relative path of the cb_docs document, under the docs directory.

For example, if we want to display the onboarding document in the page, then the mkdocs.yml would be updated as:
```
nav:
  - Home: index.md
  - Troubleshooting: cb_docs/support/troubleshooting.md
  - Onboarding: cb_docs/cb_onboarding/onboarding.md
  ```