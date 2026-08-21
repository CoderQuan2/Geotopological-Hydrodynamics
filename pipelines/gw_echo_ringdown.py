import numpy as np

def compute_gth_echo_waveform(
    remnant_mass_solar=65.0,
    f_qnm=251.0,
    tau_qnm=4.0e-3,
    delta_t_echo=7.045e-3,
    f_echo=141.94,
    num_echoes=5,
    damping=0.62
):
    fs = 4096
    duration = 0.08
    t = np.linspace(0, duration, int(fs * duration))
    h_primary = np.exp(-t / tau_qnm) * np.sin(2 * np.pi * f_qnm * t)
    h_echoes = np.zeros_like(t)
    for n in range(1, num_echoes + 1):
        t_delay = n * delta_t_echo
        mask = t >= t_delay
        dt = t[mask] - t_delay
        amp = (damping ** n)
        h_echoes[mask] += amp * np.exp(-dt / (tau_qnm * 1.5)) * np.sin(2 * np.pi * f_echo * dt)
    h_total = h_primary + h_echoes
    return t, h_total

if __name__ == '__main__':
    print("[GTH Gravitational Wave Pipeline] Calculating GW150914 Echo Resonance...")
    t, h_tot = compute_gth_echo_waveform()
    print("GTH Target Echo Delay: Delta t_SG = 7.045 ms")
    print("GTH Cavity Resonance:  f_SG = 141.94 Hz")
    print(f"Max Synthetic Strain: {np.max(np.abs(h_tot)):.4f}")
