# Basic Collaboration Instructions

__note__: Any time you see a command wrapped in angled brackets `<like-this>`, the angled brackets are meant to be _ignored_ `like this`.

## Clone this repo:

 - SSH: `git clone git@github.com:sredna43/gameoff2020.git`
 - HTTP: `git clone https://github.com/sredna43/gameoff2020`
 
## Work in a new branch:

You _**cannot**_ make commits directly to the `main` or `dev` branches, they must all be in a new branch which you made. The `main` and `dev` branches require a Pull Request. More on PR's later.

### To make a new branch:
 1. Pull the dev branch: `git pull origin dev`
 2. Create a new branch for the work you're doing: `git checkout -b <branch-name-here>`
  a. Use this branch naming scheme: 
   - `feat: <name-of-feature>` for features
   - `fix: <name-of-feature>` for fixes
   - `update: <name-of-update>` for updates to pre-existing code
 
### To commit and push those changes to this repository:
 1. Add any changes you made: `git add --all` to add everything, or `git add <specific-file-name`
 2. Commit those changes if you're satisfied with them: `git commit -m <informative-message-here>` with an informative message
 3. Push the changes you made:
  a. if it's a _new_ branch: `git push --set-upstream origin <branch-name>`
  b. if it's a branch that you've already done this ^^ for, then: `git push origin <branch-name>` or simply `git push`
  
### To make a pull request:
Pull requests are simply requests that you make to have the code from your branch "pulled into" the main development branch. We have these set up so that you cannot accidentally push bad code into the repository, which could really mess things up for everyone. Here's how you open a PR:
 1. It's likely that after you push code from your local repository (aka your computer) all you'll need to do is navigate to this repository (github.com/sredna32/gameoff2020), and there will be a big green button at the top asking you if you want to open a pull request, or it might say something about merging your code into the parent branch.
