#!/bin/bash

# Update Project Generator
cd module
rm -rf PrGen
git clone https://github.com/hyunwnuyh/PrGen.git
cd PrGen
rm -rf .git
