/-
  Module: GTH.Cosmology.CMBAcousticPeakGeometry
  Description: CMB Sound Horizon r_s(z_*), Acoustic Angle theta_*, Multipoles (l1, l2, l3), and BAO Scale.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real

noncomputable section

namespace GTH.Cosmology

/-- CMB Recombination Sound Horizon and Distance State -/
structure CMBAcousticState where
  r_s_Mpc      : ℝ  -- Comoving sound horizon at drag epoch (144.43 Mpc) (> 0)
  D_M_Mpc      : ℝ  -- Comoving distance to last scattering surface (13872.4 Mpc) (> 0)
  phi_1        : ℝ  -- Peak 1 phase shift (0.267) (> 0)
  phi_2        : ℝ  -- Peak 2 phase shift (0.238) (> 0)
  phi_3        : ℝ  -- Peak 3 phase shift (0.354) (> 0)
  h_rs_pos     : 0 < r_s_Mpc
  h_DM_pos     : 0 < D_M_Mpc
  h_phi1_lt    : phi_1 < 1
  h_phi2_lt    : phi_2 < 2
  h_phi3_lt    : phi_3 < 3
  h_phi_pos1   : 0 < phi_1
  h_phi_pos2   : 0 < phi_2
  h_phi_pos3   : 0 < phi_3

/-- Fundamental Angular Acoustic Scale: theta_* = r_s / D_M -/
noncomputable def acousticAngle (C : CMBAcousticState) : ℝ :=
  C.r_s_Mpc / C.D_M_Mpc

theorem acousticAngle_pos (C : CMBAcousticState) :
    0 < acousticAngle C := by
  dsimp [acousticAngle]
  exact div_pos C.h_rs_pos C.h_DM_pos

/-- Fundamental Acoustic Multipole: l_* = pi / theta_* -/
noncomputable def acousticMultipoleStar (C : CMBAcousticState) : ℝ :=
  Real.pi / acousticAngle C

theorem acousticMultipoleStar_pos (C : CMBAcousticState) :
    0 < acousticMultipoleStar C := by
  dsimp [acousticMultipoleStar]
  exact div_pos Real.pi_pos (acousticAngle_pos C)

/-- n-th Acoustic Peak Multipole: l_n = l_* * (n - phi_n) -/
noncomputable def acousticPeakMultipole (C : CMBAcousticState) (n : ℕ) (phi : ℝ) : ℝ :=
  acousticMultipoleStar C * ((n : ℝ) - phi)

/-- First Compression Peak Multipole l_1 -/
noncomputable def peakMultipole1 (C : CMBAcousticState) : ℝ :=
  acousticPeakMultipole C 1 C.phi_1

/-- First Rarefaction Peak Multipole l_2 -/
noncomputable def peakMultipole2 (C : CMBAcousticState) : ℝ :=
  acousticPeakMultipole C 2 C.phi_2

/-- Second Compression Peak Multipole l_3 -/
noncomputable def peakMultipole3 (C : CMBAcousticState) : ℝ :=
  acousticPeakMultipole C 3 C.phi_3

theorem peakMultipole1_pos (C : CMBAcousticState) :
    0 < peakMultipole1 C := by
  dsimp [peakMultipole1, acousticPeakMultipole]
  have h_diff : 0 < (1 : ℝ) - C.phi_1 := sub_pos.mpr C.h_phi1_lt
  exact mul_pos (acousticMultipoleStar_pos C) h_diff

theorem peakMultipole2_pos (C : CMBAcousticState) :
    0 < peakMultipole2 C := by
  dsimp [peakMultipole2, acousticPeakMultipole]
  have h_diff : 0 < (2 : ℝ) - C.phi_2 := sub_pos.mpr C.h_phi2_lt
  exact mul_pos (acousticMultipoleStar_pos C) h_diff

theorem peakMultipole3_pos (C : CMBAcousticState) :
    0 < peakMultipole3 C := by
  dsimp [peakMultipole3, acousticPeakMultipole]
  have h_diff : 0 < (3 : ℝ) - C.phi_3 := sub_pos.mpr C.h_phi3_lt
  exact mul_pos (acousticMultipoleStar_pos C) h_diff

/-- Strict Harmonic Multipole Ordering: l_1 < l_2 < l_3 -/
theorem cmb_peak_ordering_1_2 (C : CMBAcousticState) (h_p12 : C.phi_2 - C.phi_1 < 1) :
    peakMultipole1 C < peakMultipole2 C := by
  dsimp [peakMultipole1, peakMultipole2, acousticPeakMultipole]
  have h_lstar_pos := acousticMultipoleStar_pos C
  have h_diff : (1 : ℝ) - C.phi_1 < (2 : ℝ) - C.phi_2 := by linarith
  exact (mul_lt_mul_left h_lstar_pos).mpr h_diff

theorem cmb_peak_ordering_2_3 (C : CMBAcousticState) (h_p23 : C.phi_3 - C.phi_2 < 1) :
    peakMultipole2 C < peakMultipole3 C := by
  dsimp [peakMultipole2, peakMultipole3, acousticPeakMultipole]
  have h_lstar_pos := acousticMultipoleStar_pos C
  have h_diff : (2 : ℝ) - C.phi_2 < (3 : ℝ) - C.phi_3 := by linarith
  exact (mul_lt_mul_left h_lstar_pos).mpr h_diff

end GTH.Cosmology
