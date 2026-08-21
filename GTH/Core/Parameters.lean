import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace GTH.Core

structure StateVector where
  M_UV    : ℝ
  m_IR    : ℝ
  rho_0   : ℝ
  K_bulk  : ℝ
  G_shear : ℝ
  tau_0   : ℝ
  eta_n   : ℝ
  h_M_UV  : 0 < M_UV
  h_m_IR  : 0 < m_IR
  h_rho   : 0 < rho_0
  h_K     : 0 < K_bulk
  h_G     : 0 < G_shear
  h_tau   : 0 < tau_0
  h_eta   : 0 < eta_n

variable (S : StateVector)

noncomputable def soundSpeed : ℝ := Real.sqrt (S.K_bulk / S.rho_0)
noncomputable def shearWaveSpeed : ℝ := Real.sqrt (S.G_shear / S.rho_0)
def maxwellRelaxationTime : ℝ := S.eta_n / S.G_shear
noncomputable def lambdaGTH : ℝ := Real.sqrt (S.M_UV * S.m_IR)

theorem soundSpeed_pos : 0 < S.soundSpeed := by
  dsimp [soundSpeed]
  apply Real.sqrt_pos.mpr
  exact div_pos S.h_K S.h_rho

theorem shearWaveSpeed_pos : 0 < S.shearWaveSpeed := by
  dsimp [shearWaveSpeed]
  apply Real.sqrt_pos.mpr
  exact div_pos S.h_G S.h_rho

theorem maxwellRelaxationTime_pos : 0 < S.maxwellRelaxationTime := by
  dsimp [maxwellRelaxationTime]
  exact div_pos S.h_eta S.h_G

theorem lambdaGTH_pos : 0 < S.lambdaGTH := by
  dsimp [lambdaGTH]
  apply Real.sqrt_pos.mpr
  exact mul_pos S.h_M_UV S.h_m_IR

end GTH.Core
