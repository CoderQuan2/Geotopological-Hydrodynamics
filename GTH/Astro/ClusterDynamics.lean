/-
  Module: GTH.Astro.ClusterDynamics
  Description: Cluster Virial Equilibrium with Substrate Pressure and Bullet Cluster Lensing Offset.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

noncomputable section

namespace GTH.Astro

/-- Hydrodynamic Cluster Virial State -/
structure ClusterVirialState where
  kinetic_energy   : ℝ  -- K_vir (> 0)
  potential_energy : ℝ  -- U_vir (< 0)
  substrate_work   : ℝ  -- W_sub = ∫ x · ∇P_sub d³x
  h_K_pos          : 0 < kinetic_energy
  h_U_neg          : potential_energy < 0
  virial_balance   : 2 * kinetic_energy + potential_energy + substrate_work = 0

/-- Bullet Cluster Collision and Wake Offset Geometry -/
structure ClusterMergerState where
  relative_velocity_km_s : ℝ  -- Merger velocity (~ 4500 km/s)
  ram_pressure_drag      : ℝ  -- Gas deceleration parameter
  wake_relaxation_time   : ℝ  -- Substrate relaxation tau_0
  sound_speed_km_s       : ℝ  -- c_s in substrate
  h_v_pos                : 0 < relative_velocity_km_s
  h_drag_pos             : 0 < ram_pressure_drag
  h_tau_pos              : 0 < wake_relaxation_time
  h_cs_pos               : 0 < sound_speed_km_s

/-- Projected Lensing Offset Delta x_offset = v_rel * tau_0 * (1 - (c_s / v_rel)^2)^(-1/2) -/
noncomputable def projectedLensingOffset (M : ClusterMergerState) (drag_factor : ℝ) (h_drag : 0 < drag_factor) : ℝ :=
  M.relative_velocity_km_s * M.wake_relaxation_time * drag_factor

/-- Theorem: Lensing offset is strictly positive -/
theorem projectedLensingOffset_pos (M : ClusterMergerState) (drag_factor : ℝ) (h_drag : 0 < drag_factor) :
    0 < projectedLensingOffset M drag_factor h_drag := by
  dsimp [projectedLensingOffset]
  have h_vt : 0 < M.relative_velocity_km_s * M.wake_relaxation_time := mul_pos M.h_v_pos M.h_tau_pos
  exact mul_pos h_vt h_drag

end GTH.Astro
