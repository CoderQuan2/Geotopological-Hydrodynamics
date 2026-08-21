#!/usr/bin/env bash
set -e
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
NC='\033[0m'

echo -e "${CYAN}==============================================================================${NC}"
echo -e "${CYAN}   GEOTOPOLOGICAL HYDRODYNAMICS (GTH v5.0) — SETUP & GITHUB DEPLOYER         ${NC}"
echo -e "${CYAN}   Target Repository: CoderQuan2/geotopological-hydrodynamics                ${NC}"
echo -e "${CYAN}==============================================================================${NC}"

echo -e "
${YELLOW}[1/4] Running Validation Pipelines...${NC}"
python3 pipelines/sparc_rotation_fit.py
python3 pipelines/gw_echo_ringdown.py
python3 pipelines/frg_density_ceiling_solver.py

echo -e "
${YELLOW}[2/4] Initializing Git Repository...${NC}"
if [ ! -d ".git" ]; then
    git init
    git branch -M main
fi

TARGET_REMOTE="https://github.com/CoderQuan2/geotopological-hydrodynamics.git"
if git remote | grep -q "^origin$"; then
    git remote set-url origin "$TARGET_REMOTE"
else
    git remote add origin "$TARGET_REMOTE"
fi

git add .
git commit -m "GTH v5.0: Complete formal proof suite, GPGPU engine, and empirical pipelines" || true

echo -e "
${CYAN}==============================================================================${NC}"
echo -e "${GREEN}✓ ALL SYSTEMS VERIFIED & READY FOR PUSH!${NC}"
echo -e "Execute the following command to push to GitHub:"
echo -e "
    ${MAGENTA}git push -u origin main${NC}
"
echo -e "${CYAN}==============================================================================${NC}"
