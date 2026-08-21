#!/usr/bin/env bash
set -e
echo "=== Running GTH v5.0 Diagnostics for CoderQuan2 ==="
python3 pipelines/sparc_rotation_fit.py
python3 pipelines/gw_echo_ringdown.py
python3 pipelines/frg_density_ceiling_solver.py

if [ ! -d ".git" ]; then
    git init
    git branch -M main
fi

git remote add origin https://github.com/CoderQuan2/geotopological-hydrodynamics.git 2>/dev/null || git remote set-url origin https://github.com/CoderQuan2/geotopological-hydrodynamics.git
git branch -M main
git add .
git commit -m "GTH v5.0: Formal Proofs & Empirical Pipelines" || true
echo ""
echo "=== READY TO PUSH! ==="
echo "Run: git push -u origin main"
