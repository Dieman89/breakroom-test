![KaPI is the gateway in and out of Orion systems](https://cdn.breakroom.cc/images/breakroom-logo--social-sharing-4adb0ee71378a289a052098a125c7e9e.png)
<p align="center"><b>Welcome!</b> 👐️</p>

## Setup

- Install NodeJS: `brew install node`
- Install yarn v1: `brew install yarn`
- Run `yarn` at the root of the repository to install all dependencies

## How to Run
- Go into the `src` folder, open terminal and type: `node v2.js answers.json --print`
- For tests: `yarn jest`

## V1 or V2
I started writing the v1 trying to make the structure of the functions similar to how I would write it in Elixir, with small functions and pipeline that calls and pass accumulator between them. After starting to get some problems, I decided to semplify it with a refactor.

TLDR: use v2!