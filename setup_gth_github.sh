#!/usr/bin/env bash
# ==============================================================================
#  GEOTOPOLOGICAL HYDRODYNAMICS (GTH v5.0) — AUTOMATED SETUP & GITHUB DEPLOYER
# ==============================================================================
set -e

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${CYAN}==================================================================${NC}"
echo -e "${CYAN}   GEOTOPOLOGICAL HYDRODYNAMICS (GTH v5.0) — SETUP & DEPLOYMENT   ${NC}"
echo -e "${CYAN}==================================================================${NC}"

# 1. Check & Install Python Dependencies
echo -e "
${YELLOW}[1/5] Checking Python scientific dependencies...${NC}"
if python3 -c "import numpy, scipy, matplotlib" 2>/dev/null; then
    echo -e "${GREEN}✓ Python packages (numpy, scipy, matplotlib) available.${NC}"
else
    echo -e "${YELLOW}Installing numpy, scipy, matplotlib...${NC}"
    pip install --upgrade numpy scipy matplotlib || true
fi

# 2. Check Lean 4 (Elan & Lake)
echo -e "
${YELLOW}[2/5] Checking Lean 4 toolchain (elan / lake)...${NC}"
if command -v elan &> /dev/null; then
    echo -e "${GREEN}✓ elan detected: $(elan --version)${NC}"
    if command -v lake &> /dev/null; then
        echo -e "${GREEN}✓ lake detected: $(lake --version)${NC}"
    fi
else
    echo -e "${YELLOW}! elan is not installed.${NC}"
    echo -e "To install elan, run: ${CYAN}curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf | sh -s -- -y${NC}"
fi

# 3. Execute Empirical Validation Tests
echo -e "
${YELLOW}[3/5] Executing empirical validation test suites...${NC}"
echo -e "${CYAN}--> Running SPARC galaxy rotation curve fitting...${NC}"
python3 pipelines/sparc_rotation_fit.py

echo -e "${CYAN}--> Running Gravitational Wave echo comb simulation...${NC}"
python3 pipelines/gw_echo_ringdown.py

# 4. WebGL2 GPGPU Field Visualizer
echo -e "
${YELLOW}[4/5] WebGL2 120 FPS Sandbox ready:${NC}"
echo -e "File location: ${GREEN}$(pwd)/webgl2_engine/index.html${NC}"
echo -e "To launch locally: ${CYAN}cd webgl2_engine && python3 -m http.server 8080${NC}"

# 5. Git Repository Verification & Remote Setup
echo -e "
${YELLOW}[5/5] Git repository status & GitHub remote link...${NC}"
if [ ! -d ".git" ]; then
    git init
    git branch -M main
    git add .
    git commit -m "GTH v5.0: Complete formal proof suite, GPGPU solver, and empirical pipelines"
fi

echo -e "${GREEN}Current Git Status:${NC}"
git status --short
git log -1 --oneline

echo -e "
${CYAN}==================================================================${NC}"
echo -e "${GREEN}✓ SETUP COMPLETE!${NC}"
echo -e "To push this repository to your GitHub account:"
echo -e "  ${YELLOW}git remote add origin https://github.com/<your-username>/geotopological-hydrodynamics.git${NC}"
echo -e "  ${YELLOW}git push -u origin main${NC}"
echo -e "${CYAN}==================================================================${NC}"
