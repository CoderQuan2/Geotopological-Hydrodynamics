# Geotopological Hydrodynamics (GTH) — Core Repository

[![Lean 4 CI](https://img.shields.io/badge/Lean_4-Formal_Proofs-blue.svg)](https://github.com/leanprover/lean4)
[![Vulkan 1.2+](https://img.shields.io/badge/Vulkan-Compute_Shader-red.svg)](https://www.khronos.org/vulkan/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**Geotopological Hydrodynamics (GTH)** is an axiomatic, continuous field physics framework modeling spacetime, gravitation, and topological particle knots as dynamic vorticity excitations in a 5D viscoelastic superfluid substrate ($\mathcal{M}_5 = \mathcal{M}_4 	imes S^1_	au$).

---

## 🏛️ Repository Architecture

```
geotopological-hydrodynamics/
├── GTH.lean                          # Root Lean 4 formalization library
├── GTH/                              # Machine-verified proof modules (Zero-Sorry)
│   ├── Core/Parameters.lean          # 7-Parameter State Vector (Θ) & scale bounds
│   ├── Geometry/Substrate5D.lean     # 5D Kaluza-Klein reduction (G₄ = G₅ / L_τ)
│   ├── Continuum/Viscoelasticity.lean# Maxwell-Kelvin-Voigt constitutive equations
│   ├── Topology/Knots.lean           # Călugăreanu-White-Fuller knot invariance (Tw + Wr = N)
│   ├── Fields/ChiralGovernor.lean    # Chiral suppression & graviton mass bounds (0 < M²_eff ≤ M²)
│   └── Astro/WeakField.lean          # Topological dark matter & Tully-Fisher quartic relation
├── webgl2_engine/                    # 120 FPS Real-Time GPGPU Field Solver
│   └── index.html                    # Mobile/DeX touch-interactive WebGL2 simulation
├── vulkan_compute/                   # Low-level C++20 / Vulkan NDK compute pipeline
│   ├── CMakeLists.txt                # Build configuration
│   ├── src/main.cpp                  # Vulkan pipeline host runner
│   └── shaders/gth_field_solver.comp # GLSL compute kernel for spatial grid integration
├── pipelines/                        # Empirical observation & benchmark suites
│   └── sparc_rotation_fit.py         # SPARC 175 galaxy rotation curve solver
├── .github/workflows/                # Automated Continuous Integration
│   ├── lean_ci.yml                   # Lean 4 proof check
│   └── vulkan_ci.yml                 # Vulkan C++20 build verification
├── lakefile.lean                     # Lake package manager specification
├── lean-toolchain                    # Lean 4 toolchain pin (v4.8.0)
└── LICENSE                           # MIT Open Source License
```

---

## 🔬 Core Physical Principles

### 1. 7-Parameter Vacuum State Vector $\mathbf{\Theta}$
$$\mathbf{\Theta} = \left( M_{	ext{UV}},\, m_{	ext{IR}},\, ho_0,\, K_{	ext{bulk}},\, G_{	ext{shear}},\, 	au_0,\, \eta_n ight)$$

* **Acoustic & Shear Wave Propagation:**
  $$c_s = \sqrt{rac{K_{	ext{bulk}}}{ho_0}}, \quad c_t = \sqrt{rac{G_{	ext{shear}}}{ho_0}}$$
* **Intermediate Geometric Scale:**
  $$\Lambda_{	ext{GTH}} = \sqrt{M_{	ext{UV}} \cdot m_{	ext{IR}}}$$

### 2. Kaluza-Klein Dimensional Reduction
The 5D Einstein-Hilbert action reduces to canonical 4D General Relativity on fiber length $L_	au = 2\pi R_	au$:
$$G_4 = rac{G_5}{L_	au}, \quad 2lpha + eta = 0$$

### 3. Călugăreanu-White-Fuller Ribbon Invariance
$$	ext{Lk}(\mathcal{K}, \mathcal{K}^+) = 	ext{Tw}(\mathcal{K}) + 	ext{Wr}(\mathcal{K}) = N \in \mathbb{Z}$$

### 4. Chiral Orthogonality Governor
$$0 < M_{G,	ext{eff}}^2(x) \le M_G^2, \quad orall x \in \mathcal{M}_4$$

---

## 🚀 Quick Start

### 1. Building Lean 4 Proofs
```bash
# Install elan (Lean 4 version manager)
curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf | sh

# Build and verify all proofs
lake update
lake build
```

### 2. Running the 120 FPS WebGL2 Sandbox
Host locally on any device (e.g., Samsung Galaxy Z Fold 7 / Termux):
```bash
cd webgl2_engine
python3 -m http.server 8080
# Open http://localhost:8080 in Chrome
```

### 3. Executing SPARC Benchmark Fitting
```bash
python3 pipelines/sparc_rotation_fit.py
```

---

## 📜 License
Released under the [MIT License](LICENSE).
