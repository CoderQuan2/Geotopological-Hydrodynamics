/-
  Module: GTH.Core.Parameters
  Description: Foundational 7-Parameter Substrate State Vector and Derived Constants.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace GTH.Core

/-- The Fundamental 7-Parameter State Vector defining the GTH Vacuum Substrate -/
structure StateVector where
  M_UV    : ℝ  -- Ultraviolet cutoff scale (Planck/sub-Planck mass)
  m_IR    : ℝ  -- Infrared mass scale (Hubble/cosmological scale)
  rho_0   : ℝ  -- Equilibrium vacuum condensate mass density
  K_bulk  : ℝ  -- Bulk modulus of the condensate
  G_shear : ℝ  -- Shear modulus of the viscoelastic lattice
  tau_0   : ℝ  -- Substrate Maxwell relaxation timescale
  eta_n   : ℝ  -- Normal component dynamic viscosity
  h_M_UV  : 0 < M_UV
  h_m_IR  : 0 < m_IR
  h_rho   : 0 < rho_0
  h_K     : 0 < K_bulk
  h_G     : 0 < G_shear
  h_tau   : 0 < tau_0
  h_eta   : 0 < eta_n

variable (S : StateVector)

/-- Speed of sound in the condensate (compressional acoustic mode) -/
noncomputable def soundSpeed : ℝ := Real.sqrt (S.K_bulk / S.rho_0)

/-- Speed of transverse shear waves in the viscoelastic lattice -/
noncomputable def shearWaveSpeed : ℝ := Real.sqrt (S.G_shear / S.rho_0)

/-- Maxwell relaxation time ratio: tau_M = eta_n / G_shear -/
def maxwellRelaxationTime : ℝ := S.eta_n / S.G_shear

/-- Intermediate GTH Geometric Mean Mass Scale: Lambda_GTH = sqrt(M_UV * m_IR) -/
noncomputable def lambdaGTH : ℝ := Real.sqrt (S.M_UV * S.m_IR)

/-- Theorem: Sound speed is strictly positive -/
theorem soundSpeed_pos : 0 < S.soundSpeed := by
  dsimp [soundSpeed]
  apply Real.sqrt_pos.mpr
  exact div_pos S.h_K S.h_rho

/-- Theorem: Shear wave speed is strictly positive -/
theorem shearWaveSpeed_pos : 0 < S.shearWaveSpeed := by
  dsimp [shearWaveSpeed]
  apply Real.sqrt_pos.mpr
  exact div_pos S.h_G S.h_rho

/-- Theorem: Maxwell relaxation time is strictly positive -/
theorem maxwellRelaxationTime_pos : 0 < S.maxwellRelaxationTime := by
  dsimp [maxwellRelaxationTime]
  exact div_pos S.h_eta S.h_G

/-- Theorem: Geometric intermediate scale Lambda_GTH is strictly positive -/
theorem lambdaGTH_pos : 0 < S.lambdaGTH := by
  dsimp [lambdaGTH]
  apply Real.sqrt_pos.mpr
  exact mul_pos S.h_M_UV S.h_m_IR

end GTH.Core
